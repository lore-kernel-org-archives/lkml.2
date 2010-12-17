Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0LQPCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:02:44 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45119 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab0LQPCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:02:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vhelKi38Rh7LINPzDWt2xpJv/W8bo38CRiYgF2tcMC9CKOCr9hPzIe/gC8CfjsaRPa
         wYZ6mipS/gqEbYUgI9uGlGYs6MG6LVGAE5HBMcPgy9xolke0bWsIhHNIT3WDWT76ydAl
         T8aObA93X0W3FxMafDooaPM34Y0O/lPL1zKZg=
MIME-Version: 1.0
In-Reply-To: <1292596194.2266.283.camel@twins>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	<1292596194.2266.283.camel@twins>
Date: Fri, 17 Dec 2010 16:02:42 +0100
Message-ID: <AANLkTi=L9KB_P62Rn7kpuMxbSNnE9U4+EZK6nwqFZ-x7@mail.gmail.com>
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
From: Harald Gustafsson <hgu1972@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Dario Faggioli <faggioli@gandalf.sssup.it>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/17 Peter Zijlstra <peterz@infradead.org>:
>
> I'm thinking this is going about it totally wrong..
>
> Solving the CPUfreq problem involves writing a SCHED_DEADLINE aware
> CPUfreq governor. The governor must know about the constraints placed on
> the system by the task-set. You simply cannot lower the frequency when
> your system is at u=1.
>
> Once you have a governor that keeps the freq such that: freq/max_freq >=
> utilization (which is only sufficient for deadline == period systems),
> then you need to frob the SCHED_DEADLINE runtime accounting.

I agree that this is the other part of the solution, which I have in a separate
ondemand governor, but that code is not ready for public review yet. Since that
code also incorporate other ondemand changes I'm playing with. Such
changes to the ondemand is quite simple it just picks a frequency that at
least supports the total dl bandwidth. It might get tricky for systems which
support individual/clusters frequency for the cores on the system together with
the G-EDF.

> Adding a complete normalized clock to the system like you've done is a
> total no-go, it adds overhead even for the !SCHED_DEADLINE case.

I suspected this, it works as a proof of concept, but not good for mainline.
I will rework this part, if we in general thinks having the dl runtime
accounting
be cpufreq "aware" is a good idea.

> The simple solution would be to slow down the runtime accounting of
> SCHED_DEADLINE tasks by freq/max_freq. So instead of having:
>
>  dl_se->runtime -= delta;
>
> you do something like:
>
>  dl_se->runtime -= (freq * delta) / max_freq;
>
> Which auto-magically grows the actual bandwidth, and since the deadlines
> are wall-time already it all works out nicely. It also keeps the
> overhead inside SCHED_DEADLINE.

OK, I can do that. My thought from the beginning was considering that
the reading of the clock was done more often then updating it, but I agree that
it has a negative impact on none dl threads.

/Harald
