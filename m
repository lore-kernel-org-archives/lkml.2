Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab2IZSax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:30:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27392 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab2IZSaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:30:52 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=GecNO-ZYI38A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=NrfBHxz3jJsA:10 a=hSN8Xoj4_yB9FK1t6HkA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348684250.22822.59.camel@gandalf.local.home>
Subject: Re: [PATCH v4 3/3] tracing: format non-nanosec times from tsc clock
 without a decimal point.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 26 Sep 2012 14:30:50 -0400
In-Reply-To: <1348612174-19881-1-git-send-email-dhsharp@google.com>
References: <CAJL_ekvRFSDkFMmTyKD1-RTE2J=ajTdhb0s5TKmbVVKLRzakmw@mail.gmail.com>
	 <1348612174-19881-1-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 15:29 -0700, David Sharp wrote:

>  static int
> -lat_print_timestamp(struct trace_seq *s, u64 abs_usecs,
> -		    unsigned long rel_usecs)
> +lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
>  {
> -	return trace_seq_printf(s, " %4lldus%c: ", abs_usecs,
> -				rel_usecs > preempt_mark_thresh ? '!' :
> -				  rel_usecs > 1 ? '+' : ' ');
> +	unsigned long verbose = trace_flags & TRACE_ITER_VERBOSE;
> +	unsigned long in_ns = iter->iter_flags & TRACE_FILE_TIME_IN_NS;
> +	unsigned long long abs_ts = iter->ts - iter->tr->time_start;
> +	unsigned long long rel_ts = next_ts - iter->ts;
> +	struct trace_seq *s = &iter->seq;
> +	unsigned long mark_thresh;
> +	int ret;
> +
> +	if (in_ns) {
> +		abs_ts = ns2usecs(abs_ts);
> +		rel_ts = ns2usecs(rel_ts);
> +		mark_thresh = preempt_mark_thresh_us;
> +	} else
> +		mark_thresh = preempt_mark_thresh_cycles;
> +
> +	if (verbose && in_ns) {
> +		unsigned long abs_msec = abs_ts;
> +		unsigned long abs_usec = do_div(abs_msec, USEC_PER_MSEC);
> +		unsigned long rel_msec = rel_ts;
> +		unsigned long rel_usec = do_div(rel_msec, USEC_PER_MSEC);
> +
> +		ret = trace_seq_printf(
> +				s, "[%08llx] %ld.%03ldms (+%ld.%03ldms): ",
> +				ns2usecs(iter->ts),
> +				abs_msec, abs_usec,
> +				rel_msec, rel_usec);
> +	} else if (verbose && !in_ns) {
> +		ret = trace_seq_printf(
> +				s, "[%016llx] %lld (+%lld): ",
> +				iter->ts, abs_ts, rel_ts);
> +	} else { /* !verbose */
> +		ret = trace_seq_printf(
> +				s, " %4lld%s%c: ",
> +				abs_ts,
> +				in_ns ? "us" : "",
> +				rel_ts > mark_thresh ? '!' :
> +				  rel_ts > 1 ? '+' : ' ');

I still think the annotations are meaningless for counters. Even if the
counter is a timer like the tsc, as it does not coincide with real time
(us), I say just don't print it for counters.

This is not helpful:

  <idle>-0       0d..1  168+: trace_hardirqs_off_thunk <-apic_timer_interrupt
  <idle>-0       0d..1  672+: smp_apic_timer_interrupt <-apic_timer_interrupt
  <idle>-0       0d..1 1224+: irq_enter <-smp_apic_timer_interrupt
  <idle>-0       0d..1 1720+: rcu_irq_enter <-irq_enter
  <idle>-0       0d..1 2328+: rcu_idle_exit_common.isra.38 <-rcu_irq_enter
  <idle>-0       0d..1 3016+: local_bh_disable <-irq_enter
  <idle>-0       0d..1 3512+: __local_bh_disable <-irq_enter
  <idle>-0       0d.s1 4120+: tick_check_idle <-irq_enter
  <idle>-0       0d.s1 4632+: tick_check_oneshot_broadcast <-tick_check_idle
  <idle>-0       0d.s1 5296+: ktime_get <-tick_check_idle
  <idle>-0       0d.s1 6104+: tick_nohz_stop_idle <-tick_check_idle
  <idle>-0       0d.s1 6616+: update_ts_time_stats <-tick_nohz_stop_idle
  <idle>-0       0d.s1 7144+: nr_iowait_cpu <-update_ts_time_stats
  <idle>-0       0d.s1 7720+: ktime_get <-sched_clock_tick
  <idle>-0       0d.s1 8480+: touch_softlockup_watchdog <-tick_check_idle
  <idle>-0       0d.s1 9120+: tick_do_update_jiffies64 <-tick_check_idle
  <idle>-0       0d.s1 9648+: _raw_spin_lock <-tick_do_update_jiffies64


> +	}
> +	return ret;
>  }
>  
>  int trace_print_context(struct trace_iterator *iter)
>  {
>  	struct trace_seq *s = &iter->seq;
>  	struct trace_entry *entry = iter->ent;
> -	unsigned long long t = ns2usecs(iter->ts);
> -	unsigned long usec_rem = do_div(t, USEC_PER_SEC);
> -	unsigned long secs = (unsigned long)t;
> +	unsigned long long t;
> +	unsigned long secs, usec_rem;
>  	char comm[TASK_COMM_LEN];
>  	int ret;
>  
> @@ -644,8 +680,13 @@ int trace_print_context(struct trace_iterator *iter)
>  			return 0;
>  	}
>  
> -	return trace_seq_printf(s, " %5lu.%06lu: ",
> -				secs, usec_rem);
> +	if (iter->iter_flags & TRACE_FILE_TIME_IN_NS) {
> +		t = ns2usecs(iter->ts);
> +		usec_rem = do_div(t, USEC_PER_SEC);
> +		secs = (unsigned long)t;
> +		return trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);

You took away the space before %5.

> +	} else
> +		return trace_seq_printf(s, "%12llu: ", iter->ts);

here too.

We end up with this:

          <idle>-0     [002] d.h11968173392984: _raw_spin_lock_irqsave <-try_to_wake_up
          <idle>-0     [002] d.h11968173393704: add_preempt_count <-_raw_spin_lock_irqsave
          <idle>-0     [002] d.h21968173394568: task_waking_fair <-try_to_wake_up
          <idle>-0     [002] d.h21968173395488: select_task_rq_fair <-select_task_rq
          <idle>-0     [002] d.h21968173396240: __rcu_read_lock <-select_task_rq_fair
          <idle>-0     [002] d.h21968173397136: idle_cpu <-select_task_rq_fair
          <idle>-0     [002] d.h21968173397816: __rcu_read_unlock <-select_task_rq_fair
          <idle>-0     [002] d.h21968173398608: cpus_share_cache <-try_to_wake_up
          <idle>-0     [002] d.h21968173399272: _raw_spin_lock <-try_to_wake_up
          <idle>-0     [002] d.h21968173399888: add_preempt_count <-_raw_spin_lock
          <idle>-0     [002] d.h31968173400608: ttwu_do_activate.constprop.87 <-try_to_wake_up
          <idle>-0     [002] d.h31968173401272: activate_task <-ttwu_do_activate.constprop.87
          <idle>-0     [002] d.h31968173401912: enqueue_task <-ttwu_do_activate.constprop.87

-- Steve

>  }
>  
>  int trace_print_lat_context(struct trace_iterator *iter)
> @@ -659,36 +700,29 @@ int trace_print_lat_context(struct trace_iterator *iter)
>  			   *next_entry = trace_find_next_entry(iter, NULL,
>  							       &next_ts);
>  	unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
> -	unsigned long abs_usecs = ns2usecs(iter->ts - iter->tr->time_start);
> -	unsigned long rel_usecs;
>  
>  	/* Restore the original ent_size */
>  	iter->ent_size = ent_size;
>  
>  	if (!next_entry)
>  		next_ts = iter->ts;
> -	rel_usecs = ns2usecs(next_ts - iter->ts);


