Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab1GORmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:42:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48603 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab1GORme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:42:34 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=MwenTAR9eMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Y93dwUiIUxdXrAYNwjUA:9 a=nsbHt4bMgqiOFZkH4dQA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: INFO: possible circular locking dependency detected
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ed Tomlinson <edt@aei.ca>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110715172416.GE2327@linux.vnet.ibm.com>
References: <20110714144946.GA3354@swordfish.minsk.epam.com>
	 <1310665613.27864.50.camel@gandalf.stny.rr.com>
	 <20110714191809.GF2349@linux.vnet.ibm.com> <201107150705.46248.edt@aei.ca>
	 <1310729362.2586.325.camel@twins>
	 <20110715124206.GA2376@linux.vnet.ibm.com>
	 <1310735259.2586.330.camel@twins>
	 <1310748957.27864.62.camel@gandalf.stny.rr.com>
	 <20110715170304.GD2327@linux.vnet.ibm.com>
	 <1310750204.27864.69.camel@gandalf.stny.rr.com>
	 <20110715172416.GE2327@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Jul 2011 13:42:31 -0400
Message-ID: <1310751751.27864.74.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 10:24 -0700, Paul E. McKenney wrote:

> But the rcu_read_unlock() called from within the irq handler would
> take a second snapshot of ->special.  It could then enter
> rcu_read_unlock_special().

You agree that an interrupt preempting the rcu_read_unlock() is causing
the issues correct? But it is also contained within rcu_read_unlock().
That is, we just don't want interrupts or softirqs from calling the
special function when it preempted rcu_read_unlock().

How about this patch? (again totally untested and not even compiled)

-- Steve

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 7784bd2..0bdf0ea 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -46,6 +46,8 @@
 #include <linux/module.h>
 #include <linux/hardirq.h>
 
+DEFINE_PER_CPU(int, in_rcu_read_unlock);
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
 struct lockdep_map rcu_lock_map =
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 14dc7dd..a4adbb7 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -375,6 +375,8 @@ static void rcu_read_unlock_special(struct task_struct *t)
 	}
 }
 
+DECLARE_PER_CPU(int, in_rcu_read_unlock);
+
 /*
  * Tree-preemptible RCU implementation for rcu_read_unlock().
  * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
@@ -386,12 +388,16 @@ void __rcu_read_unlock(void)
 {
 	struct task_struct *t = current;
 
+	get_cpu_var(in_rcu_read_unlock)++;
 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
 	--t->rcu_read_lock_nesting;
 	barrier();  /* decrement before load of ->rcu_read_unlock_special */
 	if (t->rcu_read_lock_nesting == 0 &&
+	    __get_cpu_var(in_rcu_read_unlock) == 1 &&
 	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 		rcu_read_unlock_special(t);
+	__get_cpu_var(in_rcu_read_unlock)--;
+	put_cpu_var(in_rcu_read_unlock);
 #ifdef CONFIG_PROVE_LOCKING
 	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
 #endif /* #ifdef CONFIG_PROVE_LOCKING */


