Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2KLDzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 22:55:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39803 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab2KLDzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 22:55:09 -0500
X-IronPort-AV: E=Sophos;i="4.80,759,1344182400"; 
   d="scan'208";a="6179497"
Message-ID: <50A07477.2050002@cn.fujitsu.com>
Date: Mon, 12 Nov 2012 12:00:55 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
CC: linux-acpi@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com, rjw@sisk.pl,
        lenb@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/3] acpi: Introduce prepare_remove device operation
References: <1352399371-8015-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
In-Reply-To: <1352399371-8015-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/12 11:54:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/12 11:54:50,
	Serialize complete at 2012/11/12 11:54:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 11/09/2012 02:29 AM, Vasilis Liaskovitis Wrote:
> As discussed in
> https://patchwork.kernel.org/patch/1581581/
> the driver core remove function needs to always succeed. This means we need
> to know that the device can be successfully removed before acpi_bus_trim / 
> acpi_bus_hot_remove_device are called. This can cause panics when OSPM-initiated
> eject (echo 1 > /sys/bus/acpi/devices/PNP/eject) of memory devices fails, since
> the ACPI core goes ahead and ejects the device regardless of whether the memory
> is still in use or not.
> 
> For this reason a new acpi_device operation called prepare_remove is introduced.
> This operation should be registered for acpi devices whose removal (from kernel
> perspective) can fail.  Memory devices fall in this category.
> 
> acpi_bus_hot_remove_device is changed to handle removal in 2 steps:
> - preparation for removal i.e. perform part of removal that can fail outside of
>   ACPI core. Should succeed for device and all its children.
> - if above step was successfull, proceed to actual ACPI removal

If we unbind the device from the driver, we still need to do preparation. But
you don't do it in your patch.

Thanks
Wen Congyang
> 
> acpi_bus_trim is changed accordingly to handle preparation for removal and
> actual removal.
> 
> With this patchset, only acpi memory devices use the new prepare_remove
> device operation. The actual memory removal (VM-related offline and other memory
> cleanups) is moved to prepare_remove. The old remove operation just cleans up
> the acpi structures. Directly ejecting PNP0C80 memory devices works safely. I
> haven't tested yet with an ACPI container which contains memory devices.
> 
> Other ACPI devices (e.g. CPU) do not register prepare_remove callbacks, and
> their OSPM-side eject should not be affected.
> 
> I am not happy with the name prepare_remove. Comments welcome. Let me know if I
> should work more in this direction (I think Yasuaki might also look into this
> and might have a simpler idea)
> 
> Patches are on top of Rafael's linux-pm/linux-next
> 
> Vasilis Liaskovitis (3):
>   acpi: Introduce prepare_remove operation in acpi_device_ops
>   acpi: Make acpi_bus_trim handle device removal preparation
>   acpi_memhotplug: Add prepare_remove operation
> 
>  drivers/acpi/acpi_memhotplug.c     |   24 +++++++++++++++++++++---
>  drivers/acpi/dock.c                |    2 +-
>  drivers/acpi/scan.c                |   32 +++++++++++++++++++++++++++++---
>  drivers/pci/hotplug/acpiphp_glue.c |    4 ++--
>  drivers/pci/hotplug/sgi_hotplug.c  |    2 +-
>  include/acpi/acpi_bus.h            |    4 +++-
>  6 files changed, 57 insertions(+), 11 deletions(-)
> 

