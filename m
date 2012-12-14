Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab2LNQHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:07:43 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44463 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab2LNQHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:07:40 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv2 06/11] remoteproc: Add resource entry number to callbacks
Date: Fri, 14 Dec 2012 17:06:55 +0100
Message-Id: <1355501220-4572-7-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add information on the resource entry sequence number
to the callback functions.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index ea4b76a..2c78ea5 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -43,9 +43,8 @@
 
 #include "remoteproc_internal.h"
 
-typedef int (*rproc_handle_resources_t)(struct rproc *rproc,
-				struct resource_table *table, int len);
-typedef int (*rproc_handle_resource_t)(struct rproc *rproc, void *, int avail);
+typedef int (*rproc_handle_resource_t)(struct rproc *rproc, void *,
+							int avail, int seqno);
 
 /* Unique indices for remoteproc devices */
 static DEFINE_IDA(rproc_dev_index);
@@ -300,6 +299,7 @@ void rproc_free_vring(struct rproc_vring *rvring)
  * @rproc: the remote processor
  * @rsc: the vring resource descriptor
  * @avail: size of available data (for sanity checking the image)
+ * @seqno: resource entry sequence number
  *
  * This resource entry requests the host to statically register a virtio
  * device (vdev), and setup everything needed to support it. It contains
@@ -323,7 +323,7 @@ void rproc_free_vring(struct rproc_vring *rvring)
  * Returns 0 on success, or an appropriate error code otherwise
  */
 static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
-								int avail)
+							int avail, int seqno)
 {
 	struct device *dev = &rproc->dev;
 	struct rproc_vdev *rvdev;
@@ -389,6 +389,7 @@ free_rvdev:
  * @rproc: the remote processor
  * @rsc: the trace resource descriptor
  * @avail: size of available data (for sanity checking the image)
+ * @seqno: resource entry sequence number
  *
  * In case the remote processor dumps trace logs into memory,
  * export it via debugfs.
@@ -401,7 +402,7 @@ free_rvdev:
  * Returns 0 on success, or an appropriate error code otherwise
  */
 static int rproc_handle_trace(struct rproc *rproc, struct fw_rsc_trace *rsc,
-								int avail)
+							int avail, int seqno)
 {
 	struct rproc_mem_entry *trace;
 	struct device *dev = &rproc->dev;
@@ -462,6 +463,7 @@ static int rproc_handle_trace(struct rproc *rproc, struct fw_rsc_trace *rsc,
  * @rproc: remote processor handle
  * @rsc: the devmem resource entry
  * @avail: size of available data (for sanity checking the image)
+ * @seqno: resource entry sequence number
  *
  * Remote processors commonly need to access certain on-chip peripherals.
  *
@@ -483,7 +485,7 @@ static int rproc_handle_trace(struct rproc *rproc, struct fw_rsc_trace *rsc,
  * are outside those ranges.
  */
 static int rproc_handle_devmem(struct rproc *rproc, struct fw_rsc_devmem *rsc,
-								int avail)
+							int avail, int seqno)
 {
 	struct rproc_mem_entry *mapping;
 	struct device *dev = &rproc->dev;
@@ -542,6 +544,7 @@ out:
  * @rproc: rproc handle
  * @rsc: the resource entry
  * @avail: size of available data (for image validation)
+ * @seqno: resource entry sequence number
  *
  * This function will handle firmware requests for allocation of physically
  * contiguous memory regions.
@@ -556,7 +559,7 @@ out:
  * pressure is important; it may have a substantial impact on performance.
  */
 static int rproc_handle_carveout(struct rproc *rproc,
-				struct fw_rsc_carveout *rsc, int avail)
+			struct fw_rsc_carveout *rsc, int avail, int seqno)
 {
 	struct rproc_mem_entry *carveout, *mapping;
 	struct device *dev = &rproc->dev;
@@ -722,7 +725,7 @@ rproc_handle_resource(struct rproc *rproc, struct resource_table *table,
 		if (!handler)
 			continue;
 
-		ret = handler(rproc, rsc, avail);
+		ret = handler(rproc, rsc, avail, i);
 		if (ret)
 			break;
 	}
-- 
1.7.5.4

