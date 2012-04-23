Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab2DWGN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 02:13:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54483 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab2DWGN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 02:13:58 -0400
Message-ID: <1335161629.10076.74.camel@marge.simpson.net>
Subject: irq latency regression post af5ab277 - was Re: [patch] clockevents:
 Reinstate the per cpu tick skew
From: Mike Galbraith <mgalbraith@suse.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: RT <linux-rt-users@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dimitri Sivanich <sivanich@sgi.com>
Date: Mon, 23 Apr 2012 08:13:49 +0200
In-Reply-To: <1325571658.6087.63.camel@marge.simson.net>
References: <1324717569.5025.73.camel@marge.simson.net>
	 <1324968044.5217.103.camel@marge.simson.net>
	 <1324977605.5217.132.camel@marge.simson.net>
	 <4EFB1A56.1040902@linux.intel.com>
	 <1325085037.16165.31.camel@marge.simson.net>
	 <1325571658.6087.63.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

On Tue, 2012-01-03 at 07:20 +0100, Mike Galbraith wrote: 
> On Wed, 2011-12-28 at 16:10 +0100, Mike Galbraith wrote:
> > On Wed, 2011-12-28 at 14:32 +0100, Arjan van de Ven wrote:
> > > 
> > > I think we need to just say no to this, and kill the nohz=off option
> > > entirely.
> > > 
> > > Seriously, are people still running with ticks for any legitimate
> > > reasons? (and not just because they goofed their config file)
> > 
> > Yup.  Realtime loads sometimes need it.  Even without contention
> > problems, entering/leaving nohz is a latency source.  If every little
> > bit counts, you may have the choice of letting the electric meter spin
> > or not getting the job done at all.

There are other facets to tick skew removal that have turned up while
looking into an irq latency regression 2.6.32->3.0.  Not only does skew
removal induce jitter woes for moderate sized boxen running RT kernels,
it's a jitter source for large machines in general. 

More interestingly, that skew removal also appears to be indirectly
responsible for a rather large irq latency regression.  I bisected the
source of same to..

0209f649 rcu: limit rcu_node leaf-level fanout

.._but_, the source of the lock contention it addressed appears to be
the very tick skew removal that caused my xtime_lock jitter woes in RT.
Revert 0209f649 in CONFIG_MAXSMP CONFIG_PREEMPT_NONE kernel, contention
appears, restore skew, it disappears virtually entirely.  So it would
appear that we induced a ~400% latency regression to combat contention
that was itself induced by tick skew removal.

In enterprise, I can revert 0209f649 and enable tick skew across the
board instead of selectively, and kill the regression at the cost of
losing whatever power savings killing skew brought us.  May have to do
that.  In another thread, Paul suggested limiting GP initialization to
CPUs that have been online, which indeed turned the regression into a
modest progression.  That's highly attractive long term, but doing that
in a stable kernel before it's baked in mainline is not the least bit
attractive.  Hohum, rock or hard spot, pick one.

Anyway, I thought I should summarize the linkage of RCU induced latency
regression to tick skew removal.  Seems likely I'm not the only sod who
will have this land in their bug list.

> Patch making tick skew a boot option below, and hard numbers below that.
> 
> Test setup:
> 60 isolated cores running a synchronized frame scheduler model for 1
> hour, scheduling worker-bees at three frequencies.  (The testcase is
> supposed to "good enough" simulate a real frame rate scheduler, and did
> pretty well at showing the cost of these particular collisions.)
> 
> First set of numbers is without tick skew, and nohz enabled.  Second set
> is tick skewed, nohz and rt push/pull turned off for the isolated core
> set.  The tick skew alone is responsible for an order of magnitude of
> jitter improvement.  I have hard numbers for nohz and cpupri_set() as
> well, but bottom line for me is that with nohz enabled, my 30us jitter
> budget is nearly doubled, so even with the tick skewed, nohz is just not
> a viable option ATM.
> 
> 
> From: Mike Galbraith <mgalbraith@suse.de>
> 
> clockevents: Reinstate the per cpu tick skew
> 
> Quoting removal commit af5ab277ded04bd9bc6b048c5a2f0e7d70ef0867
> Historically, Linux has tried to make the regular timer tick on the
> various CPUs not happen at the same time, to avoid contention on
> xtime_lock.
>     
> Nowadays, with the tickless kernel, this contention no longer happens
> since time keeping and updating are done differently. In addition,
> this skew is actually hurting power consumption in a measurable way on
> many-core systems.
> End quote
> 
> Contrary to the above, contention does still happen, and can be a
> problem for realtime loads whether nohz is active or not, so give
> the user the ability to decide whether power consumption or jitter
> is the more important consideration.
> 
> Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> 
> ---
>  Documentation/kernel-parameters.txt |    3 +++
>  kernel/time/tick-sched.c            |   19 +++++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2295,6 +2295,9 @@ bytes respectively. Such letter suffixes
>  	simeth=		[IA-64]
>  	simscsi=
>  
> +	skew_tick=	[KNL] Offset the periodic timer tick per cpu to mitigate
> +			xtime_lock contention on larger systems.
> +
>  	slram=		[HW,MTD]
>  
>  	slub_debug[=options[,slabs]]	[MM, SLUB]
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -759,6 +759,8 @@ static enum hrtimer_restart tick_sched_t
>  	return HRTIMER_RESTART;
>  }
>  
> +static int sched_skew_tick;
> +
>  /**
>   * tick_setup_sched_timer - setup the tick emulation timer
>   */
> @@ -777,6 +779,14 @@ void tick_setup_sched_timer(void)
>  	/* Get the next period (per cpu) */
>  	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update());
>  
> +	/* Offset the tick to avert xtime_lock contention. */
> +	if (sched_skew_tick) {
> +		u64 offset = ktime_to_ns(tick_period) >> 1;
> +		do_div(offset, num_possible_cpus());
> +		offset *= smp_processor_id();
> +		hrtimer_add_expires_ns(&ts->sched_timer, offset);
> +	}
> +
>  	for (;;) {
>  		hrtimer_forward(&ts->sched_timer, now, tick_period);
>  		hrtimer_start_expires(&ts->sched_timer,
> @@ -858,3 +868,12 @@ int tick_check_oneshot_change(int allow_
>  	tick_nohz_switch_to_nohz();
>  	return 0;
>  }
> +
> +static int __init skew_tick(char *str)
> +{
> +	get_option(&str, &sched_skew_tick);
> +
> +	return 0;
> +}
> +early_param("skew_tick", skew_tick);
> +
> 
> No skewed tick, nohz active:
> FREQ=960 FRAMES=3456000 LOOP=50000 using CPUs 4 - 23
> FREQ=666 FRAMES=2397600 LOOP=72072 using CPUs 24 - 43
> FREQ=300 FRAMES=1080000 LOOP=160000 using CPUs 44 - 63
> on your marks... get set... POW!
> Cpu Frames    Min     Max(Frame)      Avg     Sigma     LastTrans Fliers(Frames) 
> 4   3456000   0.0159  51.51 (1751285) 1.0811  2.3215    0 (0)     940 (2496,2497,36625,36626,45649,..3438632)
> 5   3456000   0.0159  57.44 (1301949) 1.1164  2.3599    0 (0)     1010 (32353,32354,36625,36626,43681,..3434312)
> 6   3456000   0.0159  49.58 (546753)  1.0602  2.3222    0 (0)     1037 (32353,32354,36625,36626,41809,..3425240)
> 7   3456000   0.0159  52.20 (546753)  1.0681  2.3370    0 (0)     1035 (32353,32354,36625,36626,41809,..3432248)
> 8   3456000   0.0159  58.91 (1407504) 1.0592  2.0873    0 (0)     865 (11041,11042,15505,15506,25585,..3412208)
> 9   3456000   0.0159  54.61 (1407504) 1.0581  2.0775    0 (0)     850 (11041,11042,15505,15506,20234,..3411272)
> 10  3456000   0.0159  52.91 (1338694) 1.1259  2.0825    0 (0)     799 (11041,11042,15505,15506,16465,..3400640)
> 11  3456000   0.0159  50.56 (2470554) 1.1881  2.0364    0 (0)     334 (50714,113715,113716,166349,178780,..3421185)
> 12  3456000   0.0159  50.29 (2462200) 0.9961  2.0202    0 (0)     639 (9337,9338,11041,11042,15505,..3452529)
> 13  3456000   0.0159  56.52 (2470554) 1.1478  2.0602    0 (0)     400 (2545,2546,9121,9122,66434,..3440289)
> 14  3456000   0.0159  55.06 (34587)   1.2129  2.4890    0 (0)     444 (34587,34588,62571,62572,62619,..3440434)
> 15  3456000   0.0159  46.48 (583883)  1.2891  2.1824    0 (0)     306 (91563,95739,95740,141197,155741,..3406785)
> 16  3456000   0.0159  103.70 (2828662)2.1077  4.0380    410 (2)   9435 (697,698,1105,1106,1153,..3455937)
> 17  3456000   0.0159  73.89 (2470553) 2.1598  3.7529    0 (0)     6180 (2473,2474,3985,3986,8569,..3438201)
> 18  3456000   0.0159  54.14 (1212190) 2.2391  3.7075    0 (0)     5485 (10274,10275,13970,13971,14379,..3455794)
> 19  3456000   0.0159  99.20 (810712)  2.3861  4.5793    0 (0)     19845 (674,675,2259,2260,3554,..3455915)
> 20  3456000   0.0159  71.30 (631597)  2.2565  4.3141    0 (0)     9365 (674,675,3555,7394,7395,..3455914)
> 21  3456000   0.0159  71.51 (1431073) 2.3127  4.4810    0 (0)     25073 (1154,2259,2260,4011,4012,..3455963)
> 22  3456000   0.0159  62.45 (215262)  2.1318  4.3088    0 (0)     23570 (2259,2260,4011,4012,4539,..3455963)
> 23  3456000   0.0159  61.50 (212190)  2.1307  4.3165    0 (0)     23605 (2259,2260,4539,4540,5019,..3455963)
> 24  2397600   0.0587  145.26 (2229318)2.6808  6.2104    492 (14)  32977 (812,813,1145,1470,1471,..2397564)
> 25  2397600   0.0587  133.93 (250966) 2.6171  6.3300    492 (13)  35463 (812,813,1145,1146,1462,..2397564)
> 26  2397600   0.0587  140.25 (1405878)2.7079  6.1603    492 (12)  32428 (806,812,813,1145,1146,..2397564)
> 27  2397600   0.0587  141.56 (1405879)2.6893  6.1515    492 (14)  32089 (808,809,810,811,812,..2397564)
> 28  2397600   0.0587  146.57 (1405879)2.7129  6.0797    492 (14)  31637 (800,801,812,813,827,..2397564)
> 29  2397600   0.0587  137.99 (2172039)2.3360  5.9859    492 (14)  30551 (826,827,1157,1480,1481,..2397564)
> 30  2397600   0.0587  144.06 (948198) 2.2381  5.0413    496 (6)   19401 (826,827,832,833,1175,..2397566)
> 31  2397600   0.0587  141.92 (948198) 2.2509  5.0654    496 (4)   19353 (826,827,832,833,1175,..2397566)
> 32  2397600   0.0587  149.31 (2172038)2.7842  6.8891    492 (10)  41301 (822,823,824,825,826,..2397564)
> 33  2397600   0.0587  142.99 (1975198)2.6904  5.3538    181 (6)   21954 (511,512,846,847,1175,..2397582)
> 34  2397600   0.0587  167.07 (948199) 2.6350  5.6616    179 (4)   23602 (503,504,507,508,511,..2397582)
> 35  2397600   0.0587  79.81 (2152123) 2.5135  4.1781    0 (0)     5406 (1879,1881,1882,2876,2877,..2396956)
> 36  2397600   0.0587  112.24 (1184061)2.7419  5.3774    0 (0)     21005 (1185,1186,1189,1190,1518,..2397263)
> 37  2397600   0.0587  78.86 (986867)  2.6678  5.1954    0 (0)     19350 (529,530,861,863,1189,..2397263)
> 38  2397600   0.0587  77.90 (1782680) 2.5881  4.8399    0 (0)     13516 (525,526,529,530,860,..2396938)
> 39  2397600   0.0587  78.02 (1642135) 2.4351  3.8095    0 (0)     3569 (898,2900,2901,3561,3566,..2397291)
> 40  2397600   0.0587  218.81 (891116) 2.7215  6.6456    392 (8)   38961 (714,715,726,727,1046,..2397450)
> 41  2397600   0.0587  141.56 (1975198)2.6441  5.2995    181 (4)   22572 (846,847,1179,1180,1185,..2397249)
> 42  2397600   0.0587  77.07 (1782679) 2.3957  5.0119    0 (0)     17798 (529,530,860,861,862,..2397263)
> 43  2397600   0.0587  81.72 (1333323) 2.3469  4.5082    0 (0)     11172 (1205,1206,1207,1208,1865,..2396552)
> 44  1080000   0.0032  168.33 (988438) 2.7037  7.1729    381 (10)  20368 (650,651,662,663,809,..1056079)
> 45  1080000   0.0032  156.88 (935898) 2.6181  7.1047    0 (0)     19932 (767,768,809,810,866,..1022038)
> 46  1080000   0.0032  156.40 (935898) 2.2137  6.8080    0 (0)     18522 (684567,684568,695466,695467,699570,..975856)
> 47  1080000   0.0032  150.20 (905448) 2.6011  7.0525    0 (0)     19427 (2012,2013,510347,510348,617324,..980947)
> 48  1080000   0.0032  163.08 (1012102)3.0856  8.6857    491 (49)  32197 (527,528,536,537,545,..1059883)
> 49  1080000   0.0032  151.87 (861738) 2.1150  6.2499    0 (0)     14993 (679920,679921,681762,681763,684567,..889561)
> 50  1080000   0.0032  143.53 (843639) 2.3864  6.2304    0 (0)     14372 (673311,673312,676716,676717,679680,..907048)
> 51  1080000   0.0032  148.53 (815289) 2.4022  6.1284    0 (0)     13945 (667971,667972,672835,673311,673312,..925077)
> 52  1080000   0.0032  149.49 (815289) 2.4059  6.0745    0 (0)     13932 (667971,667972,672834,672835,673311,..925077)
> 53  1080000   0.0032  149.49 (788680) 2.2976  5.4171    0 (0)     10821 (662766,662767,664794,664795,667971,..851374)
> 54  1080000   0.0032  146.63 (788680) 2.1600  5.5494    0 (0)     11435 (662766,662767,664794,664795,667971,..925077)
> 55  1080000   0.0032  145.91 (817180) 2.3747  5.9131    0 (0)     13198 (664794,664795,667971,667972,672834,..925077)
> 56  1080000   0.0032  140.91 (788680) 2.4499  5.8216    0 (0)     13403 (641917,658567,662767,664794,664795,..925077)
> 57  1080000   0.0032  141.38 (707776) 1.2948  3.8831    0 (0)     5041 (654816,654817,658320,658321,658566,..757666)
> 58  1080000   0.0032  149.73 (707776) 1.2131  3.6946    0 (0)     4076 (641916,641917,654136,654816,654817,..739225)
> 59  1080000   0.0032  51.02 (220341)  1.3073  3.1542    0 (0)     1869 (138187,145140,145141,147822,147823,..1021026)
> 60  1080000   0.0032  119.93 (313205) 1.6518  5.2116    0 (0)     9504 (3019,3020,12955,12956,25645,..1078275)
> 61  1080000   0.0032  149.25 (707776) 1.2933  3.5546    0 (0)     3393 (631761,631762,641916,641917,647521,..732562)
> 62  1080000   0.0032  126.60 (222973) 2.0194  5.6079    0 (0)     11357 (3019,3020,12955,12956,14420,..1078275)
> 63  1080000   0.0032  126.60 (222973) 2.0223  5.6224    0 (0)     11452 (3019,3020,12955,12956,14420,..1078275)
> 
> Same kernel, tick skew enabled, nohz and push/pull (100% pinned load...)
> disabled for the isolated cpuset.  This is 10us or so better than 33-rt
> can do on this box with nohz=off, ie that's roughly the jitter that
> cpupri_set() induces (_can_ double that very rarely it seems).
> 
> So with a couple little tweaks, 3.0-rt performs better than 33-rt (and
> can dynamically become "green" again when not running picky rt load)
> despite being a little fatter.  'Course if I applied the same dinky
> tweaks to 33-rt, the weight gain would show.  Anyway, the numbers..
> 
> FREQ=960 FRAMES=3456000 LOOP=50000 using CPUs 4 - 23
> FREQ=666 FRAMES=2397600 LOOP=72072 using CPUs 24 - 43
> FREQ=300 FRAMES=1080000 LOOP=160000 using CPUs 44 - 63
> on your marks... get set... POW!
> Cpu Frames    Min     Max(Frame)      Avg     Sigma     LastTrans Fliers(Frames) 
> 4   3456000   0.0159  5.98 (1957035)  0.1275  0.2979    0 (0)     
> 5   3456000   0.0159  6.21 (2641598)  0.2173  0.3444    0 (0)     
> 6   3456000   0.0159  5.26 (1313825)  0.1599  0.2956    0 (0)     
> 7   3456000   0.0159  5.98 (346106)   0.1632  0.2877    0 (0)     
> 8   3456000   0.0159  5.50 (70893)    0.1437  0.3450    0 (0)     
> 9   3456000   0.0159  5.98 (1550901)  0.1381  0.3502    0 (0)     
> 10  3456000   0.0159  5.74 (106100)   0.1478  0.3313    0 (0)     
> 11  3456000   0.0159  5.71 (3174550)  0.1413  0.3090    0 (0)     
> 12  3456000   0.0159  5.02 (1506694)  0.1761  0.3098    0 (0)     
> 13  3456000   0.0159  5.71 (3054611)  0.1768  0.3546    0 (0)     
> 14  3456000   0.0159  5.02 (3148871)  0.1299  0.3062    0 (0)     
> 15  3456000   0.0159  4.99 (2122036)  0.1521  0.3132    0 (0)     
> 16  3456000   0.0159  6.42 (1728959)  0.1521  0.3905    0 (0)     
> 17  3456000   0.0159  6.21 (854434)   0.1618  0.3652    0 (0)     
> 18  3456000   0.0159  6.93 (2190440)  0.1418  0.3548    0 (0)     
> 19  3456000   0.0159  6.90 (1614252)  0.2075  0.4128    0 (0)     
> 20  3456000   0.0159  5.47 (136316)   0.2002  0.3977    0 (0)     
> 21  3456000   0.0159  6.69 (1057262)  0.1435  0.3475    0 (0)     
> 22  3456000   0.0159  6.66 (3123382)  0.1602  0.3585    0 (0)     
> 23  3456000   0.0159  5.94 (2297025)  0.2283  0.3616    0 (0)     
> 24  2397600   0.0587  6.38 (991357)   0.2580  0.3817    0 (0)     
> 25  2397600   0.0587  6.73 (1162518)  0.2380  0.3730    0 (0)     
> 26  2397600   0.0587  7.21 (733474)   0.2502  0.3590    0 (0)     
> 27  2397600   0.0587  6.86 (1873716)  0.2280  0.3768    0 (0)     
> 28  2397600   0.0587  7.21 (2296767)  0.2521  0.3884    0 (0)     
> 29  2397600   0.0587  7.21 (616888)   0.4165  0.4887    0 (0)     
> 30  2397600   0.0587  7.09 (458995)   0.4245  0.4577    0 (0)     
> 31  2397600   0.0587  6.14 (1674893)  0.3974  0.4544    0 (0)     
> 32  2397600   0.0587  7.45 (130233)   0.4440  0.5456    0 (0)     
> 33  2397600   0.0587  7.09 (1453350)  0.2482  0.3813    0 (0)     
> 34  2397600   0.0587  6.73 (2365066)  0.2886  0.3827    0 (0)     
> 35  2397600   0.0587  6.14 (35955)    0.2556  0.3841    0 (0)     
> 36  2397600   0.0587  6.62 (2145554)  0.2566  0.3933    0 (0)     
> 37  2397600   0.0587  7.81 (130234)   0.5375  0.5129    0 (0)     
> 38  2397600   0.0587  7.33 (130234)   0.4921  0.5255    0 (0)     
> 39  2397600   0.0587  7.57 (130234)   0.4200  0.4901    0 (0)     
> 40  2397600   0.0587  6.62 (2367859)  0.2962  0.4553    0 (0)     
> 41  2397600   0.0587  6.26 (206979)   0.5036  0.5491    0 (0)     
> 42  2397600   0.0587  6.38 (1302660)  0.5093  0.5469    0 (0)     
> 43  2397600   0.0587  6.73 (1825681)  0.5511  0.5734    0 (0)     
> 44  1079999   0.0032  7.39 (91927)    0.4603  0.5291    0 (0)     
> 45  1079999   0.0032  6.92 (977865)   0.3143  0.4378    0 (0)     
> 46  1079999   0.0032  5.96 (1002473)  0.2129  0.3999    0 (0)     
> 47  1079999   0.0032  6.44 (981423)   0.4193  0.5293    0 (0)     
> 48  1079999   0.0032  6.20 (375165)   0.2602  0.4201    0 (0)     
> 49  1079999   0.0032  5.73 (886536)   0.4002  0.5174    0 (0)     
> 50  1079999   0.0032  6.44 (547629)   0.3182  0.4507    0 (0)     
> 51  1079999   0.0032  5.73 (143994)   0.4736  0.5952    0 (0)     
> 52  1079999   0.0032  6.68 (1053525)  0.4753  0.5132    0 (0)     
> 53  1079999   0.0032  6.44 (378576)   0.3686  0.4691    0 (0)     
> 54  1079999   0.0032  6.92 (886639)   0.6017  0.5538    0 (0)     
> 55  1079999   0.0032  6.68 (1055655)  0.4917  0.5232    0 (0)     
> 56  1079999   0.0032  6.44 (293526)   0.2752  0.4340    0 (0)     
> 57  1079999   0.0032  8.59 (913209)   1.1433  0.8550    0 (0)     
> 58  1079999   0.0032  5.25 (259824)   0.2139  0.3702    0 (0)     
> 59  1079999   0.0032  6.68 (245211)   0.2031  0.3665    0 (0)     
> 60  1079999   0.0032  6.44 (895440)   0.4445  0.4867    0 (0)     
> 61  1079999   0.0032  5.96 (896382)   0.2541  0.3923    0 (0)     
> 62  1079999   0.0032  7.16 (895440)   0.5437  0.5162    0 (0)     
> 63  1079999   0.0032  6.44 (895371)   0.5707  0.5135    0 (0)
> 
> So IMHO there is a valid case for keeping NO_HZ a config option for
> folks who can never tolerate the pricetag, but as for the nohz=off
> option, methinks that could indeed go away, given it's easy to make an
> on/off switch.  I made one for both nohz and push/pull, just need to
> move it into cpusets and make it pretty enough to live.
> 
> WRT $subject, it seems pretty clear that the RT kernel either wants tick
> skew back.. or collision avoidance radar.. or something.
> 
> 	-Mike
> 


