Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083Ab0D3SfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:35:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933139Ab0D3RVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/7] KEYS: Better handling of errors from construct_alloc_key()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Fri, 30 Apr 2010 14:32:34 +0100
Message-ID: <20100430133234.2126.63891.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
References: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Errors from construct_alloc_key() shouldn't just be ignored in the way they are
by construct_key_and_link().  The only error that can be ignored so is
EINPROGRESS as that is used to indicate that we've found a key and don't need
to construct one.

We don't, however, handle ENOMEM, EDQUOT or EACCES to indicate allocation
failures of one sort or another.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/request_key.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index d8c1a6a..ac49c8a 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -302,6 +302,7 @@ static int construct_alloc_key(struct key_type *type,
 	const struct cred *cred = current_cred();
 	struct key *key;
 	key_ref_t key_ref;
+	int ret;
 
 	kenter("%s,%s,,,", type->name, description);
 
@@ -337,14 +338,23 @@ static int construct_alloc_key(struct key_type *type,
 	kleave(" = 0 [%d]", key_serial(key));
 	return 0;
 
+	/* the key is now present - we tell the caller that we found it by
+	 * returning -EINPROGRESS  */
 key_already_present:
 	mutex_unlock(&key_construction_mutex);
+	ret = 0;
 	if (dest_keyring) {
-		__key_link(dest_keyring, key_ref_to_ptr(key_ref));
+		ret = __key_link(dest_keyring, key_ref_to_ptr(key_ref));
 		up_write(&dest_keyring->sem);
 	}
 	mutex_unlock(&user->cons_lock);
 	key_put(key);
+	if (ret < 0) {
+		key_ref_put(key_ref);
+		*_key = NULL;
+		kleave(" = %d [link]", ret);
+		return ret;
+	}
 	*_key = key = key_ref_to_ptr(key_ref);
 	kleave(" = -EINPROGRESS [%d]", key_serial(key));
 	return -EINPROGRESS;
@@ -390,6 +400,10 @@ static struct key *construct_key_and_link(struct key_type *type,
 			kdebug("cons failed");
 			goto construction_failed;
 		}
+	} else if (ret == -EINPROGRESS) {
+		ret = 0;
+	} else {
+		key = ERR_PTR(ret);
 	}
 
 	key_put(dest_keyring);
@@ -422,6 +436,7 @@ struct key *request_key_and_link(struct key_type *type,
 	const struct cred *cred = current_cred();
 	struct key *key;
 	key_ref_t key_ref;
+	int ret;
 
 	kenter("%s,%s,%p,%zu,%p,%p,%lx",
 	       type->name, description, callout_info, callout_len, aux,
@@ -435,8 +450,13 @@ struct key *request_key_and_link(struct key_type *type,
 		key = key_ref_to_ptr(key_ref);
 		if (dest_keyring) {
 			construct_get_dest_keyring(&dest_keyring);
-			key_link(dest_keyring, key);
+			ret = key_link(dest_keyring, key);
 			key_put(dest_keyring);
+			if (ret < 0) {
+				key_put(key);
+				key = ERR_PTR(ret);
+				goto error;
+			}
 		}
 	} else if (PTR_ERR(key_ref) != -EAGAIN) {
 		key = ERR_CAST(key_ref);

