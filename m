Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab2DXWGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:06:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61531 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab2DXWGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:06:20 -0400
MIME-Version: 1.0
In-Reply-To: <4F7EB406.5020703@linaro.org>
References: <1329724172-27690-1-git-send-email-dmitry.antipov@linaro.org>
	<20120404171013.ac08575d.akpm@linux-foundation.org>
	<4F7EB406.5020703@linaro.org>
Date: Wed, 25 Apr 2012 10:06:19 +1200
X-Google-Sender-Auth: fIQ02s53ILiOwHw9t1Sgl3zGBgY
Message-ID: <CAHO5Pa3X9oC+kpUmJ_HYVRnckXOd-bf=7zTaUZguqN1KNL4MfQ@mail.gmail.com>
Subject: Re: [RFC PATCH] hrtimers: system-wide and per-task hrtimer slacks
From: Michael Kerrisk <mtk.manpages@gmail.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-man@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

On Fri, Apr 6, 2012 at 9:14 PM, Dmitry Antipov
<dmitry.antipov@linaro.org> wrote:
> On 04/05/2012 04:10 AM, Andrew Morton wrote:
>
>> Well..  there are some back-incompatibilities here.
>> prctl(PR_SET_TIMERSLACK, -1) used to restore current's slack setting to
>> whatever-we-inherited-at-fork, but that has been removed.  What are the
>> implications of this, and did we need to do it?
>
>
> It seems you're looking at the previous version of this patch
> (http://lkml.org/lkml/2012/2/20/55). Latest proposal is
> http://lwn.net/Articles/484162/, which defines PR_SET_TIMERSLACK
> action as:
> ...
> case PR_SET_TIMERSLACK:
>        if (arg2 <= 0)
>                current->timer_slack_ns =
>                        default_timer_slack_ns;
>        else if (arg2 <= HRTIMER_MAX_SLACK)
>                current->timer_slack_ns = arg2;
>        else
>                error = -EINVAL;
>        break;
> ...
>
>
>> If we do make changes in this area then the prctl manpage should be
>> updated, please.  And if
>> http://www.spinics.net/lists/linux-man/msg01149.html represents the
>> current state of that manpage then it should be updated anyway - that
>> entry doesn't say anything about the (arg2<= 0) case.
>
>
> I sent a patch for man pages too, it should be one of the recent posts
> at http://www.spinics.net/lists/linux-man/index.html.

Your response didn't actually address Andrew's point. Your patch
changes user-visible semantics that have been in place since kernel
2.6.28. Specifically:

* The meaning of prctl(PS_SET_TIMESLACK, n) changes,
  for the n<0 case (formerly, this reverted the timer slack
  to the per-process "default", with the proposed patch, it
  reverts the timer slack to a system-wide default).
* The semantics of setting the timer slack of a new thread
  have changed.

Perhaps these changes are warranted/necessary, but they *are* ABI
changes, and so should be carefully explained and well justified.

Thanks,

Michael

PS As background to the discussion, here's the current draft of some
text I plan to add to prctl(2) that explains the current semantics,
which would change with Dmitry's patch:

prctl(2):
       PR_SET_TIMERSLACK (since Linux 2.6.28)
              Set  the  timer slack for the calling thread to the value in
              arg2.  The timer slack is a value, expressed in nanoseconds,
              that  is  used  by the kernel to group timer expirations for
              this thread that are close to one another; as a consequence,
              timer expirations for this thread may be up to the specified
              number of nanoseconds late (but will  never  expire  early).
              Grouping timer expirations can help reduce system power con‐
              sumption by minimizing CPU wake-ups.

              The timer expirations affected by timer slack are those  set
              by  select(2), pselect(2), poll(2), ppoll(2), epoll_wait(2),
              epoll_pwait(2),   clock_nanosleep(2),   nanosleep(2),    and
              futex(2)  (and  thus  the  library functions implemented via
              futexes: pthread_cond_timedwait(3),  pthread_rwlock_timedrd‐
              lock(3), pthread_rwlock_timedwrlock(3), and sem_wait(3)).

              Each  thread  has  two  associated  timer  slack  values:  a
              "default" value, and a "current" value.  The "current" value
              is the one that governs grouping of timer expirations.  When
              a new thread is created, the two timer slack values are made
              the  same  as  the  "current"  value of the creating thread.
              Thereafter, a thread can adjust its timer  slack  value  via
              PR_SET_TIMERSLACK:  if  arg2  is  greater than zero, then it
              specifies a new value for the "current" timer slack for  the
              calling  thread; if arg2 is less than or equal to zero, then
              the "current" timer slack is set  to  the  "default"  value.
              The  timer  slack value of init (PID 1), the ancestor of all
              threads, is 50,000 nanoseconds (50 microseconds).

fork(2):
       *  The "default" timer slack of the child is set to  the  value  of
          the  "current"  timer slack of the parent.  (See the description
          of PR_SET_TIMERSLACK on prctl(2).)

-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
