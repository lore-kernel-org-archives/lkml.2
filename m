Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030189Ab2CIP7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:59:49 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:36709 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964913Ab2CIP7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:59:46 -0500
Date: Thu, 8 Mar 2012 11:14:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH 2/6] Don't touch the snap in srcu_readers_active()
Message-ID: <20120308191439.GL2348@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331027858-7648-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030915-6148-0000-0000-0000041F7ACC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 05:57:34PM +0800, Lai Jiangshan wrote:
> srcu_readers_active() is called without the mutex, but it touch the snap.
> also achieve better cache locality a little
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Queued with updated commit-log message, thank you!

							Thanx, Paul

	Expand the calls to srcu_readers_active_idx() from
	srcu_readers_active() inline.  This change improves cache locality
	by interating over the CPUs once rather than twice.

> ---
>  kernel/srcu.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/srcu.c b/kernel/srcu.c
> index b6b9ea2..fbe2d5f 100644
> --- a/kernel/srcu.c
> +++ b/kernel/srcu.c
> @@ -181,7 +181,14 @@ static bool srcu_readers_active_idx_check(struct srcu_struct *sp, int idx)
>   */
>  static int srcu_readers_active(struct srcu_struct *sp)
>  {
> -	return srcu_readers_active_idx(sp, 0) + srcu_readers_active_idx(sp, 1);
> +	int cpu;
> +	unsigned long sum = 0;
> +
> +	for_each_possible_cpu(cpu) {
> +		sum += ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, cpu)->c[0]);
> +		sum += ACCESS_ONCE(per_cpu_ptr(sp->per_cpu_ref, cpu)->c[1]);
> +	}
> +	return sum & SRCU_REF_MASK;
>  }
> 
>  /**
> -- 
> 1.7.4.4
> 

