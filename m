Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab1ANSf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:35:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38789 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1ANSf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:35:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=BncprW4icnKfUSqVeeJCE8QCsdtet0ptcYqCoGqS0Cix9y7JMtrOpV6K7ZPkObgnjS
         97syzmz8Mvyrbv0ENIw+faAOPuxEuANR1atjnjZFrbqsGhA/7PsPN//ynLEoERsdaEMb
         e98jcbQDfIVGBkz3ihXEd6PSAX0sE7AVWKfdY=
Date: Fri, 14 Jan 2011 19:35:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH] tracing, perf : add cpu hotplug trace events
Message-ID: <20110114183516.GB1926@nowhere>
References: <AANLkTimsR3=BKSF8EyASu4_T_vTznw4yEqmxPS8gOQCy@mail.gmail.com>
 <20110107151200.GB1736@nowhere>
 <AANLkTi=L3=_2dzHH4Wu6QWXw=AUjxtrAu60xfM3-Qwn4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=L3=_2dzHH4Wu6QWXw=AUjxtrAu60xfM3-Qwn4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 07:25:08PM +0100, Vincent Guittot wrote:
> On 7 January 2011 16:12, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> +
> >> + TP_PROTO(unsigned int type, unsigned int step, unsigned int cpuid),
> >
> > I feel a bit uncomfortable with these opaque type and step.
> >
> > What about splitting the events:
> >
> >        cpu_down_start
> >        cpu_down_end
> >
> >        cpu_up_start
> >        cpu_up_end
> >
> > This ways they are much more self-explanatory.
> >
> > I also feel uncomfortable about exposing arch step details in core
> > tracepoints.
> >
> > But if we consider the following sequence:
> >
> >        cpu_down() {
> >                __cpu_disable() {
> >                        platform_cpu_disable();
> >                }
> >        }
> >
> > Then exposing start/end of cpu_disable() makes sense, by way of:
> >
> >        cpu_arch_disable_start
> >        cpu_arch_disable_end
> >
> >        cpu_arch_enable_start
> >        cpu_arch_enable_end
> >
> >
> >        cpu_arch_die_start
> >        cpu_arch_die_end
> >
> >        cpu_arch_die_start
> >        cpu_arch_die_end
> >
> > Because they are arch events that you can retrieve everywhere, the tracepoints
> > are still called from the code code.
> >
> > Now for the machine part, it's very highly arch specific, most notably for arm
> > so I wonder if it would make more sense to keep that seperate into arch
> > tracepoints.
> >
> 
> May be we could find some event names that matches for all system and
> that can be kept in the same file ?

But that's only an ARM concern, right? So ARM can create its own
set of tracepoints for that. If that becomes more widely useful then
we can think about gathering the whole into a single file.

> > How does that all look? I hope I'm not overengineering.
> >
> 
> that's could be ok for me, I can find almost the same kind of
> information with this solution. I just wonder what traces are the
> easiest to treat for extracting some latency measurement or to treat
> with other event like the power event.

Hmm, I'm not sure what you mean. You want to know which tracepoints
can be useful to measure latencies? Well, it depends on what kind
of latency you seek in general: scheduler, io, etc...
