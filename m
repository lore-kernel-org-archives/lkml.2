Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab1KOVqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:46:32 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42156 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab1KOVqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:46:31 -0500
X-Originating-IP: 217.70.178.129
X-Originating-IP: 50.43.15.19
Date: Tue, 15 Nov 2011 13:46:15 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 2/9] rcu: Add rcutorture system-shutdown
 capability
Message-ID: <20111115214615.GD31473@leaf>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
 <1321388885-11211-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321388885-11211-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 12:27:58PM -0800, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> Although it is easy to run rcutorture tests under KVM, there is currently
> no nice way to run such a test for a fixed time period, collect all of
> the rcutorture data, and then shut the system down cleanly.  This commit
> therefore adds an rcutorture module parameter named "shutdown_secs" that
> specified the run duration in seconds, after which rcutorture terminates
> the test and powers the system down.  The default value for "shutdown_secs"
> is zero, which disables shutdown.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

>From your recent post on this, I thought you found a solution through
the init= parameter, which seems preferable.

> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -61,9 +61,10 @@ static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
>  static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
>  static int stutter = 5;		/* Start/stop testing interval (in sec) */
>  static int irqreader = 1;	/* RCU readers from irq (timers). */
> -static int fqs_duration = 0;	/* Duration of bursts (us), 0 to disable. */
> -static int fqs_holdoff = 0;	/* Hold time within burst (us). */
> +static int fqs_duration;	/* Duration of bursts (us), 0 to disable. */
> +static int fqs_holdoff;		/* Hold time within burst (us). */

Looks like these lines picked up unrelated whitespace changes in this
commit.

> @@ -1305,6 +1313,37 @@ static int rcutorture_booster_init(int cpu)
>  	return 0;
>  }
>  
> +/*
> + * Cause the rcutorture test to "stutter", starting and stopping all
> + * threads periodically.
> + */

This comment looks like a copy-paste error.

> +static int
> +rcu_torture_shutdown(void *arg)
> +{
> +	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task started");
> +	while (ULONG_CMP_LT(jiffies, shutdown_time) &&
> +	       !kthread_should_stop()) {
> +		if (verbose)
> +			printk(KERN_ALERT "%s" TORTURE_FLAG
> +			       "rcu_torture_shutdown task: %lu "
> +			       "jiffies remaining\n",
> +			       torture_type, shutdown_time - jiffies);
> +		schedule_timeout_interruptible(HZ);
> +	}

Any particular reason to wake up once a second here?  If !verbose, this could just
sleep until shutdown time.  (And does the verbose output really help
here, given printk timestamps?)

> +	if (ULONG_CMP_LT(jiffies, shutdown_time)) {
> +		VERBOSE_PRINTK_STRING("rcu_torture_shutdown task stopping");
> +		return 0;
> +	}
> +
> +	/* OK, shut down the system. */
> +
> +	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task shutting down system");
> +	shutdown_task = NULL;	/* Avoid self-kill deadlock. */

Not that it matters much here, but won't this cause a leak?

> +	rcu_torture_cleanup();	/* Get the success/failure message. */
> +	kernel_power_off();	/* Shut down the system. */
> +	return 0;
> +}

Huh.  I would have expected kernel_power_off to use noreturn, making the
return 0 unnecessary here; however, apparently it doesn't.

- Josh Triplett
