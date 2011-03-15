Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab1COOLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:11:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19784 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431Ab1COOLo (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 15 Mar 2011 10:11:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: xen-devel@lists.xensource.com, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, dgdegra@tycho.nsa.gov
Subject: [PATCH 1/4] xen-fbfront: Read width/height from backend
Date: Tue, 15 Mar 2011 10:11:12 -0400
Message-Id: <1300198274-1325-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300198274-1325-1-git-send-email-konrad.wilk@oracle.com>
References: <1300198274-1325-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D7F7394.00FD,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel De Graaf <dgdegra@tycho.nsa.gov>

This allows the backend driver to specify the size of the framebuffer
instead of requiring it to be on the kernel command line.

Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Ian Campbell <Ian.Campbell@eu.citrix.com>
---
 drivers/video/xen-fbfront.c |   30 ++++++++++++++++++++++++------
 1 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index a20218c..56d6061 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -58,7 +58,7 @@ struct xenfb_info {
 #define XENFB_DEFAULT_FB_LEN (XENFB_WIDTH * XENFB_HEIGHT * XENFB_DEPTH / 8)
 
 enum { KPARAM_MEM, KPARAM_WIDTH, KPARAM_HEIGHT, KPARAM_CNT };
-static int video[KPARAM_CNT] = { 2, XENFB_WIDTH, XENFB_HEIGHT };
+static int video[KPARAM_CNT] = { 0, 0, 0 };
 module_param_array(video, int, NULL, 0);
 MODULE_PARM_DESC(video,
 	"Video memory size in MB, width, height in pixels (default 2,800,600)");
@@ -363,7 +363,7 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 {
 	struct xenfb_info *info;
 	struct fb_info *fb_info;
-	int fb_size;
+	int fb_size, fb_need;
 	int val;
 	int ret;
 
@@ -375,14 +375,32 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 
 	/* Limit kernel param videoram amount to what is in xenstore */
 	if (xenbus_scanf(XBT_NIL, dev->otherend, "videoram", "%d", &val) == 1) {
-		if (val < video[KPARAM_MEM])
+		if (!video[KPARAM_MEM] || val < video[KPARAM_MEM])
 			video[KPARAM_MEM] = val;
 	}
 
+	/* Take width/height from xenstore if not set on command line */
+	if (!video[KPARAM_WIDTH]) {
+		if (xenbus_scanf(XBT_NIL, dev->otherend, "width", "%d", &val) == 1)
+			video[KPARAM_WIDTH] = val;
+		else
+			video[KPARAM_WIDTH] = XENFB_WIDTH;
+	}
+	if (!video[KPARAM_HEIGHT]) {
+		if (xenbus_scanf(XBT_NIL, dev->otherend, "height", "%d", &val) == 1)
+			video[KPARAM_HEIGHT] = val;
+		else
+			video[KPARAM_HEIGHT] = XENFB_HEIGHT;
+	}
+
+	fb_need = video[KPARAM_WIDTH] * video[KPARAM_HEIGHT] * XENFB_DEPTH / 8;
+	if (video[KPARAM_MEM])
+		fb_size = video[KPARAM_MEM] * 1024 * 1024;
+	else
+		fb_size = video[KPARAM_MEM] = fb_need;
+
 	/* If requested res does not fit in available memory, use default */
-	fb_size = video[KPARAM_MEM] * 1024 * 1024;
-	if (video[KPARAM_WIDTH] * video[KPARAM_HEIGHT] * XENFB_DEPTH / 8
-	    > fb_size) {
+	if (fb_need > fb_size) {
 		video[KPARAM_WIDTH] = XENFB_WIDTH;
 		video[KPARAM_HEIGHT] = XENFB_HEIGHT;
 		fb_size = XENFB_DEFAULT_FB_LEN;
-- 
1.7.1

