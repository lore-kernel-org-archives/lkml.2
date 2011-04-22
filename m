Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1DVMFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:05:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23153 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1DVME5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:04:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lbA8/dL9O2OFkIcRoYKzgulYiXImkWL442TKKtLj7nAVXzLScotG6qdUk0daVa0TOQ
         gy6pctju19Dk5G/gAP1g==
MIME-Version: 1.0
In-Reply-To: <20110422105211.GB1948@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
	<20110422092322.GA1948@elte.hu>
	<BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
	<20110422105211.GB1948@elte.hu>
Date: Fri, 22 Apr 2011 14:04:53 +0200
Message-ID: <BANLkTinaZyHNV2Bm7CJFJ11WBCPGgsYijQ@mail.gmail.com>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 12:52 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> >> Generic cache events are a myth. They are not usable. [...]
>> >
>> > Well:
>> >
>> >  aldebaran:~> perf stat --repeat 10 -e instructions -e L1-dcache-loads -e L1-dcache-load-misses -e LLC-misses ./hackbench 10
>> >  Time: 0.125
>> >  Time: 0.136
>> >  Time: 0.180
>> >  Time: 0.103
>> >  Time: 0.097
>> >  Time: 0.125
>> >  Time: 0.104
>> >  Time: 0.125
>> >  Time: 0.114
>> >  Time: 0.158
>> >
>> >  Performance counter stats for './hackbench 10' (10 runs):
>> >
>> >     2,102,556,398 instructions             #      0.000 IPC     ( +-   1.179% )
>> >       843,957,634 L1-dcache-loads            ( +-   1.295% )
>> >       130,007,361 L1-dcache-load-misses      ( +-   3.281% )
>> >         6,328,938 LLC-misses                 ( +-   3.969% )
>> >
>> >        0.146160287  seconds time elapsed   ( +-   5.851% )
>> >
>> > It's certainly useful if you want to get ballpark figures about cache behavior
>> > of an app and want to do comparisons.
>> >
>> What can you conclude from the above counts?
>> Are they good or bad? If they are bad, how do you go about fixing the app?
>
> So let me give you a simplified example.
>
> Say i'm a developer and i have an app with such code:
>
> #define THOUSAND 1000
>
> static char array[THOUSAND][THOUSAND];
>
> int init_array(void)
> {
>        int i, j;
>
>        for (i = 0; i < THOUSAND; i++) {
>                for (j = 0; j < THOUSAND; j++) {
>                        array[j][i]++;
>                }
>        }
>
>        return 0;
> }
>
> Pretty common stuff, right?
>
> Using the generalized cache events i can run:
>
>  $ perf stat --repeat 10 -e cycles:u -e instructions:u -e l1-dcache-loads:u -e l1-dcache-load-misses:u ./array
>
>  Performance counter stats for './array' (10 runs):
>
>         6,719,130 cycles:u                   ( +-   0.662% )
>         5,084,792 instructions:u           #      0.757 IPC     ( +-   0.000% )
>         1,037,032 l1-dcache-loads:u          ( +-   0.009% )
>         1,003,604 l1-dcache-load-misses:u    ( +-   0.003% )
>
>        0.003802098  seconds time elapsed   ( +-  13.395% )
>
> I consider that this is 'bad', because for almost every dcache-load there's a
> dcache-miss - a 99% L1 cache miss rate!
>
> Then i think a bit, notice something, apply this performance optimization:
>
I don't think this example is really representative of the kind of problems
people face, it is just too small and obvious. So I would not generalize on it.

If you are happy with generalized cache events then, as I said, I am fine with
it. But the API should ALWAYS allow users access to raw events when they
need finer grain analysis.

> diff --git a/array.c b/array.c
> index 4758d9a..d3f7037 100644
> --- a/array.c
> +++ b/array.c
> @@ -9,7 +9,7 @@ int init_array(void)
>
>        for (i = 0; i < THOUSAND; i++) {
>                for (j = 0; j < THOUSAND; j++) {
> -                       array[j][i]++;
> +                       array[i][j]++;
>                }
>        }
>
> I re-run perf-stat:
>
>  $ perf stat --repeat 10 -e cycles:u -e instructions:u -e l1-dcache-loads:u -e l1-dcache-load-misses:u ./array
>
>  Performance counter stats for './array' (10 runs):
>
>         2,395,407 cycles:u                   ( +-   0.365% )
>         5,084,788 instructions:u           #      2.123 IPC     ( +-   0.000% )
>         1,035,731 l1-dcache-loads:u          ( +-   0.006% )
>             3,955 l1-dcache-load-misses:u    ( +-   4.872% )
>
>  - I got absolute numbers in the right ballpark figure: i got a million loads as
>   expected (the array has 1 million elements), and 1 million cache-misses in
>   the 'bad' case.
>
>  - I did not care which specific Intel CPU model this was running on
>
>  - I did not care about *any* microarchitectural details - i only knew it's a
>   reasonably modern CPU with caching
>
>  - I did not care how i could get access to L1 load and miss events. The events
>   were named obviously and it just worked.
>
> So no, kernel driven generalization and sane tooling is not at all a 'myth'
> today, really.
>
> So this is the general direction in which we want to move on. If you know about
> problems with existing generalization definitions then lets *fix* them, not
> pretend that generalizations and sane workflows are impossible ...
>
Again, to fix them, you need to give us definitions for what you expect those
events to count. Otherwise we cannot make forward progress.

Let me give just one simple example: cycles

What your definition for the generic cycle event?

There are various flavors:
  - count halted, unhalted cycles?
  - impacted by frequency scaling?

LLC-misses:
  - what considered the LLC?
  - does it include code, data or both?
  - does it include demand, hw prefetch?
  - it is to local or remote dram?

Once you have clear and precise definition, then we can look at the actual
events and figure out a mapping.
