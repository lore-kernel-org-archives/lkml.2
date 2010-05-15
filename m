Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab0EOVW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:22:28 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:51489 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab0EOVWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:22:23 -0400
Date: Sat, 15 May 2010 23:22:18 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 30/37] drivers/platform/x86: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152322010.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kmemdup when some other buffer is immediately copied into the
allocated region.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
statement S;
@@

-  to = \(kmalloc\|kzalloc\)(size,flag);
+  to = kmemdup(from,size,flag);
   if (to==NULL || ...) S
-  memcpy(to, from, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/platform/x86/wmi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -u -p a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -756,12 +756,10 @@ static __init acpi_status parse_wdg(acpi
 
 	total = obj->buffer.length / sizeof(struct guid_block);
 
-	gblock = kzalloc(obj->buffer.length, GFP_KERNEL);
+	gblock = kmemdup(obj->buffer.pointer, obj->buffer.length, GFP_KERNEL);
 	if (!gblock)
 		return AE_NO_MEMORY;
 
-	memcpy(gblock, obj->buffer.pointer, obj->buffer.length);
-
 	for (i = 0; i < total; i++) {
 		/*
 		  Some WMI devices, like those for nVidia hooks, have a
