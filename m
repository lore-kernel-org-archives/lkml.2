Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab2HNN1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 09:27:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:11005 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab2HNN1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 09:27:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,766,1336374000"; 
   d="scan'208";a="180882605"
Date: Tue, 14 Aug 2012 21:21:50 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] tick: Emphasize tck_broadcast_on_off could only be
 called for host cpu
Message-ID: <20120814212150.1a5400b0@feng-i7>
In-Reply-To: <1343721441-28148-1-git-send-email-feng.tang@intel.com>
References: <1343721441-28148-1-git-send-email-feng.tang@intel.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012 15:57:21 +0800
Feng Tang <feng.tang@intel.com> wrote:

> With current tick_do_broadcast_on_off() and tick_broadcast_on_off(),
> it only cares host cpu, and doesn't really support to make the on/off
> for another target CPU as it seems to be. So remove the unneeded
> online check and add a WARN to notify user who doesn't know this
> new usage model.
> 
> Next step should be to remove those cases that sends the BROADCAST
> ON/OFF/FORCE msg on one cpu for another CPU, if this patch is reviewed
> to be ok.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/time/tick-broadcast.c |   15 +--------------
>  kernel/time/tick-common.c    |    6 +++++-
>  kernel/time/tick-internal.h  |    4 ++--
>  3 files changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index f113755..0433274 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -204,7 +204,7 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
>   * Powerstate information: The system enters/leaves a state, where
>   * affected devices might stop
>   */
> -static void tick_do_broadcast_on_off(unsigned long *reason)
> +void tick_broadcast_on_off(unsigned long *reason)
>  {
>  	struct clock_event_device *bc, *dev;
>  	struct tick_device *td;
> @@ -266,19 +266,6 @@ out:
>  }
>  
>  /*
> - * Powerstate information: The system enters/leaves a state, where
> - * affected devices might stop.
> - */
> -void tick_broadcast_on_off(unsigned long reason, int *oncpu)
> -{
> -	if (!cpumask_test_cpu(*oncpu, cpu_online_mask))
> -		printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
> -		       "offline CPU #%d\n", *oncpu);
> -	else
> -		tick_do_broadcast_on_off(&reason);
> -}
> -
> -/*
>   * Set the periodic handler depending on broadcast on/off
>   */
>  void tick_set_periodic_handler(struct clock_event_device *dev, int broadcast)
> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index da6c9ec..950c635 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -362,6 +362,8 @@ static void tick_resume(void)
>  static int tick_notify(struct notifier_block *nb, unsigned long reason,
>  			       void *dev)
>  {
> +	int *cpu = dev;
> +
>  	switch (reason) {
>  
>  	case CLOCK_EVT_NOTIFY_ADD:
> @@ -370,7 +372,9 @@ static int tick_notify(struct notifier_block *nb, unsigned long reason,
>  	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
>  	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
>  	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
> -		tick_broadcast_on_off(reason, dev);
> +		WARN((*cpu != smp_processor_id()),
> +			"BROADCAST ON/OFF/FORCE should only be fired for host CPU\n");
> +		tick_broadcast_on_off(&reason);
>  		break;
>  
>  	case CLOCK_EVT_NOTIFY_BROADCAST_ENTER:
> diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
> index 4e265b9..40e4a8b 100644
> --- a/kernel/time/tick-internal.h
> +++ b/kernel/time/tick-internal.h
> @@ -90,7 +90,7 @@ static inline bool tick_broadcast_oneshot_available(void) { return false; }
>  extern int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu);
>  extern int tick_check_broadcast_device(struct clock_event_device *dev);
>  extern int tick_is_broadcast_device(struct clock_event_device *dev);
> -extern void tick_broadcast_on_off(unsigned long reason, int *oncpu);
> +extern void tick_broadcast_on_off(unsigned long *reason);
>  extern void tick_shutdown_broadcast(unsigned int *cpup);
>  extern void tick_suspend_broadcast(void);
>  extern int tick_resume_broadcast(void);
> @@ -115,7 +115,7 @@ static inline int tick_device_uses_broadcast(struct clock_event_device *dev,
>  	return 0;
>  }
>  static inline void tick_do_periodic_broadcast(struct clock_event_device *d) { }
> -static inline void tick_broadcast_on_off(unsigned long reason, int *oncpu) { }
> +static inline void tick_broadcast_on_off(unsigned long *reason) { }
>  static inline void tick_shutdown_broadcast(unsigned int *cpup) { }
>  static inline void tick_suspend_broadcast(void) { }
>  static inline int tick_resume_broadcast(void) { return 0; }

Ping for comments.

Thanks,
Feng
