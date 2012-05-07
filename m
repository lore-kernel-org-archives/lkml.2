Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab2EGQ25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:28:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59881 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab2EGQ2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:28:54 -0400
Message-ID: <1336408208.3638.15.camel@lappy>
Subject: Re: [PATCH 3/3] tty_lock: Localise the lock
From: Sasha Levin <levinsasha928@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Mon, 07 May 2012 18:30:08 +0200
In-Reply-To: <20120507171126.5beddc27@pyramind.ukuu.org.uk>
References: <20120503212151.568.91854.stgit@bob.linux.org.uk>
	 <20120503212219.568.15653.stgit@bob.linux.org.uk>
	 <CA+1xoqezLCQh_fqJ1iNAs25X7Fm24W=-0J8zTZuVVJQnWTtSLg@mail.gmail.com>
	 <20120507171126.5beddc27@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 17:11 +0100, Alan Cox wrote:
> > I don't believe that this change is correct.
> > 
> > Consider the following scenario:
> > 
> > tty_release -> tty_lock -> pty_close -> tty_vhangup -> tty_lock
> 
> We hang up tty->link not tty.
> 
> It's now a per tty lock. So I think we are ok.

Unless we can cause tty->link == tty, in which case:

[ 6522.256890] =============================================
[ 6522.257023] [ INFO: possible recursive locking detected ]
[ 6522.257023] 3.4.0-rc6-next-20120507-sasha-00001-g06a300f #175 Tainted: G        W   
[ 6522.257023] ---------------------------------------------
[ 6522.257023] trinity/18088 is trying to acquire lock:
[ 6522.257023]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff82d8a6f2>] tty_lock+0x72/0x80
[ 6522.257023] 
[ 6522.257023] but task is already holding lock:
[ 6522.257023]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff82d8a6f2>] tty_lock+0x72/0x80
[ 6522.257023] 
[ 6522.257023] other info that might help us debug this:
[ 6522.257023]  Possible unsafe locking scenario:
[ 6522.257023] 
[ 6522.257023]        CPU0
[ 6522.257023]        ----
[ 6522.257023]   lock(&tty->legacy_mutex);
[ 6522.257023]   lock(&tty->legacy_mutex);
[ 6522.257023] 
[ 6522.257023]  *** DEADLOCK ***
[ 6522.257023] 
[ 6522.257023]  May be due to missing lock nesting notation
[ 6522.257023] 
[ 6522.257023] 1 lock held by trinity/18088:
[ 6522.257023]  #0:  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff82d8a6f2>] tty_lock+0x72/0x80
[ 6522.257023] 
[ 6522.257023] stack backtrace:
[ 6522.257023] Pid: 18088, comm: trinity Tainted: G        W    3.4.0-rc6-next-20120507-sasha-00001-g06a300f #175
[ 6522.257023] Call Trace:
[ 6522.257023]  [<ffffffff8111a509>] print_deadlock_bug+0x119/0x140
[ 6522.257023]  [<ffffffff8111c6fe>] validate_chain+0x5ee/0x790
[ 6522.257023]  [<ffffffff810f1418>] ? sched_clock_cpu+0x108/0x120
[ 6522.257023]  [<ffffffff8111ccc3>] __lock_acquire+0x423/0x4c0
[ 6522.257023]  [<ffffffff8111ce3c>] lock_acquire+0xdc/0x120
[ 6522.257023]  [<ffffffff82d8a6f2>] ? tty_lock+0x72/0x80
[ 6522.257023]  [<ffffffff82d86b60>] __mutex_lock_common+0x60/0x590
[ 6522.257023]  [<ffffffff82d8a6f2>] ? tty_lock+0x72/0x80
[ 6522.257023]  [<ffffffff82d8a6f2>] ? tty_lock+0x72/0x80
[ 6522.257023]  [<ffffffff82d871c0>] mutex_lock_nested+0x40/0x50
[ 6522.257023]  [<ffffffff82d8a6f2>] tty_lock+0x72/0x80
[ 6522.257023]  [<ffffffff81a2ce34>] __tty_hangup+0x74/0x400
[ 6522.257023]  [<ffffffff82d8a154>] ? _raw_spin_unlock_irqrestore+0x94/0xc0
[ 6522.257023]  [<ffffffff81a2d1e9>] tty_vhangup+0x9/0x10
[ 6522.257023]  [<ffffffff81a36264>] pty_close+0x154/0x160
[ 6522.257023]  [<ffffffff81a2dfcd>] tty_release+0xed/0x4d0
[ 6522.257023]  [<ffffffff8122d0eb>] ? vfs_lock_file+0x3b/0x40
[ 6522.257023]  [<ffffffff8122d18e>] ? locks_remove_posix+0x9e/0xe0
[ 6522.257023]  [<ffffffff811e13ea>] __fput+0x11a/0x2c0
[ 6522.257023]  [<ffffffff811e15a5>] fput+0x15/0x20
[ 6522.257023]  [<ffffffff811dd8b2>] filp_close+0x82/0xa0
[ 6522.257023]  [<ffffffff810bb914>] close_files+0x1b4/0x200
[ 6522.257023]  [<ffffffff810bb760>] ? sys_waitid+0x200/0x200
[ 6522.257023]  [<ffffffff810bb981>] put_files_struct+0x21/0x180
[ 6522.257023]  [<ffffffff82d8a090>] ? _raw_spin_unlock+0x30/0x60
[ 6522.257023]  [<ffffffff810bbb2d>] exit_files+0x4d/0x60
[ 6522.257023]  [<ffffffff810bc7b5>] do_exit+0x285/0x460
[ 6522.257023]  [<ffffffff810e74e1>] ? get_parent_ip+0x11/0x50
[ 6522.257023]  [<ffffffff810bca31>] do_group_exit+0xa1/0xe0
[ 6522.257023]  [<ffffffff810cceb8>] get_signal_to_deliver+0x348/0x3a0
[ 6522.257023]  [<ffffffff810e855d>] ? finish_task_switch+0x8d/0x110
[ 6522.257023]  [<ffffffff8104daf2>] do_signal+0x42/0x120
[ 6522.257023]  [<ffffffff810e74e1>] ? get_parent_ip+0x11/0x50
[ 6522.257023]  [<ffffffff810e7c1e>] ? sub_preempt_count+0xae/0xf0
[ 6522.257023]  [<ffffffff82d8850f>] ? __schedule+0x79f/0x7d0
[ 6522.257023]  [<ffffffff82d8a934>] ? retint_restore_args+0x13/0x13
[ 6522.257023]  [<ffffffff82d8a9bf>] ? retint_signal+0x11/0x92
[ 6522.257023]  [<ffffffff8104dc24>] do_notify_resume+0x54/0xb0
[ 6522.257023]  [<ffffffff82d8a9fb>] retint_signal+0x4d/0x92

