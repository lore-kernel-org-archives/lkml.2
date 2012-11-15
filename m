Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab2KOJ5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:57:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43126 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab2KOJ5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:57:40 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50A4BC72.4060305@jp.fujitsu.com>
Date: Thu, 15 Nov 2012 18:57:06 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-acpi@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Toshi Kani <toshi.kani@hp.com>, Jiang Liu <liuj97@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [Patch v5 7/7] acpi_memhotplug.c: auto bind the memory device
 which is hotplugged before the driver is loaded
References: <1352962777-24407-1-git-send-email-wency@cn.fujitsu.com> <1352962777-24407-8-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1352962777-24407-8-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/15 15:59, Wen Congyang wrote:
> If the memory device is hotplugged before the driver is loaded, the user
> cannot see this device under the directory /sys/bus/acpi/devices/, and the
> user cannot bind it by hand after the driver is loaded.  This patch
> introduces a new feature to bind such device when the driver is being
> loaded.
> 
> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> CC: Len Brown <len.brown@intel.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> CC: Rafael J. Wysocki <rjw@sisk.pl>
> CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   drivers/acpi/acpi_memhotplug.c | 37 ++++++++++++++++++++++++++++++++++++-
>   1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index e0f7425..9f1d107 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -52,6 +52,9 @@ MODULE_LICENSE("GPL");
>   #define MEMORY_POWER_ON_STATE	1
>   #define MEMORY_POWER_OFF_STATE	2
>   
> +static bool auto_probe;
> +module_param(auto_probe, bool, S_IRUGO | S_IWUSR);
> +
>   static int acpi_memory_device_add(struct acpi_device *device);
>   static int acpi_memory_device_remove(struct acpi_device *device, int type);
>   
> @@ -494,12 +497,44 @@ acpi_memory_register_notify_handler(acpi_handle handle,
>   				    u32 level, void *ctxt, void **retv)
>   {
>   	acpi_status status;
> -
> +	struct acpi_memory_device *mem_device = NULL;
> +	unsigned long long current_status;
>   
>   	status = is_memory_device(handle);
>   	if (ACPI_FAILURE(status))
>   		return AE_OK;	/* continue */
>   
> +	if (auto_probe) {
> +		/* Get device present/absent information from the _STA */
> +		status = acpi_evaluate_integer(handle, "_STA", NULL,
> +					       &current_status);
> +		if (ACPI_FAILURE(status))
> +			goto install;
> +
> +		/*
> +		 * Check for device status. Device should be
> +		 * present/enabled/functioning.
> +		 */
> +		if (!(current_status &
> +		      (ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED |
> +		       ACPI_STA_DEVICE_FUNCTIONING)))
> +			goto install;
> +
> +		if (acpi_memory_get_device(handle, &mem_device))
> +			goto install;
> +
> +		/* We have bound this device while we register the driver */
> +		if (mem_device->state == MEMORY_POWER_ON_STATE)
> +			goto install;
> +
> +		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +				  "\nauto probe memory device\n"));
> +
> +		if (acpi_memory_enable_device(mem_device))
> +			pr_err(PREFIX "Cannot enable memory device\n");
> +	}
> +
> +install:
>   	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
>   					     acpi_memory_device_notify, NULL);
>   	/* continue */
> 


