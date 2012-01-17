Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab2AQUk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:40:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773Ab2AQUj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:39:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] keys: fix trusted/encrypted keys sparse
 rcu_assign_pointer messages
To: jmorris@namei.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, David Howells <dhowells@redhat.com>
Date: Tue, 17 Jan 2012 20:39:51 +0000
Message-ID: <20120117203951.14882.60470.stgit@warthog.procyon.org.uk>
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

Define rcu_assign_keypointer(), which uses the key payload.rcudata instead
of payload.data, to resolve the CONFIG_SPARSE_RCU_POINTER message:
"incompatible types in comparison expression (different address spaces)"

Replace the rcu_assign_pointer() calls in encrypted/trusted keys with
rcu_assign_keypointer().

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/key.h                              |    3 +++
 security/keys/encrypted-keys/encrypted.c         |    4 ++--
 security/keys/encrypted-keys/masterkey_trusted.c |    2 ++
 security/keys/trusted.c                          |    4 ++--
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index 183a6af..bfc014c 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -293,6 +293,9 @@ static inline bool key_is_instantiated(const struct key *key)
 	(rcu_dereference_protected((KEY)->payload.rcudata,		\
 				   rwsem_is_locked(&((struct key *)(KEY))->sem)))
 
+#define rcu_assign_keypointer(KEY, PAYLOAD)				\
+	(rcu_assign_pointer((KEY)->payload.rcudata, PAYLOAD))
+
 #ifdef CONFIG_SYSCTL
 extern ctl_table key_sysctls[];
 #endif
diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 41144f7..d91efb6 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -810,7 +810,7 @@ static int encrypted_instantiate(struct key *key, const void *data,
 		goto out;
 	}
 
-	rcu_assign_pointer(key->payload.data, epayload);
+	rcu_assign_keypointer(key, epayload);
 out:
 	kfree(datablob);
 	return ret;
@@ -874,7 +874,7 @@ static int encrypted_update(struct key *key, const void *data, size_t datalen)
 	memcpy(new_epayload->payload_data, epayload->payload_data,
 	       epayload->payload_datalen);
 
-	rcu_assign_pointer(key->payload.data, new_epayload);
+	rcu_assign_keypointer(key, new_epayload);
 	call_rcu(&epayload->rcu, encrypted_rcu_free);
 out:
 	kfree(buf);
diff --git a/security/keys/encrypted-keys/masterkey_trusted.c b/security/keys/encrypted-keys/masterkey_trusted.c
index df87272..8c16c3e 100644
--- a/security/keys/encrypted-keys/masterkey_trusted.c
+++ b/security/keys/encrypted-keys/masterkey_trusted.c
@@ -18,6 +18,8 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <keys/trusted-type.h>
+#include <keys/encrypted-type.h>
+#include "encrypted.h"
 
 /*
  * request_trusted_key - request the trusted key
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 0ed5fdf..2d5d041 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -993,7 +993,7 @@ out:
 	kfree(datablob);
 	kfree(options);
 	if (!ret)
-		rcu_assign_pointer(key->payload.data, payload);
+		rcu_assign_keypointer(key, payload);
 	else
 		kfree(payload);
 	return ret;
@@ -1067,7 +1067,7 @@ static int trusted_update(struct key *key, const void *data, size_t datalen)
 			goto out;
 		}
 	}
-	rcu_assign_pointer(key->payload.data, new_p);
+	rcu_assign_keypointer(key, new_p);
 	call_rcu(&p->rcu, trusted_rcu_free);
 out:
 	kfree(datablob);

