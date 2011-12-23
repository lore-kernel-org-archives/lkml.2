Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab1LWRkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 12:40:21 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:43315 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab1LWRjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 12:39:48 -0500
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] drivers/staging/media/as102/as102_usb_drv.c: shift position of allocation code
Date: Fri, 23 Dec 2011 18:39:34 +0100
Message-Id: <1324661974-17281-9-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conditional after the kzalloc says that the tested expression should
never be true, but if it were, the allocated data would have to be freed.
This change just moves the allocation below the test, to avoid any
possibility of the problem.

A simplified version of the semantic match that finds the problem is as
follows: (http://coccinelle.lip6.fr)

// <smpl>
@r exists@
local idexpression x;
statement S;
identifier f1;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
x->f1
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/media/as102/as102_usb_drv.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index 7bcb28c..d775be0 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -353,12 +353,6 @@ static int as102_usb_probe(struct usb_interface *intf,
 
 	ENTER();
 
-	as102_dev = kzalloc(sizeof(struct as102_dev_t), GFP_KERNEL);
-	if (as102_dev == NULL) {
-		err("%s: kzalloc failed", __func__);
-		return -ENOMEM;
-	}
-
 	/* This should never actually happen */
 	if ((sizeof(as102_usb_id_table) / sizeof(struct usb_device_id)) !=
 	    (sizeof(as102_device_names) / sizeof(const char *))) {
@@ -366,6 +360,12 @@ static int as102_usb_probe(struct usb_interface *intf,
 		return -EINVAL;
 	}
 
+	as102_dev = kzalloc(sizeof(struct as102_dev_t), GFP_KERNEL);
+	if (as102_dev == NULL) {
+		err("%s: kzalloc failed", __func__);
+		return -ENOMEM;
+	}
+
 	/* Assign the user-friendly device name */
 	for (i = 0; i < (sizeof(as102_usb_id_table) /
 			 sizeof(struct usb_device_id)); i++) {

