Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab0JLRiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 13:38:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51491 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0JLRiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 13:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=naDt3bXfnIGBxBzNWLCJJm2CIONNMiixB5/hbEzfud5Qk1aFtnnRKY0IseLydz9dXc
         sEnDxDk7voQNIxVqU3pw==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1010121848061.2909@localhost6.localdomain6>
References: <20101012000159.7091.84336.stgit@dungbeetle.mtv.corp.google.com>
	<alpine.LFD.2.00.1010121046060.2909@localhost6.localdomain6>
	<AANLkTikgvZuT5+sgPyD-1j1gG+-pC0+4hpXQj7Z_ZuYE@mail.gmail.com>
	<alpine.LFD.2.00.1010121848061.2909@localhost6.localdomain6>
Date: Tue, 12 Oct 2010 10:38:45 -0700
Message-ID: <AANLkTimd=Zu85hdPLzZ8dpGJKpx=0SWJTrniMyRVstdz@mail.gmail.com>
Subject: Re: [PATCH] Fix a complex race in hrtimer code.
From: Salman Qazi <sqazi@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 9:54 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 12 Oct 2010, Salman Qazi wrote:
>> On Tue, Oct 12, 2010 at 1:49 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Mon, 11 Oct 2010, Salman Qazi wrote:
>> >> /* There are other issues, like deadlocks between multiple hrtimer_start observed
>> >>  * calls, at least in 2.6.34 that this lock works around.  Will look into
>> >>  * those later.
>> >
>> > Well, we don't have to work around callsites not serializing themself
>> > in the core code, right ?
>>
>> I assumed that the semantics were that hrtimer_starts are serialized
>> with respect to each other and with respect to cancels.   You seem to
>> disagree.
>
> Yes, I disagree. The code makes sure that cancel/start does not
> conflict with a running callback, but it's not responsible for random
> code fiddling with the same timer, really.

Sounds reasonable.

>
> The outcome of random start/cancel operations on two cpus of the same
> timer is just unpredictible, so where is the point of caring about
> that in the core code ?
>
>> In any case, I have to rerun that test without this lock with the
>> patch present.  It's possible that it was a symptom of the same bug
>> that we just didn't observe in production.
>
> Which bug did you observe in production and what's the code which is
> triggering this?

The initial observation in production that there is a lockup (noticed
through the NMI watchdog) in rb_insert_color when running certain
networking workloads that use the net cgroup subsystem.  Further down
in the stack trace, we notice that hrtimer for qdisc_watchdog (see:
net/sch_api.c) is the one that is being started when this happened and
then I remembered that I had already fixed something similar in our
tree for 2.6.26 and basically forgotten about that patch.   So, I went
back and dug out this patch and it fixed the problem.  Looking back,
the symptom was almost identical in 2.6.26, with the exception that it
would crash in rb_erase instead of locking up in rb_insert_color.

I wrote the above test to mimic the behaviour of the qdisc_watchdog
timer (except taken to extremes): long running callback function and
returning with NORESTART and it reproduces the symptom reliably.

>
> Thanks,
>
>        tglx
