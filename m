Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab1FFP5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:57:46 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59252 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1FFP5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:57:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kKpICNiqqiUJES1hunOLI9OV+MqCWC2Z+4ZnDiKi8XnJnEZbQEB8JVAezHLjslFI6V
         EywZNIAMfmP9F2bOt0FA9e0eh0zVuS0bJc/o/m2ioUz3EBrJLChvV/tuLPvGuhnlFKVz
         RULG9UWdSYsiM8UKOVZy3JNGaALGrUCcvff5s=
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        Jim Bos <jim876@xs4all.nl>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
Subject: [PATCH] x86, efi: free memory with the correct call
Date: Mon,  6 Jun 2011 17:56:53 +0200
Message-Id: <1307375813-14438-1-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 916f676f8dc introduced a call to free_bootmem_late while it
reserves memory with memblock_x64_reserve_range
Fix this call to silence the swapper BUGs:

BUG: Bad page state in process swapper  pfn:00000

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Tested-by: Jim Bos <jim876@xs4all.nl>
---
 arch/x86/platform/efi/efi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0d3a4fa..d2eefaa 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -29,7 +29,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/efi.h>
-#include <linux/bootmem.h>
 #include <linux/memblock.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
@@ -334,7 +333,7 @@ static void __init efi_free_boot_services(void)
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
-		free_bootmem_late(start, size);
+		memblock_x86_free_memory_in_range(start, start + size);
 	}
 }
 
-- 
1.7.4.1

