Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934232Ab2JXGzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:55:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35522 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933450Ab2JXGzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:55:16 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <508790AC.5080001@jp.fujitsu.com>
Date: Wed, 24 Oct 2012 15:54:36 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: <yinghai@kernel.org>, <bhelgaas@google.com>, <lenb@kernel.org>,
        <jiang.liu@huawei.com>, <izumi.taku@jp.fujitsu.com>,
        <mihailm@parallels.com>, <linux-acpi@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] Use kacpi_hotplug_wq to handle container hotplug
 event.
References: <1351058750-4275-1-git-send-email-tangchen@cn.fujitsu.com> <1351058750-4275-2-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1351058750-4275-2-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tang,

2012/10/24 15:05, Tang Chen wrote:
> As the comments in __acpi_os_execute() said:
> 
> 	We can't run hotplug code in keventd_wq/kacpid_wq/kacpid_notify_wq
> 	because the hotplug code may call driver .remove() functions,
> 	which invoke flush_scheduled_work/acpi_os_wait_events_complete
> 	to flush these workqueues.
> 
> we should keep the hotplug code in kacpi_hotplug_wq.
> 
> But we have the following call series in kernel now:
> 	acpi_ev_queue_notify_request()
> 	|--> acpi_os_execute()
> 	     |--> __acpi_os_execute(type, function, context, 0)
> 
> The last parameter 0 makes the container_notify_cb() executed in
> kacpi_notify_wq or kacpid_wq. So, we need to put the real hotplug code
> into kacpi_hotplug_wq.

I cannot understand the purpose of the patch.
Is the patch a bug fix patch? If yes, what problem happens?

Thanks,
Yasuaki Ishimatsu

> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>   drivers/acpi/container.c |   17 ++++++++++++++++-
>   1 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
> index 69e2d6b..d300e03 100644
> --- a/drivers/acpi/container.c
> +++ b/drivers/acpi/container.c
> @@ -35,6 +35,7 @@
>   #include <acpi/acpi_bus.h>
>   #include <acpi/acpi_drivers.h>
>   #include <acpi/container.h>
> +#include <acpi/acpiosxf.h>
>   
>   #define PREFIX "ACPI: "
>   
> @@ -165,14 +166,21 @@ static int container_device_add(struct acpi_device **device, acpi_handle handle)
>   	return result;
>   }
>   
> -static void container_notify_cb(acpi_handle handle, u32 type, void *context)
> +static void __container_notify_cb(struct work_struct *work)
>   {
>   	struct acpi_device *device = NULL;
>   	int result;
>   	int present;
>   	acpi_status status;
> +	struct acpi_hp_work *hp_work;
> +	acpi_handle handle;
> +	u32 type;
>   	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
>   
> +	hp_work = container_of(work, struct acpi_hp_work, work);
> +	handle = hp_work->handle;
> +	type = hp_work->type;
> +
>   	switch (type) {
>   	case ACPI_NOTIFY_BUS_CHECK:
>   		/* Fall through */
> @@ -224,6 +232,13 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
>   	return;
>   }
>   
> +static void container_notify_cb(acpi_handle handle, u32 type,
> +				void *context)
> +{
> +	alloc_acpi_hp_work(handle, type, context,
> +			   __container_notify_cb);
> +}
> +
>   static acpi_status
>   container_walk_namespace_cb(acpi_handle handle,
>   			    u32 lvl, void *context, void **rv)
> 


