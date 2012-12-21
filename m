Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab2LUQNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 11:13:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4654 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2LUQNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 11:13:19 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eZnsvP3-SpoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=om32Zw-ELMQA:10 a=VT4-vTsrXc7iMSGJpiAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356106396.5896.111.camel@gandalf.local.home>
Subject: Re: [PATCH 07/24] nohz: Assign timekeeping duty to a non-full-nohz
 CPU
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 21 Dec 2012 11:13:16 -0500
In-Reply-To: <1356028391-14427-8-git-send-email-fweisbec@gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
	 <1356028391-14427-8-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-20 at 19:32 +0100, Frederic Weisbecker wrote:

kernel/time/tick-sched.c:517:6: error: have_full_nohz_mask undeclared
(first use in this function)


> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -112,7 +112,8 @@ static void tick_sched_do_timer(ktime_t now)
>  	 * this duty, then the jiffies update is still serialized by
>  	 * jiffies_lock.
>  	 */
> -	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
> +	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)
> +	    && !tick_nohz_full_cpu(cpu))
>  		tick_do_timer_cpu = cpu;
>  #endif
>  
> @@ -512,6 +513,10 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
>  		return false;
>  	}
>  
> +	/* If there are full nohz CPUs around, we need to keep the timekeeping duty */
> +	if (have_full_nohz_mask && tick_do_timer_cpu == cpu)
> +		return false;
> +
>  	return true;
>  }
>  

Fold in:

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4a68b50..00e5682 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -164,6 +164,8 @@ static int __init tick_nohz_full_setup(char *str)
 	return 1;
 }
 __setup("full_nohz=", tick_nohz_full_setup);
+#else
+#define have_full_nohz_mask 0
 #endif
 
 /*


-- Steve


