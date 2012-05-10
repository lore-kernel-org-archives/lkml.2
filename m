Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab2EJXk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:40:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933010Ab2EJXku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:40:50 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/29] Fix signature verification for shorter signatures [ver
 #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        Milan Broz <mbroz@redhat.com>, David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:40:41 +0100
Message-ID: <20120510234040.4137.10639.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpg can produce a signature file where length of signature is less than the
modulus size because the amount of space an MPI takes up is kept as low as
possible by discarding leading zeros.  This regularly happens for several
modules during the build.

Fix it by relaxing check in RSA verification code.

Thanks to Tomas Mraz and Miloslav Trmac for help.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/crypto/crypto_rsa.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)


diff --git a/security/keys/crypto/crypto_rsa.c b/security/keys/crypto/crypto_rsa.c
index beb5181..cc5cd95 100644
--- a/security/keys/crypto/crypto_rsa.c
+++ b/security/keys/crypto/crypto_rsa.c
@@ -219,15 +219,23 @@ static int RSA_verify_signature(const struct public_key *key,
 	kenter("");
 
 	/* (1) Check the signature size against the public key modulus size */
-	k = (mpi_get_nbits(key->rsa.n) + 7) / 8;
+	k = mpi_get_nbits(key->rsa.n);
+	tsize = mpi_get_nbits(sig->rsa.s);
 
-	tsize = (mpi_get_nbits(sig->rsa.s) + 7) / 8;
+	/* According to RFC 4880 sec 3.2, length of MPI is computed starting
+	 * from most significant bit.  So the RFC 3447 sec 8.2.2 size check
+	 * must be relaxed to conform with shorter signatures - so we fail here
+	 * only if signature length is longer than modulus size.
+	 */
 	pr_devel("step 1: k=%zu size(S)=%zu\n", k, tsize);
-	if (tsize != k) {
+	if (k < tsize) {
 		ret = -EBADMSG;
 		goto error;
 	}
 
+	/* Round up and convert to octets */
+	k = (k + 7) / 8;
+
 	/* (2b) Apply the RSAVP1 verification primitive to the public key */
 	ret = RSAVP1(key, sig->rsa.s, &m);
 	if (ret < 0)

