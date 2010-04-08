Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab0DHFxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 01:53:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43659 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab0DHFxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 01:53:11 -0400
Date: Thu, 8 Apr 2010 07:47:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
Message-ID: <20100408054707.GA9299@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
	hannes@cmpxchg.org
References: <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org>
 <20100408101925.FB9F.A69D9226@jp.fujitsu.com>
 <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, Apr 07, 2010 at 07:33:01PM -0700

> Anyway, I think it might be interesting to test my anon_vma_prepare() 
> locking change patch together with Rik's _first_ version of his "fix 
> anon_vma_prepare" thing (the one without the spinlock). They should apply 
> independently of each other, and maybe it all even works together.

There are still issues: vma_adjust() grabs mapping->i_mmap_lock for file
mappings while we might sleep in anon_vma_prepare():

[    9.386929] BUG: sleeping function called from invalid context at mm/rmap.c:119
[    9.387188] in_atomic(): 1, irqs_disabled(): 0, pid: 1068, name: modprobe
[    9.387343] 3 locks held by modprobe/1068:
[    9.387524]  #0:  (&p->cred_guard_mutex){+.+.+.}, at: [<ffffffff810d97fc>] prepare_bprm_creds+0x29/0x5a
[    9.387959]  #1:  (&mm->mmap_sem){++++++}, at: [<ffffffff81110ee2>] elf_map+0x70/0x190
[    9.388416]  #2:  (&(&inode->i_data.i_mmap_lock)->rlock){+.+...}, at: [<ffffffff810bcbdf>] vma_adjust+0x190
/0x3ca
[    9.388848] Pid: 1068, comm: modprobe Not tainted 2.6.34-rc3-00290-ge4b2849 #6
[    9.389102] Call Trace:
[    9.389256]  [<ffffffff810630f6>] ? __debug_show_held_locks+0x22/0x24
[    9.389418]  [<ffffffff8102c288>] __might_sleep+0x117/0x11b
[    9.389570]  [<ffffffff810c0f2e>] anon_vma_prepare+0x30/0x132
[    9.389722]  [<ffffffff810bcd95>] vma_adjust+0x346/0x3ca
[    9.389874]  [<ffffffff810bcf68>] __split_vma+0x14f/0x1b9
[    9.390027]  [<ffffffff810bd143>] do_munmap+0x171/0x315
[    9.390181]  [<ffffffff81110ee2>] ? elf_map+0x70/0x190
[    9.390335]  [<ffffffff81110f9d>] elf_map+0x12b/0x190
[    9.390493]  [<ffffffff81111b35>] load_elf_binary+0xb33/0x170e
[    9.390645]  [<ffffffff8102d529>] ? sub_preempt_count+0xa3/0xb6
[    9.390800]  [<ffffffff810d945a>] search_binary_handler+0x166/0x30e
[    9.390952]  [<ffffffff810d92ab>] ? copy_strings+0x1d4/0x1e5
[    9.391111]  [<ffffffff81111002>] ? load_elf_binary+0x0/0x170e
[    9.391265]  [<ffffffff810dadff>] do_execve+0x1fc/0x2f5
[    9.391424]  [<ffffffff8100a379>] sys_execve+0x43/0x61
[    9.391576]  [<ffffffff810025fa>] stub_execve+0x6a/0xc0


-- 
Regards/Gruss,
Boris.
