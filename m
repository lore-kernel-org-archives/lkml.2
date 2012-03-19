Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161959Ab2CSGAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:00:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30770 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161488Ab2CSFsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:48:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 25/47] Fix an access-after-free issue in function pci_stop_and_remove_bus()
Date: Sun, 18 Mar 2012 22:46:14 -0700
Message-Id: <1332135996-13860-26-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F66C88C.0027,ss=1,re=0.000,fgs=0
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
index 75b0092..18efb31 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -186,6 +186,7 @@ void pci_stop_and_remove_bus(struct pci_bus *bus)
 
 	if (pci_is_root_bus(bus)) {
 		host_bridge = to_pci_host_bridge(bus->bridge);
+		get_device(&host_bridge->dev);
 		pci_stop_host_bridge(host_bridge);
 	} else
 		pci_bridge = bus->self;
@@ -194,8 +195,10 @@ void pci_stop_and_remove_bus(struct pci_bus *bus)
 
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

