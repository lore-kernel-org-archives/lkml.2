Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab2GLMdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:33:50 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:39641 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab2GLMds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:33:48 -0400
Message-ID: <4FFEC3E7.1030606@linux.vnet.ibm.com>
Date: Thu, 12 Jul 2012 18:02:39 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
        toshi.kani@hp.com
Subject: Re: [PATCH v3 1/3] acpi : cpu hot-remove returns error when cpu_down()
 fails
References: <4FFEB35A.6030500@jp.fujitsu.com>
In-Reply-To: <4FFEB35A.6030500@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
x-cbid: 12071203-3568-0000-0000-00000220227B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 04:52 PM, Yasuaki Ishimatsu wrote:
> Even if cpu_down() fails, acpi_processor_remove() continues to remove the cpu.
> But in this case, it should return error number since some process may run on
> the cpu. If the cpu has a running process and the cpu is turned the power off,
> the system may not work well.
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  drivers/acpi/processor_driver.c |   18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> Index: linux-3.5-rc4/drivers/acpi/processor_driver.c
> ===================================================================
> --- linux-3.5-rc4.orig/drivers/acpi/processor_driver.c	2012-06-25 04:53:04.000000000 +0900
> +++ linux-3.5-rc4/drivers/acpi/processor_driver.c	2012-07-05 21:02:58.711285382 +0900
> @@ -610,7 +610,7 @@ err_free_pr:
>  static int acpi_processor_remove(struct acpi_device *device, int type)
>  {
>  	struct acpi_processor *pr = NULL;
> -
> +	int ret;
> 
>  	if (!device || !acpi_driver_data(device))
>  		return -EINVAL;
> @@ -621,8 +621,9 @@ static int acpi_processor_remove(struct
>  		goto free;
> 
>  	if (type == ACPI_BUS_REMOVAL_EJECT) {
> -		if (acpi_processor_handle_eject(pr))
> -			return -EINVAL;
> +		ret = acpi_processor_handle_eject(pr);
> +		if (ret)
> +			return ret;
>  	}
> 
>  	acpi_processor_power_exit(pr, device);
> @@ -841,12 +842,17 @@ static acpi_status acpi_processor_hotadd
> 
>  static int acpi_processor_handle_eject(struct acpi_processor *pr)
>  {
> -	if (cpu_online(pr->id))
> -		cpu_down(pr->id);
> +	int ret;
> +
> +	if (cpu_online(pr->id)) {
> +		ret = cpu_down(pr->id);
> +		if (ret)
> +			return ret;
> +	}
> 
>  	arch_unregister_cpu(pr->id);
>  	acpi_unmap_lsapic(pr->id);
> -	return (0);
> +	return ret;
>  }
>  #else
>  static acpi_status acpi_processor_hotadd_init(struct acpi_processor *pr)
> 

