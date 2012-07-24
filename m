Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab2GXBim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:38:42 -0400
Received: from marvin.crapouillou.net ([109.190.31.181]:54129 "EHLO
	marvin.crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab2GXBiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:38:11 -0400
From: Paul Cercueil <paul@crapouillou.net>
To: FlorianSchandinat@gmx.de
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 1/4] fbcon: use kstrtouint instead of deprecated function simple_strtoul.
Date: Tue, 24 Jul 2012 03:00:23 +0200
Message-Id: <1343091626-11435-1-git-send-email-paul@crapouillou.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/video/console/fbcon.c |  102 ++++++++++++++++++++++++++++-------------
 1 file changed, 69 insertions(+), 33 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 2e471c2..a0b1818 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -435,7 +435,7 @@ static void fbcon_del_cursor_timer(struct fb_info *info)
 static int __init fb_console_setup(char *this_opt)
 {
 	char *options;
-	int i, j;
+	int i, j, ret;
 
 	if (!this_opt || !*this_opt)
 		return 1;
@@ -445,18 +445,29 @@ static int __init fb_console_setup(char *this_opt)
 			strcpy(fontname, options + 5);
 		
 		if (!strncmp(options, "scrollback:", 11)) {
+			char *k;
 			options += 11;
-			if (*options) {
-				fbcon_softback_size = simple_strtoul(options, &options, 0);
-				if (*options == 'k' || *options == 'K') {
-					fbcon_softback_size *= 1024;
-					options++;
-				}
-				if (*options != ',')
-					return 1;
-				options++;
-			} else
-				return 1;
+			k = options;
+
+			while (*k != '\0' && *k != 'k' && *k != 'K')
+				k++;
+
+			/* Clear the 'k' or 'K' suffix to
+			 * prevent errors with kstrtouint */
+			if (*k != '\0')
+				*k++ = '\0';
+			else
+				k = NULL;
+
+			ret = kstrtouint(options, 0, (unsigned int *)
+						&fbcon_softback_size);
+
+			if (!ret && k)
+				fbcon_softback_size *= 1024;
+
+			/* (k && *k): Check for garbage after the suffix */
+			if (ret || (k && *k))
+				pr_warn("fbcon: scrollback: incorrect value.\n");
 		}
 		
 		if (!strncmp(options, "map:", 4)) {
@@ -476,22 +487,44 @@ static int __init fb_console_setup(char *this_opt)
 		}
 
 		if (!strncmp(options, "vc:", 3)) {
+			char *dash;
 			options += 3;
-			if (*options)
-				first_fb_vc = simple_strtoul(options, &options, 10) - 1;
-			if (first_fb_vc < 0)
-				first_fb_vc = 0;
-			if (*options++ == '-')
-				last_fb_vc = simple_strtoul(options, &options, 10) - 1;
-			fbcon_is_default = 0; 
-		}	
+
+			dash = strchr(options, '-');
+			if (dash)
+				*dash++ = '\0';
+
+			ret = kstrtouint(options, 10,
+						(unsigned int *) &first_fb_vc);
+			if (!ret) {
+				if (--first_fb_vc < 0)
+					first_fb_vc = 0;
+
+				if (dash) {
+					ret = kstrtouint(dash, 10,
+								(unsigned int *)
+								&last_fb_vc);
+					if (!ret)
+						last_fb_vc--;
+				}
+			}
+
+			if (!ret)
+				fbcon_is_default = 0;
+			else
+				pr_warn("fbcon: vc: incorrect value.\n");
+		}
 
 		if (!strncmp(options, "rotate:", 7)) {
 			options += 7;
-			if (*options)
-				initial_rotation = simple_strtoul(options, &options, 0);
-			if (initial_rotation > 3)
-				initial_rotation = 0;
+			ret = kstrtouint(options, 0, (unsigned int *)
+						&initial_rotation);
+			if (!ret) {
+				if (initial_rotation > 3)
+					initial_rotation = 0;
+			} else {
+				pr_warn("fbcon: rotate: incorrect value.\n");
+			}
 		}
 	}
 	return 1;
@@ -3312,8 +3345,8 @@ static ssize_t store_rotate(struct device *device,
 			    size_t count)
 {
 	struct fb_info *info;
-	int rotate, idx;
-	char **last = NULL;
+	int idx;
+	unsigned int rotate;
 
 	if (fbcon_has_exited)
 		return count;
@@ -3325,7 +3358,8 @@ static ssize_t store_rotate(struct device *device,
 		goto err;
 
 	info = registered_fb[idx];
-	rotate = simple_strtoul(buf, last, 0);
+	if (kstrtouint(buf, 0, &rotate))
+		goto err;
 	fbcon_rotate(info, rotate);
 err:
 	console_unlock();
@@ -3337,8 +3371,8 @@ static ssize_t store_rotate_all(struct device *device,
 				size_t count)
 {
 	struct fb_info *info;
-	int rotate, idx;
-	char **last = NULL;
+	int idx;
+	unsigned int rotate;
 
 	if (fbcon_has_exited)
 		return count;
@@ -3350,7 +3384,8 @@ static ssize_t store_rotate_all(struct device *device,
 		goto err;
 
 	info = registered_fb[idx];
-	rotate = simple_strtoul(buf, last, 0);
+	if (kstrtouint(buf, 0, &rotate))
+		goto err;
 	fbcon_rotate_all(info, rotate);
 err:
 	console_unlock();
@@ -3412,8 +3447,8 @@ static ssize_t store_cursor_blink(struct device *device,
 				  const char *buf, size_t count)
 {
 	struct fb_info *info;
-	int blink, idx;
-	char **last = NULL;
+	int idx;
+	unsigned int blink;
 
 	if (fbcon_has_exited)
 		return count;
@@ -3429,7 +3464,8 @@ static ssize_t store_cursor_blink(struct device *device,
 	if (!info->fbcon_par)
 		goto err;
 
-	blink = simple_strtoul(buf, last, 0);
+	if (kstrtouint(buf, 0, &blink))
+		goto err;
 
 	if (blink) {
 		fbcon_cursor_noblink = 0;
-- 
1.7.10.4

