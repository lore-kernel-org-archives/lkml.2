Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab0GIDvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:51:04 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43556 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab0GIDvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:51:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Gv2XqOS+r/CEE9WsUgGI/iuOb0ZIyumk9KZjJQ9LdkyER9nnMqOgEyAdowZXee8Fdo
         5iNZbf9YtNxdTkIm56BNDLkRxFL7TP+q+YjnOklBbTyXGNdAdV2UFEdbsOb/EIhmiNTW
         +W3hwcdKbUCuc28ilR68qdZdG/7HOaAShwf+M=
Subject: [PATCH] acer-wmi: fix memory leaks in wmab_execute error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Matthew Garrett <mjg@redhat.com>, Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Fri, 09 Jul 2010 11:51:15 +0800
Message-Id: <1278647475.26099.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When acpi_evaluate_object() is passed ACPI_ALLOCATE_BUFFER,
the caller must kfree the returned buffer if AE_OK is returned.

Call Trace:
wmab_execute
  -> wmi_evaluate_method
    -> acpi_evaluate_object

Thus if callers of wmab_execute() pass ACPI_ALLOCATE_BUFFER,
the return buffer must be kfreed if wmab_execute return AE_OK.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/acer-wmi.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 1ea6c43..a158d39 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -555,6 +555,7 @@ static acpi_status AMW0_find_mailled(void)
 	obj->buffer.length == sizeof(struct wmab_ret)) {
 		ret = *((struct wmab_ret *) obj->buffer.pointer);
 	} else {
+		kfree(out.pointer);
 		return AE_ERROR;
 	}
 
@@ -598,6 +599,7 @@ static acpi_status AMW0_set_capabilities(void)
 	obj->buffer.length == sizeof(struct wmab_ret)) {
 		ret = *((struct wmab_ret *) obj->buffer.pointer);
 	} else {
+		kfree(out.pointer);
 		return AE_ERROR;
 	}
 
@@ -607,15 +609,24 @@ static acpi_status AMW0_set_capabilities(void)
 	args.ebx = 2 << 8;
 	args.ebx |= ACER_AMW0_BLUETOOTH_MASK;
 
+	/*
+	 * It's ok to use existing buffer for next wmab_execute call.
+	 * But we need to kfree(out.pointer) if next wmab_execute call
+	 * returns AE_BUFFER_OVERFLOW.
+	 */
 	status = wmab_execute(&args, &out);
-	if (ACPI_FAILURE(status))
+	if (ACPI_FAILURE(status)) {
+		if (status == AE_BUFFER_OVERFLOW)
+			kfree(out.pointer);
 		return status;
+	}
 
 	obj = (union acpi_object *) out.pointer;
 	if (obj && obj->type == ACPI_TYPE_BUFFER
 	&& obj->buffer.length == sizeof(struct wmab_ret)) {
 		ret = *((struct wmab_ret *) obj->buffer.pointer);
 	} else {
+		kfree(out.pointer);
 		return AE_ERROR;
 	}
 
-- 
1.5.4.3



