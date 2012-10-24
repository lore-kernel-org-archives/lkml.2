Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab2JXRk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:40:56 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:10820 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729Ab2JXRky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:40:54 -0400
Message-ID: <1351100001.19172.26.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/2] Use kacpi_hotplug_wq to handle container hotplug
 event.
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: yinghai@kernel.org, bhelgaas@google.com, lenb@kernel.org,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 24 Oct 2012 11:33:21 -0600
In-Reply-To: <1350997839-13260-2-git-send-email-tangchen@cn.fujitsu.com>
References: <1350997839-13260-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1350997839-13260-2-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 21:10 +0800, Tang Chen wrote:
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

Hi Tang,

I am curious; is there a particular reason why you use
alloc_acpi_container_hp_work() instead of acpi_os_hotplug_execute(),
which is already there in the tree?

Thanks,
-Toshi


> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  drivers/acpi/container.c |   44 +++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 43 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
> index 1f9f7d7..643657a 100644
> --- a/drivers/acpi/container.c
> +++ b/drivers/acpi/container.c
> @@ -72,8 +72,36 @@ static struct acpi_driver acpi_container_driver = {
>  		},
>  };
>  
> +struct acpi_container_hp_work {
> +	struct work_struct work;
> +	acpi_handle handle;
> +	u32 type;
> +	void *context;
> +};
> +
>  /*******************************************************************/
>  
> +static void alloc_acpi_container_hp_work(acpi_handle handle, u32 type,
> +					void *context,
> +					void (*func)(struct work_struct *work))
> +{
> +	struct acpi_container_hp_work *hp_work;
> +	int ret;
> +
> +	hp_work = kmalloc(sizeof(*hp_work), GFP_KERNEL);
> +	if (!hp_work)
> +		return;
> +
> +	hp_work->handle = handle;
> +	hp_work->type = type;
> +	hp_work->context = context;
> +
> +	INIT_WORK(&hp_work->work, func);
> +	ret = queue_work(kacpi_hotplug_wq, &hp_work->work);
> +	if (!ret)
> +		kfree(hp_work);
> +}
> +
>  static int is_device_present(acpi_handle handle)
>  {
>  	acpi_handle temp;
> @@ -152,14 +180,21 @@ static int container_device_add(struct acpi_device **device, acpi_handle handle)
>  	return result;
>  }
>  
> -static void container_notify_cb(acpi_handle handle, u32 type, void *context)
> +static void __container_notify_cb(struct work_struct *work)
>  {
>  	struct acpi_device *device = NULL;
>  	int result;
>  	int present;
>  	acpi_status status;
> +	struct acpi_container_hp_work *hp_work;
> +	acpi_handle handle;
> +	u32 type;
>  	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
>  
> +	hp_work = container_of(work, struct acpi_container_hp_work, work);
> +	handle = hp_work->handle;
> +	type = hp_work->type;
> +
>  	switch (type) {
>  	case ACPI_NOTIFY_BUS_CHECK:
>  		/* Fall through */
> @@ -211,6 +246,13 @@ static void container_notify_cb(acpi_handle handle, u32 type, void *context)
>  	return;
>  }
>  
> +static void container_notify_cb(acpi_handle handle, u32 type,
> +				void *context)
> +{
> +	alloc_acpi_container_hp_work(handle, type, context,
> +				__container_notify_cb);
> +}
> +
>  static acpi_status
>  container_walk_namespace_cb(acpi_handle handle,
>  			    u32 lvl, void *context, void **rv)


