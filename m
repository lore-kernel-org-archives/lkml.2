Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab1DINp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 09:45:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab1DINp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 09:45:57 -0400
Date: Sat, 9 Apr 2011 15:45:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Alexander Kaliadin <akaliadin@mvista.com>, oishi.y@sys.yzk.co.jp
Cc: linux-kernel@vger.kernel.org
Subject: Re: Likely race between sys_rt_sigtimedwait() and complete_signal()
Message-ID: <20110409134520.GA19651@redhat.com>
References: <20110407141215.46d0b930.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110407141215.46d0b930.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can't find the original email, replying to Andrew's fwd.

On 04/07, Andrew Morton wrote:
>
> Within project we are working on, we are facing a "rare" situation when
> setitimer() / sigwait() - based periodic task execution hangs. "Rare"
> means once per several hours for 1000 Hz timer.
>
> For hanged thread, cat /proc/pid/status shows
>
> ...
> State:	S (sleeping)
> ...
> SigPnd:	0000000000000000
> ShdPnd:	0000000000002000
> SigBlk:	0000000000000000
> ...
>
> and SysRq - T shows
>
> [<c015b1b0>] (__schedule+0x2fc/0x37c) from [<c015b7b8>]
> (schedule+0x1c/0x30)
> [<c015b7b8>] (schedule+0x1c/0x30) from [<c015b8c4>]
> (schedule_timeout+0x18/0x1dc)
> [<c015b8c4>] (schedule_timeout+0x18/0x1dc) from [<c004a084>]
> (sys_rt_sigtimedwait+0x1b4/0x288)
> [<c004a084>] (sys_rt_sigtimedwait+0x1b4/0x288) from [<c001cf00>]
> (ret_fast_syscall+0x0/0x28)

Is this thread the group leader?

> All other threads have SIGALRM blocked as they should, looking
> through /proc/X/status proves this.

Do they ever had SIGALRM unlblocked ?

> So for some reason, SIGALRM was successfully delivered by timer, bit was
> set in ShdPnd [I guess at the bottom of __send_signal()], but that still
> resulted somehow in thread going to schedule() and not waking.

Thanks for the detailed report.

There is an old, ancient problem which I constantly forget to fix.
It _can_ perfectly explain the hang, at least in theory. I'll try
to make the patch on Monday.



In short: if a thread T runs with SIGALRM unblocked while another
thread sleeps in sigtimedwait(), and then T blocks SIGALRM, the
signal can be "lost" as above.

Does your application do something like this? If not, then there
is another problem.



> This is on embedded system running vendor 2.6.31-based kernel, moving
> forward is unfortunately impossible because of hardware support issues.

If I make the patch for 2.6.31, any chance you can test it?

> However I guess the race we faced still exists in the current upstream
> kernel,

Yes, this is possible. OTOH, the bug can be anywhere, not necessarily in
signal.c, and it might be already fixed.

Oleg.

