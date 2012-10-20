Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340Ab2JTATf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 20:19:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab2JTATe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 20:19:34 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MODSIGN: Move the magic string to the end of a module and
 eliminate the search
To: torvalds@linux-foundation.org, rusty@rustcorp.com.au
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Sat, 20 Oct 2012 01:19:29 +0100
Message-ID: <20121020001928.24141.30477.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emit the magic string that indicates a module has a signature after the
signature data instead of before it.  This allows module_sig_check() to be
made simpler and faster by the elimination of the search for the magic string.
Instead we just need to do a single memcmp().

This works because at the end of the signature data there is the fixed-length
signature information block.  This block then falls immediately prior to the
magic number.

>From the contents of the information block, it is trivial to calculate the size
of the signature data and thus the size of the actual module data.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/module-internal.h |    3 +--
 kernel/module.c          |   26 +++++++++-----------------
 kernel/module_signing.c  |   24 +++++++++++++++---------
 scripts/sign-file        |    6 +++---
 4 files changed, 28 insertions(+), 31 deletions(-)


diff --git a/kernel/module-internal.h b/kernel/module-internal.h
index 6114a13..24f9247 100644
--- a/kernel/module-internal.h
+++ b/kernel/module-internal.h
@@ -11,5 +11,4 @@
 
 extern struct key *modsign_keyring;
 
-extern int mod_verify_sig(const void *mod, unsigned long modlen,
-			  const void *sig, unsigned long siglen);
+extern int mod_verify_sig(const void *mod, unsigned long *_modlen);
diff --git a/kernel/module.c b/kernel/module.c
index 0e2da86..6085f5e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2421,25 +2421,17 @@ static inline void kmemleak_load_module(const struct module *mod,
 
 #ifdef CONFIG_MODULE_SIG
 static int module_sig_check(struct load_info *info,
-			    const void *mod, unsigned long *len)
+			    const void *mod, unsigned long *_len)
 {
 	int err = -ENOKEY;
-	const unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
-	const void *p = mod, *end = mod + *len;
-
-	/* Poor man's memmem. */
-	while ((p = memchr(p, MODULE_SIG_STRING[0], end - p))) {
-		if (p + markerlen > end)
-			break;
-
-		if (memcmp(p, MODULE_SIG_STRING, markerlen) == 0) {
-			const void *sig = p + markerlen;
-			/* Truncate module up to signature. */
-			*len = p - mod;
-			err = mod_verify_sig(mod, *len, sig, end - sig);
-			break;
-		}
-		p++;
+	unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
+	unsigned long len = *_len;
+
+	if (len > markerlen &&
+	    memcmp(mod + len - markerlen, MODULE_SIG_STRING, markerlen) == 0) {
+		/* We truncate the module to discard the signature */
+		*_len -= markerlen;
+		err = mod_verify_sig(mod, _len);
 	}
 
 	if (!err) {
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index 6b09f69..d492a23 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -183,27 +183,33 @@ static struct key *request_asymmetric_key(const char *signer, size_t signer_len,
 /*
  * Verify the signature on a module.
  */
-int mod_verify_sig(const void *mod, unsigned long modlen,
-		   const void *sig, unsigned long siglen)
+int mod_verify_sig(const void *mod, unsigned long *_modlen)
 {
 	struct public_key_signature *pks;
 	struct module_signature ms;
 	struct key *key;
-	size_t sig_len;
+	const void *sig;
+	size_t modlen = *_modlen, sig_len;
 	int ret;
 
-	pr_devel("==>%s(,%lu,,%lu,)\n", __func__, modlen, siglen);
+	pr_devel("==>%s(,%lu)\n", __func__, modlen);
 
-	if (siglen <= sizeof(ms))
+	if (modlen <= sizeof(ms))
 		return -EBADMSG;
 
-	memcpy(&ms, sig + (siglen - sizeof(ms)), sizeof(ms));
-	siglen -= sizeof(ms);
+	memcpy(&ms, mod + (modlen - sizeof(ms)), sizeof(ms));
+	modlen -= sizeof(ms);
 
 	sig_len = be32_to_cpu(ms.sig_len);
-	if (sig_len >= siglen ||
-	    siglen - sig_len != (size_t)ms.signer_len + ms.key_id_len)
+	if (sig_len >= modlen)
 		return -EBADMSG;
+	modlen -= sig_len;
+	if ((size_t)ms.signer_len + ms.key_id_len >= modlen)
+		return -EBADMSG;
+	modlen -= (size_t)ms.signer_len + ms.key_id_len;
+
+	*_modlen = modlen;
+	sig = mod + modlen;
 
 	/* For the moment, only support RSA and X.509 identifiers */
 	if (ms.algo != PKEY_ALGO_RSA ||
diff --git a/scripts/sign-file b/scripts/sign-file
index d37d130..87ca59d 100755
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -403,11 +403,11 @@ my $info = pack("CCCCCxxxN",
 
 if ($verbose) {
     print "Size of unsigned module: ", length($unsigned_module), "\n";
-    print "Size of magic number   : ", length($magic_number), "\n";
     print "Size of signer's name  : ", length($signers_name), "\n";
     print "Size of key identifier : ", length($key_identifier), "\n";
     print "Size of signature      : ", length($signature), "\n";
     print "Size of informaton     : ", length($info), "\n";
+    print "Size of magic number   : ", length($magic_number), "\n";
     print "Signer's name          : '", $signers_name, "'\n";
     print "Digest                 : $dgst\n";
 }
@@ -416,11 +416,11 @@ open(FD, ">$dest") || die $dest;
 binmode FD;
 print FD
     $unsigned_module,
-    $magic_number,
     $signers_name,
     $key_identifier,
     $signature,
-    $info
+    $info,
+    $magic_number
     ;
 close FD || die $dest;
 

