Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819Ab1LPVhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 16:37:31 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:20073 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760653Ab1LPVh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 16:37:28 -0500
Date: Fri, 16 Dec 2011 16:36:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ke.yu@intel.com, kevin.tian@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad@kernel.org,
        stefan.bader@canonical.com, Ian.Campbell@citrix.com,
        mike.mcclurg@citrix.com, liang.tang@oracle.com
Subject: Re: [PATCH 4/8] ACPI: processor: Don't setup cpu idle driver and
 handler when we do not want them.
Message-ID: <20111216213618.GB9832@phenom.dumpdata.com>
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
 <1322673664-14642-5-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322673664-14642-5-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4EEBBA0D.0085,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 12:21:00PM -0500, Konrad Rzeszutek Wilk wrote:
> From: Kevin Tian <kevin.tian@intel.com>
> 
> This patch inhibits processing of the CPU idle handler if it is not
> set to the appropiate one. This is needed by the Xen processor driver
> which, while still needing processor details, wants to use the default_idle
> call (which makes a yield hypercall).

Which I think is not required anymore with the d91ee5863b71e8c90eaf6035bff3078a85e2e7b5
(cpuidle: replace xen access to x86 pm_idle and default_idle) and
62027aea23fcd14478abdddd3b74a4e0f5fb2984
(cpuidle: create bootparam "cpuidle.off=1")

Liang, can you double-check that please?

> 
> Signed-off-by: Yu Ke <ke.yu@intel.com>
> Signed-off-by: Tian Kevin <kevin.tian@intel.com>
> Signed-off-by: Tang Liang <liang.tang@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/acpi/processor_idle.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index d88974a..0ad347f 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -1127,7 +1127,7 @@ int acpi_processor_hotplug(struct acpi_processor *pr)
>  	cpuidle_pause_and_lock();
>  	cpuidle_disable_device(&pr->power.dev);
>  	acpi_processor_get_power_info(pr);
> -	if (pr->flags.power) {
> +	if (pr->flags.power  && (cpuidle_get_driver() == &acpi_idle_driver)) {
>  		acpi_processor_setup_cpuidle_cx(pr);
>  		ret = cpuidle_enable_device(&pr->power.dev);
>  	}
> @@ -1183,7 +1183,8 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
>  			if (!_pr || !_pr->flags.power_setup_done)
>  				continue;
>  			acpi_processor_get_power_info(_pr);
> -			if (_pr->flags.power) {
> +			if (_pr->flags.power && (cpuidle_get_driver()
> +						== &acpi_idle_driver)) {
>  				acpi_processor_setup_cpuidle_cx(_pr);
>  				cpuidle_enable_device(&_pr->power.dev);
>  			}
> @@ -1237,7 +1238,8 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr,
>  	 * Note that we use previously set idle handler will be used on
>  	 * platforms that only support C1.
>  	 */
> -	if (pr->flags.power) {
> +	if (pr->flags.power && (__acpi_processor_register_driver ==
> +				acpi_processor_register_driver)) {
>  		/* Register acpi_idle_driver if not already registered */
>  		if (!acpi_processor_registered) {
>  			acpi_processor_setup_cpuidle_states(pr);
> -- 
> 1.7.7.3
