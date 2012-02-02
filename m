Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab2BBFOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 00:14:06 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59246 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab2BBFOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 00:14:04 -0500
X-Originating-IP: 217.70.178.133
X-Originating-IP: 50.43.15.19
Date: Wed, 1 Feb 2012 21:13:37 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 24/41] rcu: Check for idle-loop entry
 while in RCU read-side critical section
Message-ID: <20120202051337.GP29058@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-24-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328125319-5205-24-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:41:42AM -0800, Paul E. McKenney wrote:
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -366,6 +366,20 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
>  	atomic_inc(&rdtp->dynticks);
>  	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
>  	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
> +
> +	/*
> +	 * The idle task is not permitted to enter the idle loop while
> +	 * in an RCU read-side critical section.
> +	 */
> +	rcu_lockdep_assert(!lock_is_held(&rcu_lock_map),
> +			   "Illegal idle entry in RCU read-side "
> +			   "critical section.");
> +	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),
> +			   "Illegal idle entry in RCU-bh read-side "
> +			   "critical section.");
> +	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
> +			   "Illegal idle entry in RCU-sched read-side "
> +			   "critical section.");

Quoting a paragraph I added to Documentation/CodingStyle:

> Statements longer than 80 columns will be broken into sensible chunks, unless
> exceeding 80 columns significantly increases readability and does not hide
> information. Descendants are always substantially shorter than the parent and
> are placed substantially to the right. The same applies to function headers
> with a long argument list. However, never break user-visible strings such as
> printk messages, because that breaks the ability to grep for them.

So, please don't break those strings across multiple lines.  The same
goes for the similar rcu_lockdep_assert strings added in a previous
patch in this series.

- Josh Triplett
