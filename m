Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab1LWPIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 10:08:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab1LWPIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 10:08:37 -0500
Date: Fri, 23 Dec 2011 16:02:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Anders Johansson <ajohansson@novell.com>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: possible ERESTARTNOHAND leak into userspace
Message-ID: <20111223150227.GA27059@redhat.com>
References: <20111223131139.GA26157@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111223131139.GA26157@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, Michal Hocko wrote:
>
> Hi,
> this has already been discussed few years back with reports that select
> returned with ERESTARTNOHAND in multi-threaded applications
> (http://forum.soft32.com/linux/PATCH-select-fix-sys_select-leak-ERESTARTNOHAND-userspace-ftopict338572.html)
>
> Dave has come up with a possible explanation of the race but there was
> no further follow up with a conclusion.
>
> Just for reference:
>         Thread_A				Thread_B
> 	CPU0					CPU1
> 						syscall_XYZ
> core_sys_select
>   ret = -ERESTARTNOHAND;
>   if (signal_pending(current))
>      					do_notify_resume
>      					  do_signal (clear signal pending)

"clear signal pending" can't affect Thread_A. Even if it steals
the signal sent to Thread_A.

>   return ret;
> return from syscall
> no pending signal

please see above. Only the task itself can clear its TIF_DIGPENDING.

> return ERESTARTNOHAND

do_signal() should take care and restart the syscall.

> The race window is rather small and hard to trigger but we have seen
> reports where people really saw select returning ERESTARTNOHAND (on
> 2.6.16 based kernel - x86_64).
> I am not able to reproduce that myself neither with .16 kernel nor with
> the current vanilla so I am not sure whether the problem has been fixed
> already. But I do not see what prevents the race with vanilla.

I hope the problem was already fixed, at least I do not see anything
wrong in core_sys_select().

Oleg.

