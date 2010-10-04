Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab0JDR5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:57:03 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:58073 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755879Ab0JDR5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:57:00 -0400
Date: Mon, 4 Oct 2010 19:56:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: [PATCH 2/2] PM / Hibernate: Make default image size depend on
 total RAM size
Message-ID: <20101004175650.GG1518@ucw.cz>
References: <201009150021.45101.rjw@sisk.pl>
 <201009150023.30635.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009150023.30635.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Hibernate: Make default image size depend on total RAM size
> 
> The default hibernation image size is currently hard coded and euqal
> to 500 MB, which is not a reasonable default on many contemporary
> systems.  Make it equal 2/5 of the total RAM size (this is slightly
> below the maximum, i.e. 1/2 of the total RAM size, and seems to be
> generally suitable).

I do not think I agree here.

Making limit say 1GB may be good idea, but by making it 2/5 of RAM you
essentialy make it useless -- 40% RAM is very similar to 50% RAM.

I have box with lot of memory and old distro -- it mostly uses RAM for
cache. Now you have made my suspend/resume 6 times slower... And when I
add more memory to the machine, it will slow down even further.

								Pavel




> ---
>  Documentation/power/interface.txt |    2 +-
>  kernel/power/main.c               |    1 +
>  kernel/power/power.h              |    9 ++++++++-
>  kernel/power/snapshot.c           |    7 ++++++-
>  4 files changed, 16 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/kernel/power/snapshot.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/snapshot.c
> +++ linux-2.6/kernel/power/snapshot.c
> @@ -46,7 +46,12 @@ static void swsusp_unset_page_forbidden(
>   * size will not exceed N bytes, but if that is impossible, it will
>   * try to create the smallest image possible.
>   */
> -unsigned long image_size = 500 * 1024 * 1024;
> +unsigned long image_size;
> +
> +void __init hibernate_image_size_init(void)
> +{
> +	image_size = ((totalram_pages * 2) / 5) * PAGE_SIZE;
> +}
>  
>  /* List of PBEs needed for restoring the pages that were allocated before
>   * the suspend and included in the suspend image, but have also been
> Index: linux-2.6/kernel/power/power.h
> ===================================================================
> --- linux-2.6.orig/kernel/power/power.h
> +++ linux-2.6/kernel/power/power.h
> @@ -14,6 +14,9 @@ struct swsusp_info {
>  } __attribute__((aligned(PAGE_SIZE)));
>  
>  #ifdef CONFIG_HIBERNATION
> +/* kernel/power/snapshot.c */
> +extern void __init hibernate_image_size_init(void);
> +
>  #ifdef CONFIG_ARCH_HIBERNATION_HEADER
>  /* Maximum size of architecture specific data in a hibernation header */
>  #define MAX_ARCH_HEADER_SIZE	(sizeof(struct new_utsname) + 4)
> @@ -49,7 +52,11 @@ static inline char *check_image_kernel(s
>  extern int hibernation_snapshot(int platform_mode);
>  extern int hibernation_restore(int platform_mode);
>  extern int hibernation_platform_enter(void);
> -#endif
> +
> +#else /* !CONFIG_HIBERNATION */
> +
> +static inline void hibernate_image_size_init(void) {}
> +#endif /* !CONFIG_HIBERNATION */
>  
>  extern int pfn_is_nosave(unsigned long);
>  
> Index: linux-2.6/kernel/power/main.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/main.c
> +++ linux-2.6/kernel/power/main.c
> @@ -321,6 +321,7 @@ static int __init pm_init(void)
>  	int error = pm_start_workqueue();
>  	if (error)
>  		return error;
> +	hibernate_image_size_init();
>  	power_kobj = kobject_create_and_add("power", NULL);
>  	if (!power_kobj)
>  		return -ENOMEM;
> Index: linux-2.6/Documentation/power/interface.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/power/interface.txt
> +++ linux-2.6/Documentation/power/interface.txt
> @@ -57,7 +57,7 @@ smallest image possible.  In particular,
>  suspend image will be as small as possible.
>  
>  Reading from this file will display the current image size limit, which
> -is set to 500 MB by default.
> +is set to 2/5 of available RAM by default.
>  
>  /sys/power/pm_trace controls the code which saves the last PM event point in
>  the RTC across reboots, so that you can debug a machine that just hangs
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
