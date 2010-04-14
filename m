Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0DNUqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:46:34 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54182 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab0DNUqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:46:32 -0400
Message-ID: <4BC629A5.4040500@canonical.com>
Date: Wed, 14 Apr 2010 16:46:29 -0400
From: "Peter M. Petrakis" <peter.petrakis@canonical.com>
Organization: Canonical USA Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100404 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Reset ps/2 port should psmouse_probe fail before retrying
Content-Type: multipart/mixed;
 boundary="------------000001030100080907070605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000001030100080907070605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Filed a bug on this too:

https://bugzilla.kernel.org/show_bug.cgi?id=15780

This particular laptop will lose it's synaptics touch
pad on return from suspend state. Reloading the psmouse
module makes no difference. I came up with the attached
work around which simply calls psmouse_reset on the
port should the initial probe fail. This solves the problem
for me and I've tested this on several laptops.

Initially discovered on Ubuntu 2.6.31 (karmic) and the problem
continues to exist in lucid 2.6.32. I've filed a bug against
ubuntu kernel here:

https://bugs.launchpad.net/oem-priority/+bug/551234

though the Ubuntu kernel team would really like to get upstream's
input on the matter before accepting the patch. Please
let me know what you think. Thanks.

Peter



--------------000001030100080907070605
Content-Type: text/x-diff;
 name="psmouse_reset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="psmouse_reset.patch"

diff --git a/psmouse-base.c b/psmouse-base.c
index b407b35..d79eafc 100644
--- a/psmouse-base.c
+++ b/psmouse-base.c
@@ -856,12 +856,12 @@ static const struct psmouse_protocol *psmouse_protocol_by_name(const char *name,
 	return NULL;
 }
 
-
 /*
- * psmouse_probe() probes for a PS/2 mouse.
+ * __psmouse_probe() probes for a PS/2 mouse.
+ * Wrapped by psmouse_probe() for clean reset code.
  */
 
-static int psmouse_probe(struct psmouse *psmouse)
+static int __psmouse_probe(struct psmouse *psmouse)
 {
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	unsigned char param[2];
@@ -892,6 +892,23 @@ static int psmouse_probe(struct psmouse *psmouse)
 }
 
 /*
+ * Wrapper for probe routine to cleanly reset the device should
+ * the initial probe fail for any reason.
+ */
+static int psmouse_probe(struct psmouse *psmouse) {
+	struct ps2dev *ps2dev = &psmouse->ps2dev;
+	int i, ret = -1;
+
+	for (i=0; ((ret = __psmouse_probe(psmouse)) != 0) && i < 3; i++) {
+		printk(KERN_ERR "psmouse.c: Error encountered while probing"
+			" PS/2 device on %s, reseting.\n", ps2dev->serio->phys);
+		psmouse_reset(psmouse);
+	}
+
+	return ret;
+}
+
+/*
  * Here we set the mouse resolution.
  */
 

--------------000001030100080907070605--
