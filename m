Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab2CATfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:35:39 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46304 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab2CATfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:35:37 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/6] vt: sort out locking for font handling
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Thu, 01 Mar 2012 19:49:55 +0000
Message-ID: <20120301194945.11322.59535.stgit@bob.linux.org.uk>
In-Reply-To: <20120301194831.11322.38295.stgit@bob.linux.org.uk>
References: <20120301194831.11322.38295.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The font methods are console_lock covered. Unfortunately they don't extend
the lock over all the needed tests.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/vt/vt.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)


diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 8205578..8439303 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3972,9 +3972,6 @@ static int con_font_get(struct vc_data *vc, struct console_font_op *op)
 	int rc = -EINVAL;
 	int c;
 
-	if (vc->vc_mode != KD_TEXT)
-		return -EINVAL;
-
 	if (op->data) {
 		font.data = kmalloc(max_font_size, GFP_KERNEL);
 		if (!font.data)
@@ -3983,7 +3980,9 @@ static int con_font_get(struct vc_data *vc, struct console_font_op *op)
 		font.data = NULL;
 
 	console_lock();
-	if (vc->vc_sw->con_font_get)
+	if (vc->vc_mode != KD_TEXT)
+		rc = -EINVAL;
+	else if (vc->vc_sw->con_font_get)
 		rc = vc->vc_sw->con_font_get(vc, &font);
 	else
 		rc = -ENOSYS;
@@ -4065,7 +4064,9 @@ static int con_font_set(struct vc_data *vc, struct console_font_op *op)
 	if (IS_ERR(font.data))
 		return PTR_ERR(font.data);
 	console_lock();
-	if (vc->vc_sw->con_font_set)
+	if (vc->vc_mode != KD_TEXT)
+		rc = -EINVAL;
+	else if (vc->vc_sw->con_font_set)
 		rc = vc->vc_sw->con_font_set(vc, &font, op->flags);
 	else
 		rc = -ENOSYS;
@@ -4081,8 +4082,6 @@ static int con_font_default(struct vc_data *vc, struct console_font_op *op)
 	char *s = name;
 	int rc;
 
-	if (vc->vc_mode != KD_TEXT)
-		return -EINVAL;
 
 	if (!op->data)
 		s = NULL;
@@ -4092,6 +4091,10 @@ static int con_font_default(struct vc_data *vc, struct console_font_op *op)
 		name[MAX_FONT_NAME - 1] = 0;
 
 	console_lock();
+	if (vc->vc_mode != KD_TEXT) {
+		console_unlock();
+		return -EINVAL;
+	}
 	if (vc->vc_sw->con_font_default)
 		rc = vc->vc_sw->con_font_default(vc, &font, s);
 	else
@@ -4109,11 +4112,11 @@ static int con_font_copy(struct vc_data *vc, struct console_font_op *op)
 	int con = op->height;
 	int rc;
 
-	if (vc->vc_mode != KD_TEXT)
-		return -EINVAL;
 
 	console_lock();
-	if (!vc->vc_sw->con_font_copy)
+	if (vc->vc_mode != KD_TEXT)
+		rc = -EINVAL;
+	else if (!vc->vc_sw->con_font_copy)
 		rc = -ENOSYS;
 	else if (con < 0 || !vc_cons_allocated(con))
 		rc = -ENOTTY;

