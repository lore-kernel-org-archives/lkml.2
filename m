Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab1DBSdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 14:33:19 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:45280 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1DBSdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 14:33:17 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D976C48.5070709@cam.ac.uk>
Date: Sat, 02 Apr 2011 19:34:48 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        tglx@linutronix.de
Subject: Re: [PATCH 15/21] staging:iio: Add infrastructure for irq_chip based
 triggers
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk> <1301583255-28468-16-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1301583255-28468-16-git-send-email-jic23@cam.ac.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a heads up, the multiple consumers case is completely broken.  There is
also a lockup that can occur if the trigger is too much faster than we can
handle (being rigorous with the usecounter is the fix for that).

Next version will have the following additional patch merged into this one.
(probably with correct locking on the various parameters - unlike here).

There's a reason this was an RFC for now ;)

---
 drivers/staging/iio/industrialio-trigger.c |   35 ++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/iio/industrialio-trigger.c b/drivers/staging/iio/industrialio-trigger.c
index a350f25..f3b8e05 100644
--- a/drivers/staging/iio/industrialio-trigger.c
+++ b/drivers/staging/iio/industrialio-trigger.c
@@ -164,11 +164,14 @@ static struct iio_trigger *iio_trigger_find_by_name(const char *name,
 void iio_trigger_poll(struct iio_trigger *trig, s64 time)
 {
 	int i;
-	for (i = 0; i < CONFIG_IIO_CONSUMERS_PER_TRIGGER; i++)
-		if (trig->subirqs[i].enabled) {
-			trig->use_count++;
-			generic_handle_irq(trig->subirq_base + i);
-		}
+	if (!trig->use_count) {
+		for (i = 0; i < CONFIG_IIO_CONSUMERS_PER_TRIGGER; i++)
+			if (trig->subirqs[i].enabled) {
+				trig->use_count++;
+				generic_handle_irq(trig->subirq_base + i);
+			}
+	}
 }
 EXPORT_SYMBOL(iio_trigger_poll);
 
@@ -208,13 +211,18 @@ int iio_trigger_attach_poll_func(struct iio_trigger *trig,
 				 struct iio_poll_func *pf)
 {
 	int ret = 0;
-
+	bool notinuse
+		= bitmap_empty(trig->pool, CONFIG_IIO_CONSUMERS_PER_TRIGGER);
+		
 	pf->irq = iio_trigger_get_irq(trig);
 	ret = request_threaded_irq(pf->irq, NULL, pf->handler,
 				   pf->type, pf->name,
 				   pf);
-	if (trig->set_trigger_state)
+
+	
+	if (trig->set_trigger_state && notinuse) {
 		ret = trig->set_trigger_state(trig, true);
+	}
 
 	return ret;
 }
@@ -223,9 +231,16 @@ EXPORT_SYMBOL(iio_trigger_attach_poll_func);
 int iio_trigger_dettach_poll_func(struct iio_trigger *trig,
 				  struct iio_poll_func *pf)
 {
-	int ret = trig->set_trigger_state(trig, false);
-	if (ret)
-		goto error_ret;
+	int ret = 0;
+	bool no_other_users
+		= (bitmap_weight(trig->pool,
+				 CONFIG_IIO_CONSUMERS_PER_TRIGGER) == 1);
+
+	if (trig->set_trigger_state && no_other_users) {
+		ret = trig->set_trigger_state(trig, false);
+		if (ret)
+			goto error_ret;
+	}
 	iio_trigger_put_irq(trig, pf->irq);
 	free_irq(pf->irq, pf);
 
-- 
1.7.3.4



> ---
>  drivers/staging/Makefile                      |    2 +-
>  drivers/staging/iio/Kconfig                   |   12 ++
>  drivers/staging/iio/Makefile                  |    2 +
>  drivers/staging/iio/iio-board-info.h          |   24 ++++
>  drivers/staging/iio/iio-core.h                |   13 ++
>  drivers/staging/iio/iio.h                     |   13 ++
>  drivers/staging/iio/industrialio-board-info.c |   25 ++++
>  drivers/staging/iio/industrialio-core.c       |   28 +++++
>  drivers/staging/iio/industrialio-trigger.c    |  146 ++++++++++++++++++++-----
>  drivers/staging/iio/trigger.h                 |   40 +++++++-
>  10 files changed, 275 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> index cfd13cd..ee7594c 100644
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -42,7 +42,7 @@ obj-$(CONFIG_HYPERV)		+= hv/
>  obj-$(CONFIG_VME_BUS)		+= vme/
>  obj-$(CONFIG_MRST_RAR_HANDLER)	+= memrar/
>  obj-$(CONFIG_DX_SEP)            += sep/
> -obj-$(CONFIG_IIO)		+= iio/
> +obj-y				+= iio/
>  obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio/
>  obj-$(CONFIG_ZRAM)		+= zram/
>  obj-$(CONFIG_XVMALLOC)		+= zram/
> diff --git a/drivers/staging/iio/Kconfig b/drivers/staging/iio/Kconfig
> index 6775bf9..df9aa08 100644
> --- a/drivers/staging/iio/Kconfig
> +++ b/drivers/staging/iio/Kconfig
> @@ -12,6 +12,10 @@ menuconfig IIO
>  	  Documentation/industrialio for more information.
>  if IIO
>  
> +config IIO_BOARDINFO
> +       boolean
> +       default y
> +
>  config IIO_RING_BUFFER
>  	bool "Enable ring buffer support within IIO"
>  	help
> @@ -42,12 +46,20 @@ endif # IIO_RINGBUFFER
>  
>  config IIO_TRIGGER
>  	boolean "Enable triggered sampling support"
> +	depends on IIO_BOARDINFO
>  	help
>  	  Provides IIO core support for triggers.  Currently these
>  	  are used to initialize capture of samples to push into
>  	  ring buffers.  The triggers are effectively a 'capture
>  	  data now' interrupt.
>  
> +config IIO_CONSUMERS_PER_TRIGGER
> +       int "Maximum number of consumers per trigger"
> +       depends on IIO_TRIGGER
> +       default "2"
> +       help
> +	This value controls the maximum number of consumers that a
> +	given trigger may handle. Default is 2.
>  
>  source "drivers/staging/iio/accel/Kconfig"
>  source "drivers/staging/iio/adc/Kconfig"
> diff --git a/drivers/staging/iio/Makefile b/drivers/staging/iio/Makefile
> index bb5c95c..37b4d12 100644
> --- a/drivers/staging/iio/Makefile
> +++ b/drivers/staging/iio/Makefile
> @@ -2,6 +2,8 @@
>  # Makefile for the industrial I/O core.
>  #
>  
> +obj-$(CONFIG_IIO_BOARDINFO) += industrialio-board-info.o
> +
>  obj-$(CONFIG_IIO) += industrialio.o
>  industrialio-y := industrialio-core.o
>  industrialio-$(CONFIG_IIO_RING_BUFFER) += industrialio-ring.o
> diff --git a/drivers/staging/iio/iio-board-info.h b/drivers/staging/iio/iio-board-info.h
> new file mode 100644
> index 0000000..c608a4d
> --- /dev/null
> +++ b/drivers/staging/iio/iio-board-info.h
> @@ -0,0 +1,24 @@
> +/*
> + * Board information for IIO.
> + *
> + * Copyright (c) 2011 Jonathan Cameron <jic23@cam.ac.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifdef CONFIG_IIO_BOARDINFO
> +
> +/**
> + * iio_set_irq_pool() - provid iio with a pool of virtaul interrupts to use
> + * @start: start of the pool
> + * @num: number of interupts in the pool
> + **/
> +void iio_set_irq_pool(int start, int num);
> +
> +#else
> +
> +static inline void iio_set_irq_pool(int start, int num) {};
> +
> +#endif
> diff --git a/drivers/staging/iio/iio-core.h b/drivers/staging/iio/iio-core.h
> new file mode 100644
> index 0000000..2c4f433
> --- /dev/null
> +++ b/drivers/staging/iio/iio-core.h
> @@ -0,0 +1,13 @@
> +/*
> + * IIO core header. Should never be included by drivers.
> + *
> + * Copyright (c) 2011 Jonathan Cameron <jic23@cam.ac.uk>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#define IIO_MAX_POOL 128
> +extern int __iio_irqstart;
> +extern int __iio_irqnum;
> diff --git a/drivers/staging/iio/iio.h b/drivers/staging/iio/iio.h
> index fb6caae..add0659 100644
> --- a/drivers/staging/iio/iio.h
> +++ b/drivers/staging/iio/iio.h
> @@ -304,6 +304,19 @@ extern dev_t iio_devt;
>  extern struct bus_type iio_bus_type;
>  
>  /**
> + * iio_irq_pool_get_range() - get a set of irqs from the pool
> + * @num: number of interrupts requested
> + **/
> +int iio_irq_pool_get_range(int num);
> +
> +/**
> + * iio_irq_pool_put_range()
> + * @start: first irq to return to the pool
> + * @num: number to return
> + **/
> +void iio_irq_pool_put_range(int start, int num);
> +
> +/**
>   * iio_put_device() - reference counted deallocation of struct device
>   * @dev: the iio_device containing the device
>   **/
> diff --git a/drivers/staging/iio/industrialio-board-info.c b/drivers/staging/iio/industrialio-board-info.c
> new file mode 100644
> index 0000000..28f9156
> --- /dev/null
> +++ b/drivers/staging/iio/industrialio-board-info.c
> @@ -0,0 +1,25 @@
> +/* IIO Board info
> + *
> + * Copyright (c) 2011 Jonathan Cameron
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include "iio-core.h"
> +
> +int __iio_irqstart;
> +EXPORT_SYMBOL(__iio_irqstart);
> +int __iio_irqnum;
> +EXPORT_SYMBOL(__iio_irqnum);
> +
> +void __init iio_set_irq_pool(int start, int num)
> +{
> +	__iio_irqstart = start;
> +	__iio_irqnum = num;
> +	if (num > IIO_MAX_POOL)
> +		__iio_irqnum = IIO_MAX_POOL;
> +}
> diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
> index 0473f55..39b987d 100644
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -23,6 +23,7 @@
>  #include <linux/cdev.h>
>  #include <linux/slab.h>
>  #include "iio.h"
> +#include "iio-core.h"
>  #include "trigger_consumer.h"
>  
>  #define IIO_ID_PREFIX "device"
> @@ -35,6 +36,33 @@ static DEFINE_IDA(iio_chrdev_ida);
>  /* Lock used to protect both of the above */
>  static DEFINE_SPINLOCK(iio_ida_lock);
>  
> +static DEFINE_MUTEX(iio_irq_pool_lock);
> +static unsigned long iio_irq_pool_mask[BITS_TO_LONGS(IIO_MAX_POOL)] = {};
> +
> +int iio_irq_pool_get_range(int num)
> +{
> +	int ret;
> +
> +	mutex_lock(&iio_irq_pool_lock);
> +	ret = bitmap_find_free_region(iio_irq_pool_mask,
> +				      __iio_irqnum, ilog2(num));
> +	if (ret >= 0)
> +		ret += __iio_irqstart;
> +	mutex_unlock(&iio_irq_pool_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(iio_irq_pool_get_range);
> +
> +void iio_irq_pool_put_range(int start, int num)
> +{
> +	mutex_lock(&iio_irq_pool_lock);
> +	bitmap_release_region(iio_irq_pool_mask,
> +			      start - __iio_irqstart, ilog2(num));
> +	mutex_unlock(&iio_irq_pool_lock);
> +}
> +EXPORT_SYMBOL(iio_irq_pool_put_range);
> +
>  dev_t iio_devt;
>  EXPORT_SYMBOL(iio_devt);
>  
> diff --git a/drivers/staging/iio/industrialio-trigger.c b/drivers/staging/iio/industrialio-trigger.c
> index 083847c..8100822 100644
> --- a/drivers/staging/iio/industrialio-trigger.c
> +++ b/drivers/staging/iio/industrialio-trigger.c
> @@ -163,6 +163,7 @@ static struct iio_trigger *iio_trigger_find_by_name(const char *name,
>  
>  void iio_trigger_poll(struct iio_trigger *trig, s64 time)
>  {
> +	int i;
>  	struct iio_poll_func *pf_cursor;
>  
>  	list_for_each_entry(pf_cursor, &trig->pollfunc_list, list) {
> @@ -178,6 +179,11 @@ void iio_trigger_poll(struct iio_trigger *trig, s64 time)
>  			trig->use_count++;
>  		}
>  	}
> +	for (i = 0; i < CONFIG_IIO_CONSUMERS_PER_TRIGGER; i++)
> +		if (trig->subirqs[i].enabled) {
> +			trig->use_count++;
> +			generic_handle_irq(trig->subirq_base + i);
> +		}
>  }
>  EXPORT_SYMBOL(iio_trigger_poll);
>  
> @@ -219,16 +225,23 @@ int iio_trigger_attach_poll_func(struct iio_trigger *trig,
>  	int ret = 0;
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&trig->pollfunc_list_lock, flags);
> -	list_add_tail(&pf->list, &trig->pollfunc_list);
> -	spin_unlock_irqrestore(&trig->pollfunc_list_lock, flags);
> -
> +	if (pf->handler) {
> +		pf->irq = iio_trigger_get_irq(trig);
> +		ret = request_threaded_irq(pf->irq, NULL, pf->handler,
> +					   pf->type, pf->name,
> +					   pf);
> +	} else {
> +		spin_lock_irqsave(&trig->pollfunc_list_lock, flags);
> +		list_add_tail(&pf->list, &trig->pollfunc_list);
> +		spin_unlock_irqrestore(&trig->pollfunc_list_lock, flags);
> +	}
>  	if (trig->set_trigger_state)
>  		ret = trig->set_trigger_state(trig, true);
>  	if (ret) {
>  		printk(KERN_ERR "set trigger state failed\n");
>  		list_del(&pf->list);
>  	}
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(iio_trigger_attach_poll_func);
> @@ -240,31 +253,42 @@ int iio_trigger_dettach_poll_func(struct iio_trigger *trig,
>  	unsigned long flags;
>  	int ret = -EINVAL;
>  
> -	spin_lock_irqsave(&trig->pollfunc_list_lock, flags);
> -	list_for_each_entry(pf_cursor, &trig->pollfunc_list, list)
> -		if (pf_cursor == pf) {
> -			ret = 0;
> -			break;
> +	if (pf->handler) {
> +		ret = trig->set_trigger_state(trig, false);
> +		if (ret)
> +			goto error_ret;
> +		iio_trigger_put_irq(trig, pf->irq);
> +		free_irq(pf->irq, pf);
> +	} else {
> +		spin_lock_irqsave(&trig->pollfunc_list_lock, flags);
> +		list_for_each_entry(pf_cursor, &trig->pollfunc_list, list)
> +			if (pf_cursor == pf) {
> +				ret = 0;
> +				break;
> +			}
> +		if (!ret) {
> +			if (list_is_singular(&trig->pollfunc_list)
> +			    && trig->set_trigger_state) {
> +				spin_unlock_irqrestore(&trig
> +						       ->pollfunc_list_lock,
> +						       flags);
> +				/* May sleep hence cannot hold the spin lock */
> +				ret = trig->set_trigger_state(trig, false);
> +				if (ret)
> +					goto error_ret;
> +				spin_lock_irqsave(&trig->pollfunc_list_lock,
> +						  flags);
> +			}
> +			/*
> +			 * Now we can delete safe in the knowledge that, if
> +			 * this is the last pollfunc then we have disabled
> +			 * the trigger anyway and so nothing should be able
> +			 * to call the pollfunc.
> +			 */
> +			list_del(&pf_cursor->list);
>  		}
> -	if (!ret) {
> -		if (list_is_singular(&trig->pollfunc_list)
> -		    && trig->set_trigger_state) {
> -			spin_unlock_irqrestore(&trig->pollfunc_list_lock,
> -					       flags);
> -			/* May sleep hence cannot hold the spin lock */
> -			ret = trig->set_trigger_state(trig, false);
> -			if (ret)
> -				goto error_ret;
> -			spin_lock_irqsave(&trig->pollfunc_list_lock, flags);
> -		}
> -		/*
> -		 * Now we can delete safe in the knowledge that, if this is
> -		 * the last pollfunc then we have disabled the trigger anyway
> -		 * and so nothing should be able to call the pollfunc.
> -		 */
> -		list_del(&pf_cursor->list);
> +		spin_unlock_irqrestore(&trig->pollfunc_list_lock, flags);
>  	}
> -	spin_unlock_irqrestore(&trig->pollfunc_list_lock, flags);
>  
>  error_ret:
>  	return ret;
> @@ -337,6 +361,21 @@ static const struct attribute_group iio_trigger_consumer_attr_group = {
>  static void iio_trig_release(struct device *device)
>  {
>  	struct iio_trigger *trig = to_iio_trigger(device);
> +	int i;
> +
> +	if (trig->subirq_base) {
> +		for (i = 0; i < CONFIG_IIO_CONSUMERS_PER_TRIGGER; i++) {
> +			set_irq_flags(trig->subirq_base + i, 0);
> +			irq_set_chip(trig->subirq_base + i,
> +				     NULL);
> +			irq_set_handler(trig->subirq_base + i,
> +					NULL);
> +		}
> +
> +		kfree(trig->subirq_chip.name);
> +		iio_irq_pool_put_range(trig->subirq_base,
> +				       CONFIG_IIO_CONSUMERS_PER_TRIGGER);
> +	}
>  	kfree(trig);
>  	iio_put();
>  }
> @@ -345,11 +384,30 @@ static struct device_type iio_trig_type = {
>  	.release = iio_trig_release,
>  };
>  
> -struct iio_trigger *iio_allocate_trigger(void)
> +static void iio_trig_subirqmask(struct irq_data *d)
> +{
> +	struct irq_chip *chip = irq_data_get_irq_chip(d);
> +	struct iio_trigger *trig
> +		= container_of(chip,
> +			       struct iio_trigger, subirq_chip);
> +	trig->subirqs[d->irq - trig->subirq_base].enabled = false;
> +}
> +
> +static void iio_trig_subirqunmask(struct irq_data *d)
> +{
> +	struct irq_chip *chip = irq_data_get_irq_chip(d);
> +	struct iio_trigger *trig
> +		= container_of(chip,
> +			       struct iio_trigger, subirq_chip);
> +	trig->subirqs[d->irq - trig->subirq_base].enabled = true;
> +}
> +
> +struct iio_trigger *iio_allocate_trigger_named(const char *name)
>  {
>  	struct iio_trigger *trig;
>  	trig = kzalloc(sizeof *trig, GFP_KERNEL);
>  	if (trig) {
> +		int i;
>  		trig->dev.type = &iio_trig_type;
>  		trig->dev.bus = &iio_bus_type;
>  		device_initialize(&trig->dev);
> @@ -357,10 +415,42 @@ struct iio_trigger *iio_allocate_trigger(void)
>  		spin_lock_init(&trig->pollfunc_list_lock);
>  		INIT_LIST_HEAD(&trig->list);
>  		INIT_LIST_HEAD(&trig->pollfunc_list);
> +
> +		if (name) {
> +			mutex_init(&trig->pool_lock);
> +			trig->subirq_base
> +				= iio_irq_pool_get_range(
> +					CONFIG_IIO_CONSUMERS_PER_TRIGGER);
> +			if (trig->subirq_base < 0) {
> +				kfree(trig);
> +				return NULL;
> +			}
> +			trig->subirq_chip.name = kstrdup(name, GFP_KERNEL);
> +			if (trig->subirq_chip.name == NULL) {
> +				kfree(trig);
> +				return NULL;
> +			}
> +			trig->subirq_chip.irq_mask = &iio_trig_subirqmask;
> +			trig->subirq_chip.irq_unmask = &iio_trig_subirqunmask;
> +			for (i = 0; i < CONFIG_IIO_CONSUMERS_PER_TRIGGER; i++) {
> +				irq_set_chip(trig->subirq_base + i,
> +					     &trig->subirq_chip);
> +				irq_set_handler(trig->subirq_base + i,
> +						&handle_simple_irq);
> +				set_irq_flags(trig->subirq_base + i,
> +					      IRQF_VALID);
> +			}
> +		}
>  		iio_get();
>  	}
>  	return trig;
>  }
> +EXPORT_SYMBOL(iio_allocate_trigger_named);
> +
> +struct iio_trigger *iio_allocate_trigger(void)
> +{
> +	return iio_allocate_trigger_named(NULL);
> +}
>  EXPORT_SYMBOL(iio_allocate_trigger);
>  
>  void iio_free_trigger(struct iio_trigger *trig)
> diff --git a/drivers/staging/iio/trigger.h b/drivers/staging/iio/trigger.h
> index c6ab32f..2e52004 100644
> --- a/drivers/staging/iio/trigger.h
> +++ b/drivers/staging/iio/trigger.h
> @@ -6,9 +6,15 @@
>   * under the terms of the GNU General Public License version 2 as published by
>   * the Free Software Foundation.
>   */
> +#include <linux/irq.h>
> +
>  #ifndef _IIO_TRIGGER_H_
>  #define _IIO_TRIGGER_H_
>  
> +struct iio_subirq {
> +	bool enabled;
> +};
> +
>  /**
>   * struct iio_trigger - industrial I/O trigger device
>   *
> @@ -43,6 +49,13 @@ struct iio_trigger {
>  
>  	int (*set_trigger_state)(struct iio_trigger *trig, bool state);
>  	int (*try_reenable)(struct iio_trigger *trig);
> +
> +	struct irq_chip			subirq_chip;
> +	int				subirq_base;
> +
> +	struct iio_subirq subirqs[CONFIG_IIO_CONSUMERS_PER_TRIGGER];
> +	unsigned long pool[BITS_TO_LONGS(CONFIG_IIO_CONSUMERS_PER_TRIGGER)];
> +	struct mutex			pool_lock;
>  };
>  
>  static inline struct iio_trigger *to_iio_trigger(struct device *d)
> @@ -114,6 +127,27 @@ int iio_trigger_dettach_poll_func(struct iio_trigger *trig,
>  void iio_trigger_poll(struct iio_trigger *trig, s64 time);
>  void iio_trigger_notify_done(struct iio_trigger *trig);
>  
> +static inline int iio_trigger_get_irq(struct iio_trigger *trig)
> +{
> +	int ret;
> +	mutex_lock(&trig->pool_lock);
> +	ret = bitmap_find_free_region(trig->pool,
> +				      CONFIG_IIO_CONSUMERS_PER_TRIGGER,
> +				      ilog2(1));
> +	mutex_unlock(&trig->pool_lock);
> +	if (ret >= 0)
> +		ret += trig->subirq_base;
> +
> +	return ret;
> +};
> +
> +static inline void iio_trigger_put_irq(struct iio_trigger *trig, int irq)
> +{
> +	mutex_lock(&trig->pool_lock);
> +	clear_bit(irq - trig->subirq_base, trig->pool);
> +	mutex_unlock(&trig->pool_lock);
> +};
> +
>  /**
>   * struct iio_poll_func - poll function pair
>   *
> @@ -137,6 +171,10 @@ struct iio_poll_func {
>  	void (*poll_func_immediate)(struct iio_dev *indio_dev);
>  	void (*poll_func_main)(struct iio_dev *private_data, s64 time);
>  
> +	irqreturn_t (*handler)(int irq, void *p);
> +	int type;
> +	char *name;
> +	int irq;
>  };
>  
>  int iio_alloc_pollfunc(struct iio_dev *indio_dev,
> @@ -151,7 +189,7 @@ int iio_triggered_ring_postenable(struct iio_dev *indio_dev);
>  int iio_triggered_ring_predisable(struct iio_dev *indio_dev);
>  
>  struct iio_trigger *iio_allocate_trigger(void);
> -
> +struct iio_trigger *iio_allocate_trigger_named(const char *name);
>  void iio_free_trigger(struct iio_trigger *trig);
>  
>  #endif /* _IIO_TRIGGER_H_ */

