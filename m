Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab2KZRIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:08:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47664 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287Ab2KZRIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:08:45 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sylvain Munaut <tnt@246tNt.com>, Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 142/270] libceph: fix crypto key null deref, memory leak
Date: Mon, 26 Nov 2012 14:57:12 -0200
Message-Id: <1353949160-26803-143-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sylvain Munaut <tnt@246tNt.com>

commit f0666b1ac875ff32fe290219b150ec62eebbe10e upstream.

Avoid crashing if the crypto key payload was NULL, as when it was not correctly
allocated and initialized.  Also, avoid leaking it.

Signed-off-by: Sylvain Munaut <tnt@246tNt.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/crypto.c |    1 +
 net/ceph/crypto.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index b780cb7..9da7fdd 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -466,6 +466,7 @@ void ceph_key_destroy(struct key *key) {
 	struct ceph_crypto_key *ckey = key->payload.data;
 
 	ceph_crypto_key_destroy(ckey);
+	kfree(ckey);
 }
 
 struct key_type key_type_ceph = {
diff --git a/net/ceph/crypto.h b/net/ceph/crypto.h
index 1919d15..3572dc5 100644
--- a/net/ceph/crypto.h
+++ b/net/ceph/crypto.h
@@ -16,7 +16,8 @@ struct ceph_crypto_key {
 
 static inline void ceph_crypto_key_destroy(struct ceph_crypto_key *key)
 {
-	kfree(key->key);
+	if (key)
+		kfree(key->key);
 }
 
 extern int ceph_crypto_key_clone(struct ceph_crypto_key *dst,
-- 
1.7.9.5

