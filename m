Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab2JCXAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:00:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31145 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2JCXAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:00:18 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Len Brown <lenb@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/4] ACPI: kill acpi_pci_root_start
Date: Wed,  3 Oct 2012 16:00:10 -0700
Message-Id: <1349305214-3241-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now acpi_pci_root_driver has two ops: .add and .start, aka acpi_pci_root_add
and acpi_pci_root_start.

That is for hotplug handling: .add need to return early to make sure all
acpi device could be created and added early. So .start could device_add
pci device that are found in acpi_pci_root_add/pci_acpi_scan_root().

That is holding pci devics to be out of devices for while.

We could use bus notifier to handle hotplug case.
	CONFIG_HOTPLUG is enabled always now.
Need to add drivers_autoprobe bit in acpi_device to hold attaching drivers
for acpi_devices, so could make sure all acpi_devices get created at first.
Then acpi_bus_attach() that is called from acpi_bus_add will attach driver
for all acpi_devices that are just created.

That make the logic more simple: hotplug path handling just like booting path
that drivers are attached after all acpi device get created.

At last we could remove all acpi_bus_start workaround.

Thanks

Yinghai

Yinghai Lu (4):
  ACPI: add drivers_autoprobe in struct acpi_device
  ACPI: use device drivers_autoprobe to delay loading acpi drivers
  PCI, ACPI: Remove not used acpi_pci_root_start()
  ACPI: remove acpi_op_start workaround

 drivers/acpi/pci_root.c |   27 +++------
 drivers/acpi/scan.c     |  145 ++++++++++++++++++++++-------------------------
 include/acpi/acpi_bus.h |    9 +---
 3 files changed, 77 insertions(+), 104 deletions(-)

-- 
1.7.7

