Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964867Ab2EJXoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:44:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab2EJXoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:44:11 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 27/29] MODSIGN: Create digest of module content and check
 signature [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:43:59 +0100
Message-ID: <20120510234359.4137.22844.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply signature checking to modules on module load, checking the signature
against the ring of public keys compiled into the kernel (if enabled by
CONFIG_MODULE_SIG).  Turning on signature checking will also force the module's
ELF metadata to be verified first.

There are several reasons why these patches are useful, amongst which are:

 (1) to prevent accidentally corrupted modules from causing damage;

 (2) to prevent maliciously modified modules from causing damage;

 (3) to allow a sysadmin (or more likely an IT department) to enforce a policy
     that only known and approved modules shall be loaded onto machines which
     they're expected to support;

 (4) to allow other support providers to do likewise, or at least to _detect_
     the fact that unsupported modules are loaded;

 (5) to allow the detection of modules replaced by a second-order distro or a
     preloaded Linux purveyor.

These patches have two main appeals: (a) preventing malicious modules from
being loaded, and (b) reducing support workload by pointing out modules on a
crashing box that aren't what they're expected to be.

Note that this is not a complete solution by any means: the core kernel is not
protected, and nor are /dev/mem or /dev/kmem, but it denies (or at least
controls) one relatively simple attack vector.  To protect the kernel image
would be the responsibility of the boot loader or the system BIOS.

This facility is optional: the builder of a kernel is by no means under any
requirement to actually enable it, let alone force the set of loadable modules
to be restricted to just those that the builder provides (there are degrees of
restriction available).

Note!  The "noinline" attribute on module_verify_signature() results in
somewhat smaller code.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/module-verify.c |  321 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 320 insertions(+), 1 deletions(-)


diff --git a/kernel/module-verify.c b/kernel/module-verify.c
index 13c60c2..a31b39c 100644
--- a/kernel/module-verify.c
+++ b/kernel/module-verify.c
@@ -49,6 +49,22 @@ static bool modsign_signedonly;
 static const char modsign_note_name[] = ELFNOTE_NAME(MODSIGN_NOTE_NAME);
 static const char modsign_note_section[] = ELFNOTE_SECTION(MODSIGN_NOTE_NAME);
 
+#define crypto_digest_update_data(C, PTR, N)			\
+do {								\
+	uint8_t *__p = (uint8_t *)(PTR);			\
+	size_t __n = (N);					\
+	count_and_csum((C), __p, __n);				\
+	verify_sig_add_data((C)->mod_sig, __p, __n);		\
+} while (0)
+
+#define crypto_digest_update_val(C, VAL)			\
+do {								\
+	uint8_t *__p = (uint8_t *)&(VAL);			\
+	size_t __n = sizeof(VAL);				\
+	count_and_csum((C), __p, __n);				\
+	verify_sig_add_data((C)->mod_sig, __p, __n);		\
+} while (0)
+
 /*
  * Verify the minimum amount of ELF structure of a module needed to check the
  * module's signature without bad ELF crashing the kernel.
@@ -342,6 +358,309 @@ static int module_verify_canonicalise(struct module_verify_data *mvdata)
 }
 
 /*
+ * Extract an ELF REL table
+ *
+ * We need to canonicalise the entries in case section/symbol addition/removal
+ * has rearranged the symbol table and the section table.
+ */
+static int extract_elf_rel(struct module_verify_data *mvdata,
+			   unsigned secix,
+			   const Elf_Rel *reltab, size_t nrels,
+			   const char *sh_name)
+{
+	struct {
+#if defined(MODULES_ARE_ELF32)
+		uint32_t	r_offset;
+		uint32_t	st_value;
+		uint32_t	st_size;
+		uint16_t	st_shndx;
+		uint8_t		r_type;
+		uint8_t		st_info;
+		uint8_t		st_other;
+#elif defined(MODULES_ARE_ELF64)
+		uint64_t	r_offset;
+		uint64_t	st_value;
+		uint64_t	st_size;
+		uint32_t	r_type;
+		uint16_t	st_shndx;
+		uint8_t		st_info;
+		uint8_t		st_other;
+#else
+#error unsupported module type
+#endif
+	} __attribute__((packed)) relocation;
+
+	const Elf_Rel *reloc;
+	const Elf_Sym *symbols, *symbol;
+	const char *strings;
+	unsigned long r_sym;
+	size_t nsyms, loop;
+
+	nsyms = mvdata->sections[secix].sh_size / sizeof(Elf_Sym);
+	symbols = mvdata->buffer + mvdata->sections[secix].sh_offset;
+	strings = mvdata->buffer +
+		mvdata->sections[mvdata->sections[secix].sh_link].sh_offset;
+
+	/* Contribute the relevant bits from a join of { REL, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		unsigned st_shndx;
+
+		reloc = &reltab[loop];
+
+		/* Decode the relocation */
+		relocation.r_offset = reloc->r_offset;
+		relocation.r_type = ELF_R_TYPE(reloc->r_info);
+
+		/* Decode the symbol referenced by the relocation */
+		r_sym = ELF_R_SYM(reloc->r_info);
+		if (r_sym >= nsyms)
+			return -ELIBBAD;
+		symbol = &symbols[r_sym];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = symbol->st_shndx;
+
+		/* Canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < mvdata->nsects) {
+			if (!(mvdata->sections[st_shndx].sh_flags & SHF_ALLOC))
+				return -ELIBBAD;
+			relocation.st_shndx = mvdata->canonmap[st_shndx];
+		}
+
+		crypto_digest_update_val(mvdata, relocation);
+
+		/* Undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = strings + symbol->st_name;
+			crypto_digest_update_data(mvdata,
+						  name, strlen(name) + 1);
+		}
+	}
+
+	_debug("%08zx %02x digested the %s section, nrels %zu\n",
+	       mvdata->signed_size, mvdata->csum, sh_name, nrels);
+
+	return 0;
+}
+
+/*
+ * Extract an ELF RELA table
+ *
+ * We need to canonicalise the entries in case section/symbol addition/removal
+ * has rearranged the symbol table and the section table.
+ */
+static int extract_elf_rela(struct module_verify_data *mvdata,
+			    unsigned secix,
+			    const Elf_Rela *relatab, size_t nrels,
+			    const char *sh_name)
+{
+	struct {
+#if defined(MODULES_ARE_ELF32)
+		uint32_t	r_offset;
+		uint32_t	r_addend;
+		uint32_t	st_value;
+		uint32_t	st_size;
+		uint16_t	st_shndx;
+		uint8_t		r_type;
+		uint8_t		st_info;
+		uint8_t		st_other;
+#elif defined(MODULES_ARE_ELF64)
+		uint64_t	r_offset;
+		uint64_t	r_addend;
+		uint64_t	st_value;
+		uint64_t	st_size;
+		uint32_t	r_type;
+		uint16_t	st_shndx;
+		uint8_t		st_info;
+		uint8_t		st_other;
+#else
+#error unsupported module type
+#endif
+	} __attribute__((packed)) relocation;
+
+	const Elf_Shdr *relsec, *symsec, *strsec;
+	const Elf_Rela *reloc;
+	const Elf_Sym *symbols, *symbol;
+	unsigned long r_sym;
+	const char *strings;
+	size_t nsyms, loop;
+
+	relsec = &mvdata->sections[secix];
+	symsec = &mvdata->sections[relsec->sh_link];
+	strsec = &mvdata->sections[symsec->sh_link];
+	nsyms = symsec->sh_size / sizeof(Elf_Sym);
+	symbols = mvdata->buffer + symsec->sh_offset;
+	strings = mvdata->buffer + strsec->sh_offset;
+
+	/* Contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		unsigned st_shndx;
+
+		reloc = &relatab[loop];
+
+		/* Decode the relocation */
+		relocation.r_offset = reloc->r_offset;
+		relocation.r_addend = reloc->r_addend;
+		relocation.r_type = ELF_R_TYPE(reloc->r_info);
+
+		/* Decode the symbol referenced by the relocation */
+		r_sym = ELF_R_SYM(reloc->r_info);
+		if (r_sym >= nsyms)
+			return -ELIBBAD;
+		symbol = &symbols[r_sym];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = 0;
+		st_shndx = symbol->st_shndx;
+
+		/* Canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < mvdata->nsects) {
+			if (!(mvdata->sections[st_shndx].sh_flags & SHF_ALLOC))
+				return -ELIBBAD;
+			relocation.st_shndx = mvdata->canonmap[st_shndx];
+		}
+
+		crypto_digest_update_val(mvdata, relocation);
+
+		/* Undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = strings + symbol->st_name;
+			crypto_digest_update_data(mvdata,
+						  name, strlen(name) + 1);
+		}
+	}
+
+	_debug("%08zx %02x digested the %s section, nrels %zu\n",
+	       mvdata->signed_size, mvdata->csum, sh_name, nrels);
+
+	return 0;
+}
+
+/*
+ * Verify a module's signature
+ */
+static noinline int module_verify_signature(struct module_verify_data *mvdata)
+{
+	struct crypto_key_verify_context *mod_sig;
+	const Elf_Shdr *sechdrs = mvdata->sections;
+	const char *secstrings = mvdata->secstrings;
+	const u8 *sig = mvdata->sig;
+	size_t sig_size = mvdata->sig_size;
+	int loop, ret;
+
+	_debug("sig in section %u (size %zu)\n",
+	       mvdata->sig_index, mvdata->sig_size);
+	_debug("%02x%02x%02x%02x%02x%02x%02x%02x\n",
+	       sig[0], sig[1], sig[2], sig[3],
+	       sig[4], sig[5], sig[6], sig[7]);
+
+	/* Find the crypto key for the module signature
+	 * - !!! if this tries to load the required hash algorithm module,
+	 *       we will deadlock!!!
+	 */
+	mod_sig = verify_sig_begin(modsign_keyring, sig, sig_size);
+	if (IS_ERR(mod_sig)) {
+		pr_err("Couldn't initiate module signature verification: %ld\n",
+		       PTR_ERR(mod_sig));
+		return PTR_ERR(mod_sig);
+	}
+
+	mvdata->mod_sig = mod_sig;
+#ifdef DEBUG
+	mvdata->xcsum = 0;
+#endif
+
+	/* Load data from each relevant section into the digest.  Note that
+	 * canonlist[] is a filtered list and only contains the sections we
+	 * actually want.
+	 */
+	for (loop = 0; loop < mvdata->ncanon; loop++) {
+		int sect = mvdata->canonlist[loop];
+		unsigned long sh_type = sechdrs[sect].sh_type;
+		unsigned long sh_info = sechdrs[sect].sh_info;
+		unsigned long sh_size = sechdrs[sect].sh_size;
+		const char *sh_name = secstrings + sechdrs[sect].sh_name;
+		const void *data = mvdata->buffer + sechdrs[sect].sh_offset;
+
+#ifdef DEBUG
+		mvdata->csum = 0;
+#endif
+
+		/* Digest the headers of any section we include. */
+		crypto_digest_update_data(mvdata, sh_name, strlen(sh_name));
+		crypto_digest_update_val(mvdata, sechdrs[sect].sh_type);
+		crypto_digest_update_val(mvdata, sechdrs[sect].sh_flags);
+		crypto_digest_update_val(mvdata, sechdrs[sect].sh_size);
+		crypto_digest_update_val(mvdata, sechdrs[sect].sh_addralign);
+
+		/* Relocation record sections refer to the section to be
+		 * relocated, but this needs to be canonicalised to survive
+		 * stripping.
+		 */
+		if (is_elf_rel(sh_type) || is_elf_rela(sh_type))
+			crypto_digest_update_val(mvdata,
+						 mvdata->canonmap[sh_info]);
+
+		/* Since relocation records give details of how we have to
+		 * alter the allocatable sections, we need to digest these too.
+		 *
+		 * These, however, refer to metadata (symbols and sections)
+		 * that may have been altered by the process of adding the
+		 * signature section or the process of being stripped.
+		 *
+		 * To deal with this, we substitute the referenced metadata for
+		 * the references to that metadata.  So, for instance, the
+		 * symbol ref from the relocation record is replaced with the
+		 * contents of the symbol to which it refers, and the symbol's
+		 * section ref is replaced with a canonicalised section number.
+		 */
+		if (is_elf_rel(sh_type)) {
+			ret = extract_elf_rel(mvdata, sect,
+					      data,
+					      sh_size / sizeof(Elf_Rel),
+					      sh_name);
+			if (ret < 0)
+				goto format_error;
+			continue;
+		}
+
+		if (is_elf_rela(sh_type)) {
+			ret = extract_elf_rela(mvdata, sect,
+					       data,
+					       sh_size / sizeof(Elf_Rela),
+					       sh_name);
+			if (ret < 0)
+				goto format_error;
+			continue;
+		}
+
+		/* Include allocatable loadable sections */
+		if (sh_type != SHT_NOBITS)
+			crypto_digest_update_data(mvdata, data, sh_size);
+
+		_debug("%08zx %02x digested the %s section, size %ld\n",
+		       mvdata->signed_size, mvdata->csum, sh_name, sh_size);
+	}
+
+	_debug("Contributed %zu bytes to the digest (csum 0x%02x)\n",
+	       mvdata->signed_size, mvdata->xcsum);
+
+	/* Do the actual signature verification */
+	ret = verify_sig_end(mvdata->mod_sig, sig, sig_size);
+	_debug("verify-sig : %d\n", ret);
+	return ret;
+
+format_error:
+	verify_sig_cancel(mvdata->mod_sig);
+	return -ELIBBAD;
+}
+
+/*
  * Verify a module's integrity
  */
 int module_verify(const Elf_Ehdr *hdr, size_t size, bool *_gpgsig_ok)
@@ -377,7 +696,7 @@ int module_verify(const Elf_Ehdr *hdr, size_t size, bool *_gpgsig_ok)
 	if (ret < 0)
 		goto out;
 
-	ret = 0;
+	ret = module_verify_signature(&mvdata);
 	kfree(mvdata.canonlist);
 
 out:

