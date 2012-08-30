Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab2H3XXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 19:23:19 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46555 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab2H3XXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 19:23:16 -0400
X-Originating-IP: 217.70.178.147
X-Originating-IP: 173.246.103.110
Date: Thu, 30 Aug 2012 16:23:07 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 2/5] rcu: Track CPU-hotplug duration
 statistics
Message-ID: <20120830232306.GD11928@jtriplet-mobl1>
References: <20120830184448.GA31753@linux.vnet.ibm.com>
 <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352312-31987-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120830190017.GC6749@jtriplet-mobl1>
 <20120830203842.GH30381@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120830203842.GH30381@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 01:38:42PM -0700, Paul E. McKenney wrote:
> On Thu, Aug 30, 2012 at 12:00:18PM -0700, Josh Triplett wrote:
> > On Thu, Aug 30, 2012 at 11:45:09AM -0700, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > > 
> > > Many rcutorture runs include CPU-hotplug operations in their stress
> > > testing.  This commit accumulates statistics on the durations of these
> > > operations in deference to the recent concern about the overhead and
> > > latency of these operations.
> > 
> > How many jiffies, on average, do these operations take?  Measuring these
> > using jiffies seems highly prone to repeated rounding error.
> 
> On my laptop, 30-140 depending on what hotplug patches I have in place.
> Some users have reported as few as 2-3 jiffies, but they don't use
> rcutorture.
> 
> I eagerly look forward to the time when I need to change the timebase for
> my own use.  ;-)

Fair enough.  In that case, this seems precise enough for the purpose it
serves.

> > > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> > > ---
> > >  kernel/rcutorture.c |   42 +++++++++++++++++++++++++++++++++++++-----
> > >  1 files changed, 37 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> > > index 86315d3..c6cf6ff 100644
> > > --- a/kernel/rcutorture.c
> > > +++ b/kernel/rcutorture.c
> > > @@ -176,8 +176,14 @@ static long n_rcu_torture_boosts;
> > >  static long n_rcu_torture_timers;
> > >  static long n_offline_attempts;
> > >  static long n_offline_successes;
> > > +static unsigned long sum_offline;
> > > +static int min_offline = -1;
> > > +static int max_offline;
> > >  static long n_online_attempts;
> > >  static long n_online_successes;
> > > +static unsigned long sum_online;
> > > +static int min_online = -1;
> > > +static int max_online;
> > >  static long n_barrier_attempts;
> > >  static long n_barrier_successes;
> > >  static struct list_head rcu_torture_removed;
> > > @@ -1214,11 +1220,13 @@ rcu_torture_printk(char *page)
> > >  		       n_rcu_torture_boost_failure,
> > >  		       n_rcu_torture_boosts,
> > >  		       n_rcu_torture_timers);
> > > -	cnt += sprintf(&page[cnt], "onoff: %ld/%ld:%ld/%ld ",
> > > -		       n_online_successes,
> > > -		       n_online_attempts,
> > > -		       n_offline_successes,
> > > -		       n_offline_attempts);
> > > +	cnt += sprintf(&page[cnt],
> > > +		       "onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
> > > +		       n_online_successes, n_online_attempts,
> > > +		       n_offline_successes, n_offline_attempts,
> > > +		       min_online, max_online,
> > > +		       min_offline, max_offline,
> > > +		       sum_online, sum_offline, HZ);
> > >  	cnt += sprintf(&page[cnt], "barrier: %ld/%ld:%ld",
> > >  		       n_barrier_successes,
> > >  		       n_barrier_attempts,
> > > @@ -1490,8 +1498,10 @@ static int __cpuinit
> > >  rcu_torture_onoff(void *arg)
> > >  {
> > >  	int cpu;
> > > +	unsigned long delta;
> > >  	int maxcpu = -1;
> > >  	DEFINE_RCU_RANDOM(rand);
> > > +	unsigned long starttime;
> > >  
> > >  	VERBOSE_PRINTK_STRING("rcu_torture_onoff task started");
> > >  	for_each_online_cpu(cpu)
> > > @@ -1509,6 +1519,7 @@ rcu_torture_onoff(void *arg)
> > >  				printk(KERN_ALERT "%s" TORTURE_FLAG
> > >  				       "rcu_torture_onoff task: offlining %d\n",
> > >  				       torture_type, cpu);
> > > +			starttime = jiffies;
> > >  			n_offline_attempts++;
> > >  			if (cpu_down(cpu) == 0) {
> > >  				if (verbose)
> > > @@ -1516,12 +1527,23 @@ rcu_torture_onoff(void *arg)
> > >  					       "rcu_torture_onoff task: offlined %d\n",
> > >  					       torture_type, cpu);
> > >  				n_offline_successes++;
> > > +				delta = jiffies - starttime;
> > > +				sum_offline += delta;
> > > +				if (min_offline < 0) {
> > > +					min_offline = delta;
> > > +					max_offline = delta;
> > > +				}
> > > +				if (min_offline > delta)
> > > +					min_offline = delta;
> > > +				if (max_offline < delta)
> > > +					max_offline = delta;
> > >  			}
> > >  		} else if (cpu_is_hotpluggable(cpu)) {
> > >  			if (verbose)
> > >  				printk(KERN_ALERT "%s" TORTURE_FLAG
> > >  				       "rcu_torture_onoff task: onlining %d\n",
> > >  				       torture_type, cpu);
> > > +			starttime = jiffies;
> > >  			n_online_attempts++;
> > >  			if (cpu_up(cpu) == 0) {
> > >  				if (verbose)
> > > @@ -1529,6 +1551,16 @@ rcu_torture_onoff(void *arg)
> > >  					       "rcu_torture_onoff task: onlined %d\n",
> > >  					       torture_type, cpu);
> > >  				n_online_successes++;
> > > +				delta = jiffies - starttime;
> > > +				sum_online += delta;
> > > +				if (min_online < 0) {
> > > +					min_online = delta;
> > > +					max_online = delta;
> > > +				}
> > > +				if (min_online > delta)
> > > +					min_online = delta;
> > > +				if (max_online < delta)
> > > +					max_online = delta;
> > >  			}
> > >  		}
> > >  		schedule_timeout_interruptible(onoff_interval * HZ);
> > > -- 
> > > 1.7.8
> > > 
> > 
> 
