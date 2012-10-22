Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab2JVBZJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 21:25:09 -0400
Received: from ozlabs.org ([203.10.76.45]:59427 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744Ab2JVBZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 21:25:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: Move the magic string to the end of a module and eliminate the search
In-Reply-To: <20121020001928.24141.30477.stgit@warthog.procyon.org.uk>
References: <20121020001928.24141.30477.stgit@warthog.procyon.org.uk>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 22 Oct 2012 11:36:47 +1030
Message-ID: <874nlnjowo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> Emit the magic string that indicates a module has a signature after the
> signature data instead of before it.  This allows module_sig_check() to be
> made simpler and faster by the elimination of the search for the magic string.
> Instead we just need to do a single memcmp().
>
> This works because at the end of the signature data there is the fixed-length
> signature information block.  This block then falls immediately prior to the
> magic number.
>
>>From the contents of the information block, it is trivial to calculate the size
> of the signature data and thus the size of the actual module data.

Meh, I really wanted to separate the module signature locating (my
problem) from the decoding and checking (your problem).

If we're going to require such a header, we can simplify further (untested!).

BTW, I'm not convinced your use of bitfields here is portable; it may be
portable enough for Linux though.

Cheers,
Rusty.

diff --git a/include/linux/module.h b/include/linux/module.h
index 7760c6d..bfd1b2d 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -21,9 +21,6 @@
 #include <linux/percpu.h>
 #include <asm/module.h>
 
-/* In stripped ARM and x86-64 modules, ~ is surprisingly rare. */
-#define MODULE_SIG_STRING "~Module signature appended~\n"
-
 /* Not Yet Implemented */
 #define MODULE_SUPPORTED_DEVICE(name)
 
@@ -656,4 +653,29 @@ static inline void module_bug_finalize(const Elf_Ehdr *hdr,
 static inline void module_bug_cleanup(struct module *mod) {}
 #endif	/* CONFIG_GENERIC_BUG */
 
+#ifdef CONFIG_MODULE_SIG
+#define MODULE_SIG_STRING "~Module signature appended~\n"
+
+/*
+ * Appended module signature information block.
+ *
+ * The constituents of the signature section are, in order:
+ *
+ *	- Signer's name
+ *	- Key identifier
+ *	- Signature data
+ *	- Information block
+ */
+struct module_signature {
+	enum pkey_algo		algo : 8;	/* Public-key crypto algorithm */
+	enum pkey_hash_algo	hash : 8;	/* Digest algorithm */
+	enum pkey_id_type	id_type : 8;	/* Key identifier type */
+	u8			signer_len;	/* Length of signer's name */
+	u8			key_id_len;	/* Length of key identifier */
+	u8			__pad[3];
+	__be32			sig_len;	/* Length of signature data */
+	char			marker[sizeof(MODULE_SIG_STRING)-1];
+};
+#endif /* CONFIG_MODULE_SIG */
+
 #endif /* _LINUX_MODULE_H */
diff --git a/kernel/module.c b/kernel/module.c
index 6085f5e..254d6a3 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2424,14 +2424,17 @@ static int module_sig_check(struct load_info *info,
 			    const void *mod, unsigned long *_len)
 {
 	int err = -ENOKEY;
-	unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
+	struct module_signature sig;
 	unsigned long len = *_len;
 
-	if (len > markerlen &&
-	    memcmp(mod + len - markerlen, MODULE_SIG_STRING, markerlen) == 0) {
-		/* We truncate the module to discard the signature */
-		*_len -= markerlen;
-		err = mod_verify_sig(mod, _len);
+	if (len > sizeof(sig)) {
+		memcpy(&sig, mod + len - sizeof(sig), sizeof(sig));
+
+		if (!memcmp(sig.marker, MODULE_SIG_STRING, sizeof(sig.marker))) {
+			/* We truncate the module to discard the signature */
+			*_len -= sizeof(sig);
+			err = mod_verify_sig(mod, &sig, _len);
+		}
 	}
 
 	if (!err) {
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index d492a23..db8e836 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -17,26 +17,6 @@
 #include "module-internal.h"
 
 /*
- * Module signature information block.
- *
- * The constituents of the signature section are, in order:
- *
- *	- Signer's name
- *	- Key identifier
- *	- Signature data
- *	- Information block
- */
-struct module_signature {
-	enum pkey_algo		algo : 8;	/* Public-key crypto algorithm */
-	enum pkey_hash_algo	hash : 8;	/* Digest algorithm */
-	enum pkey_id_type	id_type : 8;	/* Key identifier type */
-	u8			signer_len;	/* Length of signer's name */
-	u8			key_id_len;	/* Length of key identifier */
-	u8			__pad[3];
-	__be32			sig_len;	/* Length of signature data */
-};
-
-/*
  * Digest the module contents.
  */
 static struct public_key_signature *mod_make_digest(enum pkey_hash_algo hash,
@@ -183,10 +163,10 @@ static struct key *request_asymmetric_key(const char *signer, size_t signer_len,
 /*
  * Verify the signature on a module.
  */
-int mod_verify_sig(const void *mod, unsigned long *_modlen)
+int mod_verify_sig(const void *mod,
+		   const struct module_signature *ms, unsigned long *_modlen)
 {
 	struct public_key_signature *pks;
-	struct module_signature ms;
 	struct key *key;
 	const void *sig;
 	size_t modlen = *_modlen, sig_len;
@@ -194,44 +174,38 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 
 	pr_devel("==>%s(,%lu)\n", __func__, modlen);
 
-	if (modlen <= sizeof(ms))
-		return -EBADMSG;
-
-	memcpy(&ms, mod + (modlen - sizeof(ms)), sizeof(ms));
-	modlen -= sizeof(ms);
-
-	sig_len = be32_to_cpu(ms.sig_len);
+	sig_len = be32_to_cpu(ms->sig_len);
 	if (sig_len >= modlen)
 		return -EBADMSG;
 	modlen -= sig_len;
 	if ((size_t)ms.signer_len + ms.key_id_len >= modlen)
 		return -EBADMSG;
-	modlen -= (size_t)ms.signer_len + ms.key_id_len;
+	modlen -= (size_t)ms->signer_len + ms.key_id_len;
 
 	*_modlen = modlen;
 	sig = mod + modlen;
 
 	/* For the moment, only support RSA and X.509 identifiers */
-	if (ms.algo != PKEY_ALGO_RSA ||
-	    ms.id_type != PKEY_ID_X509)
+	if (ms->algo != PKEY_ALGO_RSA ||
+	    ms->id_type != PKEY_ID_X509)
 		return -ENOPKG;
 
-	if (ms.hash >= PKEY_HASH__LAST ||
+	if (ms->hash >= PKEY_HASH__LAST ||
 	    !pkey_hash_algo[ms.hash])
 		return -ENOPKG;
 
-	key = request_asymmetric_key(sig, ms.signer_len,
-				     sig + ms.signer_len, ms.key_id_len);
+	key = request_asymmetric_key(sig, ms->signer_len,
+				     sig + ms->signer_len, ms->key_id_len);
 	if (IS_ERR(key))
 		return PTR_ERR(key);
 
-	pks = mod_make_digest(ms.hash, mod, modlen);
+	pks = mod_make_digest(ms->hash, mod, modlen);
 	if (IS_ERR(pks)) {
 		ret = PTR_ERR(pks);
 		goto error_put_key;
 	}
 
-	ret = mod_extract_mpi_array(pks, sig + ms.signer_len + ms.key_id_len,
+	ret = mod_extract_mpi_array(pks, sig + ms->signer_len + ms->key_id_len,
 				    sig_len);
 	if (ret < 0)
 		goto error_free_pks;
