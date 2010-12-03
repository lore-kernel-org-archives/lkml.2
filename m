Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab0LCJFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 04:05:19 -0500
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:43587 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab0LCJFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 04:05:12 -0500
Subject: [PATCH] staging/vme_user: fix usage of the slave resources after
	they've been freed
To: Greg KH <greg@kroah.com>
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        "Emilio G. Cota" <cota@braap.org>, LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Date: Fri, 03 Dec 2010 09:05:08 +0000
Message-ID: <20101203090508.31963.9563.stgit@ES-BJ21R4J>
In-Reply-To: <1288055476-19438-24-git-send-email-cota@braap.org>
References: <1288055476-19438-24-git-send-email-cota@braap.org>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
Acked-by: Martyn Welch <martyn.welch@ge.com>
---

 drivers/staging/vme/devices/vme_user.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 3638148..dc7175b 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -829,8 +829,8 @@ err_master:
 err_slave:
 	while (i > SLAVE_MINOR) {
 		i--;
-		vme_slave_free(image[i].resource);
 		buf_unalloc(i);
+		vme_slave_free(image[i].resource);
 	}
 err_class:
 	cdev_del(vme_user_cdev);
@@ -855,8 +855,8 @@ static int __exit vme_user_remove(struct device *dev, int cur_bus, int cur_slot)
 
 	for (i = SLAVE_MINOR; i < (SLAVE_MAX + 1); i++) {
 		vme_slave_set(image[i].resource, 0, 0, 0, 0, VME_A32, 0);
-		vme_slave_free(image[i].resource);
 		buf_unalloc(i);
+		vme_slave_free(image[i].resource);
 	}
 
 	/* Unregister device driver */


--
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
