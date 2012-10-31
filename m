Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934918Ab2JaH3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:29:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33923 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932447Ab2JaH3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:29:05 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344182400"; 
   d="scan'208";a="6106805"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: yinghai@kernel.org, bhelgaas@google.com, lenb@kernel.org,
        jiang.liu@huawei.com, izumi.taku@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] ACPI: container hot remove support.
Date: Wed, 31 Oct 2012 15:27:48 +0800
Message-Id: <1351668471-31436-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 15:28:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 15:28:20,
	Serialize complete at 2012/10/31 15:28:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The container hotplug handler container_notify_cb() didn't implement
the hot-remove functionality. So, these 3 patches implement it like
the following way:

patch 1. Do not use kacpid_wq/kacpid_notify_wq to handle container hotplug event,
         use kacpi_hotplug_wq instead to avoid deadlock.
         Doing this is to reuse acpi_bus_hot_remove_device() in container
         hot-remove handling.

patch 2. Introduce a new function container_device_remove() to handle
         ACPI_NOTIFY_EJECT_REQUEST event for container.


change log v2 -> v3:

1. Add 1 patch(patch1). As Toshi Kan mentioned, acpi_os_hotplug_execute() is already
   kernel. So use it instead of alloc_acpi_hp_work() to add hotplug job onto kacpi_hotplug_wq.

2. In patch3: Print caller's function name when container_device_remove() fails to help to debug.

3. In patch3: Add commit message to describ why we need to call acpi_bus_trim() twice when
   removing devices.

change log v1 -> v2:

1. In patch1: Based on the lastest for-pci-split-pci-root-hp-2 branch from Lu Yinghai, 
   use alloc_acpi_hp_work() to add container hotplug work into kacpi_hotplug_wq.

2. In patch2: Allocate ej_event after container is stopped, so that we don't need to
   kfree the ej_event if stopping container failed.


This is based on Lu Yinghai's job.
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-split-pci-root-hp-2


Tang Chen (3):
  Use acpi_os_hotplug_execute() instead of alloc_acpi_hp_work().
  Use kacpi_hotplug_wq to handle container hotplug event.
  Improve container_notify_cb() to support container hot-remove.

 drivers/acpi/container.c           |   95 +++++++++++++++++++++++++++++++-----
 drivers/acpi/osl.c                 |   28 +++++-----
 drivers/acpi/pci_root_hp.c         |   25 ++++++---
 drivers/pci/hotplug/acpiphp_glue.c |   39 ++++++++-------
 include/acpi/acpiosxf.h            |    7 +--
 5 files changed, 137 insertions(+), 57 deletions(-)

