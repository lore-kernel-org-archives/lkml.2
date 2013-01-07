Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3AGWJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:09:58 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:51554 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab3AGWJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:09:57 -0500
Date: Mon, 7 Jan 2013 14:09:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 04/14] rcu: Provide compile-time control for
 no-CBs CPUs
Message-ID: <20130107220943.GY2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130105174844.GA14172@linux.vnet.ibm.com>
 <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1357408144-15830-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130107165023.GA12229@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107165023.GA12229@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010722-7606-0000-0000-000007396F3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 08:50:23AM -0800, Josh Triplett wrote:
> On Sat, Jan 05, 2013 at 09:48:54AM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > Currently, the only way to specify no-CBs CPUs is via the rcu_nocbs
> > kernel command-line parameter.  This is inconvenient in some cases,
> > particularly for randconfig testing, so this commit adds a new
> > RCU_NOCB_CPU_DEFAULT kernel configuration parameter.  Setting this
> > new parameter to zero (the default) retains the old behavior, setting
> > it to one offloads callback processing from CPU 0 (along with any
> > other CPUs specified by the rcu_nocbs boot-time parameter), and setting
> > it to two offloads callback processing from all CPUs.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Comments below.
> 
> >  init/Kconfig            |   13 +++++++++++++
> >  kernel/rcutree_plugin.h |   13 +++++++++++++
> >  2 files changed, 26 insertions(+), 0 deletions(-)
> > 
> > diff --git a/init/Kconfig b/init/Kconfig
> > index fc6a3ca..35dcedb 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -676,6 +676,19 @@ config RCU_NOCB_CPU
> >  	  Say Y here if you want to help to debug reduced OS jitter.
> >  	  Say N here if you are unsure.
> >  
> > +config RCU_NOCB_CPU_DEFAULT
> > +	int "Offload RCU callback processing from compile-selected CPUs"
> > +	depends on RCU_NOCB_CPU
> > +	range 0 2
> > +	default 0
> > +	help
> > +	  Set this option to zero to only offload RCU callback processing
> > +	  from those CPUs specified by the boot-time rcu_nocbs kernel
> > +	  parameter.  Set it to one to offload processing from CPU 0
> > +	  in addition to any CPUs specified at boot time.  Set it to
> > +	  two to offload processing from all CPUs, regardless of the
> > +	  setting of the boot-time rcu_nocbs kernel parameter.
> > +
> 
> Rather than making users translate the meanings of 0, 1, and 2, this
> seems like something better done with a choice/endchoice; that would
> then offer a menu of options that can each have their own description.
> Take a look at the "Memory split" option in arch/x86/Kconfig for an
> example.

My first reaction was that this couldn't possibly handle the dependency
on CONFIG_RCU_NOCB_CPU, but it actually does work, suppressing all the
choices when CONFIG_RCU_NOCB_CPU=n.  Cute!

> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -86,6 +86,19 @@ static void __init rcu_bootup_announce_oddness(void)
> >  	if (nr_cpu_ids != NR_CPUS)
> >  		printk(KERN_INFO "\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
> >  #ifdef CONFIG_RCU_NOCB_CPU
> > +#if CONFIG_RCU_NOCB_CPU_DEFAULT != 0
> 
> That would then make each of these conditionals self-documenting as
> well.

Indeed, much better!  Thank you!

							Thanx, Paul

