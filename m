Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab2EKKlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:41:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54355 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab2EKKlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:41:03 -0400
MIME-Version: 1.0
In-Reply-To: <CA+1xoqdi1Jdkrjtj9bmnDfs4Ok=o=AsmpP=MY0V8cDXjcSNm1w@mail.gmail.com>
References: <20120503212151.568.91854.stgit@bob.linux.org.uk>
 <20120503212219.568.15653.stgit@bob.linux.org.uk> <CA+1xoqezLCQh_fqJ1iNAs25X7Fm24W=-0J8zTZuVVJQnWTtSLg@mail.gmail.com>
 <20120507171126.5beddc27@pyramind.ukuu.org.uk> <1336408208.3638.15.camel@lappy>
 <20120507174240.4209c5cb@pyramind.ukuu.org.uk> <CA+1xoqez0PaX2KBHHN-etztwbFoU1cKx3NwMXX+PO4SguA3bRg@mail.gmail.com>
 <4FA838D2.9000908@suse.cz> <CA+1xoqdi1Jdkrjtj9bmnDfs4Ok=o=AsmpP=MY0V8cDXjcSNm1w@mail.gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 11 May 2012 12:40:41 +0200
Message-ID: <CA+1xoqcZnxGoo=_X1idCPTk9gR=drnAKhULGzgkH33zYGnAgOA@mail.gmail.com>
Subject: Re: [PATCH 3/3] tty_lock: Localise the lock
To: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 8:12 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Mon, May 7, 2012 at 11:04 PM, Jiri Slaby <jslaby@suse.cz> wrote:
>> On 05/07/2012 07:00 PM, Sasha Levin wrote:
>>>> So whatever your trace is showing, that's not the bug. Something more
>>>> complicated would appear to be afoot.
>>>
>>> Oddly enough, tty != tty->link, but the lockdep warning triggers.
>>>
>>> Any idea why it might happen?
>>
>> I think so, both locks are the same lockdep class. So lockdep thinks it
>> is the same lock. However this is a false positive. I guess we need
>> mutex_lock_nested...
>
> It looks like it causes an actual deadlock, and hung_tasks screams if
> left alone for a bit, so it doesn't look like a lockdep issue.

I've applied the patch that unlocks before hangup, and started seeing
this new warning instead (sorry if output below looks a bit broken,
linux-next has a printk rework in progress):

[   47.919734] =============================================
[   47.920013] [ INFO: possible recursive locking detected ]
[   47.920013] 3.4.0-rc6-next-20120511-sasha-00001-g1975c5f #183
Tainted: G        W
[   47.920013] ---------------------------------------------
[   47.920013] trinity/6825 is trying to acquire lock:
[   47.920013]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff82e9cd02>]
tty_lock+0x72/0x80
[   47.920013]
but task is already holding lock:
[   47.920013]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff82e9cd02>]
tty_lock+0x72/0x80
[   47.920013]
other info that might help us debug this:
[   47.920013]  Possible unsafe locking scenario:

[   47.920013]        CPU0
[   47.920013]        ----
[   47.920013]   lock(&tty->legacy_mutex);
[   47.920013]   lock(&tty->legacy_mutex);
[   47.920013]
 *** DEADLOCK ***

[   47.920013]  May be due to missing lock nesting notation

[   47.920013] 2 locks held by trinity/6825:
[   47.920013]  #0:  (tty_mutex){+.+.+.}, at: [<ffffffff81b00837>]
tty_release+0x177/0x4d0
[   47.920013]  #1:  (&tty->legacy_mutex){+.+.+.}, at:
[<ffffffff82e9cd02>] tty_lock+0x72/0x80
[   47.920013]
stack backtrace:
[   47.920013] Pid: 6825, comm: trinity Tainted: G        W
3.4.0-rc6-next-20120511-sasha-00001-g1975c5f #183
[   47.920013] Call Trace:
[   47.920013]  [<ffffffff811440b9>] print_deadlock_bug+0x119/0x140
[   47.920013]  [<ffffffff8114622e>] validate_chain+0x5ee/0x790
[   47.920013]  [<ffffffff81119eb8>] ? sched_clock_cpu+0x108/0x120
[   47.920013]  [<ffffffff811467f3>] __lock_acquire+0x423/0x4c0
[   47.920013]  [<ffffffff81146a1a>] lock_acquire+0x18a/0x1e0
[   47.920013]  [<ffffffff82e9cd02>] ? tty_lock+0x72/0x80
[   47.920013]  [<ffffffff82e99558>] ? __mutex_lock_common+0x518/0x590
[   47.920013]  [<ffffffff82e990a0>] __mutex_lock_common+0x60/0x590
[   47.920013]  [<ffffffff82e9cd02>] ? tty_lock+0x72/0x80
[   47.920013]  [<ffffffff82e9cd02>] ? tty_lock+0x72/0x80
[   47.920013]  [<ffffffff82e99700>] mutex_lock_nested+0x40/0x50
[   47.920013]  [<ffffffff82e9cd02>] tty_lock+0x72/0x80
[   47.920013]  [<ffffffff82e9cd36>] tty_lock_pair+0x26/0x54
[   47.920013]  [<ffffffff81b00842>] tty_release+0x182/0x4d0
[   47.920013]  [<ffffffff8122cf1a>] __fput+0x11a/0x2c0
[   47.920013]  [<ffffffff8122d0d5>] fput+0x15/0x20
[   47.920013]  [<ffffffff812293e2>] filp_close+0x82/0xa0
[   47.920013]  [<ffffffff810d6214>] close_files+0x1b4/0x200
[   47.920013]  [<ffffffff810d6060>] ? wait_task_stopped+0x3c0/0x3c0
[   47.920013]  [<ffffffff810d6425>] ? exit_files+0x45/0x60
[   47.920013]  [<ffffffff810d6281>] put_files_struct+0x21/0x180
[   47.920013]  [<ffffffff82e9c6a0>] ? _raw_spin_unlock+0x30/0x60
[   47.920013]  [<ffffffff810d642d>] exit_files+0x4d/0x60
[   47.920013]  [<ffffffff810d86e2>] do_exit+0x322/0x500
[   47.920013]  [<ffffffff810d8961>] do_group_exit+0xa1/0xe0
[   47.920013]  [<ffffffff810d89b2>] sys_exit_group+0x12/0x20
[   47.920013]  [<ffffffff82e9d7f9>] system_call_fastpath+0x16/0x1b
