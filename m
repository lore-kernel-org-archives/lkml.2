Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2GaRZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:25:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab2GaRY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:24:59 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=I5RZEMmPgckA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8 a=lQznST3YeLCgdUvaGU0A:9 a=PUjeQqilurYA:10 a=WwgC8nHKvroA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343755497.27983.59.camel@gandalf.stny.rr.com>
Subject: Re: __update_max_tr: rcu_read_lock() used illegally while idle!
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Date: Tue, 31 Jul 2012 13:24:57 -0400
In-Reply-To: <20120731171733.GK2422@linux.vnet.ibm.com>
References: <20120724090330.GA9830@localhost>
	 <1343662752.3847.2.camel@fedora> <20120731120556.GB17252@localhost>
	 <1343741625.27983.39.camel@gandalf.stny.rr.com>
	 <20120731144453.GB2422@linux.vnet.ibm.com>
	 <1343746311.27983.52.camel@gandalf.stny.rr.com>
	 <1343746583.27983.55.camel@gandalf.stny.rr.com>
	 <20120731151808.GF2422@linux.vnet.ibm.com>
	 <1343749502.27983.57.camel@gandalf.stny.rr.com>
	 <20120731171733.GK2422@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 10:17 -0700, Paul E. McKenney wrote:

> rcu: Permit RCU_NONIDLE() to be used from interrupt context
> 
> There is a need to use RCU from interrupt context, but either before
> rcu_irq_enter() is called or after rcu_irq_exit() is called.  If the
> interrupt occurs from idle, then lockdep-RCU will complain about such
> uses, as they appear to be illegal uses of RCU from the idle loop.
> In other environments, RCU_NONIDLE() could be used to properly protect
> the use of RCU, but RCU_NONIDLE() currently cannot be invoked except
> from process context.
> 
> This commit therefore modifies RCU_NONIDLE() to permit its use more
> globally.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 115ead2..4eab81a 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -210,14 +210,12 @@ extern void exit_rcu(void);
>   * to nest RCU_NONIDLE() wrappers, but the nesting level is currently
>   * quite limited.  If deeper nesting is required, it will be necessary
>   * to adjust DYNTICK_TASK_NESTING_VALUE accordingly.
> - *
> - * This macro may be used from process-level code only.
>   */
>  #define RCU_NONIDLE(a) \
>  	do { \
> -		rcu_idle_exit(); \
> +		rcu_irq_exit(); \

Don't you want that to be rcu_irq_enter? And is this safe to happen
everywhere in the kernel?

The code that is calling rcu is called by the irqsoff tracer. Which can
happen at all points where interrupts are enabled.

-- Steve

>  		do { a; } while (0); \
> -		rcu_idle_enter(); \
> +		rcu_irq_enter(); \
>  	} while (0)
>  
>  /*
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 31a10f9..aee6df8 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -115,6 +115,7 @@ void rcu_irq_exit(void)
>  	rcu_idle_enter_common(newval);
>  	local_irq_restore(flags);
>  }
> +EXPORT_SYMBOL_GPL(rcu_irq_exit);
>  
>  /* Common code for rcu_idle_exit() and rcu_irq_enter(), see kernel/rcutree.c. */
>  static void rcu_idle_exit_common(long long oldval)
> @@ -172,6 +173,7 @@ void rcu_irq_enter(void)
>  	rcu_idle_exit_common(oldval);
>  	local_irq_restore(flags);
>  }
> +EXPORT_SYMBOL_GPL(rcu_irq_enter);
>  
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 44609c3..2175b13 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -455,6 +455,7 @@ void rcu_irq_exit(void)
>  		rcu_idle_enter_common(rdtp, oldval);
>  	local_irq_restore(flags);
>  }
> +EXPORT_SYMBOL_GPL(rcu_irq_exit);
>  
>  /*
>   * rcu_idle_exit_common - inform RCU that current CPU is moving away from idle
> @@ -550,6 +551,7 @@ void rcu_irq_enter(void)
>  		rcu_idle_exit_common(rdtp, oldval);
>  	local_irq_restore(flags);
>  }
> +EXPORT_SYMBOL_GPL(rcu_irq_enter);
>  
>  /**
>   * rcu_nmi_enter - inform RCU of entry to NMI context


