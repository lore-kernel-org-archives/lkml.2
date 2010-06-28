Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab0F1B2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 21:28:36 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34732 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0F1B2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 21:28:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wWmlP6z0FrJt1VN8RWFmVgsH0R42zRvOXPkemW6JujzkoKpItU5Q6IdqoGyJkfn/gq
         tFSjC9HAMtxPRMHy2/x0bxYY8xEKb2+dnciDOWYCXjmVniIlx9HZF1msjkU8cR5/0jMP
         fb0WlGxf3oAvs9/9qleU6+7ChgFzxsiTLWSRc=
Subject: [PATCH] wmi: fix a memory leak in wmi_notify_debug
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Thomas Renninger <trenn@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Mon, 28 Jun 2010 09:30:45 +0800
Message-Id: <1277688645.22992.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When acpi_evaluate_object() is passed ACPI_ALLOCATE_BUFFER,
the caller must kfree the returned buffer if AE_OK is returned.

The callers of wmi_get_event_data() pass ACPI_ALLOCATE_BUFFER,
and thus must check its return value before accessing
or kfree() on the buffer.

This patch adds return value checking for wmi_get_event_data()
and adds a missing kfree(obj) in the end of wmi_notify_debug

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/wmi.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index e4eaa14..5bb0ae1 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -518,8 +518,13 @@ static void wmi_notify_debug(u32 value, void *context)
 {
 	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
+	acpi_status status;
 
-	wmi_get_event_data(value, &response);
+	status = wmi_get_event_data(value, &response);
+	if (status != AE_OK) {
+		printk(KERN_INFO "wmi: bad event status 0x%x\n", status);
+		return;
+	}
 
 	obj = (union acpi_object *)response.pointer;
 
@@ -543,6 +548,7 @@ static void wmi_notify_debug(u32 value, void *context)
 	default:
 		printk("object type 0x%X\n", obj->type);
 	}
+	kfree(obj);
 }
 
 /**
-- 
1.5.4.3



