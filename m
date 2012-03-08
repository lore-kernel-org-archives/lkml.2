Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826Ab2CIP7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:59:21 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51446 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab2CIP7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:59:16 -0500
Date: Thu, 8 Mar 2012 11:25:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH 3/6] use "int trycount" instead of "bool expedited"
Message-ID: <20120308192507.GM2348@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331027858-7648-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030915-4242-0000-0000-0000010132EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 05:57:35PM +0800, Lai Jiangshan wrote:
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

This looks good, but does not apply.  I will push to -rcu, and then you
can tell me what I am missing.

							Thanx, Paul

> ---
>  kernel/srcu.c |   27 ++++++++++++++-------------
>  1 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/srcu.c b/kernel/srcu.c
> index fbe2d5f..d5f3450 100644
> --- a/kernel/srcu.c
> +++ b/kernel/srcu.c
> @@ -254,12 +254,12 @@ EXPORT_SYMBOL_GPL(__srcu_read_unlock);
>   * we repeatedly block for 1-millisecond time periods.  This approach
>   * has done well in testing, so there is no need for a config parameter.
>   */
> -#define SYNCHRONIZE_SRCU_READER_DELAY 5
> +#define SYNCHRONIZE_SRCU_READER_DELAY	5
> +#define SYNCHRONIZE_SRCU_TRYCOUNT	2
> +#define SYNCHRONIZE_SRCU_EXP_TRYCOUNT	12
> 
> -static void wait_idx(struct srcu_struct *sp, int idx, bool expedited)
> +static void wait_idx(struct srcu_struct *sp, int idx, int trycount)
>  {
> -	int trycount = 0;
> -
>  	/*
>  	 * If a reader fetches the index before the ->completed increment,
>  	 * but increments its counter after srcu_readers_active_idx_check()
> @@ -278,9 +278,10 @@ static void wait_idx(struct srcu_struct *sp, int idx, bool expedited)
>  	if (!srcu_readers_active_idx_check(sp, idx)) {
>  		udelay(SYNCHRONIZE_SRCU_READER_DELAY);
>  		while (!srcu_readers_active_idx_check(sp, idx)) {
> -			if (expedited && ++ trycount < 10)
> +			if (trycount > 0) {
> +				trycount--;
>  				udelay(SYNCHRONIZE_SRCU_READER_DELAY);
> -			else
> +			} else
>  				schedule_timeout_interruptible(1);
>  		}
>  	}
> @@ -310,18 +311,18 @@ static void wait_idx(struct srcu_struct *sp, int idx, bool expedited)
>   * by the next __synchronize_srcu() invoking wait_idx() for such readers
>   * before starting a new grace period.
>   */
> -static void flip_idx_and_wait(struct srcu_struct *sp, bool expedited)
> +static void flip_idx_and_wait(struct srcu_struct *sp, int trycount)
>  {
>  	int idx;
> 
>  	idx = sp->completed++ & 0x1;
> -	wait_idx(sp, idx, expedited);
> +	wait_idx(sp, idx, trycount);
>  }
> 
>  /*
>   * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
>   */
> -static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
> +static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
>  {
>  	rcu_lockdep_assert(!lock_is_held(&sp->dep_map) &&
>  			   !lock_is_held(&rcu_bh_lock_map) &&
> @@ -357,14 +358,14 @@ static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
>  	 * fetching ->completed and incrementing their counter, wait_idx()
>  	 * will normally not need to wait.
>  	 */
> -	wait_idx(sp, (sp->completed - 1) & 0x1, expedited);
> +	wait_idx(sp, (sp->completed - 1) & 0x1, trycount);
> 
>  	/*
>  	 * Now that wait_idx() has waited for the really old readers,
>  	 * invoke flip_idx_and_wait() to flip the counter and wait
>  	 * for current SRCU readers.
>  	 */
> -	flip_idx_and_wait(sp, expedited);
> +	flip_idx_and_wait(sp, trycount);
> 
>  	mutex_unlock(&sp->mutex);
>  }
> @@ -385,7 +386,7 @@ static void __synchronize_srcu(struct srcu_struct *sp, bool expedited)
>   */
>  void synchronize_srcu(struct srcu_struct *sp)
>  {
> -	__synchronize_srcu(sp, 0);
> +	__synchronize_srcu(sp, SYNCHRONIZE_SRCU_TRYCOUNT);
>  }
>  EXPORT_SYMBOL_GPL(synchronize_srcu);
> 
> @@ -406,7 +407,7 @@ EXPORT_SYMBOL_GPL(synchronize_srcu);
>   */
>  void synchronize_srcu_expedited(struct srcu_struct *sp)
>  {
> -	__synchronize_srcu(sp, 1);
> +	__synchronize_srcu(sp, SYNCHRONIZE_SRCU_EXP_TRYCOUNT);
>  }
>  EXPORT_SYMBOL_GPL(synchronize_srcu_expedited);
> 
> -- 
> 1.7.4.4
> 

