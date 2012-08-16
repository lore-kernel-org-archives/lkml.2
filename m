Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab2HPBhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:37:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756843Ab2HPBhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:37:06 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/25] KEYS: Provide PGP key description autogeneration
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 02:36:57 +0100
Message-ID: <20120816013657.872.48479.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a facility to autogenerate the name of PGP keys from the contents of
the payload.  If add_key() is given a blank description, a description is
constructed from the last user ID packet in the payload data plus the last 8
hex digits of the key ID.  For instance:

	keyctl padd crypto "" @s </tmp/key.pub

might create a key with a constructed description that can be seen in
/proc/keys:

2f674b96 I--Q---     1 perm 39390000     0     0 crypto    Sample kernel key 31f0ae93: PGP.RSA 31f0ae93 []

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/crypto/pgp_public_key.c |   64 +++++++++++++++++++++++++++------
 1 file changed, 53 insertions(+), 11 deletions(-)


diff --git a/security/keys/crypto/pgp_public_key.c b/security/keys/crypto/pgp_public_key.c
index c260e02..2347ecd 100644
--- a/security/keys/crypto/pgp_public_key.c
+++ b/security/keys/crypto/pgp_public_key.c
@@ -52,6 +52,9 @@ struct pgp_key_data_parse_context {
 	struct crypto_key_subtype *subtype;
 	char *fingerprint;
 	void *payload;
+	const char *user_id;
+	size_t user_id_len;
+	size_t fingerprint_len;
 };
 
 /*
@@ -166,6 +169,7 @@ static int pgp_generate_fingerprint(struct pgp_key_data_parse_context *ctx,
 	if (ret < 0)
 		goto cleanup_raw_fingerprint;
 
+	ctx->fingerprint_len = digest_size * 2;
 	fingerprint = kmalloc(digest_size * 2 + 1, GFP_KERNEL);
 	if (!fingerprint)
 		goto cleanup_raw_fingerprint;
@@ -212,6 +216,13 @@ static int pgp_process_public_key(struct pgp_parse_context *context,
 
 	kenter(",%u,%u,,%zu", type, headerlen, datalen);
 
+	if (type == PGP_PKT_USER_ID) {
+		ctx->user_id = data;
+		ctx->user_id_len = datalen;
+		kleave(" = 0 [user ID]");
+		return 0;
+	}
+
 	if (ctx->subtype) {
 		kleave(" = -ENOKEY [already]");
 		return -EBADMSG;
@@ -297,21 +308,44 @@ static int pgp_key_preparse(struct key_preparsed_payload *prep)
 
 	kenter("");
 
+	memset(&ctx, 0, sizeof(ctx));
 	ctx.pgp.types_of_interest =
-		(1 << PGP_PKT_PUBLIC_KEY) | (1 << PGP_PKT_PUBLIC_SUBKEY);
+		(1 << PGP_PKT_PUBLIC_KEY) | (1 << PGP_PKT_PUBLIC_SUBKEY) |
+		(1 << PGP_PKT_USER_ID);
 	ctx.pgp.process_packet = pgp_process_public_key;
-	ctx.subtype = NULL;
-	ctx.fingerprint = NULL;
-	ctx.payload = NULL;
 
 	ret = pgp_parse_packets(prep->data, prep->datalen, &ctx.pgp);
-	if (ret < 0) {
-		if (ctx.payload)
-			ctx.subtype->destroy(ctx.payload);
-		if (ctx.subtype)
-			module_put(ctx.subtype->owner);
-		kfree(ctx.fingerprint);
-		return ret;
+	if (ret < 0)
+		goto error;
+
+	if (ctx.user_id && ctx.user_id_len > 0) {
+		/* Propose a description for the key (user ID without the comment) */
+		size_t ulen = ctx.user_id_len, flen = ctx.fingerprint_len;
+		const char *p;
+
+		p = memchr(ctx.user_id, '(', ulen);
+		if (p) {
+			/* Remove the comment */
+			do {
+				p--;
+			} while (*p == ' ' && p > ctx.user_id);
+			if (*p != ' ')
+				p++;
+			ulen = p - ctx.user_id;
+		}
+
+		if (ulen > 255 - 9)
+			ulen = 255 - 9;
+		prep->description = kmalloc(ulen + 1 + 8 + 1, GFP_KERNEL);
+		ret = -ENOMEM;
+		if (!prep->description)
+			goto error;
+		memcpy(prep->description, ctx.user_id, ulen);
+		prep->description[ulen] = ' ';
+		memcpy(prep->description + ulen + 1,
+		       ctx.fingerprint + flen - 8, 8);
+		prep->description[ulen + 9] = 0;
+		pr_debug("desc '%s'\n", prep->description);
 	}
 
 	prep->type_data[0] = ctx.subtype;
@@ -319,6 +353,14 @@ static int pgp_key_preparse(struct key_preparsed_payload *prep)
 	prep->payload = ctx.payload;
 	prep->quotalen = prep->datalen;
 	return 0;
+
+error:
+	if (ctx.payload)
+		ctx.subtype->destroy(ctx.payload);
+	if (ctx.subtype)
+		module_put(ctx.subtype->owner);
+	kfree(ctx.fingerprint);
+	return ret;
 }
 
 static struct crypto_key_parser pgp_key_parser = {

