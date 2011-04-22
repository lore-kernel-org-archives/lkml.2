Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1DVUsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 16:48:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42476 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab1DVUsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 16:48:06 -0400
Date: Fri, 22 Apr 2011 22:47:40 +0200
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
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110422204740.GA21364@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <BANLkTinaZyHNV2Bm7CJFJ11WBCPGgsYijQ@mail.gmail.com>
 <20110422131846.GA20760@elte.hu>
 <BANLkTi=jdSG1Zefn_b7Pv2NyT1jdREzW8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=jdSG1Zefn_b7Pv2NyT1jdREzW8w@mail.gmail.com>
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

> On Fri, Apr 22, 2011 at 3:18 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Stephane Eranian <eranian@google.com> wrote:
> >
> > > > Say i'm a developer and i have an app with such code:
> > > >
> > > > #define THOUSAND 1000
> > > >
> > > > static char array[THOUSAND][THOUSAND];
> > > >
> > > > int init_array(void)
> > > > {
> > > >        int i, j;
> > > >
> > > >        for (i = 0; i < THOUSAND; i++) {
> > > >                for (j = 0; j < THOUSAND; j++) {
> > > >                        array[j][i]++;
> > > >                }
> > > >        }
> > > >
> > > >        return 0;
> > > > }
> > > >
> > > > Pretty common stuff, right?
> > > >
> > > > Using the generalized cache events i can run:
> > > >
> > > >  $ perf stat --repeat 10 -e cycles:u -e instructions:u -e l1-dcache-loads:u -e l1-dcache-load-misses:u ./array
> > > >
> > > >  Performance counter stats for './array' (10 runs):
> > > >
> > > >         6,719,130 cycles:u                   ( +-   0.662% )
> > > >         5,084,792 instructions:u           #      0.757 IPC     ( +-   0.000% )
> > > >         1,037,032 l1-dcache-loads:u          ( +-   0.009% )
> > > >         1,003,604 l1-dcache-load-misses:u    ( +-   0.003% )
> > > >
> > > >        0.003802098  seconds time elapsed   ( +-  13.395% )
> > > >
> > > > I consider that this is 'bad', because for almost every dcache-load there's a
> > > > dcache-miss - a 99% L1 cache miss rate!
> > > >
> > > > Then i think a bit, notice something, apply this performance optimization:
> > >
> > > I don't think this example is really representative of the kind of problems
> > > people face, it is just too small and obvious. [...]
> >
> > Well, the overwhelming majority of performance problems are 'small and obvious'
> 
> Problems are not simple. Most serious applications these days are huge, 
> hundreds of MB of text, if not GB.
> 
> In your artificial example, you knew the answer before you started the 
> measurement.
>
> Most of the time, applications are assembled out of hundreds of libraries, so 
> no single developers knows all the code. Thus, the performance analyst is 
> faced with a black box most of the time.

I isolated out an example and assumed that you'd agree that identifying hot 
spots is trivial with generic cache events.

My assumption was wrong so let me show you how trivial it really is.

Here's an example with *two* problematic functions (but it could have hundreds, 
it does not matter):

-------------------------------->
#define THOUSAND 1000

static char array1[THOUSAND][THOUSAND];

static char array2[THOUSAND][THOUSAND];

void func1(void)
{
	int i, j;

	for (i = 0; i < THOUSAND; i++)
		for (j = 0; j < THOUSAND; j++)
			array1[i][j]++;
}

void func2(void)
{
	int i, j;

	for (i = 0; i < THOUSAND; i++)
		for (j = 0; j < THOUSAND; j++)
			array2[j][i]++;
}

int main(void)
{
	for (;;) {
		func1();
		func2();
	}

	return 0;
}
<--------------------------------

We do not know which one has the cache-misses problem, func1() or func2(), it's 
all a black box, right?

Using generic cache events you simply type this:

 $ perf top -e l1-dcache-load-misses -e l1-dcache-loads

And you get such output:

   PerfTop:    1923 irqs/sec  kernel: 0.0%  exact:  0.0% [l1-dcache-load-misses:u/l1-dcache-loads:u],  (all, 16 CPUs)
-------------------------------------------------------------------------------------------------------

   weight    samples  pcnt funct DSO
   ______    _______ _____ _____ ______________________

      1.9       6184 98.8% func2 /home/mingo/opt/array2
      0.0         69  1.1% func1 /home/mingo/opt/array2

It has pinpointed the problem in func2 *very* precisely.

Obviously this can be used to analyze larger apps as well, with thousands of 
functions, to pinpoint cachemiss problems in specific functions.

Thanks,

	Ingo
