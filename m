Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab2BWUgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:36:21 -0500
Received: from smtp.fireflyinternet.com ([109.228.6.236]:38768 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756616Ab2BWUgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:36:19 -0500
X-Greylist: delayed 2555 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Feb 2012 15:36:19 EST
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Dave Airlie <airlied@redhat.com>, Alex Deucher <alexdeucher@gmail.com>
Subject: [PATCH] drm: Reduce the number of retries whilst reading EDIDs
Date: Thu, 23 Feb 2012 19:52:51 +0000
Message-Id: <1330026771-19937-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <CA+55aFxO27oa+WAtDLuWtr-NFNmKb2T0V6pccn=AE+g5PePPUg@mail.gmail.com>
References: <CA+55aFxO27oa+WAtDLuWtr-NFNmKb2T0V6pccn=AE+g5PePPUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c retries if sees an EGAIN, drm_do_probe_ddc_edid retries until it
gets a result and *then* drm_do_get_edid retries until it gets a result
it is happy with. All in all, that is a lot of processor intensive
looping in cases where we do not expect and cannot get valid data - for
example on Intel with disconnected hardware we will busy-spin until we
hit the i2c timeout. This is then repeated for every connector when
querying the current status of outputs.

So to improve the situation, we can trim the number of retries for
reading the base block and to check for a reschedule before proceeding
so that we do not hog the machine whilst probing outputs. (Though since
we will be likely blocking the graphics device, the user is still going
to notice the latency.)

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Stephan Bärwolf <stephan.baerwolf@tu-ilmenau.de>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Eugeni Dodonov <eugeni.dodonov@intel.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Alex Deucher <alexdeucher@gmail.com>
---
 drivers/gpu/drm/drm_edid.c |   30 +++++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index ece03fc..4409cd4 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -35,6 +35,9 @@
 #include "drm_edid.h"
 #include "drm_edid_modes.h"
 
+#define EDID_PROBE_RETRIES 1
+#define EDID_READ_RETRIES 5
+
 #define version_greater(edid, maj, min) \
 	(((edid)->version > (maj)) || \
 	 ((edid)->version == (maj) && (edid)->revision > (min)))
@@ -239,11 +242,12 @@ EXPORT_SYMBOL(drm_edid_is_valid);
  * Try to fetch EDID information by calling i2c driver function.
  */
 static int
-drm_do_probe_ddc_edid(struct i2c_adapter *adapter, unsigned char *buf,
-		      int block, int len)
+drm_get_edid_block(struct i2c_adapter *adapter,
+		   unsigned char *buf, int block, int len,
+		   int retries)
 {
 	unsigned char start = block * EDID_LENGTH;
-	int ret, retries = 5;
+	int ret;
 
 	/* The core i2c driver will automatically retry the transfer if the
 	 * adapter reports EAGAIN. However, we find that bit-banging transfers
@@ -293,7 +297,19 @@ drm_do_get_edid(struct drm_connector *connector, struct i2c_adapter *adapter)
 
 	/* base block fetch */
 	for (i = 0; i < 4; i++) {
-		if (drm_do_probe_ddc_edid(adapter, block, 0, EDID_LENGTH))
+		/* EDID transfer may be quite processor intensive and last
+		 * a long time. For example, when waiting for a timeout on
+		 * a non-existent connector whilst using bit-banging. As a
+		 * result we can end up hogging the machine, so give someone
+		 * else the chance to run first. But when we have started a
+		 * transfer don't interrupt until finished.
+		 */
+		if (need_resched())
+			schedule();
+
+		if (drm_get_edid_block(adapter,
+				       block, 0, EDID_LENGTH,
+				       EDID_PROBE_RETRIES))
 			goto out;
 		if (drm_edid_block_valid(block))
 			break;
@@ -316,9 +332,9 @@ drm_do_get_edid(struct drm_connector *connector, struct i2c_adapter *adapter)
 
 	for (j = 1; j <= block[0x7e]; j++) {
 		for (i = 0; i < 4; i++) {
-			if (drm_do_probe_ddc_edid(adapter,
+			if (drm_get_edid_block(adapter,
 				  block + (valid_extensions + 1) * EDID_LENGTH,
-				  j, EDID_LENGTH))
+				  j, EDID_LENGTH, EDID_READ_RETRIES))
 				goto out;
 			if (drm_edid_block_valid(block + (valid_extensions + 1) * EDID_LENGTH)) {
 				valid_extensions++;
@@ -362,7 +378,7 @@ drm_probe_ddc(struct i2c_adapter *adapter)
 {
 	unsigned char out;
 
-	return (drm_do_probe_ddc_edid(adapter, &out, 0, 1) == 0);
+	return drm_get_edid_block(adapter, &out, 0, 1, EDID_PROBE_RETRIES) == 0;
 }
 
 /**
-- 
1.7.9.1

