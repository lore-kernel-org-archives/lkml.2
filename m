Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2IBV6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:58:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20009 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2IBVyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:54:35 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part4 04/11] PCI: Fix an access-after-free issue in function pci_stop_and_remove_bus()
Date: Sun,  2 Sep 2012 14:54:14 -0700
Message-Id: <1346622861-30865-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622861-30865-1-git-send-email-yinghai@kernel.org>
References: <1346622861-30865-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

If pci_stop_and_remove_bus() is called to remove a pci root bus,
the host_bridge structure may have already been freed after returning
from pci_remove_bus(). To avoid that, hold an extra reference count
to the root bus before calling pci_remove_bus(), so we can safely
access the pci_host_bridge structure after returning from function
pci_remove_bus().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 94407d4..40f8148 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -154,6 +154,7 @@ void pci_stop_and_remove_bus(struct pci_bus *bus)
 
 	if (pci_is_root_bus(bus)) {
 		host_bridge = to_pci_host_bridge(bus->bridge);
+		get_device(&host_bridge->dev);
 		pci_stop_host_bridge(host_bridge);
 	} else
 		pci_bridge = bus->self;
@@ -162,8 +163,10 @@ void pci_stop_and_remove_bus(struct pci_bus *bus)
 
 	pci_remove_bus(bus);
 
-	if (host_bridge)
+	if (host_bridge) {
 		host_bridge->bus = NULL;
+		put_device(&host_bridge->dev);
+	}
 
 	if (pci_bridge)
 		pci_bridge->subordinate = NULL;
-- 
1.7.7

