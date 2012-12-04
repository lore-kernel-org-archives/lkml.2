Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2LEP6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:58:41 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39471 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab2LEP6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:58:39 -0500
Date: Tue, 4 Dec 2012 11:15:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] srcu: srcu_read_lock() can be called from offline cpu
Message-ID: <20121204191509.GA1680@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
 <1354178770-6028-5-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354178770-6028-5-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120515-9360-0000-0000-00000D8ECFFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 04:46:05PM +0800, Lai Jiangshan wrote:
> SRCU is based on its own statemachine and it doesn't
> relies on normal RCU now, its read critical section can be used in
> offline cpu, so we remove the check and the comments.
> 
> It partially reverts c0d6d01b(the part for SRCU).
> 
> It also makes the codes match the comments in whatisRCU.txt:
> 
> g.	Do you need read-side critical sections that are respected
> 	even though they are in the middle of the idle loop, during
> 	user-mode execution, or on an offlined CPU?  If so, SRCU is the
> 	only choice that will work for you.

One thing just occurred to me...  Won't lockdep refuse to operated on
offline CPUs?  If so, one way to handle this would be to flag srcu_struct
structures that were to be used on idle and offline CPUs, and avoid
using lockdep on them.  This would allow most uses of SRCU to continue
using lockdep, while avoiding lockdep false positives in other cases.

Or am I confused?

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  include/linux/srcu.h |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index 6eb691b..ae3ee39 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -163,9 +163,6 @@ void srcu_barrier(struct srcu_struct *sp);
>   * power mode. This way we can notice an extended quiescent state to
>   * other CPUs that started a grace period. Otherwise we would delay any
>   * grace period as long as we run in the idle task.
> - *
> - * Similarly, we avoid claiming an SRCU read lock held if the current
> - * CPU is offline.
>   */
>  static inline int srcu_read_lock_held(struct srcu_struct *sp)
>  {
> @@ -173,8 +170,6 @@ static inline int srcu_read_lock_held(struct srcu_struct *sp)
>  		return 1;
>  	if (rcu_is_cpu_idle())
>  		return 0;
> -	if (!rcu_lockdep_current_cpu_online())
> -		return 0;
>  	return lock_is_held(&sp->dep_map);
>  }
> 
> -- 
> 1.7.4.4
> 

