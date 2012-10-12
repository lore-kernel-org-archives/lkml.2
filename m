Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922Ab2JLKcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 06:32:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43149 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab2JLKcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 06:32:52 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344182400"; 
   d="scan'208";a="5989985"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: yinghai@kernel.org, lenb@kernel.org, bhelgaas@google.com,
        izumi.taku@jp.fujitsu.com, jiang.liu@huawei.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Find pci root bridges by comparing HID from acpi_device_info, not acpi_device.
Date: Fri, 12 Oct 2012 18:31:27 +0800
Message-Id: <1350037890-5899-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 18:32:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 18:32:28,
	Serialize complete at 2012/10/12 18:32:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

I found a little problem in your following patches. :)
[PATCH 00/40] PCI, ACPI, x86: pci root bus hotplug support.

In acpi_is_root_bridge(), it gets device's HID from acpi_device struct.
If the device is not added when the system boots, there will be no
acpi_device for it. And as a result, acpi_is_root_bridge() will fail.
But it doesn't mean that the device is not a root bridge.

In this case, the not-added root bridges have no handle_hotplug_event_root()
callback registerred. And when we hot add it later, it will do nothing.

This patch set changes the acpi_is_root_bridge()'s behavior. When we fail
to get HID from acpi_device, we will get HID from acpi_device_info by
acpi_get_object_info(), which gets the HID from ACPI namespace directly.

So no matter the device is present or not, we will always find out if it
is a pci root bridge, and register a handle_hotplug_event_root() callback
for it.

These patches are based on Lu Yinghai's for-pci-root-bus-hotplug branch.

Tang Chen (3):
  Introduce a new acpi to determine HID match.
  Do not use acpi_device to find pci root bridge in _init code.
  Check exit status of acpi_install_notify_handler() in
    find_root_bridges().

 drivers/acpi/pci_root.c    |   27 ++++++++++++++++++++++-----
 drivers/acpi/pci_root_hp.c |   12 +++++++++---
 drivers/acpi/scan.c        |   24 ++++++++++++++++++++++++
 include/acpi/acpi_bus.h    |    2 ++
 4 files changed, 57 insertions(+), 8 deletions(-)

