Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab1C2Pxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:53:37 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:15944 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1C2Pxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 11:53:35 -0400
X-IronPort-AV: E=Sophos;i="4.63,263,1299456000"; 
   d="scan'208";a="5030883"
Subject: Re: [Xen-devel] [PATCH] PM / Hibernate: Introduce
 CONFIG_HIBERNATE_INTERFACE
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        Shriram Rajagopalan <rshriram@cs.ubc.ca>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <201103261229.44770.rjw@sisk.pl>
References: <201103261229.44770.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 29 Mar 2011 16:53:33 +0100
Message-ID: <1301414013.18413.29.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Sat, 2011-03-26 at 11:29 +0000, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Xen save/restore is going to use hibernate device callbacks for
> quiescing devices and putting them back to normal operations and it
> would need to select CONFIG_HIBERNATION for this purpose.  However,
> that also would cause the hibernate interfaces for user space to be
> enabled, which might confuse user space, because the Xen kernels
> don't support hibernation.  Moreover, it would be wasteful, as it
> would make the Xen kernels include a substantial amount of code that
> they would never use.
> 
> To address this issue introduce new power management Kconfig option
> CONFIG_HIBERNATE_INTERFACE, such that the hibernate interfaces for
> user space and the image-handling code will depend on it and it will
> select CONFIG_HIBERNATION.  Then, Xen save/restore will be able to
> select CONFIG_HIBERNATION without dragging the entire hibernate code
> along with it.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Were you planning to put this forward for 2.6.39 or are you waiting for
2.6.40?

> Tested-by: Shriram Rajagopalan <rshriram@cs.ubc.ca>

Shriram,

Is the additional Xen side patch still the same as in
<1299906483-31053-1-git-send-email-rshriram@cs.ubc.ca> ? Is there
anything else which isn't already in upstream?

Ian.

> ---
>  arch/x86/power/Makefile |    3 ++-
>  include/linux/suspend.h |   15 +++++----------
>  kernel/power/Kconfig    |    4 ++++
>  kernel/power/Makefile   |    4 ++--
>  kernel/power/main.c     |    2 +-
>  kernel/power/power.h    |    6 +++---
>  6 files changed, 17 insertions(+), 17 deletions(-)
> 
> Index: linux-2.6/kernel/power/Kconfig
> ===================================================================
> --- linux-2.6.orig/kernel/power/Kconfig
> +++ linux-2.6/kernel/power/Kconfig
> @@ -19,8 +19,12 @@ config SUSPEND_FREEZER
>  	  Turning OFF this setting is NOT recommended! If in doubt, say Y.
>  
>  config HIBERNATION
> +	bool
> +
> +config HIBERNATE_INTERFACE
>  	bool "Hibernation (aka 'suspend to disk')"
>  	depends on SWAP && ARCH_HIBERNATION_POSSIBLE
> +	select HIBERNATION
>  	select LZO_COMPRESS
>  	select LZO_DECOMPRESS
>  	---help---
> Index: linux-2.6/kernel/power/Makefile
> ===================================================================
> --- linux-2.6.orig/kernel/power/Makefile
> +++ linux-2.6/kernel/power/Makefile
> @@ -6,7 +6,7 @@ obj-$(CONFIG_PM_SLEEP)		+= console.o
>  obj-$(CONFIG_FREEZER)		+= process.o
>  obj-$(CONFIG_SUSPEND)		+= suspend.o
>  obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend_test.o
> -obj-$(CONFIG_HIBERNATION)	+= hibernate.o snapshot.o swap.o user.o \
> -				   block_io.o
> +obj-$(CONFIG_HIBERNATE_INTERFACE)	+= hibernate.o snapshot.o swap.o \
> +						user.o block_io.o
>  
>  obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
> Index: linux-2.6/include/linux/suspend.h
> ===================================================================
> --- linux-2.6.orig/include/linux/suspend.h
> +++ linux-2.6/include/linux/suspend.h
> @@ -229,7 +229,7 @@ struct platform_hibernation_ops {
>  	void (*recover)(void);
>  };
>  
> -#ifdef CONFIG_HIBERNATION
> +#ifdef CONFIG_HIBERNATE_INTERFACE
>  /* kernel/power/snapshot.c */
>  extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
>  static inline void __init register_nosave_region(unsigned long b, unsigned long e)
> @@ -248,7 +248,9 @@ extern unsigned long get_safe_page(gfp_t
>  extern void hibernation_set_ops(const struct platform_hibernation_ops *ops);
>  extern int hibernate(void);
>  extern bool system_entering_hibernation(void);
> -#else /* CONFIG_HIBERNATION */
> +#else /* !CONFIG_HIBERNATE_INTERFACE */
> +static inline void register_nosave_region(unsigned long b, unsigned long e) {}
> +static inline void register_nosave_region_late(unsigned long b, unsigned long e) {}
>  static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
>  static inline void swsusp_set_page_free(struct page *p) {}
>  static inline void swsusp_unset_page_free(struct page *p) {}
> @@ -256,7 +258,7 @@ static inline void swsusp_unset_page_fre
>  static inline void hibernation_set_ops(const struct platform_hibernation_ops *ops) {}
>  static inline int hibernate(void) { return -ENOSYS; }
>  static inline bool system_entering_hibernation(void) { return false; }
> -#endif /* CONFIG_HIBERNATION */
> +#endif /* !CONFIG_HIBERNATE_INTERFACE */
>  
>  #ifdef CONFIG_PM_SLEEP
>  void save_processor_state(void);
> @@ -298,13 +300,6 @@ static inline bool pm_wakeup_pending(voi
>  extern struct mutex pm_mutex;
>  
>  #ifndef CONFIG_HIBERNATION
> -static inline void register_nosave_region(unsigned long b, unsigned long e)
> -{
> -}
> -static inline void register_nosave_region_late(unsigned long b, unsigned long e)
> -{
> -}
> -
>  static inline void lock_system_sleep(void) {}
>  static inline void unlock_system_sleep(void) {}
>  
> Index: linux-2.6/arch/x86/power/Makefile
> ===================================================================
> --- linux-2.6.orig/arch/x86/power/Makefile
> +++ linux-2.6/arch/x86/power/Makefile
> @@ -4,4 +4,5 @@ nostackp := $(call cc-option, -fno-stack
>  CFLAGS_cpu.o	:= $(nostackp)
>  
>  obj-$(CONFIG_PM_SLEEP)		+= cpu.o
> -obj-$(CONFIG_HIBERNATION)	+= hibernate_$(BITS).o hibernate_asm_$(BITS).o
> +obj-$(CONFIG_HIBERNATE_INTERFACE)	+= hibernate_$(BITS).o \
> +						hibernate_asm_$(BITS).o
> Index: linux-2.6/kernel/power/main.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/main.c
> +++ linux-2.6/kernel/power/main.c
> @@ -156,7 +156,7 @@ static ssize_t state_show(struct kobject
>  			s += sprintf(s,"%s ", pm_states[i]);
>  	}
>  #endif
> -#ifdef CONFIG_HIBERNATION
> +#ifdef CONFIG_HIBERNATE_INTERFACE
>  	s += sprintf(s, "%s\n", "disk");
>  #else
>  	if (s != buf)
> Index: linux-2.6/kernel/power/power.h
> ===================================================================
> --- linux-2.6.orig/kernel/power/power.h
> +++ linux-2.6/kernel/power/power.h
> @@ -13,7 +13,7 @@ struct swsusp_info {
>  	unsigned long		size;
>  } __attribute__((aligned(PAGE_SIZE)));
>  
> -#ifdef CONFIG_HIBERNATION
> +#ifdef CONFIG_HIBERNATE_INTERFACE
>  /* kernel/power/snapshot.c */
>  extern void __init hibernate_image_size_init(void);
>  
> @@ -53,10 +53,10 @@ extern int hibernation_snapshot(int plat
>  extern int hibernation_restore(int platform_mode);
>  extern int hibernation_platform_enter(void);
>  
> -#else /* !CONFIG_HIBERNATION */
> +#else /* !CONFIG_HIBERNATE_INTERFACE */
>  
>  static inline void hibernate_image_size_init(void) {}
> -#endif /* !CONFIG_HIBERNATION */
> +#endif /* !CONFIG_HIBERNATE_INTERFACE */
>  
>  extern int pfn_is_nosave(unsigned long);
>  
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel


