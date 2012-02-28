Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab2B1Cp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:45:58 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:39286 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab2B1Cp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:45:56 -0500
Message-ID: <1330397141.4112.23.camel@ThinkPad-T61>
Subject: Re: [PATCH 0/2 x86] fix some page faults in nmi if kmemcheck is
 enabled
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, Vegard Nossum <vegardno@ifi.uio.no>,
        Don Zickus <dzickus@redhat.com>
Date: Tue, 28 Feb 2012 10:45:41 +0800
In-Reply-To: <1330340324.11248.60.camel@twins>
References: <1329717665.3448.28.camel@ThinkPad-T61>
	 <1329735648.2293.307.camel@twins> <1329788560.3448.45.camel@ThinkPad-T61>
	 <1329819437.2293.382.camel@twins> <1329990828.19165.36.camel@ThinkPad-T61>
	 <1330340324.11248.60.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12022717-3568-0000-0000-00000147AA58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 11:58 +0100, Peter Zijlstra wrote:
> On Thu, 2012-02-23 at 17:53 +0800, Li Zhong wrote:
> 
> > I will think further about it, and would appreciate it if you could give
> > some good ideas. 
> 
> *sigh*.. or you could do your own damn work..

I'm still doing the work ...

> 
> > > > 2. If CONFIG_KMEMCHECK is enabled, the pages allocated through slab will
> > > > be marked as non-present, to capture uninitialized memory access. More
> > > > information in Documentation/kmemcheck.txt .
> > > 
> > > So then kmemcheck is buggy, since the nmiaction structure is initialized
> > > in register_nmi_handler(), so it should most definitely not be marked
> > > non-present.
> > > 
> > 
> > I'm not sure whether I understand it correctly. Do you mean that
> > nmiaction is initialized in register_nmi_handler(), which indicates it
> > will be used in nmi, so it shouldn't be marked non-present?
> 
> No, you said that it marks memory non-present to detect uninitialized
> stuff, but since it is initialized, it shouldn't then be non-present,
> right?

>From my understanding of kmemcheck, the checking is based on the
non-present page. So while handling page fault, if the memory hasn't
been written before read, kmemcheck knows that it is uninitialized. 

I think it is used to find code errors, so it need mark all non-present,
to check if there are any access to uninitialized memory. 

> 
> > But for kmemcheck, why need it know the information that page fault is
> > not allowed in nmi? 
> 
> Uh, what?

Please ignore it, as I misunderstood your point previously. 

> > > > 3. From the log, there are some memories accessed in nmi, which are in
> > > > pages marked as non-present by kmemcheck, as they are allocated by
> > > > something like kmalloc(). 
> > > 
> > > So figure out why and fix that instead of writing ugly ass patches that
> > > seemingly work around the problem without actually thinking about it.
> > > 
> > 
> > I think the reason is that kmalloc ( or kzalloc ... ) uses malloc_sizes
> > slab caches to allocate memory. The malloc_sizes slab caches is set up
> > without SLAB_NOTRACK flag, then kmemcheck marks the pages non-present to
> > do its check in page fault handling code. I think we shouldn't disable
> > kmemechek for the general malloc_sizes caches. 
> 
> Nobody said you should.. there's plenty of solutions that aren't ass
> backward stupid nor as ugly.
> 
> First you need to figure out why the page is marked non-present since
> the data structure is initialized (I've got a fair idea why), then look
> if you can tell kmemcheck not to be silly like that.
> 
> Alternatively you can change the nmi stuff to use static storage like
> other notifiers (see notifier_block).

OK, I will try to update the nmi one using this way.

But I think it couldn't be used to the perf stuff. 
For perf, maybe it's good for kmemcheck to have some flag like
__GFP_NO_PAGE_FAULT? Currently it seems only has flags like
__GFP_NOTRACK, which will still mark page non-present. 

> 
> What you don't ever do is write alternative code paths that are never
> ever used except for debugging, that is just asking for problems.
> 

Got it, thanks for the reminder! Previously, I thought the biggest
problem was wasting memory ...

Thanks,
Zhong


