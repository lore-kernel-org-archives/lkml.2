Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815Ab1LPVfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 16:35:05 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:19165 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760653Ab1LPVe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 16:34:57 -0500
Date: Fri, 16 Dec 2011 16:33:45 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ke.yu@intel.com, kevin.tian@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad@kernel.org,
        stefan.bader@canonical.com, Ian.Campbell@citrix.com,
        mike.mcclurg@citrix.com, liang.tang@oracle.com
Subject: Re: [PATCH 1/8] ACPI: processor: export necessary interfaces
Message-ID: <20111216213345.GA9832@phenom.dumpdata.com>
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
 <1322673664-14642-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322673664-14642-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4EEBB976.0106,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 12:20:57PM -0500, Konrad Rzeszutek Wilk wrote:
> From: Kevin Tian <kevin.tian@intel.com>
> 
> This patch export some necessary functions which parse processor
> power management information. The Xen ACPI processor driver uses them.

I was wondering if it could be done by moving a bunch of these
functions in the processor_perflib.c, but there is a lot of code
that would have to be moved. Way too much.

Perhaps another, and a nicer way would be to:

 1). Create a processor_driver_lib.c which would have the "generic" code
 2). In the processor_driver just keep the essential notifications, and
     the hotplug code
 3). The introduce the other user of the acpi_processor_[add|remove|notify]
     calls as a seperate library?

Thoughts?
> 
> Signed-off-by: Yu Ke <ke.yu@intel.com>
> Signed-off-by: Tian Kevin <kevin.tian@intel.com>
> Signed-off-by: Tang Liang <liang.tang@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/acpi/processor_driver.c  |   11 +++--------
>  drivers/acpi/processor_perflib.c |    4 ++--
>  include/acpi/processor.h         |   10 +++++++++-
>  3 files changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index 9d7bc9f..211c078 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -79,9 +79,6 @@ MODULE_AUTHOR("Paul Diefenbaugh");
>  MODULE_DESCRIPTION("ACPI Processor Driver");
>  MODULE_LICENSE("GPL");
>  
> -static int acpi_processor_add(struct acpi_device *device);
> -static int acpi_processor_remove(struct acpi_device *device, int type);
> -static void acpi_processor_notify(struct acpi_device *device, u32 event);
>  static acpi_status acpi_processor_hotadd_init(acpi_handle handle, int *p_cpu);
>  static int acpi_processor_handle_eject(struct acpi_processor *pr);
>  
> @@ -378,7 +375,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
>  
>  static DEFINE_PER_CPU(void *, processor_device_array);
>  
> -static void acpi_processor_notify(struct acpi_device *device, u32 event)
> +void acpi_processor_notify(struct acpi_device *device, u32 event)
>  {
>  	struct acpi_processor *pr = acpi_driver_data(device);
>  	int saved;
> @@ -442,7 +439,7 @@ static struct notifier_block acpi_cpu_notifier =
>  	    .notifier_call = acpi_cpu_soft_notify,
>  };
>  
> -static int __cpuinit acpi_processor_add(struct acpi_device *device)
> +int __cpuinit acpi_processor_add(struct acpi_device *device)
>  {
>  	struct acpi_processor *pr = NULL;
>  	int result = 0;
> @@ -545,7 +542,7 @@ err_free_cpumask:
>  	return result;
>  }
>  
> -static int acpi_processor_remove(struct acpi_device *device, int type)
> +int acpi_processor_remove(struct acpi_device *device, int type)
>  {
>  	struct acpi_processor *pr = NULL;
>  
> @@ -758,7 +755,6 @@ static int acpi_processor_handle_eject(struct acpi_processor *pr)
>  }
>  #endif
>  
> -static
>  void acpi_processor_install_hotplug_notify(void)
>  {
>  #ifdef CONFIG_ACPI_HOTPLUG_CPU
> @@ -771,7 +767,6 @@ void acpi_processor_install_hotplug_notify(void)
>  	register_hotcpu_notifier(&acpi_cpu_notifier);
>  }
>  
> -static
>  void acpi_processor_uninstall_hotplug_notify(void)
>  {
>  #ifdef CONFIG_ACPI_HOTPLUG_CPU
> diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
> index 85b3237..22c6195 100644
> --- a/drivers/acpi/processor_perflib.c
> +++ b/drivers/acpi/processor_perflib.c
> @@ -386,7 +386,7 @@ static int acpi_processor_get_performance_states(struct acpi_processor *pr)
>  	return result;
>  }
>  
> -static int acpi_processor_get_performance_info(struct acpi_processor *pr)
> +int acpi_processor_get_performance_info(struct acpi_processor *pr)
>  {
>  	int result = 0;
>  	acpi_status status = AE_OK;
> @@ -492,7 +492,7 @@ int acpi_processor_notify_smm(struct module *calling_module)
>  
>  EXPORT_SYMBOL(acpi_processor_notify_smm);
>  
> -static int acpi_processor_get_psd(struct acpi_processor	*pr)
> +int acpi_processor_get_psd(struct acpi_processor	*pr)
>  {
>  	int result = 0;
>  	acpi_status status = AE_OK;
> diff --git a/include/acpi/processor.h b/include/acpi/processor.h
> index 610f6fb..12657bb 100644
> --- a/include/acpi/processor.h
> +++ b/include/acpi/processor.h
> @@ -239,6 +239,12 @@ extern void acpi_processor_unregister_performance(struct
>           if a _PPC object exists, rmmod is disallowed then */
>  int acpi_processor_notify_smm(struct module *calling_module);
>  
> +void acpi_processor_install_hotplug_notify(void);
> +void acpi_processor_uninstall_hotplug_notify(void);
> +
> +int acpi_processor_add(struct acpi_device *device);
> +int acpi_processor_remove(struct acpi_device *device, int type);
> +void acpi_processor_notify(struct acpi_device *device, u32 event);
>  /* for communication between multiple parts of the processor kernel module */
>  DECLARE_PER_CPU(struct acpi_processor *, processors);
>  extern struct acpi_processor_errata errata;
> @@ -278,7 +284,9 @@ static inline void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx
>  void acpi_processor_ppc_init(void);
>  void acpi_processor_ppc_exit(void);
>  int acpi_processor_ppc_has_changed(struct acpi_processor *pr, int event_flag);
> -extern int acpi_processor_get_bios_limit(int cpu, unsigned int *limit);
> +int acpi_processor_get_performance_info(struct acpi_processor *pr);
> +int acpi_processor_get_psd(struct acpi_processor *pr);
> +int acpi_processor_get_bios_limit(int cpu, unsigned int *limit);
>  #else
>  static inline void acpi_processor_ppc_init(void)
>  {
> -- 
> 1.7.7.3
