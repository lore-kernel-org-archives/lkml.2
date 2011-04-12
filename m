Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab1DLOsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:48:07 -0400
Received: from kroah.org ([198.145.64.141]:57639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291Ab1DLOi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:55 2011
Message-Id: <20110412143554.930009553@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [065/105] Revert "net/sunrpc: Use static const char arrays"
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 0867659fa3c245bf203d837a82e0f6ea5079c2c5 upstream.

This reverts commit 411b5e05617593efebc06241dbc56f42150f2abe.

Olga Kornievskaia reports:

Problem: linux client mounting linux server using rc4-hmac-md5
enctype. gssd fails with create a context after receiving a reply from
the server.

Diagnose: putting printout statements in the server kernel and
kerberos libraries revealed that client and server derived different
integrity keys.

Server kernel code was at fault due the the commit

[aglo@skydive linux-pnfs]$ git show 411b5e05617593efebc06241dbc56f42150f2abe

Trond: The problem is that since it relies on virt_to_page(), you cannot
call sg_set_buf() for data in the const section.

Reported-by: Olga Kornievskaia <aglo@citi.umich.edu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/auth_gss/gss_krb5_mech.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -427,7 +427,7 @@ static int
 context_derive_keys_rc4(struct krb5_ctx *ctx)
 {
 	struct crypto_hash *hmac;
-	static const char sigkeyconstant[] = "signaturekey";
+	char sigkeyconstant[] = "signaturekey";
 	int slen = strlen(sigkeyconstant) + 1;	/* include null terminator */
 	struct hash_desc desc;
 	struct scatterlist sg[1];


