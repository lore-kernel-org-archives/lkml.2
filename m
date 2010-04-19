Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab0DSPQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:16:18 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:3338 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0DSPQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:16:17 -0400
Subject: RE: Memory policy question for NUMA arch....
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Chetan Loke <generationgnu@yahoo.com>
Cc: rick.sherm@yahoo.com, andi@firstfloor.org, linux-numa@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <368225.78206.qm@web111904.mail.gq1.yahoo.com>
References: <368225.78206.qm@web111904.mail.gq1.yahoo.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Mon, 19 Apr 2010 11:16:03 -0400
Message-Id: <1271690163.10937.121.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-16 at 16:17 -0700, Chetan Loke wrote: 
> Hello,
> 
> PS - Please 'CC' me on the emails.I have not subscribed to the list.
> 
> > Hi Andy,
> > 
> > --- On Wed, 4/7/10, Andi Kleen <andi@firstfloor.org>
> > wrote:
> > > On Tue, Apr 06, 2010 at 01:46:44PM -0700, Rick Sherm
> > wrote:
> > > > On a NUMA host, if a driver calls
> > __get_free_pages()
> > > then
> > > > it will eventually invoke
> > > ->alloc_pages_current(..). The comment
> > > > above/within alloc_pages_current() says
> > > 'current->mempolicy' will be
> > > > used.So what memory policy will kick-in if the
> > driver
> > > is trying to
> > > > allocate some memory blocks during driver load
> > > time(say from probe_one)? System-wide default
> > > policy,correct?
> > >
> > > Actually the policy of the modprobe or the kernel boot
> > up
> > > if built in
> > > (which is interleaving)
> > >
> 
> I may be wrong but I think there's a difference. system-wide run-time default policy is M_PREFERRED | M_LOCAL and not Interleaving.
> 
> So, if current->mempolicy is set then default_policy will not be used. 
> And now if you don't want the default_policy mode then what?
> I'm stuck in this confused state too. So we have two cases to take care off - 
> 
> Case1) current->mempolicy is initialized and so we can just set it to
> whatever we like and then reset it once we are done with
> __get_free_pages(..) etc.

Yes, as Andi mentioned.  Also, see my response to Rick at:

http://marc.info/?l=linux-kernel&m=127066130315241&w=4


> 
> Case2) current->mempolicy is not initialized. Then default_policy is
> used. Now if we have to muck with the default_policy then we will need
> to lock it down. Otherwise some other consumer will get affected by
> it.

If current->mempolicy is not initialized, you can create a new one and
set it temporarily.  You could probably call do_set_mempolicy() directly
the way numa_policy_init() does and then call numa_default_policy() to
restore it to default.

You should never change the system default once the system is up and
running.

> 
> But both the above solutions are twisted.Why not just create a
> different wrapper? This way we can leave both current & default_policy
> alone.
> 
> #ifdef CONFIG_NUMA
> __get_free_policy_pages(policy,mask,order)??
> endif

As Andi mentioned in his response, you could certainly do this as long
as it doesn't impact the normal allocation path.
> 
> For now I may end up hacking my kernel and implementing the above
> mentioned quick and dirty solution. But if there's a cleaner approach
> then please let me know.
> 
> PS - We should create some wrapper's that will automatically figure
> out the MSIX-affinity(if present/set) and then default the allocation
> to that node? 

Still not clear on what your requirements are but, if existing
interfaces don't suffice, such a wrapper might make sense.
__get_free_pages() is simply a wrapper around alloc_pages() that then
returns page_address() of the resulting page.  So, something like
'get_free_pages_node()'--which should probably live in
mm/page_alloc.c--would just be a wrapper around alloc_pages_node() that
then returns the page_address() of the page.  

A device-centric interface--e.g., 'get_free_pages_dev()'--could get the
device/bus node affinity via dev_to_node() and then do the
allocation/conversion.   I think this is close to what you're suggesting
above. See dma_generic_alloc_coherent() [in arch/x86/kernel/pci-dma.c]
for an example of a wrapper that does the device affinity lookup and
allocation in one function.

Of course, you could just do this in your driver, as well.

> Also, is there a way to configure irqbalance and ask it to leave these
> guys alone? Like a config file that says - leave these
> irqs/pci-devices alone.For now I've shut down irqbalance.

You can set the environment variable IRQBALANCE_BANNED_INTERRUPTS--when
starting irqbalance--to list of interrupts that irqbalance should ignore
if you're using a version that supports that.  Check the init script
that starts irqbalance on your distro of choice.

Regards,
Lee

