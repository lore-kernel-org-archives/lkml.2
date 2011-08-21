Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab1HUCpM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 22:45:12 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36040 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1HUCpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 22:45:09 -0400
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Harvey Yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 1/1] devtmpfs: Fix section mismatch warning
Date: Sun, 21 Aug 2011 10:44:15 +0800
Message-Id: <1313894655-3783-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/base/built-in.o(.text+0xe554): Section mismatch in reference f
rom the function devtmpfsd() to the variable .init.data:setup_done
The function devtmpfsd() references
the variable __initdata setup_done.
This is often because devtmpfsd lacks a __initdata
annotation or the annotation of setup_done is wrong.

"setup_done" is not used after init. but putting it into initdata section leads a section mismatch warning, so initialize it dynamically in __init function.

Signed-off-by: Harvey Yang <harvey.huawei.yang@gmail.com>
---
 drivers/base/devtmpfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 33e1bed..d26b47b 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -376,7 +376,6 @@ int devtmpfs_mount(const char *mntdir)
 	return err;
 }
 
-static __initdata DECLARE_COMPLETION(setup_done);
 
 static int handle(const char *name, mode_t mode, struct device *dev)
 {
@@ -430,6 +429,9 @@ out:
  */
 int __init devtmpfs_init(void)
 {
+	struct compiletion setup_done;
+	init_compiletion(&setup_done);
+
 	int err = register_filesystem(&dev_fs_type);
 	if (err) {
 		printk(KERN_ERR "devtmpfs: unable to register devtmpfs "
-- 
1.7.2.5

