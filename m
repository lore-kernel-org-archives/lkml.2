Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab2EYPmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:42:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab2EYPmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:42:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
References: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, kyle@mcmartin.ca, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
Date: Fri, 25 May 2012 16:42:19 +0100
Message-ID: <26029.1337960539@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rusty,

If you prefer to have userspace extract the module signature and pass it in
uargs, here's a tree that will do that:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/modsign-uarg

You can use it with the attached patch to kmod.git.  I've passed the signature
length in the argument as it permits the kernel to preallocate the buffer it
decodes the signature into, but that's not actually necessary.

David
---
commit e4c9290fc949bc41f942f00a1460d9d90fc1775c
Author: David Howells <dhowells@redhat.com>
Date:   Fri May 25 16:35:19 2012 +0100

libkmod: Extract module signature and prepend on module argument list

Extract the module signature from the module image, if present, and prepend on
the module argument list hexcoded as

	"modsign=l,x "

Where "l" is the length of the signature as a decimal number and "x" is the
hex-encoded signature data.

Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/libkmod/libkmod-module.c b/libkmod/libkmod-module.c
index f5384a7..d358eec 100644
--- a/libkmod/libkmod-module.c
+++ b/libkmod/libkmod-module.c
@@ -756,6 +756,88 @@ KMOD_EXPORT int kmod_module_remove_module(struct kmod_module *mod,
 	return err;
 }
 
+static const char kmod_modsign_magic[] = "This Is A Crypto Signed Module";
+static const char kmod_arg_key[] = "modsign=";
+
+/**
+ * kmod_find_signature:
+ * @mod: kmod module
+ * @mem: The module contents
+ * @_size: The size of the module contents (updated if sig removed)
+ * @args: Argument string
+ * @_new_args: Where to place the updated argument list
+ *
+ * Returns: 0 on success or < 0 on failure.  -ELIBBAD is returned is the module
+ * format cannot be parsed.
+ */
+static int kmod_find_signature(struct kmod_module *mod,
+			       const void *mem, off_t *_size,
+			       const char *args, char **_new_args)
+{
+	const unsigned char *sig, *data = mem;
+	const char *cp;
+	char *new_args, *dp, *end;
+	size_t magic_size, sig_size, mod_size, arg_size, new_arg_size, size = *_size;
+
+	INFO(mod->ctx, "Look for signature in module image\n");
+
+	magic_size = sizeof(kmod_modsign_magic) - 1;
+	if (size <= 5 + magic_size)
+		return 0;
+
+	if (memcmp(data + size - magic_size, kmod_modsign_magic, magic_size) != 0)
+		/* Probably want to check for IMA signature file or xattr here */
+		return 0;
+	size -= 5 + magic_size;
+
+	INFO(mod->ctx, "Signature marker found in module\n");
+
+	cp = (const char *)data + size;
+	sig_size = strtoul(cp, &end, 10);
+	if (sig_size >= size || (*end != ' ' && *end != 'T'))
+		return -ELIBBAD;
+
+	mod_size = size - sig_size;
+	INFO(mod->ctx, "Module size %zu Signature size %zu\n", mod_size, sig_size);
+	if (sig_size <= 0)
+		return -ENOMSG;
+	if (sig_size > 65535)
+		return -EMSGSIZE;
+
+	sig = data + mod_size;
+	INFO(mod->ctx, "Signature dump: %02x%02x%02x%02x%02x%02x%02x%02x\n",
+	     sig[0], sig[1], sig[2], sig[3],
+	     sig[4], sig[5], sig[6], sig[7]);
+
+	arg_size = strlen(args) + 1;
+	new_arg_size = sizeof(kmod_arg_key) - 1 + 5 + 1 + sig_size * 2 + 1 + arg_size;
+	new_args = malloc(new_arg_size);
+	if (!new_args)
+		return -ENOMEM;
+
+	/* Hex encode the signature as "modsign=l,xxxxxx " at the front of the
+	 * argument list.
+	 */
+	dp = memcpy(new_args, kmod_arg_key, sizeof(kmod_arg_key) - 1);
+	dp += sizeof(kmod_arg_key) - 1;
+	dp += sprintf(dp, "%zu,", sig_size);
+	do {
+		dp += sprintf(dp, "%02x", *sig++);
+	} while (--sig_size > 0);
+	*dp++ = ' ';
+	memcpy(dp, args, arg_size);
+
+	dp += arg_size;
+	if (dp > new_args + new_arg_size) {
+		fprintf(stderr, "%p > %p\n", dp, new_args + new_arg_size);
+		abort();
+	}
+
+	*_new_args = new_args;
+	*_size = mod_size;
+	return 0;
+}
+
 extern long init_module(const void *mem, unsigned long len, const char *args);
 
 /**
@@ -782,6 +864,7 @@ KMOD_EXPORT int kmod_module_insert_module(struct kmod_module *mod,
 	struct kmod_elf *elf = NULL;
 	const char *path;
 	const char *args = options ? options : "";
+	char *new_args = NULL;
 
 	if (mod == NULL)
 		return -ENOENT;
@@ -823,6 +906,12 @@ KMOD_EXPORT int kmod_module_insert_module(struct kmod_module *mod,
 		mem = kmod_elf_get_memory(elf);
 	}
 
+	err = kmod_find_signature(mod, mem, &size, args, &new_args);
+	if (err < 0)
+		goto elf_failed;
+	if (new_args)
+		args = new_args;
+
 	err = init_module(mem, size, args);
 	if (err < 0) {
 		err = -errno;
@@ -831,6 +920,7 @@ KMOD_EXPORT int kmod_module_insert_module(struct kmod_module *mod,
 
 	if (elf != NULL)
 		kmod_elf_unref(elf);
+	free(new_args);
 elf_failed:
 	kmod_file_unref(file);
 
