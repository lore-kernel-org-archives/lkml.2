Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0JVHMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:12:53 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:50816 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab0JVHMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:12:43 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [PATCH 09/30] staging/vme: fill in struct device's .release, even if it's a NOOP
Date: Fri, 22 Oct 2010 02:36:31 -0400
Message-Id: <1287729412-24356-10-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Without it we get 32 warnings, one per device being released, when
removing a bridge module.

After applying this patch, bridge modules can at last be removed
without any apparent hiccup.

[Note: tested only on the tsi148, it's the only bridge I've got]

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/vme.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index afd2dbd..59650dd 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -1352,6 +1352,11 @@ static void vme_free_bus_num(int bus)
 	mutex_unlock(&vme_bus_num_mtx);
 }
 
+/* Note: device_release(dev) throws a warning if dev->release isn't filled in */
+static void vme_dev_release(struct device *dev)
+{
+}
+
 int vme_register_bridge(struct vme_bridge *bridge)
 {
 	struct device *dev;
@@ -1372,6 +1377,7 @@ int vme_register_bridge(struct vme_bridge *bridge)
 
 		dev->parent = bridge->parent;
 		dev->bus = &vme_bus_type;
+		dev->release = vme_dev_release;
 		/*
 		 * We save a pointer to the bridge in platform_data so that we
 		 * can get to it later. We keep driver_data for use by the
-- 
1.7.1

