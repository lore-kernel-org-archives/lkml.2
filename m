Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab1EIWEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:04:49 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47432
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754628Ab1EIVop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:45 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 043/206] Staging: hv: Get rid of the forward declaration for do_bounce_buffer()
Date: Mon,  9 May 2011 14:55:25 -0700
Message-Id: <1304978288-22999-43-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration by moving the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   55 ++++++++++++++++++-------------------
 1 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index bf5b138..9380866 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -163,6 +163,33 @@ static void destroy_bounce_buffer(struct scatterlist *sgl,
 	kfree(sgl);
 }
 
+static int do_bounce_buffer(struct scatterlist *sgl, unsigned int sg_count)
+{
+	int i;
+
+	/* No need to check */
+	if (sg_count < 2)
+		return -1;
+
+	/* We have at least 2 sg entries */
+	for (i = 0; i < sg_count; i++) {
+		if (i == 0) {
+			/* make sure 1st one does not have hole */
+			if (sgl[i].offset + sgl[i].length != PAGE_SIZE)
+				return i;
+		} else if (i == sg_count - 1) {
+			/* make sure last one does not have hole */
+			if (sgl[i].offset != 0)
+				return i;
+		} else {
+			/* make sure no hole in the middle */
+			if (sgl[i].length != PAGE_SIZE || sgl[i].offset != 0)
+				return i;
+		}
+	}
+	return -1;
+}
+
 /* Static decl */
 static int storvsc_probe(struct hv_device *dev);
 static int storvsc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd);
@@ -172,7 +199,6 @@ static int storvsc_remove(struct hv_device *dev);
 static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl,
 						unsigned int sg_count,
 						unsigned int len);
-static int do_bounce_buffer(struct scatterlist *sgl, unsigned int sg_count);
 static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 					    struct scatterlist *bounce_sgl,
 					    unsigned int orig_sgl_count);
@@ -499,33 +525,6 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 	kmem_cache_free(host_dev->request_pool, cmd_request);
 }
 
-static int do_bounce_buffer(struct scatterlist *sgl, unsigned int sg_count)
-{
-	int i;
-
-	/* No need to check */
-	if (sg_count < 2)
-		return -1;
-
-	/* We have at least 2 sg entries */
-	for (i = 0; i < sg_count; i++) {
-		if (i == 0) {
-			/* make sure 1st one does not have hole */
-			if (sgl[i].offset + sgl[i].length != PAGE_SIZE)
-				return i;
-		} else if (i == sg_count - 1) {
-			/* make sure last one does not have hole */
-			if (sgl[i].offset != 0)
-				return i;
-		} else {
-			/* make sure no hole in the middle */
-			if (sgl[i].length != PAGE_SIZE || sgl[i].offset != 0)
-				return i;
-		}
-	}
-	return -1;
-}
-
 static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl,
 						unsigned int sg_count,
 						unsigned int len)
-- 
1.7.4.1

