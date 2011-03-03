Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab1CCRdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:33:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758486Ab1CCRdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:33:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Add a key type op to permit the key description to be
 vetted
To: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Thu, 03 Mar 2011 17:33:04 +0000
Message-ID: <20110303173304.10414.2408.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a key type operation to permit the key type to vet the description of a new
key that key_alloc() is about to allocate.  The operation may reject the
description if it wishes with an error of its choosing.  If it does this, the
key will not be allocated.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/keys.txt   |    7 +++++++
 include/linux/key-type.h |    3 +++
 net/rxrpc/ar-key.c       |   19 +++++++++++++++++++
 security/keys/key.c      |    8 ++++++++
 4 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/Documentation/keys.txt b/Documentation/keys.txt
index e4dbbdb..cf68d1f 100644
--- a/Documentation/keys.txt
+++ b/Documentation/keys.txt
@@ -1062,6 +1062,13 @@ The structure has a number of fields, some of which are mandatory:
      viable.
 
 
+ (*) int (*vet_description)(const char *description);
+
+     This optional method is called to vet a key description.  If the key type
+     doesn't approve of the key description, it may return an error, otherwise
+     it should return 0.
+
+
  (*) int (*instantiate)(struct key *key, const void *data, size_t datalen);
 
      This method is called to attach a payload to a key during construction.
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index 65833d4..fc8525e8 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -41,6 +41,9 @@ struct key_type {
 	 */
 	size_t def_datalen;
 
+	/* vet a description */
+	int (*vet_description)(const char *description);
+
 	/* instantiate a key of this type
 	 * - this method should call key_payload_reserve() to determine if the
 	 *   user's quota will hold the payload
diff --git a/net/rxrpc/ar-key.c b/net/rxrpc/ar-key.c
index d763793..43ea7de 100644
--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -25,6 +25,7 @@
 #include <keys/user-type.h>
 #include "ar-internal.h"
 
+static int rxrpc_vet_description_s(const char *);
 static int rxrpc_instantiate(struct key *, const void *, size_t);
 static int rxrpc_instantiate_s(struct key *, const void *, size_t);
 static void rxrpc_destroy(struct key *);
@@ -52,6 +53,7 @@ EXPORT_SYMBOL(key_type_rxrpc);
  */
 struct key_type key_type_rxrpc_s = {
 	.name		= "rxrpc_s",
+	.vet_description = rxrpc_vet_description_s,
 	.instantiate	= rxrpc_instantiate_s,
 	.match		= user_match,
 	.destroy	= rxrpc_destroy_s,
@@ -59,6 +61,23 @@ struct key_type key_type_rxrpc_s = {
 };
 
 /*
+ * Vet the description for an RxRPC server key
+ */
+static int rxrpc_vet_description_s(const char *desc)
+{
+	unsigned long num;
+	char *p;
+
+	num = simple_strtoul(desc, &p, 10);
+	if (*p != ':' || num > 65535)
+		return -EINVAL;
+	num = simple_strtoul(p + 1, &p, 10);
+	if (*p || num < 1 || num > 255)
+		return -EINVAL;
+	return 0;
+}
+
+/*
  * parse an RxKAD type XDR format token
  * - the caller guarantees we have at least 4 words
  */
diff --git a/security/keys/key.c b/security/keys/key.c
index 1c2d43d..8e315ef 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -249,6 +249,14 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 	if (!desc || !*desc)
 		goto error;
 
+	if (type->vet_description) {
+		ret = type->vet_description(desc);
+		if (ret < 0) {
+			key = ERR_PTR(ret);
+			goto error;
+		}
+	}
+
 	desclen = strlen(desc) + 1;
 	quotalen = desclen + type->def_datalen;
 

