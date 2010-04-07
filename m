Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab0DGR2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:28:07 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:12488 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab0DGR2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:28:05 -0400
Subject: Re: Memory policy question for NUMA arch....
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Rick Sherm <rick.sherm@yahoo.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-numa@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <190529.78750.qm@web114307.mail.gq1.yahoo.com>
References: <190529.78750.qm@web114307.mail.gq1.yahoo.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Wed, 07 Apr 2010 13:27:59 -0400
Message-Id: <1270661279.14074.49.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-07 at 08:48 -0700, Rick Sherm wrote:
> Hi Andy,
> 
> --- On Wed, 4/7/10, Andi Kleen <andi@firstfloor.org> wrote:
> > On Tue, Apr 06, 2010 at 01:46:44PM -0700, Rick Sherm wrote:
> > > On a NUMA host, if a driver calls __get_free_pages()
> > then 
> > > it will eventually invoke
> > ->alloc_pages_current(..). The comment 
> > > above/within alloc_pages_current() says
> > 'current->mempolicy' will be 
> > > used.So what memory policy will kick-in if the driver
> > is trying to 
> > > allocate some memory blocks during driver load
> > time(say from probe_one)? System-wide default
> > policy,correct?
> > 
> > Actually the policy of the modprobe or the kernel boot up
> > if built in
> > (which is interleaving)
> > 
> 
> Interleaving,yup that's what I thought. I've tight control on the environment.So for one driver I need high throughput and I will use the interleaving-policy.But for the other 2-3 drivers, I need low latency.So I would like to restrict it to the local node.These are just my thoughts but I'll have to experiment and see what the numbers look like. Once I've some numbers I will post them in a few weeks.
> 
> > > 
> > > What if the driver wishes to i) stay confined to a
> > 'cpulist' OR ii) use a different mem-policy? How 
> > > do I achieve this?
> > > I will choose the 'cpulist' after I am successfuly
> > able to affinitize the MSI-X vectors.
> > 
> > You can do that right now by running numactl ... modprobe
> > ...
> > 
> Perfect.Ok, then I'll probably write a simple user-space wrapper:
>   1)set mem-policy type depending on driver-foo-M.
>   2)load driver-foo-M.
>   3)goto 1) and repeat for other driver[s]-foo-X
> BTW - I would know before hand which adapter is placed in which slot
> and so I will be able to deduce its proximity to a Node.
> 
> > Yes there should be probably a better way, like using a
> > policy
> > based on the affinity of the PCI device.
> > 

Rick:

If you want/need to use __get_free_page(), you will need to set the
current task's memory policy.  If you're loading the driver from user
space, then you can set the mempolicy of the task [shell, modprobe, ...]
using numactl as you suggest above.  From within the kernel, you'd need
to temporarily change current's mempolicy to what you need and then put
it back.  We don't have a formal interface to do this, I think, but such
could be added.

Another option, if you just want memory on a specific node, would be to
use kmalloc().  But for a multiple page allocation, this might not be
the best method.

As to how to find the node where the adapter is attached, from user
space you can look at /sys/devices/pci<pci-bus>/<pci-dev>/numa_node.
You can also find the 'local_cpus' [hex mask] and 'local_cpulist' in the
same directory.  From within the driver, you can examine dev->numa_node.
Look at 'local_cpu{s|list}_show()' to see how to find the local cpus for
a device.

Note that if your device is attached to a memoryless node on x86, this
info won't be accurate.  x86 arch code removes memoryless nodes and
reassigns cpus to other nodes that do have memory.  I'm not sure what it
does with the dev->numa_node info.  Maybe not a problem for you.

Regards,
Lee 

