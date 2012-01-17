Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2AQUkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:40:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820Ab2AQUkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:40:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] encrypted-keys: fix rcu and sparse messages
To: jmorris@namei.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, David Howells <dhowells@redhat.com>
Date: Tue, 17 Jan 2012 20:40:02 +0000
Message-ID: <20120117204002.14882.4097.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120117203940.14882.56709.stgit@warthog.procyon.org.uk>
References: <20120117203940.14882.56709.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

Enabling CONFIG_PROVE_RCU and CONFIG_SPARSE_RCU_POINTER resulted in
"suspicious rcu_dereference_check() usage!" and "incompatible types
in comparison expression (different address spaces)" messages.

Access the masterkey directly when holding the rwsem.

Changelog v1:
- Use either rcu_read_lock()/rcu_derefence_key()/rcu_read_unlock()
or remove the unnecessary rcu_derefence() - David Howells

Reported-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/encrypted-keys/encrypted.c         |    2 +-
 security/keys/encrypted-keys/masterkey_trusted.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index d91efb6..2d1bb8a 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -314,7 +314,7 @@ static struct key *request_user_key(const char *master_desc, u8 **master_key,
 		goto error;
 
 	down_read(&ukey->sem);
-	upayload = rcu_dereference(ukey->payload.data);
+	upayload = ukey->payload.data;
 	*master_key = upayload->data;
 	*master_keylen = upayload->datalen;
 error:
diff --git a/security/keys/encrypted-keys/masterkey_trusted.c b/security/keys/encrypted-keys/masterkey_trusted.c
index 8c16c3e..013f7e5 100644
--- a/security/keys/encrypted-keys/masterkey_trusted.c
+++ b/security/keys/encrypted-keys/masterkey_trusted.c
@@ -39,7 +39,7 @@ struct key *request_trusted_key(const char *trusted_desc,
 		goto error;
 
 	down_read(&tkey->sem);
-	tpayload = rcu_dereference(tkey->payload.data);
+	tpayload = tkey->payload.data;
 	*master_key = tpayload->key;
 	*master_keylen = tpayload->key_len;
 error:

