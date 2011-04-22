Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1DVKwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 06:52:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54082 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526Ab1DVKwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 06:52:32 -0400
Date: Fri, 22 Apr 2011 12:52:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [generalized cache events] Re: [PATCH 1/1] perf tools: Add missing
 user space support for config1/config2
Message-ID: <20110422105211.GB1948@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> >> Generic cache events are a myth. They are not usable. [...]
> >
> > Well:
> >
> >  aldebaran:~> perf stat --repeat 10 -e instructions -e L1-dcache-loads -e L1-dcache-load-misses -e LLC-misses ./hackbench 10
> >  Time: 0.125
> >  Time: 0.136
> >  Time: 0.180
> >  Time: 0.103
> >  Time: 0.097
> >  Time: 0.125
> >  Time: 0.104
> >  Time: 0.125
> >  Time: 0.114
> >  Time: 0.158
> >
> >  Performance counter stats for './hackbench 10' (10 runs):
> >
> >     2,102,556,398 instructions             #      0.000 IPC     ( +-   1.179% )
> >       843,957,634 L1-dcache-loads            ( +-   1.295% )
> >       130,007,361 L1-dcache-load-misses      ( +-   3.281% )
> >         6,328,938 LLC-misses                 ( +-   3.969% )
> >
> >        0.146160287  seconds time elapsed   ( +-   5.851% )
> >
> > It's certainly useful if you want to get ballpark figures about cache behavior
> > of an app and want to do comparisons.
> >
> What can you conclude from the above counts?
> Are they good or bad? If they are bad, how do you go about fixing the app?

So let me give you a simplified example.

Say i'm a developer and i have an app with such code:

#define THOUSAND 1000

static char array[THOUSAND][THOUSAND];

int init_array(void)
{
	int i, j;

	for (i = 0; i < THOUSAND; i++) {
		for (j = 0; j < THOUSAND; j++) {
			array[j][i]++;
		}
	}

	return 0;
}

Pretty common stuff, right?

Using the generalized cache events i can run:

 $ perf stat --repeat 10 -e cycles:u -e instructions:u -e l1-dcache-loads:u -e l1-dcache-load-misses:u ./array

 Performance counter stats for './array' (10 runs):

         6,719,130 cycles:u                   ( +-   0.662% )
         5,084,792 instructions:u           #      0.757 IPC     ( +-   0.000% )
         1,037,032 l1-dcache-loads:u          ( +-   0.009% )
         1,003,604 l1-dcache-load-misses:u    ( +-   0.003% )

        0.003802098  seconds time elapsed   ( +-  13.395% )

I consider that this is 'bad', because for almost every dcache-load there's a 
dcache-miss - a 99% L1 cache miss rate!

Then i think a bit, notice something, apply this performance optimization:

diff --git a/array.c b/array.c
index 4758d9a..d3f7037 100644
--- a/array.c
+++ b/array.c
@@ -9,7 +9,7 @@ int init_array(void)
 
 	for (i = 0; i < THOUSAND; i++) {
 		for (j = 0; j < THOUSAND; j++) {
-			array[j][i]++;
+			array[i][j]++;
 		}
 	}
 
I re-run perf-stat:

 $ perf stat --repeat 10 -e cycles:u -e instructions:u -e l1-dcache-loads:u -e l1-dcache-load-misses:u ./array

 Performance counter stats for './array' (10 runs):

         2,395,407 cycles:u                   ( +-   0.365% )
         5,084,788 instructions:u           #      2.123 IPC     ( +-   0.000% )
         1,035,731 l1-dcache-loads:u          ( +-   0.006% )
             3,955 l1-dcache-load-misses:u    ( +-   4.872% )

        0.001806438  seconds time elapsed   ( +-   3.831% )

And i'm happy that indeed the l1-dcache misses are now super-low and that the 
app got much faster as well - the cycle count is a third of what it was before 
the optimization!

Note that:

 - I got absolute numbers in the right ballpark figure: i got a million loads as 
   expected (the array has 1 million elements), and 1 million cache-misses in 
   the 'bad' case.

 - I did not care which specific Intel CPU model this was running on

 - I did not care about *any* microarchitectural details - i only knew it's a 
   reasonably modern CPU with caching

 - I did not care how i could get access to L1 load and miss events. The events 
   were named obviously and it just worked.

So no, kernel driven generalization and sane tooling is not at all a 'myth' 
today, really.

So this is the general direction in which we want to move on. If you know about 
problems with existing generalization definitions then lets *fix* them, not 
pretend that generalizations and sane workflows are impossible ...

Thanks,

	Ingo
