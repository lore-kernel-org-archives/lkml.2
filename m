Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab1ENW4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 18:56:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52055 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab1ENW4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 18:56:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH] PM / Hibernate: Add sysfs knob to control size of memory for drivers
Date: Sun, 15 May 2011 00:56:55 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Martin Steigerwald <Martin@lichtvoll.de>
References: <201105100059.25372.rjw@sisk.pl>
In-Reply-To: <201105100059.25372.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105150056.55601.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, May 10, 2011, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Martin reports that on his system hibernation occasionally fails due
> to the lack of memory, because the radeon driver apparently allocates
> too much of it during the device freeze stage.  It turns out that the
> amount of memory allocated by radeon during hibernation (and
> presumably during system suspend too) depends on the utilization of
> the GPU (e.g. hibernating while there are two KDE 4 sessions with
> compositing enabled causes radeon to allocate more memory than for
> one KDE 4 session).
> 
> In principle it should be possible to use image_size to make the
> memory preallocation mechanism free enough memory for the radeon
> driver, but in practice it is not easy to guess the right value
> because of the way the preallocation code uses image_size.  For this
> reason, it seems reasonable to allow users to control the amount of
> memory reserved for driver allocations made after the preallocation,
> which currently is constant and amounts to 1 MB.
> 
> Introduce a new sysfs file, /sys/power/reserved_size, whose value
> will be used as the amount of memory to reserve for the
> post-preallocation reservations made by device drivers, in bytes.
> For backwards compatibility, set its default (and initial) value to
> the currently used number (1 MB).
> 
> References: https://bugzilla.kernel.org/show_bug.cgi?id=34102
> Reported-by: Martin Steigerwald <Martin@Lichtvoll.de>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

OK, there are no comments, so my understanding is that everyone is fine
with this patch and I can add it to my linux-next branch.

Thanks,
Rafael


> ---
>  Documentation/ABI/testing/sysfs-power |   14 ++++++++++++++
>  kernel/power/hibernate.c              |   23 +++++++++++++++++++++++
>  kernel/power/main.c                   |    1 +
>  kernel/power/power.h                  |    4 ++++
>  kernel/power/snapshot.c               |   25 ++++++++++++++++++++-----
>  5 files changed, 62 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/kernel/power/hibernate.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/hibernate.c
> +++ linux-2.6/kernel/power/hibernate.c
> @@ -968,10 +968,33 @@ static ssize_t image_size_store(struct k
>  
>  power_attr(image_size);
>  
> +static ssize_t reserved_size_show(struct kobject *kobj,
> +				  struct kobj_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "%lu\n", reserved_size);
> +}
> +
> +static ssize_t reserved_size_store(struct kobject *kobj,
> +				   struct kobj_attribute *attr,
> +				   const char *buf, size_t n)
> +{
> +	unsigned long size;
> +
> +	if (sscanf(buf, "%lu", &size) == 1) {
> +		reserved_size = size;
> +		return n;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +power_attr(reserved_size);
> +
>  static struct attribute * g[] = {
>  	&disk_attr.attr,
>  	&resume_attr.attr,
>  	&image_size_attr.attr,
> +	&reserved_size_attr.attr,
>  	NULL,
>  };
>  
> Index: linux-2.6/kernel/power/power.h
> ===================================================================
> --- linux-2.6.orig/kernel/power/power.h
> +++ linux-2.6/kernel/power/power.h
> @@ -15,6 +15,7 @@ struct swsusp_info {
>  
>  #ifdef CONFIG_HIBERNATION
>  /* kernel/power/snapshot.c */
> +extern void __init hibernate_reserved_size_init(void);
>  extern void __init hibernate_image_size_init(void);
>  
>  #ifdef CONFIG_ARCH_HIBERNATION_HEADER
> @@ -55,6 +56,7 @@ extern int hibernation_platform_enter(vo
>  
>  #else /* !CONFIG_HIBERNATION */
>  
> +static inline void hibernate_reserved_size_init(void) {}
>  static inline void hibernate_image_size_init(void) {}
>  #endif /* !CONFIG_HIBERNATION */
>  
> @@ -72,6 +74,8 @@ static struct kobj_attribute _name##_att
>  
>  /* Preferred image size in bytes (default 500 MB) */
>  extern unsigned long image_size;
> +/* Size of memory reserved for drivers (default SPARE_PAGES x PAGE_SIZE) */
> +extern unsigned long reserved_size;
>  extern int in_suspend;
>  extern dev_t swsusp_resume_device;
>  extern sector_t swsusp_resume_block;
> Index: linux-2.6/kernel/power/snapshot.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/snapshot.c
> +++ linux-2.6/kernel/power/snapshot.c
> @@ -41,6 +41,18 @@ static void swsusp_set_page_forbidden(st
>  static void swsusp_unset_page_forbidden(struct page *);
>  
>  /*
> + * Number of bytes to reserve for memory allocations made by device drivers
> + * from their ->freeze() and ->freeze_noirq() callbacks so that they don't
> + * cause image creation to fail (tunable via /sys/power/reserved_size).
> + */
> +unsigned long reserved_size;
> +
> +void __init hibernate_reserved_size_init(void)
> +{
> +	reserved_size = SPARE_PAGES * PAGE_SIZE;
> +}
> +
> +/*
>   * Preferred image size in bytes (tunable via /sys/power/image_size).
>   * When it is set to N, the image creating code will do its best to
>   * ensure the image size will not exceed N bytes, but if that is
> @@ -1263,11 +1275,13 @@ static unsigned long minimum_image_size(
>   * frame in use.  We also need a number of page frames to be free during
>   * hibernation for allocations made while saving the image and for device
>   * drivers, in case they need to allocate memory from their hibernation
> - * callbacks (these two numbers are given by PAGES_FOR_IO and SPARE_PAGES,
> - * respectively, both of which are rough estimates).  To make this happen, we
> - * compute the total number of available page frames and allocate at least
> + * callbacks (these two numbers are given by PAGES_FOR_IO (which is a rough
> + * estimate) and reserverd_size divided by PAGE_SIZE (which is tunable through
> + * /sys/power/reserved_size, respectively).  To make this happen, we compute the
> + * total number of available page frames and allocate at least
>   *
> - * ([page frames total] + PAGES_FOR_IO + [metadata pages]) / 2 + 2 * SPARE_PAGES
> + * ([page frames total] + PAGES_FOR_IO + [metadata pages]) / 2
> + *  + 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
>   *
>   * of them, which corresponds to the maximum size of a hibernation image.
>   *
> @@ -1322,7 +1336,8 @@ int hibernate_preallocate_memory(void)
>  	count -= totalreserve_pages;
>  
>  	/* Compute the maximum number of saveable pages to leave in memory. */
> -	max_size = (count - (size + PAGES_FOR_IO)) / 2 - 2 * SPARE_PAGES;
> +	max_size = (count - (size + PAGES_FOR_IO)) / 2
> +			- 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE);
>  	/* Compute the desired number of image pages specified by image_size. */
>  	size = DIV_ROUND_UP(image_size, PAGE_SIZE);
>  	if (size > max_size)
> Index: linux-2.6/kernel/power/main.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/main.c
> +++ linux-2.6/kernel/power/main.c
> @@ -337,6 +337,7 @@ static int __init pm_init(void)
>  	if (error)
>  		return error;
>  	hibernate_image_size_init();
> +	hibernate_reserved_size_init();
>  	power_kobj = kobject_create_and_add("power", NULL);
>  	if (!power_kobj)
>  		return -ENOMEM;
> Index: linux-2.6/Documentation/ABI/testing/sysfs-power
> ===================================================================
> --- linux-2.6.orig/Documentation/ABI/testing/sysfs-power
> +++ linux-2.6/Documentation/ABI/testing/sysfs-power
> @@ -158,3 +158,17 @@ Description:
>  		successful, will make the kernel abort a subsequent transition
>  		to a sleep state if any wakeup events are reported after the
>  		write has returned.
> +
> +What:		/sys/power/reserved_size
> +Date:		May 2011
> +Contact:	Rafael J. Wysocki <rjw@sisk.pl>
> +Description:
> +		The /sys/power/reserved_size file allows user space to control
> +		the amount of memory reserved for allocations made by device
> +		drivers during the "device freeze" stage of hibernation.  It can
> +		be written a string representing a non-negative integer that
> +		will be used as the amount of memory to reserve for allocations
> +		made by device drivers' "freeze" callbacks, in bytes.
> +
> +		Reading from this file will display the current value, which is
> +		set to 1 MB by default.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

