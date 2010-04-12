Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab0DLHVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 03:21:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46410 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab0DLHVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 03:21:05 -0400
Date: Mon, 12 Apr 2010 09:20:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
Message-ID: <20100412072056.GA2432@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
References: <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org>
 <20100410212555.GA1797@a1.tnic>
 <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org>
 <20100410215115.GA2599@a1.tnic>
 <20100411130801.GA7189@a1.tnic>
 <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org>
 <20100411185508.GA4450@liondog.tnic>
 <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, Apr 11, 2010 at 06:04:39PM -0700

> It checks each anonymous page at unmap time against the vma it gets 
> unmapped from. It depends on the previous vma_verify debugging patch, and 
> it would be interesting to hear whether this patch causes any new warnngs 
> for you..
> 
> If the warnings do happen, they are not going to be printing out any 
> hugely informative data apart from the fact that the bad case happened at 
> all. But If they do trigger, I can try to improve on them - it's just not 
> worth trying to make them any more interesting if they never trigger.

Haa, I think you're gonna want to improve them :)

	WARN_ONCE(1, "page->mapping does not exist in vma chain");

triggered on the first resume showing a rather messy 4 WARN_ONCEs. Had I
more cores, there maybe would've been more of them :) Maybe need locking
if clean output is of interest (see below).

So, anyway, if I can read this correctly, there is a page->mapping
anon_vma which is _not_ in the anon_vmas chain of the vma
(avc->same_vma).

And the spot we oops on is in page_referenced_anon():

	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {

which is actually where we iterate over all vmas associated with this
anon_vma.

So if that previous anon_vma pointed to by the page_mapping has been
falsely unlinked at some point, no wonder we boom on that later.

By the way, I completely understand when you say that your head hurts
from looking at this :).


[  486.580872] Restarting tasks ... done.
[  494.167242] [drm] Resetting GPU
[  495.422354] ------------[ cut here ]------------
[  495.422407] WARNING: at mm/memory.c:909 unmap_vmas+0x548/0xa29()
[  495.422442] Hardware name: System Product Name
[  495.422474] page->mapping does not exist in vma chain
[  495.422504] Modules linked in:
[  495.422545] ------------[ cut here ]------------
[  495.422555] ------------[ cut here ]------------
[  495.422565]  powernow_k8
[  495.422583] WARNING: at mm/memory.c:909 unmap_vmas+0x548/0xa29()
[  495.422591]  cpufreq_ondemand
[  495.422597] Hardware name: System Product Name
[  495.422602] page->mapping does not exist in vma chain cpufreq_powersave
[  495.422612] Modules linked in: cpufreq_userspace powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table freq_table cpufreq_conservative cpufreq_conservative binfmt_misc binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt kvm_amd dm_mod 8250_pnp kvm 8250 serial_core edac_core pcspkr k10temp ohci_hcd
[  495.422676]  ipv6Pid: 2919, comm: udevd Tainted: G        W  2.6.34-rc3-00506-g6c62fe4 #1
[  495.422689] Call Trace:
[  495.422694]  vfat
[  495.422700] ------------[ cut here ]------------
[  495.422721] WARNING: at mm/memory.c:909 unmap_vmas+0x548/0xa29()
[  495.422729]  fat [<ffffffff81038fe0>] warn_slowpath_common+0x7c/0x94
[  495.422746]  dm_crypt
[  495.422751] Hardware name: System Product Name
[  495.422758]  dm_modpage->mapping does not exist in vma chain
[  495.422767] Modules linked in: 8250_pnp [<ffffffff8103904f>] warn_slowpath_fmt+0x41/0x43
[  495.422784]  powernow_k8 cpufreq_ondemand 8250 cpufreq_powersave [<ffffffff810bcd20>] unmap_vmas+0x548/0xa29
[  495.422807]  serial_core cpufreq_userspace [<ffffffff810bd021>] ? unmap_vmas+0x849/0xa29
[  495.422828]  edac_core freq_table pcspkr cpufreq_conservative [<ffffffff810c17d8>] exit_mmap+0x102/0x1e4
[  495.422851]  binfmt_misc [<ffffffff810c173f>] ? exit_mmap+0x69/0x1e4
[  495.422863]  k10temp [<ffffffff810368bc>] mmput+0x48/0xb9
[  495.422876]  kvm_amd [<ffffffff8103ad90>] exit_mm+0x110/0x11d
[  495.422889]  ohci_hcd kvm
[  495.422903]  [<ffffffff8103c9e6>] do_exit+0x1c5/0x6e5
[  495.422909]  ipv6Pid: 2916, comm: udevd Tainted: G        W  2.6.34-rc3-00506-g6c62fe4 #1
[  495.422927]  [<ffffffff81065387>] ? trace_hardirqs_off_caller+0x1f/0xa9
[  495.422934] Call Trace:
[  495.422940]  vfat [<ffffffff8141016d>] ? retint_swapgs+0xe/0x13
[  495.422956]  fat [<ffffffff81038fe0>] warn_slowpath_common+0x7c/0x94
[  495.422972]  dm_crypt dm_mod 8250_pnp [<ffffffff8103cf8a>] do_group_exit+0x84/0xb0
[  495.422989]  8250 serial_core [<ffffffff8103cfcd>] sys_exit_group+0x17/0x1b
[  495.423013]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b
[  495.423019]  edac_core
[  495.423025] ---[ end trace d9664ac54d1edb0e ]---
[  495.423031]  pcspkr k10temp ohci_hcd
[  495.423043] Pid: 2914, comm: udevd Tainted: G        W  2.6.34-rc3-00506-g6c62fe4 #1
[  495.423055]  [<ffffffff8103904f>] warn_slowpath_fmt+0x41/0x43
[  495.423063] Call Trace:
[  495.423073]  [<ffffffff810bcd20>] unmap_vmas+0x548/0xa29
[  495.423087]  [<ffffffff81038fe0>] warn_slowpath_common+0x7c/0x94
[  495.423100]  [<ffffffff810bd021>] ? unmap_vmas+0x849/0xa29
[  495.423111]  [<ffffffff8103904f>] warn_slowpath_fmt+0x41/0x43
[  495.423123]  [<ffffffff810bcd20>] unmap_vmas+0x548/0xa29
[  495.423134]  [<ffffffff810bd021>] ? unmap_vmas+0x849/0xa29
[  495.423147]  [<ffffffff810c17d8>] exit_mmap+0x102/0x1e4
[  495.423159]  [<ffffffff810c17d8>] exit_mmap+0x102/0x1e4
[  495.423172]  [<ffffffff810c173f>] ? exit_mmap+0x69/0x1e4
[  495.423184]  [<ffffffff810c173f>] ? exit_mmap+0x69/0x1e4
[  495.423194]  [<ffffffff810368bc>] mmput+0x48/0xb9
[  495.423204]  [<ffffffff810368bc>] mmput+0x48/0xb9
[  495.423214]  [<ffffffff8103ad90>] exit_mm+0x110/0x11d
[  495.423225]  [<ffffffff8103ad90>] exit_mm+0x110/0x11d
[  495.423236]  [<ffffffff8103c9e6>] do_exit+0x1c5/0x6e5
[  495.423246]  [<ffffffff8103c9e6>] do_exit+0x1c5/0x6e5
[  495.423266]  [<ffffffff81065387>] ? trace_hardirqs_off_caller+0x1f/0xa9
[  495.423277]  [<ffffffff81065387>] ? trace_hardirqs_off_caller+0x1f/0xa9
[  495.423292]  [<ffffffff8141016d>] ? retint_swapgs+0xe/0x13
[  495.423303]  [<ffffffff8141016d>] ? retint_swapgs+0xe/0x13
[  495.423315]  [<ffffffff8103cf8a>] do_group_exit+0x84/0xb0
[  495.423325]  [<ffffffff8103cfcd>] sys_exit_group+0x17/0x1b
[  495.423334]  [<ffffffff8103cf8a>] do_group_exit+0x84/0xb0
[  495.423346]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b
[  495.423357]  [<ffffffff8103cfcd>] sys_exit_group+0x17/0x1b
[  495.423365] ---[ end trace d9664ac54d1edb0f ]---
[  495.423386]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b
[  495.423402] ---[ end trace d9664ac54d1edb10 ]---
[  495.424191] WARNING: at mm/memory.c:909 unmap_vmas+0x548/0xa29()
[  495.424215] Hardware name: System Product Name
[  495.424238] page->mapping does not exist in vma chain
[  495.424259] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 serial_core edac_core pcspkr k10temp ohci_hcd
[  495.424693] Pid: 1923, comm: udevd Tainted: G        W  2.6.34-rc3-00506-g6c62fe4 #1
[  495.424723] Call Trace:
[  495.424758]  [<ffffffff81038fe0>] warn_slowpath_common+0x7c/0x94
[  495.424788]  [<ffffffff8103904f>] warn_slowpath_fmt+0x41/0x43
[  495.424816]  [<ffffffff810bcd20>] unmap_vmas+0x548/0xa29
[  495.424843]  [<ffffffff810bd021>] ? unmap_vmas+0x849/0xa29
[  495.424875]  [<ffffffff810c17d8>] exit_mmap+0x102/0x1e4
[  495.424901]  [<ffffffff810c173f>] ? exit_mmap+0x69/0x1e4
[  495.424926]  [<ffffffff810368bc>] mmput+0x48/0xb9
[  495.424954]  [<ffffffff8103ad90>] exit_mm+0x110/0x11d
[  495.424981]  [<ffffffff8103c9e6>] do_exit+0x1c5/0x6e5
[  495.425008]  [<ffffffff81065387>] ? trace_hardirqs_off_caller+0x1f/0xa9
[  495.425038]  [<ffffffff8141016d>] ? retint_swapgs+0xe/0x13
[  495.425065]  [<ffffffff8103cf8a>] do_group_exit+0x84/0xb0
[  495.425091]  [<ffffffff8103cfcd>] sys_exit_group+0x17/0x1b
[  495.425119]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b
[  495.425156] ---[ end trace d9664ac54d1edb11 ]---


-- 
Regards/Gruss,
    Boris.
