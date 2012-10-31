Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422791Ab2JaMbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 08:31:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933531Ab2JaMbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:31:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAGXu5jK22D_15jYopqaegYAGSHO2x0asXogXCnZGfMw2KwUVNw@mail.gmail.com>
References: <CAGXu5jK22D_15jYopqaegYAGSHO2x0asXogXCnZGfMw2KwUVNw@mail.gmail.com> <20121030191927.11000.68420.stgit@warthog.procyon.org.uk> <20121030192148.11000.3582.stgit@warthog.procyon.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, pjones@redhat.com,
        jwboyer@redhat.com, mjg@redhat.com, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/23] pefile: Parse a PE binary to find a key and a signature contained therein
Date: Wed, 31 Oct 2012 12:31:29 +0000
Message-ID: <30574.1351686689@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> Which means this loop will walk past the end of the memory (loop is
> bounded by n_sections, so secs[loop] can go past datalen). While
> data_addr and raw_data_size will stay bounded, the read of sec->name
> can be out of bounds.

Assuming n_sections is checked, sec->name can't be out of bounds because it's
a char array, not a pointer.

> (Also, do you want a "break" in there after the first .keylist is found, or
> is this intentionally "use last key list"?)

Actually, no I don't.  The loop also checks the limits on each section - which
I need to do since I have to individually digest the sections later.

Attached is a patch I'm applying to pefile_parse_binary() to be more rigorous
about the checking of values in the PE binary.

David
---
diff --git a/crypto/asymmetric_keys/pefile_parser.c b/crypto/asymmetric_keys/pefile_parser.c
index efae278..fb80cf0 100644
--- a/crypto/asymmetric_keys/pefile_parser.c
+++ b/crypto/asymmetric_keys/pefile_parser.c
@@ -42,8 +42,8 @@ static int pefile_parse_binary(struct key_preparsed_payload *prep,
 
 #define chkaddr(base, x, s)						\
 	do {								\
-		if ((x) < base || (s) >= datalen || (x) > datalen - (s))	\
-			return -ERANGE;					\
+		if ((x) < base || (s) >= datalen || (x) > datalen - (s)) \
+			return -ELIBBAD;				\
 	} while(0)
 
 	chkaddr(0, 0, sizeof(*mz));
@@ -88,7 +88,13 @@ static int pefile_parse_binary(struct key_preparsed_payload *prep,
 	pr_devel("checksum @ %x\n", ctx->image_checksum_offset);
 	pr_devel("header size = %x\n", ctx->header_size);
 
-	chkaddr(0, cursor, sizeof(*ddir));
+	if (cursor >= ctx->header_size || ctx->header_size >= datalen)
+		return -ELIBBAD;
+
+	if (ctx->n_data_dirents > (ctx->header_size - cursor) / sizeof(*dde) ||
+	    ctx->n_data_dirents < sizeof(*ddir) / sizeof(*dde))
+		return -ELIBBAD;
+
 	ddir = prep->data + cursor;
 	cursor += sizeof(*dde) * ctx->n_data_dirents;
 
@@ -101,7 +107,7 @@ static int pefile_parse_binary(struct key_preparsed_payload *prep,
 		return -EKEYREJECTED;
 	}
 
-	chkaddr(cursor, ddir->certs.virtual_address, ddir->certs.size);
+	chkaddr(ctx->header_size, ddir->certs.virtual_address, ddir->certs.size);
 	ctx->sig_offset = ddir->certs.virtual_address;
 	ctx->sig_len = ddir->certs.size;
 	pr_devel("cert = %x @%x [%*ph]\n",
@@ -112,7 +118,8 @@ static int pefile_parse_binary(struct key_preparsed_payload *prep,
 	 * section containing the list of keys.
 	 */
 	ctx->n_sections = pe->sections;
-	chkaddr(0, cursor, sizeof(*sec) * ctx->n_sections);
+	if (ctx->n_sections > (ctx->header_size - cursor) / sizeof(*sec))
+		return -ELIBBAD;
 	ctx->secs = secs = prep->data + cursor;
 	cursor += sizeof(*sec) * ctx->n_sections;
 
