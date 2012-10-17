Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab2JQTUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 15:20:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:50535 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab2JQTUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 15:20:36 -0400
Date: Wed, 17 Oct 2012 21:20:35 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: lockdep says circular locking since "tty: localise the lock"
Message-ID: <20121017192035.GA31303@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With dummy_hcd and g_nokia (that is CONFIG_USB_GADGET=m,
CONFIG_USB_DUMMY_HCD=m, CONFIG_USB_G_NOKIA=m) I see a lockdep complaing
about a "circular locking dependency" after executing

|modprobe dummy_hcd
|modprobe g_nokia
|cat /dev/ttyACM0 &
|sleep 1
|echo basilimi > /dev/ttyGS2

the first one goes well sometimes be the second one

|cat /dev/ttyACM0 &
|sleep 1
|echo basilimi > /dev/ttyGS2

triggers always the following output:

|======================================================
|[ INFO: possible circular locking dependency detected ]
|3.7.0-rc1+ #87 Not tainted
|-------------------------------------------------------
|kworker/0:1/17 is trying to acquire lock:
| (&tty->legacy_mutex){+.+.+.}, at: [<c1351956>] tty_lock_nested+0x36/0x80
|
|but task is already holding lock:
| ((&tty->hangup_work)){+.+...}, at: [<c104f8cf>] process_one_work+0x11f/0x5d0
|
|which lock already depends on the new lock.
|
|
|the existing dependency chain (in reverse order) is:
|
|-> #2 ((&tty->hangup_work)){+.+...}:
|       [<c107f364>] lock_acquire+0x84/0x190
|       [<c104da8d>] flush_work+0x3d/0x240
|       [<c1249b06>] tty_ldisc_flush_works+0x16/0x30
|       [<c124a9e1>] tty_ldisc_release+0x21/0x70
|       [<c1243f7c>] tty_release+0x35c/0x470
|       [<c1104fd8>] __fput+0xd8/0x270
|       [<c110517d>] ____fput+0xd/0x10
|       [<c1051fa9>] task_work_run+0xb9/0xf0
|       [<c1002a51>] do_notify_resume+0x51/0x80
|       [<c1351c7a>] work_notifysig+0x35/0x3b
|
|-> #1 (&tty->legacy_mutex/1){+.+...}:
|       [<c107f364>] lock_acquire+0x84/0x190
|       [<c134f18f>] mutex_lock_nested+0x5f/0x2d0
|       [<c1351956>] tty_lock_nested+0x36/0x80
|       [<c13519e9>] tty_lock_pair+0x29/0x70
|       [<c1243d38>] tty_release+0x118/0x470
|       [<c1104fd8>] __fput+0xd8/0x270
|       [<c110517d>] ____fput+0xd/0x10
|       [<c1051fa9>] task_work_run+0xb9/0xf0
|       [<c1002a51>] do_notify_resume+0x51/0x80
|       [<c1351c7a>] work_notifysig+0x35/0x3b
|
|-> #0 (&tty->legacy_mutex){+.+.+.}:
|       [<c107ec16>] __lock_acquire+0x1476/0x1660
|       [<c107f364>] lock_acquire+0x84/0x190
|       [<c134f18f>] mutex_lock_nested+0x5f/0x2d0
|       [<c1351956>] tty_lock_nested+0x36/0x80
|       [<c13519af>] tty_lock+0xf/0x20
|       [<c1242a44>] __tty_hangup+0x54/0x410
|       [<c1242e12>] do_tty_hangup+0x12/0x20
|       [<c104f94e>] process_one_work+0x19e/0x5d0
|       [<c10500a9>] worker_thread+0x119/0x3a0
|       [<c1055224>] kthread+0x94/0xa0
|       [<c1359177>] ret_from_kernel_thread+0x1b/0x28
|
|other info that might help us debug this:
|
|Chain exists of:
|  &tty->legacy_mutex --> &tty->legacy_mutex/1 --> (&tty->hangup_work)
|
| Possible unsafe locking scenario:
|
|       CPU0                    CPU1
|       ----                    ----
|  lock((&tty->hangup_work));
|                               lock(&tty->legacy_mutex/1);
|                               lock((&tty->hangup_work));
|  lock(&tty->legacy_mutex);
|
| *** DEADLOCK ***
|2 locks held by kworker/0:1/17:
| #0:  (events){.+.+.+}, at: [<c104f8cf>] process_one_work+0x11f/0x5d0
| #1:  ((&tty->hangup_work)){+.+...}, at: [<c104f8cf>] process_one_work+0x11f/0x5d0
|
|stack backtrace:
|Pid: 17, comm: kworker/0:1 Not tainted 3.7.0-rc1+ #87
|Call Trace:
| [<c1349996>] print_circular_bug+0x1af/0x1b9
| [<c107ec16>] __lock_acquire+0x1476/0x1660
| [<c107f364>] lock_acquire+0x84/0x190
| [<c1351956>] ? tty_lock_nested+0x36/0x80
| [<c134f18f>] mutex_lock_nested+0x5f/0x2d0
| [<c1351956>] ? tty_lock_nested+0x36/0x80
| [<c11f966f>] ? do_raw_spin_lock+0x3f/0x100
| [<c1351956>] tty_lock_nested+0x36/0x80
| [<c11f97be>] ? do_raw_spin_unlock+0x4e/0x90
| [<c13519af>] tty_lock+0xf/0x20
| [<c1242a44>] __tty_hangup+0x54/0x410
| [<c104f8cf>] ? process_one_work+0x11f/0x5d0
| [<c1242e12>] do_tty_hangup+0x12/0x20
| [<c104f94e>] process_one_work+0x19e/0x5d0
| [<c104f8cf>] ? process_one_work+0x11f/0x5d0
| [<c1242e00>] ? __tty_hangup+0x410/0x410
| [<c10500a9>] worker_thread+0x119/0x3a0
| [<c104ff90>] ? rescuer_thread+0x1d0/0x1d0
| [<c1055224>] kthread+0x94/0xa0
| [<c1359177>] ret_from_kernel_thread+0x1b/0x28
| [<c1055190>] ? kthread_create_on_node+0xc0/0xc0

This happens since

|commit 89c8d91e31f267703e365593f6bfebb9f6d2ad01
|Author: Alan Cox <alan@linux.intel.com>
|Date:   Wed Aug 8 16:30:13 2012 +0100
|
|    tty: localise the lock
|
|    The termios and other changes mean the other protections needed on the driver
|    tty arrays should be adequate. Turn it all back on.
|
|    This contains pieces folded in from the fixes made to the original patches
|
|    | From: Geert Uytterhoeven <geert@linux-m68k.org>   (fix m68k)
|    | From: Paul Gortmaker <paul.gortmaker@windriver.com>       (fix cris)
|    | From: Jiri Kosina <jkosina@suze.cz>                       (lockdep)
|    | From: Eric Dumazet <eric.dumazet@gmail.com>               (lockdep)
|
|    Signed-off-by: Alan Cox <alan@linux.intel.com>
|    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Sebastian
