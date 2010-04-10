Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab0DJRKO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 13:10:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456Ab0DJRKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 13:10:11 -0400
Date: Sat, 10 Apr 2010 10:05:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <20100410163828.GA25579@a1.tnic>
Message-ID: <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
References: <20100409191425.GB10780@a1.tnic> <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org> <20100409204328.GG28964@cmpxchg.org> <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
 <20100410003110.GI28964@cmpxchg.org> <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org> <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic> <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
 <20100410163828.GA25579@a1.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 10 Apr 2010, Borislav Petkov wrote:
> 
> And I got an oops again, this time the #GP from couple of days ago.

Oh damn. So the list corruption really does happen still.

And the pattern is similar, but not the same: now it's 0032323200323232, 
rather than 002e2e2e002e2e2e. Very intriguing. 0x32 instead of 0x2e, but 
the same pattern of duplicated bytes. And not very helpful in that it 
still doesn't actually make any sense.

> <thinking out loud>
> 
> I'm starting to think that maybe there could be something wrong with the
> machine I'm running it on. Especially since there are only two people
> who reported this issue, Steinar and me, so how probable is it that
> maybe those two machines have failing RAM module somewhere? Or some
> other data corrupting thing? Although I should be getting mchecks...
> Hmm...

No. Just the fact that there are two people who reported the same 
thing is already a pretty strong sign that it's real. Also, hardware 
problems don't tend to be as consistent in the details as yours have 
been. 

And in fact I have seen it personally (but couldn't reproduce it) on the 
kids mac mini after you reported it.

So I'm convinced the problem is real, and just not so easily 
triggered, and you're being a great tester.

			Linus
--
Here's the one I've seen, in case you care.  I haven't posted it, because 
it doesn't really add anything new.

 BUG: unable to handle kernel NULL pointer dereference at (null)
 IP: [<c02850cf>] page_referenced+0xd6/0x199
 *pde = 21d73067 *pte = 00000000 
 Oops: 0000 [#2] SMP 
 last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/block/sda/uevent
 Modules linked in: [last unloaded: scsi_wait_scan]
 
 Pid: 14440, comm: firefox Tainted: G      D    2.6.34-rc2-00391-gfc1203c #3 Mac-F4208EC8/Macmini1,1
 EIP: 0060:[<c02850cf>] EFLAGS: 00210287 CPU: 1
 EIP is at page_referenced+0xd6/0x199
 EAX: f59e65d4 EBX: c10b5480 ECX: 00000000 EDX: fffffff0
 ESI: f59e65d0 EDI: 00000000 EBP: d8f77cd8 ESP: d8f77ca0
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
 Process firefox (pid: 14440, ti=d8f76000 task=cb795440 task.ti=d8f76000)
 Stack:
  f59e65d4 00000000 fffffff0 c15ba000 d8f77cbc c02885b8 c07972c4 d8f77cdc
  c0276712 00000000 00000001 c10b5498 c10b5480 d8f77e94 d8f77d58 c0276b53
  d8f77d48 00000000 00000000 00000000 0000001d d8f77de8 00000001 c07972c4
 Call Trace:
  [<c02885b8>] ? swapcache_free+0x1b/0x24
  [<c0276712>] ? __remove_mapping+0x90/0xb2
  [<c0276b53>] ? shrink_page_list+0x109/0x3ba
  [<c0277099>] ? shrink_inactive_list+0x295/0x48e
  [<c0273d68>] ? determine_dirtyable_memory+0x34/0x4b
  [<c0273dd0>] ? get_dirty_limits+0x16/0x26d
  [<c027750c>] ? shrink_zone+0x27a/0x327
  [<c03c55a5>] ? i915_gem_shrink+0x67/0x22c
  [<c0277e6d>] ? do_try_to_free_pages+0x17d/0x292
  [<c0278078>] ? try_to_free_pages+0x6a/0x72
  [<c0275cd7>] ? isolate_pages_global+0x0/0x1bd
  [<c0273210>] ? __alloc_pages_nodemask+0x2c2/0x447
  [<c027f1c1>] ? handle_mm_fault+0x188/0x605
  [<c02192c3>] ? do_page_fault+0x253/0x269
  [<c0219070>] ? do_page_fault+0x0/0x269
  [<c05b9e82>] ? error_code+0x66/0x6c
  [<c05b0000>] ? azx_probe+0x5e8/0x8ae
  [<c0219070>] ? do_page_fault+0x0/0x269
 Code: f9 f2 74 18 ff 75 08 8d 45 f0 50 89 d8 e8 62 f6 ff ff 01 c7 59 83 7d f0 00 58 74 20 8b 55 d0 8b 42 10 83 e8 10 89 45 d0 8b 55 d0 <8b> 42 10 0f 18 00 90 89 d0 83 c0 10 39 45 c8 75 ab fe 06 e9 90 
 EIP: [<c02850cf>] page_referenced+0xd6/0x199 SS:ESP 0068:d8f77ca0
 CR2: 0000000000000000
 ---[ end trace 890710798f4c0070 ]---

