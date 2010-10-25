Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0JYQ3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:29:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48174 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab0JYQ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:29:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fQGuVvXOVptZylmW6+GN7CC9Sw7PLQEHU8vilWaqesvQILKnymz2Ik3VNLdk7LoyHU
         5sM4xrZ3r2h7EyfcpP2Q==
MIME-Version: 1.0
In-Reply-To: <1288001573.15336.52.camel@twins>
References: <AANLkTin+HE09Oui89uCmG-rrHE14zXfJuRvZgsPCB1De@mail.gmail.com>
	<1287788622-25860-1-git-send-email-venki@google.com>
	<1288001573.15336.52.camel@twins>
Date: Mon, 25 Oct 2010 09:29:12 -0700
Message-ID: <AANLkTi=m4U4BR=nbu+Tu3hag886q2E2mPa6PJwciGg2R@mail.gmail.com>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually
 high load average when idle in 2.6.35, 2.6.35.1 and later)
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 3:12 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-10-22 at 16:03 -0700, Venkatesh Pallipadi wrote:
>> I started making small changes to the code, but none of the change helped much.
>> I think the problem with the current code is that, even though idle CPUs
>> update load, the fold only happens when one of the CPU is busy
>> and we end up taking its load into global load.
>>
>> So, I tried to simplify things and doing the updates directly from idle loop.
>> This is only a test patch, and eventually we need to hook it off somewhere
>> else, instead of idle loop and also this is expected work only as x86_64
>> right now.
>>
>> Peter: Do you think something like this will work? loadavg went
>> quite on two of my test systems after this change (4 cpu and 24 cpu).
>
> Not really, CPUs can stay idle for _very_ long times (!x86 cpus that
> don't have crappy timers like HPET which roll around every 2-4 seconds).
>
> But all CPUs staying idle for a long time is exactly the scenario you
> fix before using the decay_load_misses() stuff, except that is for the
> load-balancer per-cpu load numbers not the global cpu load avg. Won't a
> similar approach work here?
>

Yes. Thought about that. One problem there is that works with nohz_idle_balance,
which will not be called if all the CPUs are idle for example.
As this is once in 5 secs, probably doing nr_running() and
nr_uninterruptible() should
be OK even on huge systems. But, that was the original code here, except that
it was inside xtime_lock.

Thanks,
Venki
