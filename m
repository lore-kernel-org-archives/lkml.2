Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1HZR3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 13:29:09 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64278 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1HZR3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 13:29:05 -0400
Message-ID: <4E57D7DD.5030902@lwfinger.net>
Date: Fri, 26 Aug 2011 12:29:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Lockdep warning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a new version of the staging driver rtl8192e, I'm getting the lockdep 
warning posted below. The lock in question is for a timer that uses init_timer() 
for initialization. From the definition of that macro, I thought this was 
initialized with a lock_class_key that should prevent this warning. Obviously, 
I'm missing something.

Any pointers would be appreciated.

Thanks,

Larry


[   88.048077] =============================================
[   88.048086] [ INFO: possible recursive locking detected ]
[   88.048093] 3.1.0-rc3-staging+ #5
[   88.048097] ---------------------------------------------
[   88.048102] kmemleak/631 is trying to acquire lock:
[   88.048108]  (ptimer){+.-...}, at: [<ffffffff81059370>] del_timer_sync+0x0/0xc0
[   88.048124]
[   88.048125] but task is already holding lock:
[   88.048131]  (ptimer){+.-...}, at: [<ffffffff81058e54>] 
run_timer_softirq+0x124/0x400
[   88.048142]
[   88.048143] other info that might help us debug this:
[   88.048149]  Possible unsafe locking scenario:
[   88.048150]
[   88.048156]        CPU0
[   88.048159]        ----
[   88.048162]   lock(ptimer);
[   88.048167]   lock(ptimer);
[   88.048172]
[   88.048173]  *** DEADLOCK ***
[   88.048174]
[   88.048179]  May be due to missing lock nesting notation
[   88.048180]
[   88.048187] 2 locks held by kmemleak/631:
[   88.048191]  #0:  (scan_mutex){+.+...}, at: [<ffffffff81122e76>] 
kmemleak_scan_thread+0x56/0xd0
[   88.048206]  #1:  (ptimer){+.-...}, at: [<ffffffff81058e54>] 
run_timer_softirq+0x124/0x400
[   88.048218]
[   88.048219] stack backtrace:
[   88.048225] Pid: 631, comm: kmemleak Tainted: G         C  3.1.0-rc3-staging+ #5
[   88.048232] Call Trace:
[   88.048236]  <IRQ>  [<ffffffff81083cbb>] __lock_acquire+0x119b/0x1ea0
[   88.048254]  [<ffffffff81084fa5>] lock_acquire+0x95/0x120
[   88.048263]  [<ffffffff81059370>] ? process_timeout+0x10/0x10
[   88.048272]  [<ffffffff810593ac>] del_timer_sync+0x3c/0xc0
[   88.048280]  [<ffffffff81059370>] ? process_timeout+0x10/0x10
[   88.048289]  [<ffffffff81058e54>] ? run_timer_softirq+0x124/0x400
[   88.048316]  [<ffffffffa008d1ee>] TsInitAddBA+0x6e/0x170 [r8192e_pci]
[   88.048332]  [<ffffffffa008b4b3>] TsAddBaProcess+0x33/0x50 [r8192e_pci]
[   88.048341]  [<ffffffff81058edb>] run_timer_softirq+0x1ab/0x400
[   88.048350]  [<ffffffff81058e54>] ? run_timer_softirq+0x124/0x400
[   88.048364]  [<ffffffffa008b480>] ? RxPktPendingTimeout+0x2d0/0x2d0 [r8192e_pci]
[   88.048377]  [<ffffffff810502ad>] __do_softirq+0xbd/0x210
[   88.048386]  [<ffffffff810714d7>] ? hrtimer_interrupt+0x137/0x240
[   88.048396]  [<ffffffff8137176c>] call_softirq+0x1c/0x30
[   88.048406]  [<ffffffff810048c5>] do_softirq+0x85/0xc0
[   88.048414]  [<ffffffff81050686>] irq_exit+0x96/0xc0
[   88.048422]  [<ffffffff8101e4e9>] smp_apic_timer_interrupt+0x69/0xa0
[   88.048431]  [<ffffffff8136fff0>] apic_timer_interrupt+0x70/0x80
[   88.048438]  <EOI>  [<ffffffff8136ea4d>] ? _raw_spin_unlock_irqrestore+0x3d/0x70
[   88.048452]  [<ffffffff81122315>] scan_gray_list+0x155/0x170
[   88.048460]  [<ffffffff8112262b>] kmemleak_scan+0x2fb/0x6e0
[   88.048468]  [<ffffffff81122330>] ? scan_gray_list+0x170/0x170
[   88.048477]  [<ffffffff81122e20>] ? kmemleak_write+0x390/0x390
[   88.048485]  [<ffffffff81122e20>] ? kmemleak_write+0x390/0x390
[   88.048494]  [<ffffffff81122e7b>] kmemleak_scan_thread+0x5b/0xd0
[   88.048502]  [<ffffffff81122e20>] ? kmemleak_write+0x390/0x390
[   88.048510]  [<ffffffff8106c8e6>] kthread+0x96/0xa0
[   88.048519]  [<ffffffff81371674>] kernel_thread_helper+0x4/0x10
[   88.048527]  [<ffffffff8136ed9d>] ? retint_restore_args+0xe/0xe
[   88.048536]  [<ffffffff8106c850>] ? __init_kthread_worker+0x70/0x70
[   88.048544]  [<ffffffff81371670>] ? gs_change+0xb/0xb
