Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab0LTQ3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:29:05 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44117 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab0LTQ3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:29:02 -0500
Subject: Re: [RFC PATCH 13/15] sched: Protect nohz task cpu affinity
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <1292858662-5650-14-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-14-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Dec 2010 17:28:53 +0100
Message-ID: <1292862533.5021.41.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> Don't allow to change a nohz task cpu affinity as we want them
> to be bound to a single CPU and we want this affinity not to
> change.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Anton Blanchard <anton@au1.ibm.com>
> Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
> ---
>  kernel/sched.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 4412493..bd0a41f 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5712,6 +5712,13 @@ again:
>  		goto out;
>  	}
>  
> +	/* Nohz tasks must keep their affinity */
> +	if (test_tsk_thread_flag(p, TIF_NOHZ) &&
> +	    !cpumask_equal(&p->cpus_allowed, new_mask)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
>  	if (p->sched_class->set_cpus_allowed)
>  		p->sched_class->set_cpus_allowed(p, new_mask);
>  	else {

NAK, this is really way too restrictive.
