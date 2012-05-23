Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab2EWCFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:05:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977Ab2EWCFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:05:50 -0400
Date: Tue, 22 May 2012 22:02:47 -0400
From: Dave Jones <davej@redhat.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: 3.4+ tty lockdep trace
Message-ID: <20120523020247.GA5653@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Alan Cox <alan@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20120523002645.GA3490@redhat.com>
 <CACVXFVMz_GKHXpzbqt24yY=fHJ6uYZPOcSnKNFHrvbdpWxc7tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMz_GKHXpzbqt24yY=fHJ6uYZPOcSnKNFHrvbdpWxc7tw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A different one. This time with devpts. (With the patch Ming Lei pointed to on top of Linus current)

	Dave

 ======================================================
 [ INFO: possible circular locking dependency detected ]
 3.4.0+ #25 Not tainted
 -------------------------------------------------------
 sshd/632 is trying to acquire lock:
  (devpts_mutex){+.+.+.}, at: [<ffffffff813b9846>] pty_close+0x156/0x180
 
 but task is already holding lock:
  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81656cb2>] tty_lock_nested+0x42/0x90
 
 which lock already depends on the new lock.
 
 
 the existing dependency chain (in reverse order) is:
 
 -> #1 (&tty->legacy_mutex){+.+.+.}:
        [<ffffffff810b51e2>] lock_acquire+0x92/0x1f0
        [<ffffffff816534f1>] mutex_lock_nested+0x71/0x3b0
        [<ffffffff81656cb2>] tty_lock_nested+0x42/0x90
        [<ffffffff81656d10>] tty_lock+0x10/0x20
        [<ffffffff813afe8f>] tty_init_dev+0x6f/0x140
        [<ffffffff813b9946>] ptmx_open+0xa6/0x180
        [<ffffffff811aa2fb>] chrdev_open+0x9b/0x1b0
        [<ffffffff811a289b>] __dentry_open+0x26b/0x380
        [<ffffffff811a3d64>] nameidata_to_filp+0x74/0x80
        [<ffffffff811b5af8>] do_last+0x468/0x900
        [<ffffffff811b60a2>] path_openat+0xd2/0x3f0
        [<ffffffff811b64e1>] do_filp_open+0x41/0xa0
        [<ffffffff811a3e5d>] do_sys_open+0xed/0x1c0
        [<ffffffff811a3f51>] sys_open+0x21/0x30
        [<ffffffff8165e6d2>] system_call_fastpath+0x16/0x1b
 
 -> #0 (devpts_mutex){+.+.+.}:
        [<ffffffff810b43ae>] __lock_acquire+0x132e/0x1aa0
        [<ffffffff810b51e2>] lock_acquire+0x92/0x1f0
        [<ffffffff816534f1>] mutex_lock_nested+0x71/0x3b0
        [<ffffffff813b9846>] pty_close+0x156/0x180
        [<ffffffff813b0203>] tty_release+0x183/0x5d0
        [<ffffffff811a765c>] fput+0x12c/0x300
        [<ffffffff811a23a9>] filp_close+0x69/0xa0
        [<ffffffff811a2f2d>] sys_close+0xad/0x1a0
        [<ffffffff8165e6d2>] system_call_fastpath+0x16/0x1b
 
 other info that might help us debug this:
 
  Possible unsafe locking scenario:
 
        CPU0                    CPU1
        ----                    ----
   lock(&tty->legacy_mutex);
                                lock(devpts_mutex);
                                lock(&tty->legacy_mutex);
   lock(devpts_mutex);
 
  *** DEADLOCK ***
 
 1 lock held by sshd/632:
  #0:  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81656cb2>] tty_lock_nested+0x42/0x90
 
 stack backtrace:
 Pid: 632, comm: sshd Not tainted 3.4.0+ #25
 Call Trace:
  [<ffffffff8164a64a>] print_circular_bug+0x1fb/0x20c
  [<ffffffff810b43ae>] __lock_acquire+0x132e/0x1aa0
  [<ffffffff810b51e2>] lock_acquire+0x92/0x1f0
  [<ffffffff813b9846>] ? pty_close+0x156/0x180
  [<ffffffff816534f1>] mutex_lock_nested+0x71/0x3b0
  [<ffffffff813b9846>] ? pty_close+0x156/0x180
  [<ffffffff8165a70d>] ? sub_preempt_count+0x6d/0xd0
  [<ffffffff813b9846>] ? pty_close+0x156/0x180
  [<ffffffff81656bd2>] ? _raw_spin_unlock_irqrestore+0x42/0x80
  [<ffffffff8107d9c3>] ? __wake_up+0x53/0x70
  [<ffffffff813b9846>] pty_close+0x156/0x180
  [<ffffffff813b0203>] tty_release+0x183/0x5d0
  [<ffffffff811c5670>] ? vfsmount_lock_local_unlock_cpu+0x70/0x70
  [<ffffffff811a765c>] fput+0x12c/0x300
  [<ffffffff811a23a9>] filp_close+0x69/0xa0
  [<ffffffff811a2f2d>] sys_close+0xad/0x1a0
  [<ffffffff8165e6d2>] system_call_fastpath+0x16/0x1b

