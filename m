Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2GKBMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 21:12:51 -0400
Received: from atomicpeace.com ([50.116.19.59]:51301 "EHLO atomicpeace.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab2GKBMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 21:12:48 -0400
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2012 21:12:48 EDT
From: Tim Sally <tsally@atomicpeace.com>
To: tyhicks@canonical.com, dustin.kirkland@gazzang.com
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Sally <tsally@atomicpeace.com>
Subject: [PATCH 1/1] eCryptfs: check for eCryptfs cipher support at mount
Date: Tue, 10 Jul 2012 21:05:51 -0400
Message-Id: <1341968751-28331-2-git-send-email-tsally@atomicpeace.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341968751-28331-1-git-send-email-tsally@atomicpeace.com>
References: <1341968751-28331-1-git-send-email-tsally@atomicpeace.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issue occurs when eCryptfs is mounted with a cipher supported by
the crypto subsystem but not by eCryptfs. The mount succeeds and an
error does not occur until a write. This change checks for eCryptfs
cipher support at mount time.

Resolves Launchpad issue #338914, reported by Tyler Hicks in 03/2009.
https://bugs.launchpad.net/ecryptfs/+bug/338914

Signed-off-by: Tim Sally <tsally@atomicpeace.com>
---
 fs/ecryptfs/main.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index df217dc..4eb1fc6 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -279,6 +279,8 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *options,
 	char *fnek_src;
 	char *cipher_key_bytes_src;
 	char *fn_cipher_key_bytes_src;
+	struct ecryptfs_key_tfm *key_tfm = NULL;
+	u8 cipher_code;
 
 	*check_ruid = 0;
 
@@ -456,6 +458,28 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *options,
 			goto out;
 		}
 	}
+
+	if (!ecryptfs_tfm_exists(mount_crypt_stat->global_default_cipher_name,
+					&key_tfm)) {
+		ecryptfs_printk(KERN_ERR,
+				"Cipher %s was not initalized correctly.\n",
+				mount_crypt_stat->global_default_cipher_name);
+		rc = -EINVAL;
+		mutex_unlock(&key_tfm_list_mutex);
+		goto out;
+	}
+
+	cipher_code = ecryptfs_code_for_cipher_string(key_tfm->cipher_name,
+						key_tfm->key_size);
+	if (!cipher_code) {
+		ecryptfs_printk(KERN_ERR,
+				"eCryptfs doesn't support: %s blocksize %zu.\n",
+				key_tfm->cipher_name, key_tfm->key_size);
+		rc = -EINVAL;
+		mutex_unlock(&key_tfm_list_mutex);
+		goto out;
+	}
+
 	mutex_unlock(&key_tfm_list_mutex);
 	rc = ecryptfs_init_global_auth_toks(mount_crypt_stat);
 	if (rc)
-- 
1.7.10.4

