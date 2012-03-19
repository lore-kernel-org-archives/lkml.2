Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161825Ab2CSFtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:49:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29755 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab2CSFsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:48:55 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 20/47] Correctly clean up pci root buses in function pci_remove_bus()
Date: Sun, 18 Mar 2012 22:46:09 -0700
Message-Id: <1332135996-13860-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F66C885.0080,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

The function pci_create_root_bus() allocates the pci bus structure,
registers the bus device and creates the legacy files for a pci root
bus, but returns without setting the is_added flag. The is_added flag
for a pci root bus will be set by function pci_scan_child_bus().
If a pci root bus is destroyed before calling pci_scan_child_bus(),
the is_added flag will not be set.  So teach function pci_remove_bus()
to detect such a case and correctly clean up pci root buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 04a4861..bf4b46b 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -70,11 +70,10 @@ void pci_remove_bus(struct pci_bus *pci_bus)
 	list_del(&pci_bus->node);
 	pci_bus_release_busn_res(pci_bus);
 	up_write(&pci_bus_sem);
-	if (!pci_bus->is_added)
-		return;
-
-	pci_remove_legacy_files(pci_bus);
-	device_unregister(&pci_bus->dev);
+	if (pci_bus->is_added || pci_is_root_bus(pci_bus)) {
+		pci_remove_legacy_files(pci_bus);
+		device_unregister(&pci_bus->dev);
+	}
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
-- 
1.7.7

