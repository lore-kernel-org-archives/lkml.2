Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab0GLKVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 06:21:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52450 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab0GLKVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 06:21:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ied2kZRPx7UVI01Vd1F0nI1UHcolrPYcePreGhBxo/r78pvfWRO7cVPtpsUqfLWFL5
         HRibwK2Ds5NhLapvSHzAM7ifI9ReKo6mw7z+b8hYb1g+9iNGMxLNskJCGMhpET/Uz390
         tepVquF39NeSMS+cL8B37AViApxUvK/MGaqq0=
MIME-Version: 1.0
In-Reply-To: <B4F5A462-AE78-4BF0-B66E-4A5949A4A519@email.unc.edu>
References: <1278682707.6083.227.camel@Palantir>
	<1278685800.1900.212.camel@laptop>
	<AANLkTilufL0jgoqQLKjxbu0egN2l6lCkF9JPCxBfV3Gz@mail.gmail.com>
	<1278786710.1998.63.camel@laptop>
	<AANLkTin0sj6ONjNcwX6IJHSgi7gKnCzkvD_jaLyOFNjs@mail.gmail.com>
	<B4F5A462-AE78-4BF0-B66E-4A5949A4A519@email.unc.edu>
Date: Mon, 12 Jul 2010 12:21:47 +0200
Message-ID: <AANLkTint_Pi5D56texfp1h5kpLhFcCN1kggwrQhdK2xe@mail.gmail.com>
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Harald Gustafsson <hgu1972@gmail.com>
To: Bjoern Brandenburg <bbb@email.unc.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, Raistlin <raistlin@linux.it>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Song Yuan <song.yuan@ericsson.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <lucabe72@email.it>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
        Giuseppe Lipari <lipari@retis.sssup.it>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/11 Bjoern Brandenburg <bbb@email.unc.edu>:
> Trying to infer whether a task is "hard" or "soft" from task parameters is not a good idea, IMO. It's much better to make this an explicit part of the task model that is configured via sched_setparam. By default, tasks should be marked "soft" (this leaves more wiggle room to the kernel); users who care can change the flag to "hard".

Yes, this was along the lines of my suggestions also.

> Taking a step back, I think the problem here is that we are trying to shove too many concepts and properties into a single scheduler. Hard (no tardiness) is different from soft (bounded tardiness) is different from global is different from partitioned.
>
> From my point of view, it makes no sense to support hard deadlines under G-EDF (this is backed up by our schedulability studies [1]). Hard deadlines are best served by a P-EDF implementation (that only migrates on task creation/admission).
>
> Also, it makes little sense to worry about supporting both hard and soft in a P-EDF implementation. Just schedule everything by its deadline and both hard and soft tasks will be fine (if the admissions test was passed).
>
> In my opinion, it is much more useful to have a two-level scheduling framework: a truly partitioned EDF implementation at the top level to support "hard" tasks, and a truly global EDF implementation at the second level for "soft" tasks, with the property that the second level implementation is only invoked if the first level is idle. This nicely matches Linux's scheduling class hierarchy.

Would this prevent soft RT tasks to be pinned to a specific CPU, i.e.
have an affinity set of one CPU? I'm asking since we would like to use
soft deadline RT (bounded tardiness, e.g. with relative deadlines
short than periods), but with threads set to run on a specific CPU.
This is due to that we do an analysis on data dependencies etc in user
space applications (or offline) and distribute jobs among threads on
each CPU. At the same time we would like the isolation between
parallel running such applications and other CPU activities.

I'm not saying that all soft RT needs to be pinned or that some such
tasks can't be made to meet hard admission control but we would need
the possibility. If I would need to priorities between soft deadline
RT and CPU affinity, soft deadline RT would win, since it is still
quite likely that the tasks get scheduled on individual cores when
needed.

When you say truly global EDF implementation does that mean the
scheduler only considers relative deadline and may "migrate" a thread
among all the CPUs at each scheduling instance, disregarding cache
effects, power management (e.g. waking an idle core), etc? Or can
these things be factored into the relative deadlines (maybe they
already are by the user)?

/Harald
