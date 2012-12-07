Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423977Ab2LGBEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:04:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61365 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423583Ab2LGBAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:00:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <jdelvare@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Doug Thompson <dougthompson@xmission.com>
Subject: [ 16/27] i7300_edac: Fix error flag testing
Date: Thu,  6 Dec 2012 16:59:00 -0800
Message-Id: <20121207005830.523517702@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Acked-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/i7300_edac.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -197,8 +197,8 @@ static const char *ferr_fat_fbd_name[] =
 	[0]  = "Memory Write error on non-redundant retry or "
 	       "FBD configuration Write error on retry",
 };
-#define GET_FBD_FAT_IDX(fbderr)	(fbderr & (3 << 28))
-#define FERR_FAT_FBD_ERR_MASK ((1 << 0) | (1 << 1) | (1 << 2) | (1 << 3))
+#define GET_FBD_FAT_IDX(fbderr)	(((fbderr) >> 28) & 3)
+#define FERR_FAT_FBD_ERR_MASK ((1 << 0) | (1 << 1) | (1 << 2) | (1 << 22))
 
 #define FERR_NF_FBD	0xa0
 static const char *ferr_nf_fbd_name[] = {
@@ -225,7 +225,7 @@ static const char *ferr_nf_fbd_name[] =
 	[1]  = "Aliased Uncorrectable Non-Mirrored Demand Data ECC",
 	[0]  = "Uncorrectable Data ECC on Replay",
 };
-#define GET_FBD_NF_IDX(fbderr)	(fbderr & (3 << 28))
+#define GET_FBD_NF_IDX(fbderr)	(((fbderr) >> 28) & 3)
 #define FERR_NF_FBD_ERR_MASK ((1 << 24) | (1 << 23) | (1 << 22) | (1 << 21) |\
 			      (1 << 18) | (1 << 17) | (1 << 16) | (1 << 15) |\
 			      (1 << 14) | (1 << 13) | (1 << 11) | (1 << 10) |\
@@ -464,7 +464,7 @@ static void i7300_process_fbd_error(stru
 		errnum = find_first_bit(&errors,
 					ARRAY_SIZE(ferr_nf_fbd_name));
 		specific = GET_ERR_FROM_TABLE(ferr_nf_fbd_name, errnum);
-		branch = (GET_FBD_FAT_IDX(error_reg) == 2) ? 1 : 0;
+		branch = (GET_FBD_NF_IDX(error_reg) == 2) ? 1 : 0;
 
 		pci_read_config_dword(pvt->pci_dev_16_1_fsb_addr_map,
 			REDMEMA, &syndrome);


