Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab0GJUIt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 16:08:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51058 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0GJUIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 16:08:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vWdOP2DLEHiQrnCydqLojwJUikqblzWAmKtDtErmP0uwaTjBZEC93VCM8FQHdL3AHm
         1X6i9sAbyqbka/LG+BDlpcyNtke7iwnDthtHA0bEJLaghIFqXbIdx8yp/t4r8KtgxMAC
         QE4fTTBWuvFZYbDL6dwNzjQZLig76crUzPi+g=
MIME-Version: 1.0
In-Reply-To: <1278786710.1998.63.camel@laptop>
References: <1278682707.6083.227.camel@Palantir>
	<1278685800.1900.212.camel@laptop>
	<AANLkTilufL0jgoqQLKjxbu0egN2l6lCkF9JPCxBfV3Gz@mail.gmail.com>
	<1278786710.1998.63.camel@laptop>
Date: Sat, 10 Jul 2010 22:08:46 +0200
Message-ID: <AANLkTin0sj6ONjNcwX6IJHSgi7gKnCzkvD_jaLyOFNjs@mail.gmail.com>
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Harald Gustafsson <hgu1972@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raistlin <raistlin@linux.it>, linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/10 Peter Zijlstra <peterz@infradead.org>:
> Sure, but 'quickly' doesn't convey whether its soft or hard RT you're
> interested in. The soft scheme would still have a bound on the tardiness
> and is quite sufficient for a large number of workloads (but of course
> there are plenty hard workloads too).

It's soft RT (since exist ways of recover) but with high requirement
on that failures being rare, e.g. once every 3000 periods due to QoS.

>> But also other use cases exist with longer running tasks (e.g. around
>> 5-10 ms) per period (e.g. around 20 ms). You might have several of
>> such tasks running, but as a system designer you know that their
>> activation phase will allow them to be scheduled interleaved. This can
>> be for example you know that the interrupt pattern waking the tasks
>> are interleaved. The admission test would be even more complex if we
>> also need to take into account the phases of task periods. Hence I
>> think some of these things need to be left for the system designer
>> without being hindered by an admission into the highest hard deadline
>> scheduling policy. As you might have understood I'm mostly talking
>> about embedded system, which have some tasks that are central parts of
>> the running system but which also might in parallel run more generic
>> software.
>
> That is a very delicate point, the whole reason SCHED_FIFO and friends
> suck so much is that they don't provide any kind of isolation, and thus,
> as an Operating-System abstraction they're an utter failure.
>
> If you take out admission control you end up with a similar situation.

OK, I see your point, and I also want to keep the isolation, its just
that I thought that the complexity might be too large to be accepted
by mainline. Let's work towards a solution with good admission
control, i.e. having more complex admission control to handle this.

> In general the sporadic task model schedulers don't need to be
> privileged because it does provide isolation. But the moment you allow
> by-passing the admission control everything goes out the window. So even
> a simple privileged flag telling the admission control to stuff it would
> render the whole system unusable, you'd have to start failing everything
> not having that flag, simply because the admission control is rendered
> useless.

Yes, thats true if you have any truly hard RT tasks in the system.
Could we have a way of making tasks with deadline=period also go into
the soft deadline RT policy and not just always run before any
deadline<period tasks? Maybe utilizing the flags field. In this way we
rather demote all tasks than elevate some tasks above other tasks, and
then the system designer could make sure that only using hard RT when
needed (and supported by the admission control). Since the fact that
it can be easily admission controlled is maybe not a sufficient fact
for making the user want to have it as a hard RT task, running before
tasks needing complex admission control. Also, without such notion the
behavior might change with new kernel releases when the admission
control is developed i.e suddenly some tasks will be scheduled as hard
that was previously scheduled as soft deadline RT.

> So I would like to take the stand that the mainline scheduler will not
> allow such a knob and people will have to help out with improving the
> admission controller.

OK, now I agree, let's keep the hard RT, but allow soft deadline
scheduling also.

> Embedded people can of course easily hack in whatever they well fancy,
> and adding the 'yes_I_really_want_this_anyway' flag or even taking out
> admission control all together is something the GPL allows them to do.

Not an option I would like to pursue, it should be possible to get a
working solution without this.
