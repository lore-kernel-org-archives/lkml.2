Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab2EPGvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:51:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759282Ab2EPGvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:51:40 -0400
From: Hannes Reinecke <hare@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Gleb Natapov <gleb@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] EDD: Check for correct EDD 3.0 length
Date: Wed, 16 May 2012 08:51:36 +0200
Message-Id: <1337151096-38511-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two competing EDD 3.0 specifications,
the original one from Phoenix
<http://mbldr.sourceforge.net/specsedd30.pdf>
and the T-13 approved one
<http://www.t13.org/documents/UploadedDocuments/docs2004/d1572r3-EDD3.pdf>

They differ in the length of the device_path field, which
is one quad word for the Phoenix spec and two quad words
for the T-13 spec. So we need to test for both lengths
and blank out the second quad word when a Phoenix
version is detected.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index e229576..beedf4c 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -192,6 +192,13 @@ edd_show_interface(struct edd_device *edev, char *buf)
 			p += scnprintf(p, left, " ");
 		}
 	}
+	/*
+	 * Phoenix EDD 3.0 reserves only one quad word for the
+	 * device path, so blank out the second quad word.
+	 */
+	if (info->params.device_path_info_length == 36)
+		info->params.device_path.unknown.reserved2 = 0;
+
 	if (!strncmp(info->params.interface_type, "ATAPI", 5)) {
 		p += scnprintf(p, left, "\tdevice: %u  lun: %u\n",
 			     info->params.device_path.atapi.device,
@@ -545,8 +552,12 @@ edd_has_edd30(struct edd_device *edev)
 	}
 
 
-	/* We support only T13 spec */
-	if (info->params.device_path_info_length != 44)
+	/*
+	 * Phoenix EDD 3.0 specifies this to be 36,
+	 * T-13 EDD 3.0 uses 44. So check for both.
+	 */
+	if (info->params.device_path_info_length != 36 &&
+	    info->params.device_path_info_length != 44)
 		return 0;
 
 	for (i = 30; i < info->params.device_path_info_length + 30; i++)
