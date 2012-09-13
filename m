Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab2IMXuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:50:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759215Ab2IMXtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:49:43 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/16] RSA: Fix signature verification for shorter signatures
To: herbert@gondor.hengli.com.au, rusty@rustcorp.com.au
Cc: linux-crypto@vger.kernel.org, zohar@us.ibm.com, dmitry.kasatkin@intel.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 14 Sep 2012 00:49:31 +0100
Message-ID: <20120913234931.3575.10461.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
References: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
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

 crypto/asymmetric_keys/rsa.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
index 9b31ee2..4a6a069 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -224,15 +224,23 @@ static int RSA_verify_signature(const struct public_key *key,
 		return -ENOTSUPP;
 
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

