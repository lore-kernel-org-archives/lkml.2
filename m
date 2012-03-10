Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab2CJHIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:08:00 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:25658 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab2CJHCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:02:36 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 18/37] PCI: Use list_for_each_entry_safe instead of list_for_each_safe
Date: Fri,  9 Mar 2012 23:00:18 -0800
Message-Id: <1331362837-10740-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020203.4F5AFC89.004A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So could skip using pci_dev_b().

Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 62c348c..d4fdf7b 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -113,15 +113,15 @@ void pci_stop_and_remove_bus_device(struct pci_dev *dev)
 
 static void __pci_remove_bus_devices(struct pci_bus *bus)
 {
-	struct list_head *l, *n;
+	struct pci_dev *dev, *tmp;
 
-	list_for_each_safe(l, n, &bus->devices)
-		__pci_remove_bus_device(pci_dev_b(l));
+	list_for_each_entry_safe(dev, tmp, &bus->devices, bus_list)
+		__pci_remove_bus_device(dev);
 }
 
 static void pci_stop_bus_devices(struct pci_bus *bus)
 {
-	struct list_head *l, *n;
+	struct pci_dev *dev, *tmp;
 
 	/*
 	 * VFs could be removed by pci_stop_and_remove_bus_device() in the
@@ -131,10 +131,8 @@ static void pci_stop_bus_devices(struct pci_bus *bus)
 	 * We can iterate the list backwards to get prev valid PF instead
 	 *  of removed VF.
 	 */
-	list_for_each_prev_safe(l, n, &bus->devices) {
-		struct pci_dev *dev = pci_dev_b(l);
+	list_for_each_entry_safe_reverse(dev, tmp, &bus->devices, bus_list)
 		pci_stop_bus_device(dev);
-	}
 }
 
 /**
-- 
1.7.7

