Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab1K2A3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 19:29:22 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38877 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab1K2A3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 19:29:21 -0500
Date: Mon, 28 Nov 2011 16:29:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 2/4] rcu: Irq nesting is always 0 on
 rcu_enter_idle_common
Message-ID: <20111129002914.GP2346@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
 <1322515487-18690-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322515487-18690-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112900-5806-0000-0000-00000E881536
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 10:24:45PM +0100, Frederic Weisbecker wrote:
> So pass 0 directly as a nesting value on the tracing calls.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> ---
>  kernel/rcutree.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index c2aaadf..b80cb41 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -350,11 +350,10 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
>   */
>  static void rcu_idle_enter_common(struct rcu_dynticks *rdtp)
>  {
> -	trace_rcu_dyntick("Start", rdtp->dynticks_nesting);
> +	trace_rcu_dyntick("Start", 0);
>  	if (!idle_cpu(smp_processor_id())) {
>  		WARN_ON_ONCE(1);	/* must be idle task! */
> -		trace_rcu_dyntick("Error on entry: not idle task",
> -				   rdtp->dynticks_nesting);
> +		trace_rcu_dyntick("Error on entry: not idle task", 0);
>  		ftrace_dump(DUMP_ALL);
>  	}
>  	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */

Queued, again updating to work around the mid-air collision.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Irq nesting is always 0 on rcu_enter_idle_common

Because tasks don't nest, the ->dyntick_nesting must always be zero upon
entry to rcu_idle_enter_common().  Therefore, pass "0" rather than the
counter itself.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 54d9b4f..e0f5072 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -350,12 +350,11 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
  */
 static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 {
-	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
+	trace_rcu_dyntick("Start", oldval, 0);
 	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
-		trace_rcu_dyntick("Error on entry: not idle task",
-				   oldval, rdtp->dynticks_nesting);
+		trace_rcu_dyntick("Error on entry: not idle task", oldval, 0);
 		ftrace_dump(DUMP_ALL);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
 			  current->pid, current->comm,

