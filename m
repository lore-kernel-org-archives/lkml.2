Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab2KVWG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:06:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:49635 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625Ab2KVSkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sylvain Munaut <tnt@246tNt.com>, Sage Weil <sage@inktank.com>,
        Alex Elder <elder@inktank.com>
Subject: [ 161/171] libceph: fix crypto key null deref, memory leak
Date: Wed, 21 Nov 2012 16:41:47 -0800
Message-Id: <20121122004049.514910817@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sylvain Munaut <tnt@246tNt.com>

(cherry picked from commit f0666b1ac875ff32fe290219b150ec62eebbe10e)

Avoid crashing if the crypto key payload was NULL, as when it was not correctly
allocated and initialized.  Also, avoid leaking it.

Signed-off-by: Sylvain Munaut <tnt@246tNt.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/crypto.c |    1 +
 net/ceph/crypto.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -466,6 +466,7 @@ void ceph_key_destroy(struct key *key) {
 	struct ceph_crypto_key *ckey = key->payload.data;
 
 	ceph_crypto_key_destroy(ckey);
+	kfree(ckey);
 }
 
 struct key_type key_type_ceph = {
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


