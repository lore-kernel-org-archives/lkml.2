Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2EaLdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:33:35 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52274 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab2EaLdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:33:33 -0400
Date: Thu, 31 May 2012 17:01:15 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tty: annotate tty_lock() for lockdep
Message-ID: <20120531113115.GA1548@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <alpine.LNX.2.00.1205282042290.15057@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1205282042290.15057@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053111-9360-0000-0000-000006DBBC59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jiri, 



> =============================================
> [ INFO: possible recursive locking detected ]
> 3.4.0-08218-gb48b2c3 #7 Not tainted
> ---------------------------------------------
> blogd/279 is trying to acquire lock:
>  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff8150f51e>] tty_lock+0x3e/0x90
> 
> but task is already holding lock:
>  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff8150f51e>] tty_lock+0x3e/0x90
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&tty->legacy_mutex);
>   lock(&tty->legacy_mutex);
> 
>  *** DEADLOCK ***
> 

I saw a similar problem and applied your patch, but that doesnt seem to
help me.

INFO: possible recursive locking detected ]
3.4.0-uprobes-debug+ #86 Not tainted
---------------------------------------------
plymouthd/710 is trying to acquire lock:
 (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff813b5054>] tty_lock+0x6c/0x70

but task is already holding lock:
 (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff813b5054>] tty_lock+0x6c/0x70

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&tty->legacy_mutex);
  lock(&tty->legacy_mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by plymouthd/710:
 #0:  (tty_mutex){+.+.+.}, at: [<ffffffff8123f452>] tty_release+0x25a/0x536
 #1:  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff813b5054>]
tty_lock+0x6c/0x70

stack backtrace:
Pid: 710, comm: plymouthd Not tainted 3.4.0-uprobes-debug+ #86
Call Trace:
 [<ffffffff810346a6>] ? vprintk_emit+0x48e/0x4c8
 [<ffffffff8107847d>] validate_chain+0x6c7/0xe57
 [<ffffffff8106175e>] ? local_clock+0x41/0x5a
 [<ffffffff81074c71>] ? trace_hardirqs_off_caller+0x1f/0x9e
 [<ffffffff81079444>] __lock_acquire+0x837/0x8a8
 [<ffffffff810795b7>] lock_acquire+0x102/0x12f
 [<ffffffff813b5054>] ? tty_lock+0x6c/0x70
 [<ffffffff813b25b3>] ? mutex_lock_nested+0x2ee/0x320
 [<ffffffff813b5054>] ? tty_lock+0x6c/0x70
 [<ffffffff813b233a>] mutex_lock_nested+0x75/0x320
 [<ffffffff813b5054>] ? tty_lock+0x6c/0x70
 [<ffffffff81076116>] ? trace_hardirqs_on_caller+0x12f/0x166
 [<ffffffff813b5054>] tty_lock+0x6c/0x70
 [<ffffffff813b5093>] tty_lock_pair+0x3b/0x40
 [<ffffffff8123f45d>] tty_release+0x265/0x536
 [<ffffffff8110eaee>] fput+0x127/0x282
 [<ffffffff8123eb11>] tty_ioctl+0x3d6/0xa89
 [<ffffffff8110579a>] ? kmem_cache_free+0x1db/0x242
 [<ffffffff8111d0f6>] do_vfs_ioctl+0x466/0x4ac
 [<ffffffff813b4f51>] ? _raw_spin_unlock+0x2b/0x3f
 [<ffffffff813bc115>] ? sysret_check+0x22/0x5d
 [<ffffffff8111d192>] sys_ioctl+0x56/0x79
 [<ffffffff813bc0e9>] system_call_fastpath+0x16/0x1b

