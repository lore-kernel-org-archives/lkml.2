Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab0HDFza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 01:55:30 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:56194 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab0HDFz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 01:55:29 -0400
References: <1278682707.6083.227.camel@Palantir> <1278685800.1900.212.camel@laptop> <AANLkTilufL0jgoqQLKjxbu0egN2l6lCkF9JPCxBfV3Gz@mail.gmail.com> <1278786710.1998.63.camel@laptop> <AANLkTin0sj6ONjNcwX6IJHSgi7gKnCzkvD_jaLyOFNjs@mail.gmail.com> <B4F5A462-AE78-4BF0-B66E-4A5949A4A519@email.unc.edu> <AANLkTint_Pi5D56texfp1h5kpLhFcCN1kggwrQhdK2xe@mail.gmail.com>
Message-Id: <42DEF92D-9AF0-46AA-B8D2-777FE4116C44@cs.unc.edu>
From: Bjoern Brandenburg <bbb@cs.unc.edu>
To: Harald Gustafsson <hgu1972@gmail.com>
In-Reply-To: <AANLkTint_Pi5D56texfp1h5kpLhFcCN1kggwrQhdK2xe@mail.gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Mailer: iPad Mail (7B405)
Mime-Version: 1.0 (iPad Mail 7B405)
Subject: Re: periods and deadlines in SCHED_DEADLINE
Date: Wed, 4 Aug 2010 01:55:55 -0400
Cc: Bjoern Brandenburg <bbb@email.unc.edu>,
        Peter Zijlstra <peterz@infradead.org>, Raistlin <raistlin@linux.it>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Song Yuan <song.yuan@ericsson.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <lucabe72@email.it>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        "bastoni@cs.unc.edu" <bastoni@cs.unc.edu>,
        Giuseppe Lipari <lipari@retis.sssup.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 12, 2010, at 6:21 AM, Harald Gustafsson <hgu1972@gmail.com> wrote:

> 2010/7/11 Bjoern Brandenburg <bbb@email.unc.edu>:
>> Trying to infer whether a task is "hard" or "soft" from task parameters is not a good idea, IMO. It's much better to make this an explicit part of the task model that is configured via sched_setparam. By default, tasks should be marked "soft" (this leaves more wiggle room to the kernel); users who care can change the flag to "hard".
> 
> Yes, this was along the lines of my suggestions also.
> 
>> Taking a step back, I think the problem here is that we are trying to shove too many concepts and properties into a single scheduler. Hard (no tardiness) is different from soft (bounded tardiness) is different from global is different from partitioned.
>> 
>> From my point of view, it makes no sense to support hard deadlines under G-EDF (this is backed up by our schedulability studies [1]). Hard deadlines are best served by a P-EDF implementation (that only migrates on task creation/admission).
>> 
>> Also, it makes little sense to worry about supporting both hard and soft in a P-EDF implementation. Just schedule everything by its deadline and both hard and soft tasks will be fine (if the admissions test was passed).
>> 
>> In my opinion, it is much more useful to have a two-level scheduling framework: a truly partitioned EDF implementation at the top level to support "hard" tasks, and a truly global EDF implementation at the second level for "soft" tasks, with the property that the second level implementation is only invoked if the first level is idle. This nicely matches Linux's scheduling class hierarchy.
> 
> Would this prevent soft RT tasks to be pinned to a specific CPU, i.e.
> have an affinity set of one CPU? I'm asking since we would like to use
> soft deadline RT (bounded tardiness, e.g. with relative deadlines
> short than periods), but with threads set to run on a specific CPU.
> This is due to that we do an analysis on data dependencies etc in user
> space applications (or offline) and distribute jobs among threads on
> each CPU. At the same time we would like the isolation between
> parallel running such applications and other CPU activities.

I think this is asking the wrong question. In the context of a global scheduler, it doesn't make sense to pin threads to individual CPUs. However, nobody is forcing you to use a global scheduler—just use partitioned EDF for your soft tasks, too, and you get bounded tardiness (the bound happens to be zero for implicit-deadline tasks). The appeal of using a global scheduler at all is that some workloads have bounded tardiness under global scheduling but not under partitioned scheduling, but the reverse is not true. 

> 
> I'm not saying that all soft RT needs to be pinned or that some such
> tasks can't be made to meet hard admission control but we would need
> the possibility. If I would need to priorities between soft deadline
> RT and CPU affinity, soft deadline RT would win, since it is still
> quite likely that the tasks get scheduled on individual cores when
> needed.
> 
> When you say truly global EDF implementation does that mean the
> scheduler only considers relative deadline and may "migrate" a thread
> among all the CPUs at each scheduling instance, disregarding cache
> effects, power management (e.g. waking an idle core), etc?

Global EDF does not consider cache affinity (but a reasonable implementation will avoid needless migrations). Applications that require string cache affinity are better served by partitioned schedulers if it is possible to partition the workload.

Power management is likely an area that will require some additional thought. However, at ECRTS, Thomas was strongly advocating race-to-idle, and this is what G-EDF does anyway: use all cores to get everything out of the way, asap. 

> Or can
> these things be factored into the relative deadlines (maybe they
> already are by the user)?

I'm not sure what you mean by that. Relative deadlines represent an application's timeliness requirements and nothing else. I guess the user could tweak parameters to force certain scheduling decisions, but I wouldn't recommend to encourage that in the kernel API.

- Björn
   

> 
