Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032692Ab2CSTTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:19:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:20175 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065Ab2CSTTP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:19:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="79277101"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "tboot-devel@lists.sourceforge.net" 
	<tboot-devel@lists.sourceforge.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "liang.tang@oracle.com" <liang.tang@oracle.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH 2/7] tboot: Add return values for tboot_sleep
Thread-Topic: [PATCH 2/7] tboot: Add return values for tboot_sleep
Thread-Index: AQHMvEQQPMq8vCzP2kC39IoeO7knJJYGLEFQgAOGhgCAACrMgIAUKQ+ggA5lMwCARiXj0A==
Date: Mon, 19 Mar 2012 19:19:12 +0000
Message-ID: <9F57BF860713DF4BA3EFA4F8C6DFEDAC46026B28@ORSMSX101.amr.corp.intel.com>
References: <1324075099-11397-1-git-send-email-konrad.wilk@oracle.com>
 <1324075099-11397-3-git-send-email-konrad.wilk@oracle.com>
 <9F57BF860713DF4BA3EFA4F8C6DFEDAC2420CBB9@ORSMSX101.amr.corp.intel.com>
 <20120112174958.GA22515@phenom.dumpdata.com>
 <20120112202308.GA2030@phenom.dumpdata.com>
 <9F57BF860713DF4BA3EFA4F8C6DFEDAC2D6870EE@ORSMSX101.amr.corp.intel.com>
 <20120203200508.GA1556@phenom.dumpdata.com>
In-Reply-To: <20120203200508.GA1556@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> Sent: Friday, February 03, 2012 12:05 PM
> To: Cihula, Joseph
> Cc: linux-kernel@vger.kernel.org; rjw@sisk.pl; x86@kernel.org; Brown, Len; linux-pm@lists.linux-
> foundation.org; tboot-devel@lists.sourceforge.net; linux-acpi@vger.kernel.org;
> liang.tang@oracle.com; hpa@zytor.com
> Subject: Re: [PATCH 2/7] tboot: Add return values for tboot_sleep
> 
> On Thu, Jan 26, 2012 at 12:16:39AM +0000, Cihula, Joseph wrote:
> > > From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> > > Sent: Thursday, January 12, 2012 12:23 PM
> > eturn values for tboot_sleep
> > >
> > > On Thu, Jan 12, 2012 at 09:49:58AM -0800, Konrad Rzeszutek Wilk wrote:
> > > > On Tue, Jan 10, 2012 at 08:10:53PM +0000, Cihula, Joseph wrote:
> > > > > ACK, but tboot_sleep() calls tboot_shutdown() and there are
> > > > > error conditions in that which you
> > > are not reflecting upward--i.e. you should make tboot_shutdown()
> > > return an 'int' and propagate its errors through tboot_sleep().
> > > >
> > > > Hey Joe,
> > > >
> > > > Thanks for looking at the patches.
> > > >
> > > > Right now [with this patch applied] the code looks as so:
> > > >
> > > > 297
> > > > 298         tboot_shutdown(acpi_shutdown_map[sleep_state]);
> > > > 299         return 0;
> > > > 300 }
> > > >
> > > >
> > > > If we do make tboot_shutdown() return an int, there will be a need
> > > > to modify other callers: native_machine_emergency_restart,
> > > > native_machine_halt, native_machine_power_off, and native_play_dead as well.
> > > >
> > > > Perhaps that could be done in another patch and leave this one as
> > > > is where the 'tboot_sleep' would just return 0 instead of 'return
> > > > tboot_shutdown(...)' ?
> > > >
> > > > Perhaps another way to do this is to extract the common code of
> > > > tboot_sleep and tboot_shutdown?
> >
> > I'd be happier to see the callers above changed to handle a tboot_shutdown() that returned an
> error than splitting this up and only checking the error in one path.
> 
> OK, so something like this then:

Looks good.

Joe

> 
> From da60a441fd62aee83763758455c08c281893ae93 Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Thu, 8 Dec 2011 17:14:08 +0800
> Subject: [PATCH] tboot: Add return values for tboot_sleep and consequently  tboot_shutdown
> 
> .. as appropiately. As tboot_sleep now returns values.
> remove tboot_sleep_wrapper.
> 
> Suggested-by: "Rafael J. Wysocki" <rjw@sisk.pl>
> Acked-by: Joseph Cihula <joseph.cihula@intel.com>
> [v1: Return -1/0/+1 instead of ACPI_xx values]
> [v2: Also make tboot_shutdown return error code]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/kernel/reboot.c  |    6 +++---
>  arch/x86/kernel/smpboot.c |    2 +-
>  arch/x86/kernel/tboot.c   |   33 +++++++++++++++------------------
>  include/linux/tboot.h     |    4 ++--
>  4 files changed, 21 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c index 37a458b..b29326a 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -549,7 +549,7 @@ static void native_machine_emergency_restart(void)
>  	if (reboot_emergency)
>  		emergency_vmx_disable_all();
> 
> -	tboot_shutdown(TB_SHUTDOWN_REBOOT);
> +	WARN_ON(tboot_shutdown(TB_SHUTDOWN_REBOOT));
> 
>  	/* Tell the BIOS if we want cold or warm reboot */
>  	*((unsigned short *)__va(0x472)) = reboot_mode; @@ -684,7 +684,7 @@ static void
> native_machine_halt(void)
>  	/* stop other cpus and apics */
>  	machine_shutdown();
> 
> -	tboot_shutdown(TB_SHUTDOWN_HALT);
> +	WARN_ON(tboot_shutdown(TB_SHUTDOWN_HALT));
> 
>  	/* stop this cpu */
>  	stop_this_cpu(NULL);
> @@ -698,7 +698,7 @@ static void native_machine_power_off(void)
>  		pm_power_off();
>  	}
>  	/* a fallback in case there is no PM info available */
> -	tboot_shutdown(TB_SHUTDOWN_HALT);
> +	WARN_ON(tboot_shutdown(TB_SHUTDOWN_HALT));
>  }
> 
>  struct machine_ops machine_ops = {
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c index 66d250c..9aa903a 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1419,7 +1419,7 @@ static inline void hlt_play_dead(void)  void native_play_dead(void)  {
>  	play_dead_common();
> -	tboot_shutdown(TB_SHUTDOWN_WFS);
> +	WARN_ON(tboot_shutdown(TB_SHUTDOWN_WFS));
> 
>  	mwait_play_dead();	/* Only returns on failure */
>  	hlt_play_dead();
> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c index 1a4ab7d..9504a7a 100644
> --- a/arch/x86/kernel/tboot.c
> +++ b/arch/x86/kernel/tboot.c
> @@ -217,12 +217,12 @@ static int tboot_setup_sleep(void)
> 
>  #endif
> 
> -void tboot_shutdown(u32 shutdown_type)
> +int tboot_shutdown(u32 shutdown_type)
>  {
>  	void (*shutdown)(void);
> 
>  	if (!tboot_enabled())
> -		return;
> +		return 0;
> 
>  	/*
>  	 * if we're being called before the 1:1 mapping is set up then just @@ -230,13 +230,14 @@
> void tboot_shutdown(u32 shutdown_type)
>  	 * due to very early panic()
>  	 */
>  	if (!tboot_pg_dir)
> -		return;
> +		return 0;
> 
>  	/* if this is S3 then set regions to MAC */
> -	if (shutdown_type == TB_SHUTDOWN_S3)
> -		if (tboot_setup_sleep())
> -			return;
> -
> +	if (shutdown_type == TB_SHUTDOWN_S3) {
> +		int rc = tboot_setup_sleep();
> +		if (rc)
> +			return rc;
> +	}
>  	tboot->shutdown_type = shutdown_type;
> 
>  	switch_to_tboot_pt();
> @@ -247,6 +248,8 @@ void tboot_shutdown(u32 shutdown_type)
>  	/* should not reach here */
>  	while (1)
>  		halt();
> +
> +	return 0;
>  }
> 
>  static void tboot_copy_fadt(const struct acpi_table_fadt *fadt) @@ -272,7 +275,7 @@ static void
> tboot_copy_fadt(const struct acpi_table_fadt *fadt)
>  		offsetof(struct acpi_table_facs, firmware_waking_vector);  }
> 
> -void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
> +static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32
> +pm1b_control)
>  {
>  	static u32 acpi_shutdown_map[ACPI_S_STATE_COUNT] = {
>  		/* S0,1,2: */ -1, -1, -1,
> @@ -281,7 +284,7 @@ void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
>  		/* S5: */ TB_SHUTDOWN_S5 };
> 
>  	if (!tboot_enabled())
> -		return;
> +		return 0;
> 
>  	tboot_copy_fadt(&acpi_gbl_FADT);
>  	tboot->acpi_sinfo.pm1a_cnt_val = pm1a_control; @@ -292,16 +295,10 @@ void tboot_sleep(u8
> sleep_state, u32 pm1a_control, u32 pm1b_control)
>  	if (sleep_state >= ACPI_S_STATE_COUNT ||
>  	    acpi_shutdown_map[sleep_state] == -1) {
>  		pr_warning("unsupported sleep state 0x%x\n", sleep_state);
> -		return;
> +		return -1;
>  	}
> 
> -	tboot_shutdown(acpi_shutdown_map[sleep_state]);
> -}
> -static int tboot_sleep_wrapper(u8 sleep_state, u32 pm1a_control,
> -			       u32 pm1b_control)
> -{
> -	tboot_sleep(sleep_state, pm1a_control, pm1b_control);
> -	return 0;
> +	return tboot_shutdown(acpi_shutdown_map[sleep_state]);
>  }
> 
>  static atomic_t ap_wfs_count;
> @@ -352,7 +349,7 @@ static __init int tboot_late_init(void)
>  	atomic_set(&ap_wfs_count, 0);
>  	register_hotcpu_notifier(&tboot_cpu_notifier);
> 
> -	acpi_os_set_prepare_sleep(&tboot_sleep_wrapper);
> +	acpi_os_set_prepare_sleep(&tboot_sleep);
>  	return 0;
>  }
> 
> diff --git a/include/linux/tboot.h b/include/linux/tboot.h index c75128b..8f14fe0 100644
> --- a/include/linux/tboot.h
> +++ b/include/linux/tboot.h
> @@ -142,7 +142,7 @@ static inline int tboot_enabled(void)  }
> 
>  extern void tboot_probe(void);
> -extern void tboot_shutdown(u32 shutdown_type);
> +extern int tboot_shutdown(u32 shutdown_type);
>  extern struct acpi_table_header *tboot_get_dmar_table(
>  				      struct acpi_table_header *dmar_tbl);  extern int
> tboot_force_iommu(void); @@ -151,7 +151,7 @@ extern int tboot_force_iommu(void);
> 
>  #define tboot_enabled()			0
>  #define tboot_probe()			do { } while (0)
> -#define tboot_shutdown(shutdown_type)	do { } while (0)
> +#define tboot_shutdown(shutdown_type)	0
>  #define tboot_sleep(sleep_state, pm1a_control, pm1b_control)	\
>  					do { } while (0)
>  #define tboot_get_dmar_table(dmar_tbl)	(dmar_tbl)
> --
> 1.7.7.5

