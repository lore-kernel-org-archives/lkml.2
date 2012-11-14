Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab2KNFuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:50:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55033 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881Ab2KNFuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:21 -0500
Message-Id: <20121114053944.584134565@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:51 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Sally <tsally@atomicpeace.com>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: [ 78/82] eCryptfs: check for eCryptfs cipher support at mount
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Sally <tsally@atomicpeace.com>

commit 5f5b331d5c21228a6519dcb793fc1629646c51a6 upstream.

The issue occurs when eCryptfs is mounted with a cipher supported by
the crypto subsystem but not by eCryptfs. The mount succeeds and an
error does not occur until a write. This change checks for eCryptfs
cipher support at mount time.

Resolves Launchpad issue #338914, reported by Tyler Hicks in 03/2009.
https://bugs.launchpad.net/ecryptfs/+bug/338914

Signed-off-by: Tim Sally <tsally@atomicpeace.com>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ecryptfs/main.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index df217dc..923f6aa 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -279,6 +279,7 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *options,
 	char *fnek_src;
 	char *cipher_key_bytes_src;
 	char *fn_cipher_key_bytes_src;
+	u8 cipher_code;
 
 	*check_ruid = 0;
 
@@ -420,6 +421,18 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *options,
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


