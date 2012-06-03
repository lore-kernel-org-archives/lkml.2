Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab2FCWv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 18:51:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab2FCWv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 18:51:57 -0400
Date: Sun, 3 Jun 2012 18:51:52 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120603225152.GA11269@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120603223617.GB7707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120603223617.GB7707@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2012 at 06:36:17PM -0400, Dave Jones wrote:
 > I noticed I had a ton of core dumps (like 70G worth) in a directory
 > I hadn't cleaned up in a while, and set about deleting them.
 > After a while I noticed the rm wasn't making any progress.
 > Even more strange, the rm process doesn't show up in the process list.
 > The shell that spawned it is still there, with no child processes,
 > but it hasn't returned to accept new input. (no message of oom kills or
 > anything, just totally missing pids).
 > 
 > 
 > I did sysrq-t to see if it showed up there. It didn't, but.. I noticed
 > a ton of processes from my syscall fuzzer were still around, and all
 > of them were stuck in this trace..
 > 
 > 
 > trinity-child2  D 0000000000000000  5528 13066      1 0x00000004
 >  ffff880100a37ce8 0000000000000046 0000000000000006 ffff880129070000
 >  ffff880129070000 ffff880100a37fd8 ffff880100a37fd8 ffff880100a37fd8
 >  ffff880145ec4d60 ffff880129070000 ffff880100a37cd8 ffff88014784e2a0
 > Call Trace:
 >  [<ffffffff8164b919>] schedule+0x29/0x70
 >  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
 >  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
 >  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
 >  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
 >  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
 >  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
 >  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
 >  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
 >  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
 >  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
 >  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
 >  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
 >  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
 >  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 >  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
 >  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
 > 
 > The whole sysrq-t is attached.
 > 
 > I ran mc to try and kill off all those core files, as I was running low on disk space,
 > and it deleted them without problem.
 > 
 > The two bash processes are chewing up 100% CPU, though strace shows no output.

trying to run perf causes hung perf processes too. hrmph, messed up.

	Dave

perf            D 0000000000000000  3944  1525   1613 0x00000004
 ffff880103e49d58 0000000000000046 0000000000000006 ffff88012c0d4d60
 ffff88012c0d4d60 ffff880103e49fd8 ffff880103e49fd8 ffff880103e49fd8
 ffff880145edcd60 ffff88012c0d4d60 ffff880103e49d48 ffff88013ea31310
Call Trace:
 [<ffffffff8164b919>] schedule+0x29/0x70
 [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
 [<ffffffff816498a6>] mutex_lock_killable_nested+0x1a6/0x470
 [<ffffffff81046134>] ? mm_access+0x34/0xc0
 [<ffffffff81046134>] ? mm_access+0x34/0xc0
 [<ffffffff81046134>] mm_access+0x34/0xc0
 [<ffffffff8106eef0>] ? pid_task+0xd0/0xd0
 [<ffffffff81213b2c>] m_start+0x7c/0x190
 [<ffffffff811cfa50>] seq_read+0xa0/0x3e0
 [<ffffffff811aae1c>] vfs_read+0xac/0x180
 [<ffffffff811aaf3d>] sys_read+0x4d/0x90
 [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
perf            x 0000000000000000  5496  1526   1525 0x00000004
 ffff88013fbf7cb8 0000000000000046 ffff88013fbf7c68 ffffffff810b248c
 ffff8801423f8000 ffff88013fbf7fd8 ffff88013fbf7fd8 ffff88013fbf7fd8
 ffff880145ee8000 ffff8801423f8000 ffff88013fbf7ca8 ffff8801423f87e0
Call Trace:
 [<ffffffff810b248c>] ? lock_release_holdtime.part.24+0xcc/0x140
 [<ffffffff8164b919>] schedule+0x29/0x70
 [<ffffffff8104f960>] do_exit+0x670/0xb90
 [<ffffffff810627e1>] ? get_signal_to_deliver+0x291/0x930
 [<ffffffff810501cc>] do_group_exit+0x4c/0xc0
 [<ffffffff8106281e>] get_signal_to_deliver+0x2ce/0x930
 [<ffffffff8100225f>] do_signal+0x3f/0x610
 [<ffffffff812b5cc5>] ? security_file_permission+0x95/0xb0
 [<ffffffff811aa961>] ? rw_verify_area+0x61/0xf0
 [<ffffffff816551cc>] ? sysret_signal+0x5/0x47
 [<ffffffff810028d8>] do_notify_resume+0x88/0xc0
 [<ffffffff8165545a>] int_signal+0x12/0x17
 
