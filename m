Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab0I0Pr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:47:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:49854 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759140Ab0I0Pr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:47:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,243,1283756400"; 
   d="scan'208";a="558355351"
Date: Mon, 27 Sep 2010 17:48:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: tom.leiming@gmail.com
Cc: linux-omap@vger.kernel.org, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Balaji T K <balajitk@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: speedup twl4030 irq response time and decrease
 irq disable time
Message-ID: <20100927154809.GI2560@sortiz-mobl>
References: <1285120171-3030-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285120171-3030-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

On Wed, Sep 22, 2010 at 09:49:31AM +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch sets scheduler policy of twl4030 irq thread
> (twl4030_irq_thread) as SCHED_FIFO to speedup irq response
> time, just like taken by kernel threaded irq in irq_thread
> (kernel/irq/manage.c). Also higher priority than that of
> threaded irq is taken to avoid preemption from twl4030
> subchips's threaded irq handler, so pih irq disable time may
> be decreased.
Wouldn't converting your twl4030_irq_thread() to the threaded IRQ framework
fix that problem ?


> The pih irq is disabled in handle_twl4030_pih which may
> wakeup twl4030 irq thread, and the pih irq will be enabled
> again until complete of all sih irqs' handling in twl4030
> irq thread.
> 
> Also for each one interrupt line of twl4030 subchip, only
> two irq events can be buffered by twl4030(4.4.2.3 of TPS65950 TRM).
Could you explain how is that related to the patch below ?

Cheers,
Samuel.



> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Balaji T K <balajitk@ti.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/mfd/twl4030-irq.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
> index 097f24d..d1e0d80 100644
> --- a/drivers/mfd/twl4030-irq.c
> +++ b/drivers/mfd/twl4030-irq.c
> @@ -286,8 +286,16 @@ static int twl4030_irq_thread(void *data)
>  	long irq = (long)data;
>  	static unsigned i2c_errors;
>  	static const unsigned max_i2c_errors = 100;
> -
> -
> +	struct sched_param param = {
> +		.sched_priority = MAX_USER_RT_PRIO/2 + 10,
> +	};
> +
> +	/* Take higher priority than threaded irq to make us immune of
> + 	 * preemption from twl4030 subchips's threaded irq handler, then
> + 	 * we can complete all SIH irqs' handling and enable PIH irq
> + 	 * again asap.
> + 	 * */
> +	sched_setscheduler(current, SCHED_FIFO, &param);
>  	current->flags |= PF_NOFREEZE;
>  
>  	while (!kthread_should_stop()) {
> -- 
> 1.6.2.5
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
