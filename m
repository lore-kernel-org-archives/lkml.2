Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3AHC2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:28:33 -0500
Received: from amsterdam.lcs.mit.edu ([18.26.4.9]:35303 "EHLO
	amsterdam.lcs.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3AHC2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:28:32 -0500
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andy Walls <awalls@md.metrocast.net>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/media/pci: use memmove for overlapping regions
Date: Mon,  7 Jan 2013 21:28:05 -0500
Message-Id: <1357612085-30075-1-git-send-email-nickolai@csail.mit.edu>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change several memcpy() to memmove() in cases when the regions are
definitely overlapping; memcpy() of overlapping regions is undefined
behavior in C and can produce different results depending on the compiler,
the memcpy implementation, etc.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 drivers/media/pci/bt8xx/dst_ca.c  |    4 ++--
 drivers/media/pci/cx18/cx18-vbi.c |    2 +-
 drivers/media/pci/ivtv/ivtv-vbi.c |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
index 7d96fab..0e788fc 100644
--- a/drivers/media/pci/bt8xx/dst_ca.c
+++ b/drivers/media/pci/bt8xx/dst_ca.c
@@ -180,11 +180,11 @@ static int ca_get_app_info(struct dst_state *state)
 	put_command_and_length(&state->messages[0], CA_APP_INFO, length);
 
 	// Copy application_type, application_manufacturer and manufacturer_code
-	memcpy(&state->messages[4], &state->messages[7], 5);
+	memmove(&state->messages[4], &state->messages[7], 5);
 
 	// Set string length and copy string
 	state->messages[9] = str_length;
-	memcpy(&state->messages[10], &state->messages[12], str_length);
+	memmove(&state->messages[10], &state->messages[12], str_length);
 
 	return 0;
 }
diff --git a/drivers/media/pci/cx18/cx18-vbi.c b/drivers/media/pci/cx18/cx18-vbi.c
index 6d3121f..add9964 100644
--- a/drivers/media/pci/cx18/cx18-vbi.c
+++ b/drivers/media/pci/cx18/cx18-vbi.c
@@ -84,7 +84,7 @@ static void copy_vbi_data(struct cx18 *cx, int lines, u32 pts_stamp)
 		   (the max size of the VBI data is 36 * 43 + 4 bytes).
 		   So in this case we use the magic number 'ITV0'. */
 		memcpy(dst + sd, "ITV0", 4);
-		memcpy(dst + sd + 4, dst + sd + 12, line * 43);
+		memmove(dst + sd + 4, dst + sd + 12, line * 43);
 		size = 4 + ((43 * line + 3) & ~3);
 	} else {
 		memcpy(dst + sd, "itv0", 4);
diff --git a/drivers/media/pci/ivtv/ivtv-vbi.c b/drivers/media/pci/ivtv/ivtv-vbi.c
index 293db80..3c156bc 100644
--- a/drivers/media/pci/ivtv/ivtv-vbi.c
+++ b/drivers/media/pci/ivtv/ivtv-vbi.c
@@ -224,7 +224,7 @@ static void copy_vbi_data(struct ivtv *itv, int lines, u32 pts_stamp)
 		   (the max size of the VBI data is 36 * 43 + 4 bytes).
 		   So in this case we use the magic number 'ITV0'. */
 		memcpy(dst + sd, "ITV0", 4);
-		memcpy(dst + sd + 4, dst + sd + 12, line * 43);
+		memmove(dst + sd + 4, dst + sd + 12, line * 43);
 		size = 4 + ((43 * line + 3) & ~3);
 	} else {
 		memcpy(dst + sd, "itv0", 4);
@@ -532,7 +532,7 @@ void ivtv_vbi_work_handler(struct ivtv *itv)
 		while (vi->cc_payload_idx) {
 			cc = vi->cc_payload[0];
 
-			memcpy(vi->cc_payload, vi->cc_payload + 1,
+			memmove(vi->cc_payload, vi->cc_payload + 1,
 					sizeof(vi->cc_payload) - sizeof(vi->cc_payload[0]));
 			vi->cc_payload_idx--;
 			if (vi->cc_payload_idx && cc.odd[0] == 0x80 && cc.odd[1] == 0x80)
-- 
1.7.10.4

