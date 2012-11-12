Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab2KLV3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:29:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45235 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab2KLV3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:29:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Tim Sally <tsally@atomicpeace.com>
Cc: Tyler Hicks <tyhicks@canonical.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [ 3.5.yuz extended stable] Patch "eCryptfs: check for eCryptfs cipher support at mount" has been added to staging queue
Date: Mon, 12 Nov 2012 19:29:09 -0200
Message-Id: <1352755749-16301-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    eCryptfs: check for eCryptfs cipher support at mount

to the linux-3.5.y-queue branch of the 3.5.yuz extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.5.y-queue

If you, or anyone else, feels it should not be added to the 3.5
Linux kernel, or for any feedback related to it, please reply to
this email. For more information on extended stable, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Herton

------

>From 13ec618bc5059edd78da95b3ce90610bab3e9519 Mon Sep 17 00:00:00 2001
From: Tim Sally <tsally@atomicpeace.com>
Date: Thu, 12 Jul 2012 19:10:24 -0400
Subject: [PATCH] eCryptfs: check for eCryptfs cipher support at mount

commit 5f5b331d5c21228a6519dcb793fc1629646c51a6 upstream.

The issue occurs when eCryptfs is mounted with a cipher supported by
the crypto subsystem but not by eCryptfs. The mount succeeds and an
error does not occur until a write. This change checks for eCryptfs
cipher support at mount time.

Resolves Launchpad issue #338914, reported by Tyler Hicks in 03/2009.
https://bugs.launchpad.net/ecryptfs/+bug/338914

Signed-off-by: Tim Sally <tsally@atomicpeace.com>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ecryptfs/main.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index c2a9c39..240832e 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -280,6 +280,7 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *options,
 	char *fnek_src;
 	char *cipher_key_bytes_src;
 	char *fn_cipher_key_bytes_src;
+	u8 cipher_code;

 	*check_ruid = 0;

@@ -421,6 +422,18 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *options,
 	    && !fn_cipher_key_bytes_set)
 		mount_crypt_stat->global_default_fn_cipher_key_bytes =
 			mount_crypt_stat->global_default_cipher_key_size;
+
+	cipher_code = ecryptfs_code_for_cipher_string(
+		mount_crypt_stat->global_default_cipher_name,
+		mount_crypt_stat->global_default_cipher_key_size);
+	if (!cipher_code) {
+		ecryptfs_printk(KERN_ERR,
+				"eCryptfs doesn't support cipher: %s",
+				mount_crypt_stat->global_default_cipher_name);
+		rc = -EINVAL;
+		goto out;
+	}
+
 	mutex_lock(&key_tfm_list_mutex);
 	if (!ecryptfs_tfm_exists(mount_crypt_stat->global_default_cipher_name,
 				 NULL)) {
--
1.7.9.5

