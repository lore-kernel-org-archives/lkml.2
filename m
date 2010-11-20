Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab0KTQI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 11:08:57 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:54305 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0KTQIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 11:08:55 -0500
Date: Sat, 20 Nov 2010 17:08:51 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>
Message-ID: <20101120160851.GA13356@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
 <65eae4de46680aa8d644619f6dc61ba17f1fdc77.1290087479.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65eae4de46680aa8d644619f6dc61ba17f1fdc77.1290087479.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv4 08/17] pps: add async PPS event handler
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 07:01:01PM +0300, Alexander Gordeev wrote:
> This handler should be called from an IRQ handler. It uses per-device
> workqueue internally.

Can you please explain to me why do you need this patch? Maybe you can
add a verbose patch's description? :)

> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> ---
>  drivers/pps/clients/pps-ktimer.c |    2 +-
>  drivers/pps/clients/pps-ldisc.c  |    2 +-
>  drivers/pps/kapi.c               |   95 ++++++++++++++++++++++++++++++++++++--
>  drivers/pps/pps.c                |   14 +++++-
>  include/linux/pps_kernel.h       |   12 +++++
>  5 files changed, 117 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pps/clients/pps-ktimer.c b/drivers/pps/clients/pps-ktimer.c
> index 2728469..26ed7a2 100644
> --- a/drivers/pps/clients/pps-ktimer.c
> +++ b/drivers/pps/clients/pps-ktimer.c
> @@ -48,7 +48,7 @@ static void pps_ktimer_event(unsigned long ptr)
>  
>  	dev_info(pps->dev, "PPS event at %lu\n", jiffies);
>  
> -	pps_event(pps, &ts, PPS_CAPTUREASSERT, NULL);
> +	pps_event_irq(pps, &ts, PPS_CAPTUREASSERT, NULL);
>  
>  	mod_timer(&ktimer, jiffies + HZ);
>  }
> diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
> index 30789fa..7006f85 100644
> --- a/drivers/pps/clients/pps-ldisc.c
> +++ b/drivers/pps/clients/pps-ldisc.c
> @@ -50,7 +50,7 @@ static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
>  	/* Now do the PPS event report */
>  	pps = (struct pps_device *)tty->disc_data;
>  	if (pps != NULL) {
> -		pps_event(pps, ts, status ? PPS_CAPTUREASSERT :
> +		pps_event_irq(pps, ts, status ? PPS_CAPTUREASSERT :
>  				PPS_CAPTURECLEAR, NULL);
>  		spin_unlock_irqrestore(&pps_ldisc_lock, flags);
>  		dev_dbg(pps->dev, "PPS %s at %lu\n",
> diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> index f5b2b78..ca3b4f8 100644
> --- a/drivers/pps/kapi.c
> +++ b/drivers/pps/kapi.c
> @@ -32,9 +32,19 @@
>  #include <linux/slab.h>
>  
>  /*
> + * Global variables
> + */
> +
> +/* PPS event workqueue */
> +struct workqueue_struct *pps_event_workqueue;
> +
> +/*
>   * Local functions
>   */
>  
> +static void assert_work_func(struct work_struct *work);
> +static void clear_work_func(struct work_struct *work);
> +
>  static void pps_add_offset(struct pps_ktime *ts, struct pps_ktime *offset)
>  {
>  	ts->nsec += offset->nsec;
> @@ -108,6 +118,9 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
>  	init_waitqueue_head(&pps->queue);
>  	spin_lock_init(&pps->lock);
>  
> +	INIT_WORK(&pps->assert_work, assert_work_func);
> +	INIT_WORK(&pps->clear_work, clear_work_func);
> +
>  	/* Create the char device */
>  	err = pps_register_cdev(pps);
>  	if (err < 0) {
> @@ -152,11 +165,12 @@ EXPORT_SYMBOL(pps_unregister_source);
>   * @event: the event type
>   * @data: userdef pointer
>   *
> - * This function is used by each PPS client in order to register a new
> - * PPS event into the system (it's usually called inside an IRQ handler).
> + * This function is used by PPS clients in order to register a new
> + * PPS event into the system. It should not be called from an IRQ
> + * handler. Use pps_event_irq instead.
>   *
> - * If an echo function is associated with the PPS device it will be called
> - * as:
> + * If an echo function is associated with the PPS device it will be
> + * called as:
>   *	pps->info.echo(pps, event, data);
>   */
>  void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
> @@ -226,3 +240,76 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
>  	spin_unlock_irqrestore(&pps->lock, flags);
>  }
>  EXPORT_SYMBOL(pps_event);
> +
> +/* Async event handlers */
> +
> +static void assert_work_func(struct work_struct *work)
> +{
> +	struct pps_device *pps = container_of(work,
> +			struct pps_device, assert_work);
> +
> +	pps_event(pps, &pps->assert_work_ts, PPS_CAPTUREASSERT,
> +			pps->assert_work_data);
> +}
> +
> +static void clear_work_func(struct work_struct *work)
> +{
> +	struct pps_device *pps = container_of(work,
> +			struct pps_device, clear_work);
> +
> +	pps_event(pps, &pps->clear_work_ts, PPS_CAPTURECLEAR,
> +			pps->clear_work_data);
> +}

The RFC-2783 says that (see 3.1 PPS abstraction):

   The API optionally supports an "echo" feature, in which events on
   the
   incoming PPS signal may be reflected through software, after the
   capture of the corresponding timestamp, to an output signal pin.
   This feature may be used to discover an upper bound on the actual
   delay between the edges of the PPS signal and the capture of the
   timestamps; such information may be useful in precise calibration
   of
   the system.

   The designation of an output pin for the echo signal, and sense and
   shape of the output transition, is outside the scope of this
   specification, but SHOULD be documented for each implementation.
   The
   output pin MAY also undergo transitions at other times besides
   those
   caused by PPS input events.

By applying this patch the echo function is called inside a work queue
so it depends to the scheduler. I suppose this is not acceptable,
otherwise we should drop the echo function support.

> +/* pps_event_irq - register a PPS event for deffered handling using
> + * workqueue
> + *
> + * @pps: the PPS device
> + * @ts: the event timestamp
> + * @event: the event type
> + * @data: userdef pointer
> + *
> + * This function is used by PPS clients in order to register a new
> + * PPS event into the system. It should be called from an IRQ handler
> + * only.
> + *
> + * If an echo function is associated with the PPS device it will be
> + * called as:
> + *	pps->info.echo(pps, event, data);
> + */

The above comment talks about the echo function but you removed it
from the code below...

> +void pps_event_irq(struct pps_device *pps, struct pps_event_time *ts,
> +		int event, void *data)
> +{
> +	/* check event type */
> +	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0);
> +
> +	if (event & PPS_CAPTUREASSERT) {
> +		if (work_pending(&pps->assert_work)) {
> +			dev_err(pps->dev, "deferred assert edge work haven't"
> +					" been handled within a second\n");
> +			/* FIXME: do something more intelligent
> +			 * then just exit */
> +		} else {
> +			/* now we can copy data safely */
> +			pps->assert_work_ts = *ts;
> +			pps->assert_work_data = data;
> +
> +			queue_work(pps_event_workqueue, &pps->assert_work);
> +		}
> +	}
> +	if (event & PPS_CAPTURECLEAR) {
> +		if (work_pending(&pps->clear_work)) {
> +			dev_err(pps->dev, "deferred clear edge work haven't"
> +					" been handled within a second\n");
> +			/* FIXME: do something more intelligent
> +			 * then just exit */
> +		} else {
> +			/* now we can copy data safely */
> +			pps->clear_work_ts = *ts;
> +			pps->clear_work_data = data;
> +
> +			queue_work(pps_event_workqueue, &pps->clear_work);
> +		}
> +	}
> +}
> +EXPORT_SYMBOL(pps_event_irq);
> diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
> index 79b4455..f642558 100644
> --- a/drivers/pps/pps.c
> +++ b/drivers/pps/pps.c
> @@ -321,18 +321,26 @@ void pps_unregister_cdev(struct pps_device *pps)
>  
>  static void __exit pps_exit(void)
>  {
> -	class_destroy(pps_class);
>  	unregister_chrdev_region(pps_devt, PPS_MAX_SOURCES);
> +	class_destroy(pps_class);
> +	destroy_workqueue(pps_event_workqueue);
>  }
>  
>  static int __init pps_init(void)
>  {
>  	int err;
>  
> +	pps_event_workqueue = create_workqueue("pps");
> +	if (!pps_event_workqueue) {
> +		pr_err("failed to create workqueue\n");
> +		return -ENOMEM;
> +	}
> +
>  	pps_class = class_create(THIS_MODULE, "pps");
>  	if (!pps_class) {
>  		pr_err("failed to allocate class\n");
> -		return -ENOMEM;
> +		err = -ENOMEM;
> +		goto destroy_workqueue;
>  	}
>  	pps_class->dev_attrs = pps_attrs;
>  
> @@ -350,6 +358,8 @@ static int __init pps_init(void)
>  
>  remove_class:
>  	class_destroy(pps_class);
> +destroy_workqueue:
> +	destroy_workqueue(pps_event_workqueue);
>  
>  	return err;
>  }
> diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
> index 1aedf50..5af0498 100644
> --- a/include/linux/pps_kernel.h
> +++ b/include/linux/pps_kernel.h
> @@ -26,6 +26,7 @@
>  #include <linux/cdev.h>
>  #include <linux/device.h>
>  #include <linux/time.h>
> +#include <linux/workqueue.h>
>  
>  /*
>   * Global defines
> @@ -70,6 +71,13 @@ struct pps_device {
>  	struct device *dev;
>  	struct fasync_struct *async_queue;	/* fasync method */
>  	spinlock_t lock;
> +
> +	struct work_struct assert_work;
> +	struct work_struct clear_work;
> +	struct pps_event_time assert_work_ts;
> +	struct pps_event_time clear_work_ts;
> +	void *assert_work_data;
> +	void *clear_work_data;
>  };
>  
>  /*
> @@ -78,6 +86,8 @@ struct pps_device {
>  
>  extern struct device_attribute pps_attrs[];
>  
> +extern struct workqueue_struct *pps_event_workqueue;
> +
>  /*
>   * Exported functions
>   */
> @@ -89,6 +99,8 @@ extern int pps_register_cdev(struct pps_device *pps);
>  extern void pps_unregister_cdev(struct pps_device *pps);
>  extern void pps_event(struct pps_device *pps,
>  		struct pps_event_time *ts, int event, void *data);
> +extern void pps_event_irq(struct pps_device *pps,
> +		struct pps_event_time *ts, int event, void *data);
>  
>  static inline void timespec_to_pps_ktime(struct pps_ktime *kt,
>  		struct timespec ts)
> -- 
> 1.7.2.3
> 

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
