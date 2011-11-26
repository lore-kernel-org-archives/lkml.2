Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab1KZKCL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 05:02:11 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:44125 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab1KZKBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 05:01:32 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: platform-driver-x86@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>,
        Corentin Chary <corentincj@iksaif.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/16] samsung-laptop: dump model and version informations
Date: Sat, 26 Nov 2011 11:00:11 +0100
Message-Id: <1322301613-8801-15-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
References: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We still need to figure out exactly what each of different fields
represent, but they contain at least model and version informations.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/samsung-laptop.c |   42 +++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 5e8bca1..487a1f0 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -303,6 +303,7 @@ struct samsung_laptop_debug {
 
 	struct debugfs_blob_wrapper f0000_wrapper;
 	struct debugfs_blob_wrapper data_wrapper;
+	struct debugfs_blob_wrapper sdiag_wrapper;
 };
 
 struct samsung_laptop;
@@ -337,6 +338,8 @@ struct samsung_laptop {
 
 	bool handle_backlight;
 	bool has_stepping_quirk;
+
+	char sdiag[64];
 };
 
 
@@ -1164,6 +1167,9 @@ static int samsung_debugfs_init(struct samsung_laptop *samsung)
 	samsung->debug.data_wrapper.data = &samsung->debug.data;
 	samsung->debug.data_wrapper.size = sizeof(samsung->debug.data);
 
+	samsung->debug.sdiag_wrapper.data = samsung->sdiag;
+	samsung->debug.sdiag_wrapper.size = strlen(samsung->sdiag);
+
 	dent = debugfs_create_u16("command", S_IRUGO | S_IWUSR,
 				  samsung->debug.root, &samsung->debug.command);
 	if (!dent)
@@ -1207,6 +1213,12 @@ static int samsung_debugfs_init(struct samsung_laptop *samsung)
 	if (!dent)
 		goto error_debugfs;
 
+	dent = debugfs_create_blob("sdiag", S_IRUGO | S_IWUSR,
+				   samsung->debug.root,
+				   &samsung->debug.sdiag_wrapper);
+	if (!dent)
+		goto error_debugfs;
+
 	return 0;
 
 error_debugfs:
@@ -1259,6 +1271,34 @@ static __init void samsung_sabi_infos(struct samsung_laptop *samsung, int loca,
 	printk(KERN_DEBUG " SABI pointer = 0x%08x\n", ifaceP);
 }
 
+static void __init samsung_sabi_diag(struct samsung_laptop *samsung)
+{
+	int loca = find_signature(samsung->f0000_segment, "SDiaG@");
+	int i;
+
+	if (loca == 0xffff)
+		return ;
+
+	/* Example:
+	 * Ident: @SDiaG@686XX-N90X3A/966-SEC-07HL-S90X3A
+	 *
+	 * Product name: 90X3A
+	 * BIOS Version: 07HL
+	 */
+	loca += 1;
+	for (i = 0; loca < 0xffff && i < sizeof(samsung->sdiag) - 1; loca++) {
+		char temp = readb(samsung->f0000_segment + loca);
+
+		if (isalnum(temp) || temp == '/' || temp == '-')
+			samsung->sdiag[i++] = temp;
+		else
+			break ;
+	}
+
+	if (debug && samsung->sdiag[0])
+		pr_info("sdiag: %s", samsung->sdiag);
+}
+
 static int __init samsung_sabi_init(struct samsung_laptop *samsung)
 {
 	const struct sabi_config *config = NULL;
@@ -1276,6 +1316,8 @@ static int __init samsung_sabi_init(struct samsung_laptop *samsung)
 		goto exit;
 	}
 
+	samsung_sabi_diag(samsung);
+
 	/* Try to find one of the signatures in memory to find the header */
 	for (i = 0; sabi_configs[i].test_string != 0; ++i) {
 		samsung->config = &sabi_configs[i];
-- 
1.7.5.4

