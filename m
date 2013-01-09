Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3AIJSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 04:18:21 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:54352 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab3AIJR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 04:17:57 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benoit Goby <benoit@android.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] usb: gadget: FunctionFS: Refactor option parsing
Date: Wed,  9 Jan 2013 10:17:48 +0100
Message-Id: <e99aff5e26a233714f8f525131c85384f3d0af41.1357722590.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <a2f4648457ce533fd08d87ac044be5e759b4622b.1357722590.git.mina86@mina86.com>
References: <a2f4648457ce533fd08d87ac044be5e759b4622b.1357722590.git.mina86@mina86.com>
In-Reply-To: <a2f4648457ce533fd08d87ac044be5e759b4622b.1357722590.git.mina86@mina86.com>
References: <a2f4648457ce533fd08d87ac044be5e759b4622b.1357722590.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

The use of memcmp() is clever and all and maybe even it makes parsing a
bit faster (since only options with given length need to be checked) but
option parsing is hardly a critical path and the additional code
complexity is not worth it.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_fs.c |   55 ++++++++++++++------------------------------
 1 files changed, 18 insertions(+), 37 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 38388d7..6a7e187 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1126,45 +1126,26 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 		}
 
 		/* Interpret option */
-		switch (eq - opts) {
-		case 5:
-			if (!memcmp(opts, "rmode", 5))
-				data->root_mode  = (value & 0555) | S_IFDIR;
-			else if (!memcmp(opts, "fmode", 5))
-				data->perms.mode = (value & 0666) | S_IFREG;
-			else
-				goto invalid;
-			break;
-
-		case 4:
-			if (!memcmp(opts, "mode", 4)) {
-				data->root_mode  = (value & 0555) | S_IFDIR;
-				data->perms.mode = (value & 0666) | S_IFREG;
-			} else {
-				goto invalid;
+		if (!strcmp(opts, "rmode")) {
+			data->root_mode  = (value & 0555) | S_IFDIR;
+		} else if (!strcmp(opts, "fmode")) {
+			data->perms.mode = (value & 0666) | S_IFREG;
+		} else if (!strcmp(opts, "mode")) {
+			data->root_mode  = (value & 0555) | S_IFDIR;
+			data->perms.mode = (value & 0666) | S_IFREG;
+		} else if (!strcmp(opts, "uid")) {
+			data->perms.uid = make_kuid(current_user_ns(), value);
+			if (!uid_valid(data->perms.uid)) {
+				pr_err("%s: unmapped value: %lu\n", opts, value);
+				return -EINVAL;
 			}
-			break;
-
-		case 3:
-			if (!memcmp(opts, "uid", 3)) {
-				data->perms.uid = make_kuid(current_user_ns(), value);
-				if (!uid_valid(data->perms.uid)) {
-					pr_err("%s: unmapped value: %lu\n", opts, value);
-					return -EINVAL;
-				}
-			} else if (!memcmp(opts, "gid", 3)) {
-				data->perms.gid = make_kgid(current_user_ns(), value);
-				if (!gid_valid(data->perms.gid)) {
-					pr_err("%s: unmapped value: %lu\n", opts, value);
-					return -EINVAL;
-				}
-			} else {
-				goto invalid;
+		} else if (!strcmp(opts, "gid")) {
+			data->perms.gid = make_kgid(current_user_ns(), value);
+			if (!gid_valid(data->perms.gid)) {
+				pr_err("%s: unmapped value: %lu\n", opts, value);
+				return -EINVAL;
 			}
-			break;
-
-		default:
-invalid:
+		} else {
 			pr_err("%s: invalid option\n", opts);
 			return -EINVAL;
 		}
-- 
1.7.7.3

