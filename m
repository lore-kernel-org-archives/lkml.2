Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab1APTRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 14:17:30 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15695 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab1APTR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 14:17:27 -0500
Date: Sun, 16 Jan 2011 20:17:25 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: James Bottomley <James.Bottomley@suse.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Fix memory leak in fd_set_configfs_dev_params().
Message-ID: <alpine.LNX.2.00.1101162006410.13377@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

match_strdup() dynamically allocates memory and it is the responsabillity 
of the caller to free that memory. In 
drivers/target/target_core_file.c::fd_set_configfs_dev_params() two calls 
are made to match_strdup() and in neither case is the allocated memory 
freed, but instead it is leaked.

This patch should take care of the problem by kfree()'ing the allocated 
memory once it is no longer needed. It also makes sure to return -ENOMEM 
if the memory allocation in match_strdup() should fail.

Please review and consider for inclusion.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 target_core_file.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

  compile tested only.

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 0aaca88..676a010 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -537,15 +537,26 @@ static ssize_t fd_set_configfs_dev_params(
 		token = match_token(ptr, tokens, args);
 		switch (token) {
 		case Opt_fd_dev_name:
+			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
 			snprintf(fd_dev->fd_dev_name, FD_MAX_DEV_NAME,
-					"%s", match_strdup(&args[0]));
+					"%s", arg_p);
+			kfree(arg_p);
 			printk(KERN_INFO "FILEIO: Referencing Path: %s\n",
 					fd_dev->fd_dev_name);
 			fd_dev->fbd_flags |= FBDF_HAS_PATH;
 			break;
 		case Opt_fd_dev_size:
 			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
 			ret = strict_strtoull(arg_p, 0, &fd_dev->fd_dev_size);
+			kfree(arg_p);
 			if (ret < 0) {
 				printk(KERN_ERR "strict_strtoull() failed for"
 						" fd_dev_size=\n");


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

