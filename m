Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab0EOVTj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:19:39 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:51365 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab0EOVTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:19:36 -0400
Date: Sat, 15 May 2010 23:19:30 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 21/37] drivers/hid: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152319150.21345@ask.diku.dk>
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
 drivers/hid/hid-core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -653,10 +653,9 @@ int hid_parse_report(struct hid_device *
 	if (device->driver->report_fixup)
 		device->driver->report_fixup(device, start, size);
 
-	device->rdesc = kmalloc(size, GFP_KERNEL);
+	device->rdesc = kmemdup(start, size, GFP_KERNEL);
 	if (device->rdesc == NULL)
 		return -ENOMEM;
-	memcpy(device->rdesc, start, size);
 	device->rsize = size;
 
 	parser = vmalloc(sizeof(struct hid_parser));
