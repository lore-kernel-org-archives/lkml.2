Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab0GFCza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 22:55:30 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36057 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab0GFCz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 22:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=OY8qbbm12i2flNb0TYHQE0QHFrFhFq6p9VRe8qwgcO4UAJ11ZKH6v4zN0jJHqLbvFH
         sExxJxk6xunAZHQLVx+TBPqFH0GqP6EMWELX+wxY3vlK6fDuMQo7rFIOtsGtl9JosLPF
         zu8xljSUkqMQln1aDBIthCmUvxpiCw6Mxp/Zo=
Subject: [PATCH] acer-wmi: fix memory leaks in WMID_set_capabilities and
	get_wmid_devices
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Tue, 06 Jul 2010 10:55:36 +0800
Message-Id: <1278384936.12801.17.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When acpi_evaluate_object() is passed ACPI_ALLOCATE_BUFFER,
the caller must kfree the returned buffer if AE_OK is returned.

The callers of wmi_query_block() pass ACPI_ALLOCATE_BUFFER,
and thus must check its return value before accessing
or kfree() on the buffer.

This patch adds a missing kfree(out.pointer) before exit
WMID_set_capabilities() and get_wmid_devices().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/acer-wmi.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 1ea6c43..fe644c6 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -772,6 +772,7 @@ static acpi_status WMID_set_capabilities(void)
 		obj->buffer.length == sizeof(u32)) {
 		devices = *((u32 *) obj->buffer.pointer);
 	} else {
+		kfree(out.pointer);
 		return AE_ERROR;
 	}
 
@@ -788,6 +789,7 @@ static acpi_status WMID_set_capabilities(void)
 	if (!(devices & 0x20))
 		max_brightness = 0x9;
 
+	kfree(out.pointer);
 	return status;
 }
 
@@ -1095,6 +1097,7 @@ static u32 get_wmid_devices(void)
 	struct acpi_buffer out = {ACPI_ALLOCATE_BUFFER, NULL};
 	union acpi_object *obj;
 	acpi_status status;
+	u32 devices = 0;
 
 	status = wmi_query_block(WMID_GUID2, 1, &out);
 	if (ACPI_FAILURE(status))
@@ -1103,10 +1106,11 @@ static u32 get_wmid_devices(void)
 	obj = (union acpi_object *) out.pointer;
 	if (obj && obj->type == ACPI_TYPE_BUFFER &&
 		obj->buffer.length == sizeof(u32)) {
-		return *((u32 *) obj->buffer.pointer);
-	} else {
-		return 0;
+		devices = *((u32 *) obj->buffer.pointer);
 	}
+
+	kfree(out.pointer);
+	return devices;
 }
 
 /*
-- 
1.5.4.3



