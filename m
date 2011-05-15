Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150Ab1EOQ2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:28:49 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:8033 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043Ab1EOQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:28:48 -0400
Date: Sun, 15 May 2011 18:27:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] Make dmi_name_in_vendors more focused
Message-ID: <20110515182721.56a10c35@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of dmi_name_in_vendors() is an invitation
to lazy coding and false positives [1]. Searching for a string in 8
different DMI fields is something nobody should ever need to do. You
know what you're looking for, so you should know where to look. strstr
isn't fast, especially when it fails, so we should avoid calling it
when it just can't succeed.

Looking at the current users of the function, it seems clear to me
that they are looking for a system or board vendor name, so let's
limit dmi_name_in_vendors to these two DMI fields. This much better
matches the function name, BTW.

[1] We currently have code looking for short names in DMI data, such
as "IBM", "ASUS" or "Acer". I let you guess what will happen the day
other vendors ship products named, for example, "SCHREIBMEISTER",
"PEGASUS" or "Acerola".

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Andi Kleen <andi@firstfloor.org>
---
 drivers/firmware/dmi_scan.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.39-rc7.orig/drivers/firmware/dmi_scan.c	2011-03-15 22:52:48.000000000 +0100
+++ linux-2.6.39-rc7/drivers/firmware/dmi_scan.c	2011-05-15 15:05:29.000000000 +0200
@@ -585,14 +585,12 @@ int dmi_name_in_serial(const char *str)
 }
 
 /**
- *	dmi_name_in_vendors - Check if string is anywhere in the DMI vendor information.
+ *	dmi_name_in_vendors - Check if string is in the DMI system or board vendor name
  *	@str: 	Case sensitive Name
  */
 int dmi_name_in_vendors(const char *str)
 {
-	static int fields[] = { DMI_BIOS_VENDOR, DMI_BIOS_VERSION, DMI_SYS_VENDOR,
-				DMI_PRODUCT_NAME, DMI_PRODUCT_VERSION, DMI_BOARD_VENDOR,
-				DMI_BOARD_NAME, DMI_BOARD_VERSION, DMI_NONE };
+	static int fields[] = { DMI_SYS_VENDOR, DMI_BOARD_VENDOR, DMI_NONE };
 	int i;
 	for (i = 0; fields[i] != DMI_NONE; i++) {
 		int f = fields[i];


-- 
Jean Delvare
