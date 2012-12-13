Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab2LMOJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:09:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44674 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab2LMOJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:09:46 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jean Delvare <jdelvare@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 141/241] i7300_edac: Fix error flag testing
Date: Thu, 13 Dec 2012 11:58:26 -0200
Message-Id: <1355407206-17100-142-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

commit 7e06b7a3333f5c7a0cec12aff20d39c5c87c0795 upstream.

* Right-shift the values in GET_FBD_FAT_IDX and GET_FBD_NF_IDX, so
  that the callers get the result they expect.
* Fix definition of FERR_FAT_FBD_ERR_MASK.
* Call GET_FBD_NF_IDX, not GET_FBD_FAT_IDX, when operating on
  register FERR_NF_FBD. We were lucky they have the same definition.

This fixes kernel bug #44131:
https://bugzilla.kernel.org/show_bug.cgi?id=44131

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/edac/i7300_edac.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 97c22fd..856a250 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -215,8 +215,8 @@ static const char *ferr_fat_fbd_name[] = {
 	[0]  = "Memory Write error on non-redundant retry or "
 	       "FBD configuration Write error on retry",
 };
-#define GET_FBD_FAT_IDX(fbderr)	(fbderr & (3 << 28))
-#define FERR_FAT_FBD_ERR_MASK ((1 << 0) | (1 << 1) | (1 << 2) | (1 << 3))
+#define GET_FBD_FAT_IDX(fbderr)	(((fbderr) >> 28) & 3)
+#define FERR_FAT_FBD_ERR_MASK ((1 << 0) | (1 << 1) | (1 << 2) | (1 << 22))
 
 #define FERR_NF_FBD	0xa0
 static const char *ferr_nf_fbd_name[] = {
@@ -243,7 +243,7 @@ static const char *ferr_nf_fbd_name[] = {
 	[1]  = "Aliased Uncorrectable Non-Mirrored Demand Data ECC",
 	[0]  = "Uncorrectable Data ECC on Replay",
 };
-#define GET_FBD_NF_IDX(fbderr)	(fbderr & (3 << 28))
+#define GET_FBD_NF_IDX(fbderr)	(((fbderr) >> 28) & 3)
 #define FERR_NF_FBD_ERR_MASK ((1 << 24) | (1 << 23) | (1 << 22) | (1 << 21) |\
 			      (1 << 18) | (1 << 17) | (1 << 16) | (1 << 15) |\
 			      (1 << 14) | (1 << 13) | (1 << 11) | (1 << 10) |\
@@ -482,7 +482,7 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
 		errnum = find_first_bit(&errors,
 					ARRAY_SIZE(ferr_nf_fbd_name));
 		specific = GET_ERR_FROM_TABLE(ferr_nf_fbd_name, errnum);
-		branch = (GET_FBD_FAT_IDX(error_reg) == 2) ? 1 : 0;
+		branch = (GET_FBD_NF_IDX(error_reg) == 2) ? 1 : 0;
 
 		pci_read_config_dword(pvt->pci_dev_16_1_fsb_addr_map,
 			REDMEMA, &syndrome);
-- 
1.7.9.5

