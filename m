Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab1LNVHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:07:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758118Ab1LNVGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:06:50 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mikew@google.com, x86@kernel.org, hpa@zytor.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/4] efi: Only create sysfs entries while booting or running
Date: Wed, 14 Dec 2011 16:06:29 -0500
Message-Id: <1323896791-10858-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1323896791-10858-1-git-send-email-mjg@redhat.com>
References: <1323896791-10858-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no point in creating sysfs entries while the machine's on its way
down. Skip it in that case in order to avoid complexity.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/firmware/efivars.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index b0a8117..eb07f13 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -552,11 +552,18 @@ static int efi_pstore_write(enum pstore_type_id type, u64 *id,
 	if (found)
 		efivar_unregister(found);
 
-	if (size)
-		ret = efivar_create_sysfs_entry(efivars,
-					  utf16_strsize(efi_name,
-							DUMP_NAME_LEN * 2),
-					  efi_name, &vendor);
+	if (size) {
+		switch (system_state) {
+		case SYSTEM_BOOTING:
+		case SYSTEM_RUNNING:
+			ret = efivar_create_sysfs_entry(efivars,
+							utf16_strsize(efi_name,
+							    DUMP_NAME_LEN * 2),
+							efi_name, &vendor);
+		default:
+			break;
+		}
+	}
 
 	*id = part;
 	return ret;
-- 
1.7.7.1

