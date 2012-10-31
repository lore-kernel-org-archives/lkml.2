Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935433Ab2JaLJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:09:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38149 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935389Ab2JaLJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:09:49 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <509106E2.70008@jp.fujitsu.com>
Date: Wed, 31 Oct 2012 20:09:22 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: <yinghai@kernel.org>, <bhelgaas@google.com>, <lenb@kernel.org>,
        <jiang.liu@huawei.com>, <izumi.taku@jp.fujitsu.com>,
        <linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] ACPI: container hot remove support.
References: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tang,

2012/10/31 16:27, Tang Chen wrote:
> Hi,
> 
> The container hotplug handler container_notify_cb() didn't implement
> the hot-remove functionality. So, these 3 patches implement it like
> the following way:
> 
> patch 1. Do not use kacpid_wq/kacpid_notify_wq to handle container hotplug event,
>           use kacpi_hotplug_wq instead to avoid deadlock.
>           Doing this is to reuse acpi_bus_hot_remove_device() in container
>           hot-remove handling.
> 
> patch 2. Introduce a new function container_device_remove() to handle
>           ACPI_NOTIFY_EJECT_REQUEST event for container.

If container device contains memory device, the function is 
very danger. As you know, we are developing a memory hotplug.
If memory has kernel memory, memory hot remove operations fails.
But container_device_remove() cannot realize it. So even if
the memory hot remove operation fails, container_device_remove()
keeps hot remove operation. Finally, the function sends _EJ0
to firmware. In this case, if the memory is accessed, kernel
panic occurs.
The example is as follows:

 https://lkml.org/lkml/2012/9/26/318

Thanks,
Yasuaki Ishimatsu

> 
> 
> change log v2 -> v3:
> 
> 1. Add 1 patch(patch1). As Toshi Kan mentioned, acpi_os_hotplug_execute() is already
>     kernel. So use it instead of alloc_acpi_hp_work() to add hotplug job onto kacpi_hotplug_wq.
> 
> 2. In patch3: Print caller's function name when container_device_remove() fails to help to debug.
> 
> 3. In patch3: Add commit message to describ why we need to call acpi_bus_trim() twice when
>     removing devices.
> 
> change log v1 -> v2:
> 
> 1. In patch1: Based on the lastest for-pci-split-pci-root-hp-2 branch from Lu Yinghai,
>     use alloc_acpi_hp_work() to add container hotplug work into kacpi_hotplug_wq.
> 
> 2. In patch2: Allocate ej_event after container is stopped, so that we don't need to
>     kfree the ej_event if stopping container failed.
> 
> 
> This is based on Lu Yinghai's job.
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-split-pci-root-hp-2
> 
> 
> Tang Chen (3):
>    Use acpi_os_hotplug_execute() instead of alloc_acpi_hp_work().
>    Use kacpi_hotplug_wq to handle container hotplug event.
>    Improve container_notify_cb() to support container hot-remove.
> 
>   drivers/acpi/container.c           |   95 +++++++++++++++++++++++++++++++-----
>   drivers/acpi/osl.c                 |   28 +++++-----
>   drivers/acpi/pci_root_hp.c         |   25 ++++++---
>   drivers/pci/hotplug/acpiphp_glue.c |   39 ++++++++-------
>   include/acpi/acpiosxf.h            |    7 +--
>   5 files changed, 137 insertions(+), 57 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


