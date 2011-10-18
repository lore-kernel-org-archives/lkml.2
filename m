Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab1JROgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:36:03 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:50390 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab1JROgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:36:01 -0400
Date: Tue, 18 Oct 2011 12:35:50 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Philipp Herz - Profihost AG <p.herz@profihost.ag>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Vanilla-Kernel 3 - page allocation failure
Message-ID: <20111018143550.GE3782@oc1711230544.ibm.com>
References: <4E9D53FF.7090609@profihost.ag>
 <20111018113251.GA3782@oc1711230544.ibm.com>
 <4E9D6C0A.1030801@profihost.ag>
 <20111018123838.GD3782@oc1711230544.ibm.com>
 <4E9D7E1C.9080202@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9D7E1C.9080202@profihost.ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 03:24:44PM +0200, Philipp Herz - Profihost AG wrote:
> Hello Cascardo
> 
> > Usually, after the stack dump, there is some
> > statistics about memory.
> Yes, i have seen this in other posts as well.
> 
> > I have seen that these may be suppressed
> > if you have a NUMA system with lots of nodes.
> Yes, in our case it seems to be suppressed.
> 
> > Check for NODE_SHIFT in your
> > config. If it's greater than 8, that output may have been suppressed.
> CONFIG_NODES_SHIFT=10 will be the answer.
> 
> Is there any way to get those stats without recompiling the kernel?
> 
> > But you may have just ignored the statistics because of the
> > stack dump.
> No, i was also wondering why other do have these ;-)
> 
> Regards,
> Philipp
> 

echo m > /proc/sysrq-trigger

will show you that same output, but not at the time the memory failure
happens. It may still show you what is the condition of memory on your
nodes.

I am not that much versed in the VM. It just happens that I had very
similar issues lately and was trying to undertand it a little more. I
still have to solve these issues myself.

In my case, the workload is IO bound on extX filesystems and I see that
other systems have these failures due to this memory pressure. Usually,
after stopping the workload and unmounting the filesystems, I get most
of the memory in the system freed.

Most of the failures are from GFP_ATOMIC allocations, because those
won't reclaim memory, but they won't allocate if there is only freed
memory below the threshold. Setting this threshold to a lower value
like it was suggested (min_free_kbytes) would have helped, but, then,
this allows whatever is putting pressure on your memory to also allocate
below the threshold and you end up in the same situation (or a worse
one).

Do your workload works better on a previous version? I had problems
using something like 2.6.32.

Regards,
Cascardo.

> Am 18.10.2011 14:38, schrieb Thadeu Lima de Souza Cascardo:
> >On Tue, Oct 18, 2011 at 02:07:38PM +0200, Philipp Herz - Profihost AG wrote:
> >>Hello Cascardo,
> >>
> >>thanks for your detailed answer!
> >>
> >>I have uploaded two call traces to pastebin for further investigation.
> >>
> >>Maybe this can help you.
> >>
> >>* http://pastebin.com/Psg2dGYC (kworker)
> >>* http://pastebin.com/pPFjZqxL (php5)
> >>
> >>Regards,
> >>Philipp
> >>
> >
> >Hello, Philipp.
> >
> >That only tells us that you have a TCP workload in your system. This is
> >the subsystem that is trying to allocate memory. However, we do not know
> >why there is failure. Usually, after the stack dump, there is some
> >statistics about memory. I have seen that these may be suppressed if you
> >have a NUMA system with lots of nodes. Check for NODE_SHIFT in your
> >config. If it's greater than 8, that output may have been suppressed.
> >But you may have just ignored the statistics because of the stack dump.
> >
> >Regards,
> >Cascardo.
> >
> >>
> >>Am 18.10.2011 13:32, schrieb Thadeu Lima de Souza Cascardo:
> >>>On Tue, Oct 18, 2011 at 12:25:03PM +0200, Philipp Herz - Profihost AG wrote:
> >>>>After updating kernel (x86_64) to stable version 3 there are a few
> >>>>messages appearing in the kernel log such as
> >>>>
> >>>>kworker/0:1: page allocation failure: order:1, mode:0x20
> >>>>mysql: page allocation failure: order:1, mode:0x20
> >>>>php5: page allocation failure: order:1, mode:0x20
> >>>>
> >>>>Searching the net showed that these messages are known to occur since 2004.
> >>>>
> >>>>Some people were able to get rid of them by setting
> >>>>/proc/sys/vm/min_free_kbytes to a high enough value. This does not
> >>>>help in our case.
> >>>>
> >>>>
> >>>>Is there a kernel comand line argument to avoid these messages?
> >>>>
> >>>>As of mm/page_alloc.c these messages are marked to be only warning
> >>>>messages and would not appear if 'gpf_mask' was set to __GFP_NOWARN
> >>>>in function warn_alloc_failed.
> >>>>
> >>>>How does this mask get set? Is it set by the "external" process
> >>>>knocking at the memory manager?
> >>>>
> >>>
> >>>Hello, Philipp.
> >>>
> >>>This happens when kernel tries to allocate memory, sometimes in response
> >>>to some request by the user space, but also in other contexts. For
> >>>example, an interrupt by a network driver may try to allocate memory. In
> >>>this context, it will use GFP_ATOMIC as a mask, for example. The most
> >>>usual flags in the kernel are GFP_KERNEL and GFP_ATOMIC.
> >>>
> >>>>What is the magic behind the 'order' and 'mode'?
> >>>>
> >>>
> >>>The order is the binary log of the number of pages requested. So, order 1
> >>>allocations are 2 pages, order 4 would be 16 pages, for example.
> >>>
> >>>The mode is, in fact, gfp_flags. 0x20 is GFP_ATOMIC. This kind of
> >>>allocation cannot do IO or access the filesystem. Also, it cannot wait
> >>>for reclaim memory from cache.
> >>>
> >>>This warning is usually followed by some statistics about memory use
> >>>in your system. Please post it to give more information about this
> >>>situation.
> >>>
> >>>I have watched some of this happen when lots of cache is used by some
> >>>filesystems. Perhaps, some tweaking of the vm sysctl options may help,
> >>>but I can point any magic tweaking right now.
> >>>
> >>>Regards,
> >>>Cascardo.
> >>>
> >>>>I'm not a subscriber, so please CC me a copy of messages related to
> >>>>the subject. I'm not sure if I can help much by looking at the
> >>>>inside of the kernel, but I will try my best to answer any questions
> >>>>concerning this issue.
> >>>>
> >>>>Best regards, Philipp
> >>>>--
> >>>>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >>>>the body of a message to majordomo@vger.kernel.org
> >>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>>Please read the FAQ at  http://www.tux.org/lkml/
> >>>
> >>
> >
> 
