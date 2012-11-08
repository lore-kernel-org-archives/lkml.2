Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab2KHS3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 13:29:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63259 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab2KHS3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 13:29:39 -0500
From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
To: linux-acpi@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com
Cc: rjw@sisk.pl, wency@cn.fujitsu.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-mm@kvack.org,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Subject: [RFC PATCH 0/3] acpi: Introduce prepare_remove device operation
Date: Thu,  8 Nov 2012 19:29:28 +0100
Message-Id: <1352399371-8015-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed in
https://patchwork.kernel.org/patch/1581581/
the driver core remove function needs to always succeed. This means we need
to know that the device can be successfully removed before acpi_bus_trim / 
acpi_bus_hot_remove_device are called. This can cause panics when OSPM-initiated
eject (echo 1 > /sys/bus/acpi/devices/PNP/eject) of memory devices fails, since
the ACPI core goes ahead and ejects the device regardless of whether the memory
is still in use or not.

For this reason a new acpi_device operation called prepare_remove is introduced.
This operation should be registered for acpi devices whose removal (from kernel
perspective) can fail.  Memory devices fall in this category.

acpi_bus_hot_remove_device is changed to handle removal in 2 steps:
- preparation for removal i.e. perform part of removal that can fail outside of
  ACPI core. Should succeed for device and all its children.
- if above step was successfull, proceed to actual ACPI removal

acpi_bus_trim is changed accordingly to handle preparation for removal and
actual removal.

With this patchset, only acpi memory devices use the new prepare_remove
device operation. The actual memory removal (VM-related offline and other memory
cleanups) is moved to prepare_remove. The old remove operation just cleans up
the acpi structures. Directly ejecting PNP0C80 memory devices works safely. I
haven't tested yet with an ACPI container which contains memory devices.

Other ACPI devices (e.g. CPU) do not register prepare_remove callbacks, and
their OSPM-side eject should not be affected.

I am not happy with the name prepare_remove. Comments welcome. Let me know if I
should work more in this direction (I think Yasuaki might also look into this
and might have a simpler idea)

Patches are on top of Rafael's linux-pm/linux-next

Vasilis Liaskovitis (3):
  acpi: Introduce prepare_remove operation in acpi_device_ops
  acpi: Make acpi_bus_trim handle device removal preparation
  acpi_memhotplug: Add prepare_remove operation

 drivers/acpi/acpi_memhotplug.c     |   24 +++++++++++++++++++++---
 drivers/acpi/dock.c                |    2 +-
 drivers/acpi/scan.c                |   32 +++++++++++++++++++++++++++++---
 drivers/pci/hotplug/acpiphp_glue.c |    4 ++--
 drivers/pci/hotplug/sgi_hotplug.c  |    2 +-
 include/acpi/acpi_bus.h            |    4 +++-
 6 files changed, 57 insertions(+), 11 deletions(-)

-- 
1.7.9

