Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab2AJFwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 00:52:33 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33619 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285Ab2AJFwb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 00:52:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9JG2XniMv5dVf1DixGNaQAJk-sZjnV9HfYeihEJP3JDyC4+Q@mail.gmail.com>
References: <CAH9JG2XniMv5dVf1DixGNaQAJk-sZjnV9HfYeihEJP3JDyC4+Q@mail.gmail.com>
Date: Tue, 10 Jan 2012 11:22:29 +0530
Message-ID: <CADDb1s2-Tsnns8qndpbS79cPAw2X_ORXqMsqWR=AuBoLCDneMg@mail.gmail.com>
Subject: Re: BUG: sleeping function called from invalid context at include/linux/freezer.h:45
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 9:57 AM, Kyungmin Park <kmpark@infradead.org> wrote:
> Dear all
>
> with the latest kernel. I got the below bug message.
> It calls the sleep function. Does it intended operation?
>
> static inline bool try_to_freeze(void)
> {
>        might_sleep();
>        if (likely(!freezing(current)))
>                return false;
>        return __refrigerator(false);
> }
this change is part of this GIT:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=a0acae0e886d44bd5ce6d2f173c1ace0fcf0d9f6

>
> # poweroff
> [    6.852523] BUG: sleeping function called from invalid context at
> include/linux/freezer.h:45
> [    6.859489] in_atomic(): 0, irqs_disabled(): 128, pid: 1, name: init
> [    6.865846] [<c0013508>] (unwind_backtrace+0x0/0xec) from
> [<c0010124>] (do_signal+0x88/0x588)
> [    6.874337] [<c0010124>] (do_signal+0x88/0x588) from [<c001063c>]
> (do_notify_resume+0x18/0x38)
> [    6.882928] [<c001063c>] (do_notify_resume+0x18/0x38) from
> [<c000dc18>] (work_pending+0x24/0x28)
is this the complete backtrace...?
The above backtrace shows that freezing was called from a context
wherein - IRQs are disabled - which resulted in this error.
How about checking ...
BUG_ON(irqs_disabled()); in try_to_freeze()...
not sure though... please check and update me also...
>
> commit e4e11180dfa545233e5145919b75b7fac88638df
> Merge: 37cfc3f adc0e91
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Mon Jan 9 17:37:37 2012 -0800
>
>    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/vi
>
> Thank you,
> Kyungmin Park
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
