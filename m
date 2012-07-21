Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab2GURV5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 13:21:57 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:57511 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab2GURV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 13:21:56 -0400
Date: Sat, 21 Jul 2012 10:21:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [Patch 4/7] softirq: Use hotplug thread infrastructure
Message-ID: <20120721172151.GB6698@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120716103749.122800930@linutronix.de>
 <20120716103948.456416747@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120716103948.456416747@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072117-4242-0000-0000-00000264FA4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 10:42:37AM -0000, Thomas Gleixner wrote:
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/softirq.c |  107 +++++++++++++------------------------------------------
>  1 file changed, 26 insertions(+), 81 deletions(-)

This is also much more compact!  One issue with fix below.

							Thanx, Paul

[ . . . ]

> +static void run_ksoftirqd(unsigned int cpu)
> +{
> +	local_irq_disable();
> +	if (local_softirq_pending()) {
> +		__do_softirq();
> +		local_irq_enable();
> +		cond_resched();
> +		rcu_note_context_switch(cpu);

The rcu_note_context_switch() function must run with preemption disabled.
I fixed this as follows:

+static void run_ksoftirqd(unsigned int cpu)
+{
+	local_irq_disable();
+	if (local_softirq_pending()) {
+		__do_softirq();
+		rcu_note_context_switch(cpu);
+		local_irq_enable();
+		cond_resched();
+		return;
 	}

Again, I also placed the updated series on -rcu at branch rcu/smp/hotplug
(git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git),
based on tip/smp/hotplug, for Linaro testing purposes.

With these two changes, this series merged with Tejun's workqueue
hotplug changes merged with my -rcu tree passed moderate rcutorture
and hotplug testing, with the exception of some apparently unrelated
build problems in UP configuration:

warning: call to ‘copy_from_user_overflow’ declared with attribute warning: copy_from_user() buffer size is not provably correct [enabled by default

I have a fix for an earlier occurrence of this problem that I will try next.

							Thanx, Paul

