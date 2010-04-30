Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176Ab0D3Shj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:37:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933129Ab0D3RVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/7] KEYS: keyring_serialise_link_sem is only needed for
	keyring->keyring links
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Fri, 30 Apr 2010 14:32:28 +0100
Message-ID: <20100430133228.2126.47629.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
References: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

keyring_serialise_link_sem is only needed for keyring->keyring links as it's
used to prevent cycle detection from being avoided by parallel keyring
additions.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/keyring.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 63385af..4dc2284 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -711,13 +711,14 @@ int __key_link(struct key *keyring, struct key *key)
 	if (keyring->type != &key_type_keyring)
 		goto error;
 
-	/* serialise link/link calls to prevent parallel calls causing a
-	 * cycle when applied to two keyring in opposite orders */
-	down_write(&keyring_serialise_link_sem);
-
-	/* check that we aren't going to create a cycle adding one keyring to
-	 * another */
+	/* do some special keyring->keyring link checks */
 	if (key->type == &key_type_keyring) {
+		/* serialise link/link calls to prevent parallel calls causing
+		 * a cycle when applied to two keyring in opposite orders */
+		down_write(&keyring_serialise_link_sem);
+
+		/* check that we aren't going to create a cycle adding one
+		 * keyring to another */
 		ret = keyring_detect_cycle(keyring, key);
 		if (ret < 0)
 			goto error2;
@@ -817,7 +818,8 @@ int __key_link(struct key *keyring, struct key *key)
 done:
 	ret = 0;
 error2:
-	up_write(&keyring_serialise_link_sem);
+	if (key->type == &key_type_keyring)
+		up_write(&keyring_serialise_link_sem);
 error:
 	return ret;
 

