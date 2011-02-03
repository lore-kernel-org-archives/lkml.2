Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab1BCM35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 07:29:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab1BCM34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 07:29:56 -0500
Date: Thu, 3 Feb 2011 14:29:48 +0200
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: [PATCHv2] Fix EDD3.0 data verification.
Message-ID: <20110203122948.GX14984@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for nonzero path in edd_has_edd30() has no sense. First, it looks
at the wrong memory. Device path starts at offset 30 of the info->params
structure which is at offset 8 from the beginning of info structure, but
code looks at info + 4 instead. This was correct when code was introduced,
but around v2.6.4 three more fields were added to edd_info structure
(commit 66b61a5c in history.git). Second, even if it will check correct
memory it will always succeed since at offset 30 (params->key) there will
be non-zero values otherwise previous check would fail.

The patch replaces this bogus check with one that verifies checksum.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
v1->v2
  use device path info length to calculate csum.

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index 96c25d9..f1b7f65 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -531,8 +531,8 @@ static int
 edd_has_edd30(struct edd_device *edev)
 {
 	struct edd_info *info;
-	int i, nonzero_path = 0;
-	char c;
+	int i;
+	u8 csum = 0;
 
 	if (!edev)
 		return 0;
@@ -544,16 +544,16 @@ edd_has_edd30(struct edd_device *edev)
 		return 0;
 	}
 
-	for (i = 30; i <= 73; i++) {
-		c = *(((uint8_t *) info) + i + 4);
-		if (c) {
-			nonzero_path++;
-			break;
-		}
-	}
-	if (!nonzero_path) {
+
+	/* We support only T13 spec */
+	if (info->params.device_path_info_length != 44)
+		return 0;
+
+	for (i = 30; i < info->params.device_path_info_length + 30; i++)
+		csum += *(((u8 *)&info->params) + i);
+
+	if (csum)
 		return 0;
-	}
 
 	return 1;
 }
--
			Gleb.
