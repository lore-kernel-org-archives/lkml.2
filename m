Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934793Ab0KQMaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:30:17 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62425 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934769Ab0KQMaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:30:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=hSM+9Uvo4GVNU/Unhvotaggo1OrMezK2RkkfhA0RQ2LrrpJhQINPVjaOlk6YIf+/dq
         ukx5ZhrDM6/12bGmxttlHhbSSn35nTzWCUHTDy7X4Gc8hN12ehFpcAZmr32L/+xyYBKq
         k2IgqhPl84j4huRcDpt8qNDG9pzQiOq/uY11g=
MIME-Version: 1.0
In-Reply-To: <20101117122425.GA25294@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	<4CE38C53.8090606@kernel.org>
	<20101117120740.GA24972@elte.hu>
	<20101117122425.GA25294@elte.hu>
Date: Wed, 17 Nov 2010 14:30:08 +0200
X-Google-Sender-Auth: Bz9Wwgznk_47k4fqA6F-X3NOmDg
Message-ID: <AANLkTimFr5oNufB_Mzucmyq0y8zOPK30O5CkHP=sH_RF@mail.gmail.com>
Subject: Re: [patch] trace: Add user-space event tracing/injection
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 2:24 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> > Does this concept lend itself to tracing latencies in userspace applications
>> > that run in virtual machines (e.g. the Java kind)? I'm of course interested in
>> > this because of Jato [1] where bunch of interesting things can cause jitter: JIT
>> > compilation, GC, kernel, and the actual application doing something (in either
>> > native code or JIT'd code). It's important to be able to measure where
>> > "slowness" to desktop applications and certain class of server applications
>> > comes from to be able to improve things.
>>
>> Makes quite a bit of sense.
>>
>> How about the attached patch? It works fine with the simple testcase included in
>> the changelog. There's a common-sense limit on the message size - but otherwise it
>> adds support for apps to generate a free-form string trace event.
>
> The entirely untested Jato patch below adds support for this to Jato's user-space
> tracer. Btw., you have _hundreds_ of tracepoints in Jato, wow!
>
> The prctl() approach is very attractive because it's very simple to integrate. It's
> also reasonably fast, there's no fd baggage in prctl(). It is also arguably a
> 'process/task event' so fits prctl()'s original design (if it ever had one ...).
>
> Note, i kept the original Jato buffering as well, and the prctl() does finegrained
> events, one event per trace_printf() line printed.
>
> I think it makes sense to generate a separate event for all trace_printf() calls,
> because that way the events propagate immediately. OTOH i dont know how large the
> trace messages are - if there's really big tables printed (or lines are constructed
> out of many trace_printf() calls) then it may make sense to buffer them a bit.

There's two kinds of tracing: simple (almost) one-liners (e.g.
trace_invoke() function) that are similar to trace points and data
dumps (e.g. trace_lir() function). I don't think we want too hook the
latter to PR_TASK_PERF_USER_TRACE but for the former, it definitely
makes tons of sense for the former!

                        Pekka
