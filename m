Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1JSQDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:03:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33075 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1JSQDv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:03:51 -0400
MIME-Version: 1.0
In-Reply-To: <20111019160037.GA11087@kroah.com>
References: <20111019153914.9153A2188@git.kroah.org>
	<20111019154910.GA9361@kroah.com>
	<CA+5PVA7-9Vyy+16+wXPCPEce3v4z8PxwW3WfGGBDzobAC-_-bQ@mail.gmail.com>
	<20111019160037.GA11087@kroah.com>
Date: Wed, 19 Oct 2011 12:03:50 -0400
Message-ID: <CA+5PVA6GnscQTRbv=r0NZvU4jNGwnr64OG6qAZvGhnjSAGCgrA@mail.gmail.com>
Subject: Re: Patch Upstream: cputimer: Cure lock inversion
From: Josh Boyer <jwboyer@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Dave Jones <davej@redhat.com>, Simon Kirby <sim@hostway.ca>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 12:00 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Oct 19, 2011 at 11:55:01AM -0400, Josh Boyer wrote:
>> On Wed, Oct 19, 2011 at 11:49 AM, Greg KH <greg@kroah.com> wrote:
>> > On Wed, Oct 19, 2011 at 11:39:14AM -0400, Gregs git-bot wrote:
>> >> commit: bcd5cff7216f9b2de0a148cc355eac199dc6f1cf
>> >> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> >> Date: Mon, 17 Oct 2011 11:50:30 +0200
>> >> Subject: cputimer: Cure lock inversion
>> >>
>> >> There's a lock inversion between the cputimer->lock and rq->lock;
>> >> notably the two callchains involved are:
>> >>
>> >>  update_rlimit_cpu()
>> >>    sighand->siglock
>> >>    set_process_cpu_timer()
>> >>      cpu_timer_sample_group()
>> >>        thread_group_cputimer()
>> >>          cputimer->lock
>> >>          thread_group_cputime()
>> >>            task_sched_runtime()
>> >>              ->pi_lock
>> >>              rq->lock
>> >>
>> >>  scheduler_tick()
>> >>    rq->lock
>> >>    task_tick_fair()
>> >>      update_curr()
>> >>        account_group_exec()
>> >>          cputimer->lock
>> >>
>> >> Where the first one is enabling a CLOCK_PROCESS_CPUTIME_ID timer, and
>> >> the second one is keeping up-to-date.
>> >>
>> >> This problem was introduced by e8abccb7193 ("posix-cpu-timers: Cure
>> >> SMP accounting oddities").
>> >
>> > There is no such patch in Linus's tree that I can find.  So, what
>> > problem is this really trying to cure here and what kernel did it show
>> > up in?
>>
>> Uh...
>>
>> bcd5cff7216f9b2de0a148cc355eac199dc6f1cf is the upstream commit (post -rc10).
>
> No, I understand that this is the commit I just referenced.
>
> I'm talking about the "This problem was introduced..." line in the
> commit.  I want to find out what was the original problem that this
> patch is fixing, to determine how far back in the -stable series I need
> to backport this to.

Ah, I misunderstood.

> The issue is that there is no e8abccb7193 ("posix-cpu-timers: Cure
> SMP accounting oddities") commit that I can see in Linus's tree right
> now.
>
>> This thread covers the conversation (it's long):
>>
>> http://thread.gmane.org/gmane.linux.kernel/1199406/focus=1204676
>
> Ugh, I'll go dig, but help would be appreciated...

My guess is they meant d670ec13178d0fd868

josh
