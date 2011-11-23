Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1KWB3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:29:12 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41705 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab1KWB3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:29:11 -0500
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, Corentin Chary <corentincj@iksaif.net>,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH] acer-wmi: check wireless capability on AMW0_GUID2 machines
Date: Wed, 23 Nov 2011 09:27:09 +0800
Message-Id: <1322011629-9034-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lee, Chun-Yi" <jlee@suse.com>

Have many non-acer machines have AMW0_GUID2 method in DSDT, in
original acer-wmi design, driver direct set ACER_CAP_WIRELESS flag
for those machines but didn't check the functionality for set/get
wireless state.
It causes acer-wmi driver create a broken wireless rfkill and it
already set to soft blocked.

So, this patch add a wireless capability check before we set
ACER_CAP_WIRELESS flag to the machines that were included AMW0_GUID2.
It avoid acer-wmi create a broken wireless rfkill.

Thank's for Matthew Garrett give the idea.

Reference: brc#674353
        https://bugzilla.redhat.com/show_bug.cgi?id=674353

Tested on Lenovo E520.
Tested on Acer TravelMate 4750.

Tested-by: mr.kobzar <mr.kobzar@gmail.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/platform/x86/acer-wmi.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 88dfecf..5dfa46a 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -678,6 +678,37 @@ static acpi_status AMW0_find_mailled(void)
 	return AE_OK;
 }
 
+static void AMW0_GUID2_set_capabilities(void)
+{
+	acpi_status status;
+	u32 original_state, new_state;
+
+	/* set wireless capability when detected has quirk */
+	if (quirks->wireless > 0) {
+		interface->capability |= ACER_CAP_WIRELESS;
+		return;
+	}
+
+	status = AMW0_get_u32(&original_state, ACER_CAP_WIRELESS);
+	if (ACPI_FAILURE(status))
+		return;
+
+	status = AMW0_set_u32(!original_state, ACER_CAP_WIRELESS);
+	if (ACPI_FAILURE(status))
+		return;
+
+	status = AMW0_get_u32(&new_state, ACER_CAP_WIRELESS);
+	if (ACPI_FAILURE(status))
+		return;
+
+	status = AMW0_set_u32(original_state, ACER_CAP_WIRELESS);
+	if (ACPI_FAILURE(status))
+		return;
+
+	if (new_state != original_state)
+		interface->capability |= ACER_CAP_WIRELESS;
+}
+
 static acpi_status AMW0_set_capabilities(void)
 {
 	struct wmab_args args;
@@ -691,7 +722,7 @@ static acpi_status AMW0_set_capabilities(void)
 	 * work.
 	 */
 	if (wmi_has_guid(AMW0_GUID2)) {
-		interface->capability |= ACER_CAP_WIRELESS;
+		AMW0_GUID2_set_capabilities();
 		return AE_OK;
 	}
 
-- 
1.7.7

