Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab0HBTfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:35:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48202 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab0HBTfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:35:20 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Peter Zijlstra <peterz@infradead.org>
To: Bjoern Brandenburg <bbb@email.unc.edu>
Cc: Harald Gustafsson <hgu1972@gmail.com>, Raistlin <raistlin@linux.it>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Song Yuan <song.yuan@ericsson.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <lucabe72@email.it>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
        Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <B4F5A462-AE78-4BF0-B66E-4A5949A4A519@email.unc.edu>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685800.1900.212.camel@laptop>
	 <AANLkTilufL0jgoqQLKjxbu0egN2l6lCkF9JPCxBfV3Gz@mail.gmail.com>
	 <1278786710.1998.63.camel@laptop>
	 <AANLkTin0sj6ONjNcwX6IJHSgi7gKnCzkvD_jaLyOFNjs@mail.gmail.com>
	 <B4F5A462-AE78-4BF0-B66E-4A5949A4A519@email.unc.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 02 Aug 2010 21:34:58 +0200
Message-ID: <1280777698.1923.345.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-11 at 09:32 +0200, Bjoern Brandenburg wrote:

> Trying to infer whether a task is "hard" or "soft" from task
> parameters is not a good idea, IMO. It's much better to make this an
> explicit part of the task model that is configured via sched_setparam.
> By default, tasks should be marked "soft" (this leaves more wiggle
> room to the kernel); users who care can change the flag to "hard".

I think we're in violent agreement here ;-) and I was convinced that was
what we were talking about. The question was only how to represent that
in the sched_param_ex structure, the options were:

 struct sched_param_ex params;

 params.flags |= SF_SOFT;
 sched_setscheduler_ex( .policy = SCHED_DEADLINE, .param = &params);

vs

 sched_setscheduler_ex( .policy = SCHED_DEADLINE_{SOFT,HARD}, 
                        .param = &params);

> Taking a step back, I think the problem here is that we are trying to
> shove too many concepts and properties into a single scheduler. Hard
> (no tardiness) is different from soft (bounded tardiness) is different
> from global is different from partitioned.
> 
> From my point of view, it makes no sense to support hard deadlines
> under G-EDF (this is backed up by our schedulability studies [1]).
> Hard deadlines are best served by a P-EDF implementation (that only
> migrates on task creation/admission).
> 
The problem is more that we need to support things like cpu affinity and
cpusets within the context of a 'global' scheduler.

Using cpusets we can partition the 'load-balancer' and create clusters
(root-domains in linux scheduler speak).

Using cpu affinity we can limit tasks to a subset of their cluster's
cpus.

Esp. the latter is very hard to do, and I think we can get away with
only allowing a single cpu or the full cluster (its a new policy, so
there is no existing userspace to break).

This ends up meaning we need to support both P-EDF and G-EDF for soft,
and since we want to re-use pretty much all the code and only have a
different admission test for hard (initially), it would end up also
being P/G-EDF for hard (even though as you rightly point out, hard G-EDF
is pretty pointless -- but since the policy doesn't promise EDF, we
could later improve it to be PD^2 or whatever, at which point global
hard does start to make sense).

(which I guess would suggest we use different policies instead of a
flag, since that would make most sense if we end up replacing the hard
part with another policy)

So what I want to have is a sporadic task scheduler, not an EDF
scheduler (hence also the request to s/SCHED_EDF/SCHED_DEADLINE/ --
avoiding the obvious SCHED_SPORADIC in order to avoid confusion with the
POSIX thing).

EDF is just the easiest of the many different ways to schedule a
sporadic task set.

