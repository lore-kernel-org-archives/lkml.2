Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab2AIBFj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 20:05:39 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38740 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab2AIBFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 20:05:38 -0500
Message-ID: <4F0A3D58.6050400@gmail.com>
Date: Mon, 09 Jan 2012 12:05:28 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] Multithread initcalls to auto-resolve ordering issues.
References: <20120109112113.07882ed9@notabene.brown>
In-Reply-To: <20120109112113.07882ed9@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/12 11:21, NeilBrown wrote:

> 
> [ To: list stolen from "introduce External Connector Class (extcon)" thread
>   where this topic was briefly mentioned. ]
> 
> Hi,
>  I welcome review/feedback on the following idea and code.


Hi Neil,

Interesting idea, some comments below.

~Ryan

> 
> The problem:
> 
>   Many devices - particular platform devices - have dependencies on other
>   devices.  That is - they use a resource that another device provides.
>   This includes (but it not limited to):
>     GPIOs
>     IRQs
>     Regulators
>     PWMs
> 
>   The identity of the resource is usually passed to the dependent device via
>   the platform_data.  If the resource is not available, the device probe will
>   either fail or will continue without the resource - neither of which are
>   satisfactory.
> 
> Current approaches:
> 
>   I am aware of two current approaches to ensuring that all dependencies are
>   available when a device is probed:
> 
>   1/ hand-tuning of the order of init calls, whether by reordering entries in
>      a Makefile or by using early_initcall or late_initcall.
> 
>      This approach is not very transparent, and assumes that a single ordering
>      of driver-initialisation can address all dependencies orderings.
> 
>   2/ The use of 'setup' function such as e.g. drivers/gpio/gpio-pca953x.c
>      provides which can be used to add a device *after* the gpios are
>      available.
> 
>      This approach requires code in the 'board' file and so is not really
>      compatible with the move to 'device tree'.
>      Also - many drives to not provide a setup callback.
> 
> Proposed solution:
> 
>   The solution I am proposing is to:
>    1/ allow the 'request' functions which find and provide a resource to block
>       until the resource is available
>    2/ run the init calls in multiple threads so that when one blocks waiting
>       for a resource, another starts up to run subsequent initcalls until
>       the blocking call gets its resource and can complete.

What happens if the resource isn't actually present (driver/hardware
missing or resource probe fails for example)? Does the initcall thread
get stuck forever, or is there a timeout?

> Details and issues.
> 
>   1/ Sometimes it is appropriate to fail rather than to block, and a resource
>      providers need to know which.
>      This is unlikely to be an issue with GPIO and IRQ as is the identifying
>      number is >= 0, then the resource must be expected at some stage.
>      However for regulators a name is not given to the driver but rather the
>      driver asks if a supply is available with a given name for the device.
>      If not, it makes do without.
>      So for regulators (and probably other resources) we need to know what
>      resources to expect so we know if a resource will never appear.
> 
>      In this sample code I have added a call 
>           regulator_has_full_constraints_listed()
>      which not only assures that all constraints are known, but list
>      them (array of pointers to regulator_init_data) so when a supply is
>      requested the regulator code can see if it expected.
> 
>   2/ We probably don't want lots of threads running at once as there is
>      no good way to decide how many (maybe num_cpus??).
>      This patch takes the approach that only one thread should be runnable
>      at once in most cases.


num_cpus won't work for UP systems. In practice the number of threads
needed is probably low, since most devices probably only have a short
dependency chain.

> 
>      We keep a count of the number of threads started and the number of
>      threads that are blocked, and only start a new thread when all threads
>      are blocked, and only start a new initcall when all other threads are
>      blocked.
> 
>      So when one initcall makes a resource available, another thread which
>      was waiting could wake up and both will run concurrently.  However no
>      more initcalls will start until all threads have completed or blocked.


With this approach having an unbounded number of threads should be okay
right? The number of threads shouldn't exceed the length of a dependency
chain.

> 
>   3/ The parent locking that __driver_attach() does which is "Needed for USB"
>      was a little problem - I changed it to alert the initcall thread
>      management so it knew that thread was blocking.  I think this wouldn't be
>      a problem is the parent lock was *only* taken for USB...
> 
>   4/ It is possible that some existing code registers a resource before it is
>      really ready to be used.  Currently that isn't a problem as no-one will
>      actually try to use it until the initcall has completed.  However with
>      this patch the device that wants to use a resource can do so the moment
>      it is registered.


Such code would be buggy and need fixing correct? This patch could
possibly help identify such buggy code?

>      This should probably be fixed by re-arranging the problematic code.
>      However we could use a mutex (a bit like the old BKL) to ensure that only
>      one initcall runs at a time, and any blocking initcall must wait for
>      others to complete before it is allowed to run.  I don't really like
>      this approach and so haven't implemented it.
> 
>   5/ This patch ensure that currently working code should keep working.  It
>      only blocks if an expected resource  isn't available yet, and anything
>      that currently works must be getting things in the right order.
>      Also, it only starts a second thread if something blocks and as nothing
>      will block, it will run everything in one thread just as current code
>      does.
> 
>   6/ There is some ugliness in this code due to duplication.  I think it could
>      be made a lot cleaner if every resource had a simple textual name.  Then
>      then the code for managing lists of expected resource and who is waiting
>      for them could all be common.
> 
>   7/ Ultimately I suspect (or hope) that the "device tree" could be used to
>      provide lists of all expected resources.
> 
>   8/ This sample code only provides blocking for GPIO and REGULATOR resources
>      as that is all I needed - so that is all I could test.
> 
> 
> I've been using this on my GTA04 which has an interesting dependencies where
> the WIFI - plugged into an MMC channels which is normally initialised quite
> early - depends on a regulator (which is initialised fairly early) and a GPIO
> on an I2C device (which is initialised quite late), and a virtual regulator
> which depends on the GPIO (for the 'enable' line) and the regulator (as the
> power source).
> 
> So it certainly solved my problem.
> 
> Thanks for your time.
> 
> NeilBrown
> 
> From 752e8a82aa4cee7040f5d6ad86de54ba3ec048af Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Wed, 21 Dec 2011 10:15:51 +1100
> Subject: [PATCH] Multi-threading initcall
> 
> Allow initcall functions to block waiting for resources, and for
> other initcall functions to then be run in separate threads.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 142e3d600..06963e4 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -288,7 +288,7 @@ static int __driver_attach(struct device *dev, void *data)
>  		return 0;
>  
>  	if (dev->parent)	/* Needed for USB */
> -		device_lock(dev->parent);
> +		initcall_lock(&dev->parent->mutex);
>  	device_lock(dev);
>  	if (!dev->driver)
>  		driver_probe_device(drv, dev);
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index a971e3d..7d283af 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -11,6 +11,7 @@
>  #include <linux/of_gpio.h>
>  #include <linux/idr.h>
>  #include <linux/slab.h>
> +#include <linux/sched.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/gpio.h>
> @@ -58,6 +59,7 @@ struct gpio_desc {
>  #define FLAG_TRIG_FALL	5	/* trigger on falling edge */
>  #define FLAG_TRIG_RISE	6	/* trigger on rising edge */
>  #define FLAG_ACTIVE_LOW	7	/* sysfs value has active low */
> +#define FLAG_WAITING	8	/* Some initcall is waiting for this gpio */
>  
>  #define ID_SHIFT	16	/* add new flags before this one */
>  
> @@ -70,6 +72,13 @@ struct gpio_desc {
>  };
>  static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
>  
> +struct gpio_waiter {
> +	struct list_head list;
> +	int gpio;
> +	wait_queue_head_t queue;
> +};
> +static LIST_HEAD(waiters);
> +
>  #ifdef CONFIG_GPIO_SYSFS
>  static DEFINE_IDR(dirent_idr);
>  #endif
> @@ -1065,6 +1074,13 @@ int gpiochip_add(struct gpio_chip *chip)
>  		for (id = base; id < base + chip->ngpio; id++) {
>  			gpio_desc[id].chip = chip;
>  
> +			if (test_bit(FLAG_WAITING, &gpio_desc[id].flags)) {
> +				struct gpio_waiter *w;
> +				list_for_each_entry(w, &waiters, list)
> +					if (w->gpio == id)
> +						wake_up(&w->queue);
> +			}
> +
>  			/* REVISIT:  most hardware initializes GPIOs as
>  			 * inputs (often with pullups enabled) so power
>  			 * usage is minimized.  Linux code should set the
> @@ -1179,15 +1195,41 @@ int gpio_request(unsigned gpio, const char *label)
>  	struct gpio_chip	*chip;
>  	int			status = -EINVAL;
>  	unsigned long		flags;
> +	int			can_wait = !in_atomic();


I don't think you can reliably do this. Callers should always track
whether they can sleep or not. See: http://lwn.net/Articles/274695/

>  
>  	spin_lock_irqsave(&gpio_lock, flags);
>  
>  	if (!gpio_is_valid(gpio))
>  		goto done;
>  	desc = &gpio_desc[gpio];
> +	if (desc->chip == NULL) {
> +		/* possibly need to wait for the chip to appear */
> +		struct gpio_waiter w;
> +		int status2 = 0;
> +		DEFINE_WAIT(wait);
> +		if (test_and_set_bit(FLAG_WAITING, &desc->flags))
> +			/* Only one waiter allowed */
> +			goto done;
> +		if (!can_wait)
> +			goto done;
> +
> +		init_waitqueue_head(&w.queue);
> +		w.gpio = gpio;
> +		list_add(&w.list, &waiters);
> +		prepare_to_wait(&w.queue, &wait, TASK_UNINTERRUPTIBLE);
> +
> +		while (desc->chip == NULL && status2 == 0) {
> +			spin_unlock_irqrestore(&gpio_lock, flags);
> +			status2 = initcall_schedule();
> +			spin_lock_irqsave(&gpio_lock, flags);
> +			prepare_to_wait(&w.queue, &wait, TASK_UNINTERRUPTIBLE);
> +		}
> +		finish_wait(&w.queue, &wait);
> +		list_del(&w.list);
> +		if (desc->chip == NULL)
> +			goto done;
> +	}
>  	chip = desc->chip;
> -	if (chip == NULL)
> -		goto done;
>  
>  	if (!try_module_get(chip->owner))
>  		goto done;
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 938398f..0ec34f7 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -68,6 +68,15 @@ struct regulator_map {
>  	struct regulator_dev *regulator;
>  };
>  
> +struct regulator_waiter {
> +	struct list_head list;
> +	const char *dev_name;
> +	const char *supply;
> +	const char *reg;
> +	wait_queue_head_t queue;
> +};
> +static LIST_HEAD(waiters);
> +
>  /*
>   * struct regulator
>   *
> @@ -961,6 +970,31 @@ static int set_supply(struct regulator_dev *rdev,
>  	return 0;
>  }
>  
> +static void regulator_wake_waiters(const char *devname, const char *id,
> +	const char *reg)
> +{
> +	struct regulator_waiter *map;
> +
> +	list_for_each_entry(map, &waiters, list) {
> +		if (map->reg) {
> +			if (!reg)
> +				continue;
> +			if (strcmp(map->reg, reg) == 0)
> +				wake_up(&map->queue);
> +			continue;
> +		}
> +		if (reg)
> +			continue;
> +		/* If the mapping has a device set up it must match */
> +		if (map->dev_name &&
> +		    (!devname || strcmp(map->dev_name, devname)))
> +			continue;
> +
> +		if (strcmp(map->supply, id) == 0)
> +			wake_up(&map->queue);
> +	}
> +}
> +
>  /**
>   * set_consumer_device_supply - Bind a regulator to a symbolic supply
>   * @rdev:         regulator source
> @@ -1031,6 +1065,7 @@ static int set_consumer_device_supply(struct regulator_dev *rdev,
>  	}
>  
>  	list_add(&node->list, &regulator_map_list);
> +	regulator_wake_waiters(node->dev_name, node->supply, NULL);
>  	return 0;
>  }
>  
> @@ -1148,12 +1183,29 @@ static int _regulator_get_enable_time(struct regulator_dev *rdev)
>  	return rdev->desc->ops->enable_time(rdev);
>  }
>  
> +static struct regulator_dev *regulator_find(const char *devname, const char *id)
> +{
> +	struct regulator_map *map;
> +
> +	list_for_each_entry(map, &regulator_map_list, list) {
> +		/* If the mapping has a device set up it must match */
> +		if (map->dev_name &&
> +		    (!devname || strcmp(map->dev_name, devname)))
> +			continue;
> +
> +		if (strcmp(map->supply, id) == 0)
> +			return map->regulator;
> +	}
> +	return NULL;
> +}
> +
> +static int regulator_expected(const char *reg);
> +static int regulator_supply_expected(const char *devname, const char *id);
>  /* Internal regulator request function */
>  static struct regulator *_regulator_get(struct device *dev, const char *id,
>  					int exclusive)
>  {
>  	struct regulator_dev *rdev;
> -	struct regulator_map *map;
>  	struct regulator *regulator = ERR_PTR(-ENODEV);
>  	const char *devname = NULL;
>  	int ret;
> @@ -1168,17 +1220,9 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
>  
>  	mutex_lock(&regulator_list_mutex);
>  
> -	list_for_each_entry(map, &regulator_map_list, list) {
> -		/* If the mapping has a device set up it must match */
> -		if (map->dev_name &&
> -		    (!devname || strcmp(map->dev_name, devname)))
> -			continue;
> -
> -		if (strcmp(map->supply, id) == 0) {
> -			rdev = map->regulator;
> -			goto found;
> -		}
> -	}
> +	rdev = regulator_find(devname, id);
> +	if (rdev)
> +		goto found;
>  
>  	if (board_wants_dummy_regulator) {
>  		rdev = dummy_regulator_rdev;
> @@ -1200,6 +1244,30 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
>  	}
>  #endif
>  
> +	if (regulator_supply_expected(devname, id)) {
> +		/* wait for it to appear */
> +		struct regulator_waiter w;
> +		int status = 0;
> +		DEFINE_WAIT(wait);
> +		init_waitqueue_head(&w.queue);
> +		w.dev_name = devname;
> +		w.supply = id;
> +		w.reg = NULL;
> +		list_add(&w.list, &waiters);
> +		prepare_to_wait(&w.queue, &wait, TASK_UNINTERRUPTIBLE);
> +		while ((rdev = regulator_find(devname, id)) == NULL &&
> +		       status == 0) {
> +			mutex_unlock(&regulator_list_mutex);
> +			status = initcall_schedule();
> +			mutex_lock(&regulator_list_mutex);
> +			prepare_to_wait(&w.queue, &wait, TASK_UNINTERRUPTIBLE);
> +		}
> +		finish_wait(&w.queue, &wait);
> +		list_del(&w.list);
> +		if (rdev)
> +			goto found;
> +	}
> +
>  	mutex_unlock(&regulator_list_mutex);
>  	return regulator;
>  
> @@ -2728,7 +2796,33 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>  				break;
>  			}
>  		}
> -
> +		if (!found && regulator_expected(init_data->supply_regulator)) {
> +			struct regulator_waiter w;
> +			int status = 0;
> +			DEFINE_WAIT(wait);
> +			init_waitqueue_head(&w.queue);
> +			w.reg = init_data->supply_regulator;
> +			w.dev_name = w.supply = NULL;
> +			list_add(&w.list, &waiters);
> +			prepare_to_wait(&w.queue, &wait, TASK_UNINTERRUPTIBLE);
> +			while (status == 0) {
> +				list_for_each_entry(r, &regulator_list, list) {
> +					if (strcmp(rdev_get_name(r),
> +						   init_data->supply_regulator) == 0) {
> +						found = 1;
> +						break;
> +					}
> +				}
> +				if (found)
> +					break;
> +				mutex_unlock(&regulator_list_mutex);
> +				status = initcall_schedule();
> +				mutex_lock(&regulator_list_mutex);
> +				prepare_to_wait(&w.queue, &wait, TASK_UNINTERRUPTIBLE);
> +			}
> +			finish_wait(&w.queue, &wait);
> +			list_del(&w.list);
> +		}
>  		if (!found) {
>  			dev_err(dev, "Failed to find supply %s\n",
>  				init_data->supply_regulator);
> @@ -2755,6 +2849,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>  	}
>  
>  	list_add(&rdev->list, &regulator_list);
> +	regulator_wake_waiters(NULL, NULL, rdev_get_name(rdev));
>  
>  	rdev_init_debugfs(rdev);
>  out:
> @@ -2897,6 +2992,49 @@ void regulator_has_full_constraints(void)
>  }
>  EXPORT_SYMBOL_GPL(regulator_has_full_constraints);
>  
> +static struct regulator_init_data **init_data_list;
> +void regulator_has_full_constraints_listed(struct regulator_init_data **dlist)
> +{
> +	has_full_constraints = 1;
> +	init_data_list = dlist;
> +}
> +
> +static int regulator_supply_expected(const char *devname, const char *id)
> +{
> +	int i;
> +
> +	if (!init_data_list)
> +		return 0;
> +	for (i = 0; init_data_list[i]; i++) {
> +		struct regulator_init_data *d = init_data_list[i];
> +		struct regulator_consumer_supply *cs = d->consumer_supplies;
> +		int s;
> +		for (s = 0; s < d->num_consumer_supplies; s++) {
> +			if (cs[s].dev_name &&
> +			    (!devname || strcmp(cs[s].dev_name, devname)))
> +				continue;
> +			if (strcmp(cs[s].supply, id) == 0)
> +				return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int regulator_expected(const char *reg)
> +{
> +	int i;
> +
> +	if (!init_data_list)
> +		return 0;
> +	for (i = 0; init_data_list[i]; i++) {
> +		struct regulator_init_data *d = init_data_list[i];
> +		if (d->constraints.name &&
> +		    strcmp(d->constraints.name, reg) == 0)
> +			return 1;
> +	}
> +	return 0;
> +}
> +
>  /**
>   * regulator_use_dummy_regulator - Provide a dummy regulator when none is found
>   *
> diff --git a/include/linux/init.h b/include/linux/init.h
> index 9146f39..e898afe 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -158,6 +158,18 @@ extern void (*late_time_init)(void);
>  
>  extern int initcall_debug;
>  
> +
> +#ifdef MODULE
> +static inline int initcall_schedule(void)
> +{
> +	return -1;

> +}

> +#else
> +extern int initcall_schedule(void);
> +struct mutex;
> +extern void initcall_lock(struct mutex *);
> +#endif
> +
>  #endif
>    
>  #ifndef MODULE
> diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
> index f3f13fd..e78def2 100644
> --- a/include/linux/regulator/machine.h
> +++ b/include/linux/regulator/machine.h
> @@ -191,12 +191,16 @@ int regulator_suspend_finish(void);
>  
>  #ifdef CONFIG_REGULATOR
>  void regulator_has_full_constraints(void);
> +void regulator_has_full_constraints_listed(struct regulator_init_data **);
>  void regulator_use_dummy_regulator(void);
>  #else
>  static inline void regulator_has_full_constraints(void)
>  {
>  }
> -
> +static inline void regulator_has_full_constraints_listed(
> +	struct regulator_init_data *)
> +{
> +}
>  static inline void regulator_use_dummy_regulator(void)
>  {
>  }
> diff --git a/init/main.c b/init/main.c
> index 217ed23..6cb2239 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -710,12 +710,112 @@ int __init_or_module do_one_initcall(initcall_t fn)
>  
>  extern initcall_t __initcall_start[], __initcall_end[], __early_initcall_end[];
>  
> +
> +static struct initcall_state {
> +	initcall_t	*next_call;
> +	atomic_t	threads, waiting;
> +	wait_queue_head_t queue;
> +	int		master_thread;
> +} initcall;
> +
> +int initcall_schedule(void)
> +{
> +	/* Some probe function needs to wait for a pre-requisite
> +	 * initcall to provide some resource.    A wakeup has already
> +	 * been arranged for when it arrives.
> +	 */
> +	if (!initcall.master_thread)
> +		return -ENODEV;
> +
> +	atomic_inc(&initcall.waiting);
> +	/* Might need to start a new thread */
> +	wake_up(&initcall.queue);
> +
> +	schedule();
> +
> +	atomic_dec(&initcall.waiting);
> +	/* Might be time to progress to next initcall */
> +	wake_up(&initcall.queue);
> +
> +	return 0;
> +}
> +
> +void initcall_lock(struct mutex *mutex)
> +{
> +	if (!initcall.master_thread) {
> +		mutex_lock(mutex);
> +		return;
> +	}
> +	if (mutex_trylock(mutex))
> +		return;
> +
> +	atomic_inc(&initcall.waiting);
> +	/* Might need to start a new thread */
> +	wake_up(&initcall.queue);
> +
> +	mutex_lock(mutex);
> +
> +	atomic_dec(&initcall.waiting);
> +	/* Might be time to progress to next initcall */
> +	wake_up(&initcall.queue);
> +}
> +
> +static int init_caller(void *vtnum)
> +{
> +	unsigned long tnum = (unsigned long)vtnum;
> +
> +	/* Both next_call and master_thread can only be changed
> +	 * when all other threads are waiting, so there is no
> +	 * race here.
> +	 */
> +	while (initcall.next_call < __initcall_end
> +	       && initcall.master_thread == tnum) {
> +		initcall_t fn;
> +
> +		/* Don't want to proceed while other threads are
> +		 * running.
> +		 */
> +		wait_event(initcall.queue,
> +			   atomic_read(&initcall.threads)
> +			   == atomic_read(&initcall.waiting)+1);
> +
> +		fn = *initcall.next_call;
> +		initcall.next_call++;
> +
> +		do_one_initcall(fn);
> +	}
> +	atomic_dec(&initcall.threads);
> +	wake_up(&initcall.queue);
> +	return 0;
> +}
> +
>  static void __init do_initcalls(void)
>  {
> -	initcall_t *fn;
> +	DEFINE_WAIT(wait);
>  
> -	for (fn = __early_initcall_end; fn < __initcall_end; fn++)
> -		do_one_initcall(*fn);
> +	initcall.next_call = __early_initcall_end;
> +
> +	init_waitqueue_head(&initcall.queue);
> +
> +	while (1) {
> +		prepare_to_wait(&initcall.queue, &wait, TASK_UNINTERRUPTIBLE);
> +
> +		if (initcall.next_call == __initcall_end)
> +			break;
> +
> +		if (atomic_read(&initcall.threads)
> +		    == atomic_read(&initcall.waiting)) {
> +			/* All threads are waiting, create a new master */
> +			initcall.master_thread++;
> +			atomic_inc(&initcall.threads);
> +			kernel_thread(init_caller,
> +				      (void*)initcall.master_thread, 0);
> +		}
> +		schedule();
> +	}
> +	finish_wait(&initcall.queue, &wait);
> +	wait_event(initcall.queue, atomic_read(&initcall.threads) == 0);
> +	initcall.master_thread = 0;
>  }
>  
>  /*


