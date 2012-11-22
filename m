Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab2KVVhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:37:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:49611 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab2KVSk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tim Sally <tsally@atomicpeace.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [ 28/38] eCryptfs: check for eCryptfs cipher support at mount
Date: Wed, 21 Nov 2012 16:40:11 -0800
Message-Id: <20121122003907.388406503@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122003904.262382971@linuxfoundation.org>
References: <20121122003904.262382971@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/main.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -279,6 +279,7 @@ static int ecryptfs_parse_options(struct
 	char *fnek_src;
 	char *cipher_key_bytes_src;
 	char *fn_cipher_key_bytes_src;
+	u8 cipher_code;
 
 	*check_ruid = 0;
 
@@ -420,6 +421,18 @@ static int ecryptfs_parse_options(struct
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


