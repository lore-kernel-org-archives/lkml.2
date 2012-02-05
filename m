Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab2BEGze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 01:55:34 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:46714 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2BEGzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 01:55:33 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/9] PCI: Fix /sys warning when sriov enabled card is hot removed
Date: Sat,  4 Feb 2012 22:55:01 -0800
Message-Id: <1328424908-6385-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F2E27DE.0050,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During recent strick checking about sysfs_remove from Eric.
it will spit more bitter warning.

For SRIOV hotplug, we are calling pci_stop_dev() for VF at first.
(after we update pci_stop_bus_devices).

that pci_stop_dev will calling device_unregiste for that VF, so that directory
in VF is removed already.

We double checking if that VF dir in /sys is there, before try removing that
 physfn link.

Signed-of-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/iov.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 0321fa3..dfc7d65 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -173,7 +173,12 @@ static void virtfn_remove(struct pci_dev *dev, int id, int reset)
 
 	sprintf(buf, "virtfn%u", id);
 	sysfs_remove_link(&dev->dev.kobj, buf);
-	sysfs_remove_link(&virtfn->dev.kobj, "physfn");
+	/*
+	 * pci_stop_dev() could be called for this virtfn before already
+	 *  so directory for the virtfn is removed before.
+	 */
+	if (virtfn->dev.kobj.sd)
+		sysfs_remove_link(&virtfn->dev.kobj, "physfn");
 
 	mutex_lock(&iov->dev->sriov->lock);
 	pci_remove_bus_device(virtfn);
-- 
1.7.7

