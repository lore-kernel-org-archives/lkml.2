Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1I2DON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 23:14:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:56219 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab1I2DOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 23:14:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,458,1312182000"; 
   d="scan'208";a="56806081"
Message-ID: <4E83E27E.5090608@linux.intel.com>
Date: Thu, 29 Sep 2011 11:14:06 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0) Gecko/20110922 Thunderbird/7.0
MIME-Version: 1.0
To: "canquan.shen" <shencanquan@huawei.com>
CC: len.brown@intel.com, Bjorn Helgaas <bhelgaas@google.com>,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>, linqiangmin@huawei.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        khalid.aziz@hp.com
Subject: Re: [PATCH v5] acpi: Fix CPU hot removal problem
References: <4E7D7468.4040506@huawei.com>
In-Reply-To: <4E7D7468.4040506@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/9/24 14:10, canquan.shen 写道:
> We run linux as a guest in Xen environment. When we used the xen tools
> (xm vcpu-set <n>) to hot add and remove vcpu to and from the guest, we
> encountered the failure on vcpu removal. We found the reason is that it
> did't go to really remove cpu in the cpu removal code path.
>
> This patch adds acpi_bus_hot_remove_device in acpi_process_hotplug_notify to
> fix this issue. With this patch, it works fine for us.
>
> Signed-off-by: Canquan Shen <shencanquan@huawei.com>
> ---
> drivers/acpi/processor_driver.c | 13 +------------
> drivers/acpi/scan.c | 4 ++--
> include/acpi/acpi_bus.h | 1 +
> 3 files changed, 4 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index a4e0f1b..8429688 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -665,18 +665,7 @@ static void acpi_processor_hotplug_notify(acpi_handle handle,
> case ACPI_NOTIFY_EJECT_REQUEST:
> ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> "received ACPI_NOTIFY_EJECT_REQUEST\n"));
> -
> - if (acpi_bus_get_device(handle, &device)) {
> - printk(KERN_ERR PREFIX
> - "Device don't exist, dropping EJECT\n");
> - break;
> - }
> - pr = acpi_driver_data(device);
> - if (!pr) {
> - printk(KERN_ERR PREFIX
> - "Driver data is NULL, dropping EJECT\n");
> - return;
> - }
> + acpi_bus_hot_remove_device(handle);

As the description in __acpi_os_execute(in acpi_os_hotplug_execute),
         /*
          * We can't run hotplug code in keventd_wq/kacpid_wq/kacpid_notify_wq
          * because the hotplug code may call driver .remove() functions,
          * which invoke flush_scheduled_work/acpi_os_wait_events_complete
          * to flush these workqueues.
          */
If so, why not using following call:

acpi_os_hotplug_execute(acpi_bus_hot_remove_device, acpi_device->handle);


