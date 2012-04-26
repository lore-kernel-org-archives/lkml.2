Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2DZNBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 09:01:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:51741 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab2DZNBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 09:01:07 -0400
Message-ID: <1335445242.13683.19.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu 3/4] rcu: Make RCU_FAST_NO_HZ account
 for pauses out of idle
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 26 Apr 2012 15:00:42 +0200
In-Reply-To: <1335197761-6577-3-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120423161539.GA6467@linux.vnet.ibm.com>
	 <1335197761-6577-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335197761-6577-3-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 09:16 -0700, Paul E. McKenney wrote:
>  static DEFINE_PER_CPU(int, rcu_dyntick_drain);
>  static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
>  static DEFINE_PER_CPU(struct timer_list, rcu_idle_gp_timer);
> +static DEFINE_PER_CPU(unsigned long, rcu_idle_gp_timer_expires);
> +static DEFINE_PER_CPU(bool, rcu_idle_first_pass);
> +static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted);
> +static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted_snap);


Wouldn't that all be prettier if it were in a struct of sorts?

struct rcu_dyntick {
	int			drain;
	unsigned long		holdoff;
	struct timer_list	gp_timer;
	unsigned long		gp_timer_expires;
	bool			first_pass;
	unsigned long		posted;
	unsigned long		posted_snap;
};

static DEFINE_PER_CPU(struct rcu_dyntick, rcu_dyntick);

( fwiw, bool doesn't have a well specified storage type )

This way you have more control over the placement, variables are forced
to be together, instead of at the mercy of whatever per_cpu and the
linker do, and you more clearly see the holes in the structure.

All the per_cpu() usage should still work like:

  per_cpu(rcu_dyntick.first_pass, cpu) = 0;


