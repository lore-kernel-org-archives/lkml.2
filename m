Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162128Ab2CSGB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:01:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30709 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161376Ab2CSFr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:47:56 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 23/47] PCI: Use list_for_each_entry_safe instead of list_for_each_safe
Date: Sun, 18 Mar 2012 22:46:12 -0700
Message-Id: <1332135996-13860-24-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F66C889.00A1,ss=1,re=0.000,fgs=0
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
index 4bdda43..64ba5b1 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -112,15 +112,15 @@ void pci_stop_and_remove_bus_device(struct pci_dev *dev)
 
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
@@ -130,10 +130,8 @@ static void pci_stop_bus_devices(struct pci_bus *bus)
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

