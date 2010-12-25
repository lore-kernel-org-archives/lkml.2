Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab0LYCMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 21:12:19 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49766 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab0LYCMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 21:12:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=DQJgk8u2JXY2lSxDshkKSKloxn0Dz6t2A51Tzj6EfYfL7pn35COWswnQEiMCAlKTd7
         Rurwg8G+IK5jtxCd1Bi1KhKMJnWAzR76WuMyA/uVTLhBzzCZ5oTr3Z7ccIjSvGIUkBs0
         t0zaB0EFNnlromDDJ/tVdO08yDrQGSY9smCns=
Date: Sat, 25 Dec 2010 10:12:09 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix unsafe operation in high resolution timer
Message-ID: <20101225021209.GA11183@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <AANLkTinvHP4rZ6PSyEOJ_ZJ2chRJX0ZyzuhNoCRrO1wK@mail.gmail.com>
 <AANLkTikVQU6ozp0H1u7ghd0=miYyUJL62uP=0FBZSLok@mail.gmail.com>
 <AANLkTimc0FwBhj5MsnibTTq94AgaQgqCKEXNSOvM_XjE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimc0FwBhj5MsnibTTq94AgaQgqCKEXNSOvM_XjE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 10:28:52PM +0800, Hillf Danton wrote:
> On Fri, Dec 24, 2010 at 3:17 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> > On Thu, Dec 23, 2010 at 9:29 PM, Hillf Danton <dhillf@gmail.com> wrote:
> >> After calling the callback function of hrtimer, the timer could become
> >> unreliable in corner cases where the timer will no longer be queued
> >> and the mm segment, in which the timer is embedded, could be reclaimed
> >> in the callback.
> >>
> >> The unreliability is fixed by checking the result of callback before
> >> operating the timer again.
> >
> > Though the patch is buggy. But it actually explores a real problem.
> >
> 
> Would you please finger out why the patch is buggy?

No problem.

Actually the patch change the behavior of current hrtimer.
See comments below :)

> >> ---
> >>
> >> --- a/kernel/hrtimer.c  2010-11-01 19:54:12.000000000 +0800
> >> +++ b/kernel/hrtimer.c  2010-12-23 21:17:02.000000000 +0800
> >> @@ -1225,6 +1225,7 @@ static void __run_hrtimer(struct hrtimer
> >>        raw_spin_unlock(&cpu_base->lock);
> >>        trace_hrtimer_expire_entry(timer, now);
> >>        restart = fn(timer);
> >> +       if (restart != HRTIMER_NORESTART)
> >>        trace_hrtimer_expire_exit(timer);
> >>        raw_spin_lock(&cpu_base->lock);
> >>
> >> @@ -1236,11 +1237,8 @@ static void __run_hrtimer(struct hrtimer
> >>        if (restart != HRTIMER_NORESTART) {
> >>                BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
> >>                enqueue_hrtimer(timer, base);
> >> +               timer->state &= ~HRTIMER_STATE_CALLBACK;

HRTIMER_STATE_CALLBACK is only cleared for RESTART hrtimer with
your modification.

> >>        }
> >> -
> >> -       WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
> >> -
> >> -       timer->state &= ~HRTIMER_STATE_CALLBACK;

But for a hrtimer which is not free in its callback, like a
static defined one. the hrtimer could be referenced at the same
time. So here you cann't just delete the two lines.

Thanks,
Yong
