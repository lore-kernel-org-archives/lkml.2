Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab2EYEph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 00:45:37 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59412 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2EYEpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 00:45:36 -0400
Message-ID: <4FBF0DF9.5040806@linaro.org>
Date: Thu, 24 May 2012 21:43:37 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Jiri Slaby <jslaby@suse.cz>, lkml <linux-kernel@vger.kernel.org>
Subject: tty_lock lockdep warning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052504-7282-0000-0000-0000095264D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Alan,
	I've been seeing the following lockdep warning w/ Linus' 3.5-rc HEAD 
from today. This is running x86_64 in a kvm environment.

Let me know if there are any other details you'd like from me.

thanks
-john


=============================================
[ INFO: possible recursive locking detected ]
3.4.0john+ #347 Not tainted
---------------------------------------------
plymouthd/1345 is trying to acquire lock:
  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81b10091>] tty_lock+0x61/0xb0

but task is already holding lock:
  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81b10091>] tty_lock+0x61/0xb0

other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&tty->legacy_mutex);
   lock(&tty->legacy_mutex);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

2 locks held by plymouthd/1345:
  #0:  (tty_mutex){+.+.+.}, at: [<ffffffff81417122>] tty_release+0x1e2/0x600
  #1:  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81b10091>] 
tty_lock+0x61/0xb0

stack backtrace:
Pid: 1345, comm: plymouthd Not tainted 3.4.0john+ #347
Call Trace:
  [<ffffffff81044727>] ? vprintk_emit+0x287/0x5d0
  [<ffffffff810b63b6>] validate_chain+0xf36/0x1380
  [<ffffffff8108b433>] ? sched_clock_local+0x43/0xb0
  [<ffffffff8108b6df>] ? local_clock+0x6f/0x80
  [<ffffffff810b0ee9>] ? trace_hardirqs_off_caller+0x29/0x140
  [<ffffffff810b6c3e>] __lock_acquire+0x43e/0xb80
  [<ffffffff810b7431>] lock_acquire+0xb1/0x210
  [<ffffffff81b10091>] ? tty_lock+0x61/0xb0
  [<ffffffff81b0c273>] mutex_lock_nested+0x73/0x4b0
  [<ffffffff81b10091>] ? tty_lock+0x61/0xb0
  [<ffffffff81b10091>] ? tty_lock+0x61/0xb0
  [<ffffffff81b10091>] tty_lock+0x61/0xb0
  [<ffffffff81b1013d>] tty_lock_pair+0x5d/0x64
  [<ffffffff8141712d>] tty_release+0x1ed/0x600
  [<ffffffff811851e8>] fput+0x138/0x2e0
  [<ffffffff81416d18>] tty_ioctl+0xb68/0xd40
  [<ffffffff81b0fee1>] ? _raw_spin_unlock_irqrestore+0x71/0xa0
  [<ffffffff81198d94>] do_vfs_ioctl+0xa4/0x5c0
  [<ffffffff8141d12c>] ? put_ldisc+0x11c/0x190
  [<ffffffff8141d1de>] ? tty_ldisc_deref+0xe/0x10
  [<ffffffff81413887>] ? tty_compat_ioctl+0xc7/0xf0
  [<ffffffff811ded87>] compat_sys_ioctl+0x257/0x1220
  [<ffffffff81b12138>] ? sysenter_dispatch+0x19/0x26
  [<ffffffff81392ffd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
  [<ffffffff81b12126>] sysenter_dispatch+0x7/0x26
  [<ffffffff81392fbe>] ? trace_hardirqs_on_thunk+0x3a/0x3f

