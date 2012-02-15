Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646Ab2BOOlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:41:12 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:4374 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758451Ab2BOOlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:41:08 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Feb 2012 09:41:08 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EADrBO0/O+Ip3/2dsb2JhbABDsE+BCIFzAQUnExsBIxALRhQlJBO9YItrAxoECwkOAQICCQwCCgIEg18FBQMtA4JhYwSITYxoji2EWg
X-IronPort-AV: E=Sophos;i="4.73,423,1325480400"; 
   d="scan'208";a="163185092"
Date: Wed, 15 Feb 2012 09:31:17 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU
	implementation
Message-ID: <20120215143116.GA1696@Krystal>
References: <20120213020951.GA12138@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20120213020951.GA12138@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:25:25 up 7 days,  1:23,  2 users,  load average: 0.01, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
[...]
> +/*
> + * To be called from the update side after an index flip.  Returns true
> + * if the modulo sum of the counters is stably zero, false if there is
> + * some possibility of non-zero.
> + */
> +static bool srcu_readers_active_idx_check(struct srcu_struct *sp, int idx)
>  {
>  	int cpu;
> -	int sum;
>  
> -	sum = 0;
> +	/*
> +	 * Note that srcu_readers_active_idx() can incorrectly return
> +	 * zero even though there is a pre-existing reader throughout.
> +	 * To see this, suppose that task A is in a very long SRCU
> +	 * read-side critical section that started on CPU 0, and that
> +	 * no other reader exists, so that the modulo sum of the counters
> +	 * is equal to one.  Then suppose that task B starts executing
> +	 * srcu_readers_active_idx(), summing up to CPU 1, and then that
> +	 * task C starts reading on CPU 0, so that its increment is not
> +	 * summed, but finishes reading on CPU 2, so that its decrement
> +	 * -is- summed.  Then when task B completes its sum, it will
> +	 * incorrectly get zero, despite the fact that task A has been
> +	 * in its SRCU read-side critical section the whole time.
> +	 *
> +	 * We therefore do a validation step should srcu_readers_active_idx()
> +	 * return zero.
> +	 */
> +	if (srcu_readers_active_idx(sp, idx) != 0)
> +		return false;
> +
> +	/*
> +	 * Since the caller recently flipped ->completed, we can see at
> +	 * most one increment of each CPU's counter from this point
> +	 * forward.  The reason for this is that the reader CPU must have
> +	 * fetched the index before srcu_readers_active_idx checked
> +	 * that CPU's counter, but not yet incremented its counter.
> +	 * Its eventual counter increment will follow the read in
> +	 * srcu_readers_active_idx(), and that increment is immediately
> +	 * followed by smp_mb() B.  Because smp_mb() D is between
> +	 * the ->completed flip and srcu_readers_active_idx()'s read,
> +	 * that CPU's subsequent load of ->completed must see the new
> +	 * value, and therefore increment the counter in the other rank.
> +	 */
> +	smp_mb(); /* A */
> +
> +	/*
> +	 * Now, we check the ->snap array that srcu_readers_active_idx()
> +	 * filled in from the per-CPU counter values.  Since both
> +	 * __srcu_read_lock() and __srcu_read_unlock() increment the
> +	 * upper bits of the per-CPU counter, an increment/decrement
> +	 * pair will change the value of the counter.  Since there is
> +	 * only one possible increment, the only way to wrap the counter
> +	 * is to have a huge number of counter decrements, which requires
> +	 * a huge number of tasks and huge SRCU read-side critical-section
> +	 * nesting levels, even on 32-bit systems.
> +	 *
> +	 * All of the ways of confusing the readings require that the scan
> +	 * in srcu_readers_active_idx() see the read-side task's decrement,
> +	 * but not its increment.  However, between that decrement and
> +	 * increment are smb_mb() B and C.  Either or both of these pair
> +	 * with smp_mb() A above to ensure that the scan below will see
> +	 * the read-side tasks's increment, thus noting a difference in
> +	 * the counter values between the two passes.

Hi Paul,

I think the implementation is correct, but the explanation above might
be improved. Let's consider the following a scenario, where a reader is
migrated between increment of the counter and issuing the memory barrier
in the read lock:

A,B,C are readers
D is synchronize_rcu (one flip'n'wait)

CPU A               CPU B           CPU C         CPU D
                                    c[1]++
                                    smp_mb(1)
                                                  read c[0] -> 0
c[0]++
(implicit smp_mb (2))
      -> migrated ->
                    (implicit smp_mb (3))
                    smp_mb (4)
                    smp_mb (5)
                    c[1]--
                                                  read c[1] -> -1
                                                  read c[2] -> 1
                                                  (false 0 sum)
                                                  smp_mb (6)
                                                  re-check each.
                                    c[1]--

re-check: because we observed c[1] == -1, thanks to the implicit memory
barriers within thread migration (2 and 3), we can assume that we _will_
observe the updated value of c[0] after smp_mb (6).

The current explanation states that memory barriers 4 and 5, along with  
6, are responsible for ensuring that the increment will be observed by 
the re-check. However, I doubt they have anything to do with it: it's 
rather the implicit memory barriers in thread migration, along with
program order guarantees on writes to the same address, that seems to be
the reason why we can do this ordering assumption.

Does it make sense, or shall I get another coffee to wake myself up ?
;)

Thanks,

Mathieu

> +	 *
> +	 * Therefore, if srcu_readers_active_idx() returned zero, and
> +	 * none of the counters changed, we know that the zero was the
> +	 * correct sum.
> +	 *
> +	 * Of course, it is possible that a task might be delayed
> +	 * for a very long time in __srcu_read_lock() after fetching
> +	 * the index but before incrementing its counter.  This
> +	 * possibility will be dealt with in __synchronize_srcu().
> +	 */
>  	for_each_possible_cpu(cpu)
> -		sum += per_cpu_ptr(sp->per_cpu_ref, cpu)->c[idx];
> -	return sum;
> +		if (sp->snap[cpu] !=
> +		    ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, cpu)->c[idx]))
> +			return false;  /* False zero reading! */
> +	return true;
>  }


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
