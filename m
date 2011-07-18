Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1GRUbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 16:31:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab1GRUbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:31:16 -0400
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, mikew@google.com, tony.luck@intel.com
Subject: [PATCH 8/9] efivars: Use string functions in pstore_write
Date: Mon, 18 Jul 2011 16:30:32 -0400
Message-Id: <1311021033-7483-9-git-send-email-mjg@redhat.com>
In-Reply-To: <1311021033-7483-1-git-send-email-mjg@redhat.com>
References: <1311021033-7483-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:721a:4ff:fed2:9f6c
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

Instead of open-coding the string operations for comparing the prefix of
the variable names, use the provided utf16_* string functions.

This patch also changes the calls to efi.set_variable to
efivars->ops->set_variable so that the right function gets called in the
case of gsmi (which doesn't have a valid efi structure).

As well, make sure that we only consider variables with the right vendor
string.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/efivars.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 15b9a01..563492e 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -512,18 +512,20 @@ static u64 efi_pstore_write(enum pstore_type_id type, unsigned int part,
 	list_for_each_entry(entry, &efivars->list, list) {
 		get_var_data_locked(efivars, &entry->var);
 
-		for (i = 0; i < DUMP_NAME_LEN; i++) {
-			if (efi_name[i] == 0) {
-				found = entry;
-				efivars->ops->set_variable(entry->var.VariableName,
-							   &entry->var.VendorGuid,
-							   EFI_VARIABLE_NON_VOLATILE | EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
-							   0, NULL);
-				break;
-			} else if (efi_name[i] != entry->var.VariableName[i]) {
-				break;
-			}
-		}
+		if (efi_guidcmp(entry->var.VendorGuid, vendor))
+			continue;
+		if (utf16_strncmp(entry->var.VariableName, efi_name,
+				  utf16_strlen(efi_name)))
+			continue;
+		/* Needs to be a prefix */
+		if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
+			continue;
+
+		/* found */
+		found = entry;
+		efivars->ops->set_variable(entry->var.VariableName, &entry->var.VendorGuid,
+					   EFI_VARIABLE_NON_VOLATILE | EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
+					   0, NULL);
 	}
 
 	if (found)
-- 
1.7.6

