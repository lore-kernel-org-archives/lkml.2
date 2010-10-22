Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0JVHRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:17:21 -0400
Received: from beaker.bytemark.co.uk ([80.68.81.2]:49498 "EHLO
	beaker.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab0JVHRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:17:20 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [PATCH 23/30] staging/vme_user: fix usage of the slave resources after they've been freed
Date: Fri, 22 Oct 2010 02:36:45 -0400
Message-Id: <1287729412-24356-24-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

buf_unalloc() frees the memory buffers allocated with vme_alloc_consistent.
The associated VME resource is needed in both vme_alloc_consistent and
vme_free_consistent; however the slave VME resources are being freed before
the calls to vme_free_consistent are made, which means the buffers
are never returned.

Fix this by freeing the VME resources only after the consistent buffers have
been returned.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/devices/vme_user.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 5def455..95c22ff 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -826,8 +826,8 @@ err_master:
 err_slave:
 	while (i > SLAVE_MINOR) {
 		i--;
-		vme_slave_free(image[i].resource);
 		buf_unalloc(i);
+		vme_slave_free(image[i].resource);
 	}
 err_class:
 	cdev_del(vme_user_cdev);
@@ -852,8 +852,8 @@ static int __devexit vme_user_remove(struct device *dev, int cur_bus, int cur_sl
 
 	for (i = SLAVE_MINOR; i < (SLAVE_MAX + 1); i++) {
 		vme_slave_set(image[i].resource, 0, 0, 0, 0, VME_A32, 0);
-		vme_slave_free(image[i].resource);
 		buf_unalloc(i);
+		vme_slave_free(image[i].resource);
 	}
 
 	/* Unregister device driver */
-- 
1.7.1

