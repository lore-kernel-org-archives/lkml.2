Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab2BXIBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 03:01:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58545 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab2BXIBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 03:01:37 -0500
Message-ID: <4F4744E9.1060109@cn.fujitsu.com>
Date: Fri, 24 Feb 2012 16:06:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH 3/3 RFC paul/rcu/srcu] srcu: flip only once for every
 grace period
References: <20120213020951.GA12138@linux.vnet.ibm.com> <4F41F315.1040900@cn.fujitsu.com> <20120220174418.GI2470@linux.vnet.ibm.com> <4F42EF53.6060400@cn.fujitsu.com> <20120221015037.GE2384@linux.vnet.ibm.com> <4F435966.9020106@cn.fujitsu.com> <20120221172442.GG2375@linux.vnet.ibm.com> <4F44B580.6040003@cn.fujitsu.com>
In-Reply-To: <4F44B580.6040003@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-24 15:59:45,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-24 15:59:51,
	Serialize complete at 2012-02-24 15:59:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 05:29 PM, Lai Jiangshan wrote:
>>From 4ddf62aaf2c4ebe6b9d4a1c596e8b43a678f1f0d Mon Sep 17 00:00:00 2001
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date: Wed, 22 Feb 2012 14:12:02 +0800
> Subject: [PATCH 3/3 RFC paul/rcu/srcu] srcu: flip only once for every grace period
> 
> flip_idx_and_wait() is not changed, and is split as two functions
> and only a short comments is added for smp_mb() E.
> 
> __synchronize_srcu() use a different algorithm for "leak" readers.
> detail is in the comments of the patch.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/srcu.c |  105 ++++++++++++++++++++++++++++++++++----------------------
>  1 files changed, 64 insertions(+), 41 deletions(-)
> 
> diff --git a/kernel/srcu.c b/kernel/srcu.c
> index a51ac48..346f9d7 100644
> --- a/kernel/srcu.c
> +++ b/kernel/srcu.c
> @@ -249,6 +249,37 @@ EXPORT_SYMBOL_GPL(__srcu_read_unlock);
>   */
>  #define SYNCHRONIZE_SRCU_READER_DELAY 5
>  
> +static void wait_idx(struct srcu_struct *sp, int idx, bool expedited)
> +{
> +	int trycount = 0;

Hi, Paul

	smp_mb() D also needs to be moved here, could you fix it before push it.
I thought it(smp_mb()) always here in my mind, wrong assumption.

Sorry.

Thanks,
Lai

> +
> +	/*
> +	 * SRCU read-side critical sections are normally short, so wait
> +	 * a small amount of time before possibly blocking.
> +	 */
> +	if (!srcu_readers_active_idx_check(sp, idx)) {
> +		udelay(SYNCHRONIZE_SRCU_READER_DELAY);
> +		while (!srcu_readers_active_idx_check(sp, idx)) {
> +			if (expedited && ++ trycount < 10)
> +				udelay(SYNCHRONIZE_SRCU_READER_DELAY);
> +			else
> +				schedule_timeout_interruptible(1);
> +		}
> +	}
> +
> +	/*
> +	 * The following smp_mb() E pairs with srcu_read_unlock()'s
> +	 * smp_mb C to ensure that if srcu_readers_active_idx_check()
> +	 * sees srcu_read_unlock()'s counter decrement, then any
> +	 * of the current task's subsequent code will happen after
> +	 * that SRCU read-side critical section.
> +	 *
> +	 * It also ensures the order between the above waiting and
> +	 * the next flipping.
> +	 */
> +	smp_mb(); /* E */
> +}
> +
>  /*
>   * Flip the readers' index by incrementing ->completed, then wait
>   * until there are no more readers using the counters referenced by
> @@ -258,12 +289,12 @@ EXPORT_SYMBOL_GPL(__srcu_read_unlock);
>   * Of course, it is possible that a reader might be delayed for the
>   * full duration of flip_idx_and_wait() between fetching the
>   * index and incrementing its counter.  This possibility is handled
> - * by __synchronize_srcu() invoking flip_idx_and_wait() twice.
> + * by the next __synchronize_srcu() invoking wait_idx() for such readers
> + * before start a new grace perioad.
>   */
>  static void flip_idx_and_wait(struct srcu_struct *sp, bool expedited)
>  {
>  	int idx;
> -	int trycount = 0;
>  
>  	idx = sp->completed++ & 0x1;
>  
> @@ -278,28 +309,7 @@ static void flip_idx_and_wait(struct srcu_struct *sp, bool expedited)
>  	 */
>  	smp_mb(); /* D */
>  
> -	/*
> -	 * SRCU read-side critical sections are normally short, so wait
> -	 * a small amount of time before possibly blocking.
> -	 */
> -	if (!srcu_readers_active_idx_check(sp, idx)) {
> -		udelay(SYNCHRONIZE_SRCU_READER_DELAY);
> -		while (!srcu_readers_active_idx_check(sp, idx)) {
> -			if (expedited && ++ trycount < 10)
> -				udelay(SYNCHRONIZE_SRCU_READER_DELAY);
> -			else
> -				schedule_timeout_interruptible(1);
> -		}
> -	}
> -
> -	/*
> -	 * The following smp_mb() E pairs with srcu_read_unlock()'s
> -	 * smp_mb C to ensure that if srcu_readers_active_idx_check()
> -	 * sees srcu_read_unlock()'s counter decrement, then any
> -	 * of the current task's subsequent code will happen after
> -	 * that SRCU read-side critical section.
> -	 */
> -	smp_mb(); /* E */
> +	wait_idx(sp, idx, expedited);
>  }
>  
>  /*
> @@ -307,8 +317,6 @@ static void flip_idx_and_wait(struct srcu_struct *sp, bool expedited)
>   */
>  static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
>  {
> -	int idx = 0;
> -
>  	rcu_lockdep_assert(!lock_is_held(&sp->dep_map) &&
>  			   !lock_is_held(&rcu_bh_lock_map) &&
>  			   !lock_is_held(&rcu_lock_map) &&
> @@ -318,27 +326,42 @@ static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
>  	mutex_lock(&sp->mutex);
>  
>  	/*
> -	 * If there were no helpers, then we need to do two flips of
> -	 * the index.  The first flip is required if there are any
> -	 * outstanding SRCU readers even if there are no new readers
> -	 * running concurrently with the first counter flip.
> -	 *
> -	 * The second flip is required when a new reader picks up
> +	 * When in the previous grace perioad, if a reader picks up
>  	 * the old value of the index, but does not increment its
>  	 * counter until after its counters is summed/rechecked by
> -	 * srcu_readers_active_idx_check().  In this case, the current SRCU
> +	 * srcu_readers_active_idx_check(). In this case, the previous SRCU
>  	 * grace period would be OK because the SRCU read-side critical
> -	 * section started after this SRCU grace period started, so the
> +	 * section started after the SRCU grace period started, so the
>  	 * grace period is not required to wait for the reader.
>  	 *
> -	 * However, the next SRCU grace period would be waiting for the
> -	 * other set of counters to go to zero, and therefore would not
> -	 * wait for the reader, which would be very bad.  To avoid this
> -	 * bad scenario, we flip and wait twice, clearing out both sets
> -	 * of counters.
> +	 * However, such leftover readers affect this new SRCU grace period.
> +	 * So we have to wait for such readers. This wait_idx() should be
> +	 * considerred as the wait_idx() in the flip_idx_and_wait() of
> +	 * the previous grace perioad except that it is for leftover readers
> +	 * started before this synchronize_srcu(). So when it returns,
> +	 * there is no leftover readers that starts before this grace period.
> +	 *
> +	 * If there are some leftover readers that do not increment its
> +	 * counter until after its counters is summed/rechecked by
> +	 * srcu_readers_active_idx_check(), In this case, this SRCU
> +	 * grace period would be OK as above comments says. We defines
> +	 * such readers as leftover-leftover readers, we consider these
> +	 * readers fteched index of (sp->completed + 1), it means they
> +	 * are considerred as exactly the same as the readers after this
> +	 * grace period.
> +	 *
> +	 * wait_idx() is expected very fast, because leftover readers
> +	 * are unlikely produced.
>  	 */
> -	for (; idx < 2; idx++)
> -		flip_idx_and_wait(sp, expedited);
> +	wait_idx(sp, (sp->completed - 1) & 0x1, expedited);
> +
> +	/*
> +	 * Starts a new grace period, this flip is required if there are
> +	 * any outstanding SRCU readers even if there are no new readers
> +	 * running concurrently with the counter flip.
> +	 */
> +	flip_idx_and_wait(sp, expedited);
> +
>  	mutex_unlock(&sp->mutex);
>  }
>  

