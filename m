Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab1CCRc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:32:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758486Ab1CCRcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:32:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Add an RCU payload dereference macro
To: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Thu, 03 Mar 2011 17:32:49 +0000
Message-ID: <20110303173248.10374.11548.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an RCU payload dereference macro as this seems to be a common piece of code
amongst key types that use RCU referenced payloads.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/key.h          |    4 ++++
 security/keys/encrypted.c    |    3 +--
 security/keys/trusted.c      |    3 +--
 security/keys/user_defined.c |    3 +--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index 3db0adc..a6b1edc 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -275,6 +275,10 @@ static inline key_serial_t key_serial(struct key *key)
 	return key ? key->serial : 0;
 }
 
+#define rcu_dereference_key(KEY)					\
+	(rcu_dereference_protected((KEY)->payload.rcudata,		\
+				   rwsem_is_locked(&((struct key *)(KEY))->sem)))
+
 #ifdef CONFIG_SYSCTL
 extern ctl_table key_sysctls[];
 #endif
diff --git a/security/keys/encrypted.c b/security/keys/encrypted.c
index 9e7e4ce..69907a5 100644
--- a/security/keys/encrypted.c
+++ b/security/keys/encrypted.c
@@ -765,8 +765,7 @@ static long encrypted_read(const struct key *key, char __user *buffer,
 	size_t asciiblob_len;
 	int ret;
 
-	epayload = rcu_dereference_protected(key->payload.data,
-				  rwsem_is_locked(&((struct key *)key)->sem));
+	epayload = rcu_dereference_key(key);
 
 	/* returns the hex encoded iv, encrypted-data, and hmac as ascii */
 	asciiblob_len = epayload->datablob_len + ivsize + 1
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 83fc92e..c99b936 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -1076,8 +1076,7 @@ static long trusted_read(const struct key *key, char __user *buffer,
 	char *bufp;
 	int i;
 
-	p = rcu_dereference_protected(key->payload.data,
-			rwsem_is_locked(&((struct key *)key)->sem));
+	p = rcu_dereference_key(key);
 	if (!p)
 		return -EINVAL;
 	if (!buffer || buflen <= 0)
diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
index 02807fb..c6ca866 100644
--- a/security/keys/user_defined.c
+++ b/security/keys/user_defined.c
@@ -184,8 +184,7 @@ long user_read(const struct key *key, char __user *buffer, size_t buflen)
 	struct user_key_payload *upayload;
 	long ret;
 
-	upayload = rcu_dereference_protected(
-		key->payload.data, rwsem_is_locked(&((struct key *)key)->sem));
+	upayload = rcu_dereference_key(key);
 	ret = upayload->datalen;
 
 	/* we can return the data as is */

