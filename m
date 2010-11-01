Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0KAHVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 03:21:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53848 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab0KAHVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 03:21:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=nSlXcSWy+njPWfG7Pj4KvWQpDsZbVW3YfQ4VVDJgeZm7ju2XU82A9so5iYyypdkPbm
         BuueAv6xInzFlycLY1fVdFmZMp+RbsNczcbrZa2210yerIfTzHkqToDaWPCqgY2rZwjq
         V3IpBLMiYuEnKDkhN9LusXa/5Xj4jUhOth5zY=
MIME-Version: 1.0
Date: Mon, 1 Nov 2010 13:21:13 +0600
Message-ID: <AANLkTimWOytXT=jDWTobyvL=xdD7xW7oRqXshULgoF6R@mail.gmail.com>
Subject: [PATCH] acpi: Fix section mismatch warning in osl.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function acpi_os_initialize1() calls acpi_osi_setup_late() which is in
.init.text section and gets called from acpi_bus_init which is in
.init.text section. So mark acpi_os_initialize1() with __init. And
declaration of __init acpi_osi_setup_late has been removed, cause its
defination is above called function.


 WARNING: drivers/acpi/acpi.o(.text+0x460): Section mismatch in
reference from the function acpi_os_initialize1() to the function
.init.text:acpi_osi_setup_late()
The function acpi_os_initialize1() references
the function __init acpi_osi_setup_late().
This is often because acpi_os_initialize1 lacks a __init
annotation or the annotation of acpi_osi_setup_late is wrong.


Thanks,
Rakib


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 966fedd..81de639 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -113,8 +113,6 @@ static DEFINE_SPINLOCK(acpi_ioremap_lock);
 #define	OSI_STRING_LENGTH_MAX 64	/* arbitrary */
 static char osi_setup_string[OSI_STRING_LENGTH_MAX];

-static void __init acpi_osi_setup_late(void);
-
 /*
  * The story of _OSI(Linux)
  *
@@ -1530,7 +1528,7 @@ acpi_status __init acpi_os_initialize(void)
 	return AE_OK;
 }

-acpi_status acpi_os_initialize1(void)
+acpi_status __init acpi_os_initialize1(void)
 {
 	kacpid_wq = create_workqueue("kacpid");
 	kacpi_notify_wq = create_workqueue("kacpi_notify");
