Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825Ab0FCDpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 23:45:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43899 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933805Ab0FCDpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 23:45:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=x5vOw+Qm2ri9Pl7XKG1yFTDderp59ULdUSwSMFyJJzWw/tVDkG0XRMIK8cGmtWAJfN
         +7DtBogyGFLc1haiVHyQdSQSraGsGeHAMGfLDJM1AzrDnn3Mix8EyX6OTl+6ysaa3jsh
         KEuauc7r+XUaQg3gPX28Rx9UsiAkWF6bwOYoU=
Subject: [PATCH] wmi: fix memory leak in parse_wdg
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Thomas Renninger <trenn@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Thu, 03 Jun 2010 11:45:45 +0800
Message-Id: <1275536745.9797.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch properly kfree out.pointer and gblock in error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/wmi.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index e4eaa14..bb8a3c6 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -827,8 +827,10 @@ static __init acpi_status parse_wdg(acpi_handle handle)
 	total = obj->buffer.length / sizeof(struct guid_block);
 
 	gblock = kmemdup(obj->buffer.pointer, obj->buffer.length, GFP_KERNEL);
-	if (!gblock)
-		return AE_NO_MEMORY;
+	if (!gblock) {
+		status = AE_NO_MEMORY;
+		goto out_free_pointer;
+	}
 
 	for (i = 0; i < total; i++) {
 		/*
@@ -848,8 +850,10 @@ static __init acpi_status parse_wdg(acpi_handle handle)
 			wmi_dump_wdg(&gblock[i]);
 
 		wblock = kzalloc(sizeof(struct wmi_block), GFP_KERNEL);
-		if (!wblock)
-			return AE_NO_MEMORY;
+		if (!wblock) {
+			status = AE_NO_MEMORY;
+			goto out_free_gblock;
+		}
 
 		wblock->gblock = gblock[i];
 		wblock->handle = handle;
@@ -860,8 +864,10 @@ static __init acpi_status parse_wdg(acpi_handle handle)
 		list_add_tail(&wblock->list, &wmi_blocks.list);
 	}
 
-	kfree(out.pointer);
+out_free_gblock:
 	kfree(gblock);
+out_free_pointer:
+	kfree(out.pointer);
 
 	return status;
 }
-- 
1.5.4.3



