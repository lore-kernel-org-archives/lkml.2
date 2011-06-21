Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab1FUUSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:18:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40529 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab1FUUSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:18:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=I5Vi2Qy2wW7W81CtEd00JA3vCAlNv8jickc5mNM91I1I2FwoRx++34apDfhvVebKo
	LWxEOVf+iZqJ+VvYhZu6A==
From: Mike Waychison <mikew@google.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org, Matt_Domsch@dell.com,
        Mike Waychison <mikew@google.com>
Subject: [PATCH 3/4] efivars: Use string functions in pstore_write
Date: Tue, 21 Jun 2011 13:18:31 -0700
Message-Id: <1308687512-11649-3-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <BANLkTi=qmS090MK=sx=xMN95zD5AtNkuLG_g092oVXJezoRCYA@mail.gmail.com>
References: <BANLkTi=qmS090MK=sx=xMN95zD5AtNkuLG_g092oVXJezoRCYA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of open-coding the string operations for comparing the prefix of
the variable names, use the provided utf16_* string functions.

This patch also changes the calls to efi.set_variable to
efivars->ops->set_variable so that the right function gets called in the
case of gsmi (which doesn't have a valid efi structure).

As well, make sure that we only consider variables with the right vendor
string.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/efivars.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index fb1219a..f424b10 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -511,17 +511,20 @@ static u64 efi_pstore_write(enum pstore_type_id type, int part, size_t size,
 	list_for_each_entry(entry, &efivars->list, list) {
 		get_var_data_locked(efivars, &entry->var);
 
-		for (i = 0; i < DUMP_NAME_LEN; i++) {
-			if (efi_name[i] == 0) {
-				found = entry;
-				efi.set_variable(entry->var.VariableName, &entry->var.VendorGuid,
-						 EFI_VARIABLE_NON_VOLATILE | EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
-						 0, NULL);
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
@@ -530,9 +533,9 @@ static u64 efi_pstore_write(enum pstore_type_id type, int part, size_t size,
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
 
-	efi.set_variable(efi_name, &vendor,
-			 EFI_VARIABLE_NON_VOLATILE | EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
-			 size, psi->buf);
+	efivars->ops->set_variable(efi_name, &vendor,
+				   EFI_VARIABLE_NON_VOLATILE | EFI_VARIABLE_BOOTSERVICE_ACCESS | EFI_VARIABLE_RUNTIME_ACCESS,
+				   size, psi->buf);
 
 	spin_unlock(&efivars->lock);
 
-- 
1.7.3.1

