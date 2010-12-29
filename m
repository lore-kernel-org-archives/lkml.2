Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab0L2VXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 16:23:19 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62554 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab0L2VXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 16:23:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=IaEEocY+rztMfjfUqQmRPJGOhvnAJtft+D8yh1cJFgDMLRNIaS7c23PtNXzL9JdH87
         qPyHaGIqiTppEsJaD7J1s5ydS6VBJN8LuUQ/pxN28qb8+SSRCZsC/EydvHgZ3yLkXA7+
         eJn9hFicfHDNa/TL6BXdQXhTe46ta/3I/qQYU=
MIME-Version: 1.0
Date: Thu, 30 Dec 2010 06:23:17 +0900
Message-ID: <AANLkTikRLeRyRjCJaTgvVzPiKiRE93DXkJvDm0TwN3P5@mail.gmail.com>
Subject: [PATCH 3/4] elf core: Cleanup ELF handling
From: HATAYAMA Daisuke <d.hatayama@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, jdike@addtoit.com, dhowells@redhat.com,
        gerg@snapgear.com, roland@redhat.com, oleg@redhat.com, mingo@elte.hu,
        viro@zeniv.linux.org.uk, andi@firstfloor.org, alan@lxorguk.ukuu.org.uk,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, suzuki@in.ibm.com,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup ELF handling.
 - Move all ELF header initialization in fill_extnum_info() into
   fill_elf_header() and fill_elf_fdpic_header(), respectively.
 - Rename fill_extnum_info() fill_section_header0(); the first entry
   of section header table is reserved and used to record three kinds
   of extensions. Extended numbering is here used to refer to the
   extension for e_phnum only. Thus, we should use more general name
   fill_section_header0().
 - Use elf->e_shoff to determine whether to write section header
   table. ELF specification defines elf->e_shoff is equal to 0 iff
   there's no section header table.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 fs/binfmt_elf.c       |   64 ++++++++++++++++++-------------------------
 fs/binfmt_elf_fdpic.c |   71 +++++++++++++++++++++---------------------------
 2 files changed, 58 insertions(+), 77 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f311276..3ba6838 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1238,11 +1238,18 @@ static void fill_elf_header(struct elfhdr
*elf, int segs,
 	elf->e_ehsize = sizeof(struct elfhdr);
 	elf->e_phentsize = sizeof(struct elf_phdr);

+	/* If segs > PN_XNUM(0xffff), then e_phnum overflows. To avoid
+	 * this, kernel supports extended numbering. Have a look at
+	 * include/linux/elf.h for further information. */
 	if (segs < PN_XNUM) {
 		elf->e_phoff = sizeof(struct elfhdr);
 		elf->e_phnum = segs;
 	} else {
-		elf->e_phoff = sizeof(struct elfhdr) + sizeof(struct elf_shdr);
+		elf->e_shoff = sizeof(struct elfhdr);
+		elf->e_shentsize = sizeof(struct elf_shdr);
+		elf->e_shnum = 1;
+		elf->e_shstrndx = SHN_UNDEF;
+		elf->e_phoff = elf->e_shoff + elf->e_shnum * elf->e_shentsize;
 		elf->e_phnum = PN_XNUM;
 	}

@@ -1844,21 +1851,15 @@ static struct vm_area_struct *next_vma(struct
vm_area_struct *this_vma,
 	return gate_vma;
 }

-static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
-			     int segs)
+static void fill_section_header0(struct elfhdr *elf, struct elf_shdr *shdr0,
+				 int segs)
 {
-	elf->e_shoff = sizeof(*elf);
-	elf->e_shentsize = sizeof(*shdr4extnum);
-	elf->e_shnum = 1;
-	elf->e_shstrndx = SHN_UNDEF;
-	elf->e_phoff = elf->e_shoff + elf->e_shnum * elf->e_shentsize;
-
-	memset(shdr4extnum, 0, sizeof(*shdr4extnum));
-
-	shdr4extnum->sh_type = SHT_NULL;
-	shdr4extnum->sh_size = elf->e_shnum;
-	shdr4extnum->sh_link = elf->e_shstrndx;
-	shdr4extnum->sh_info = segs;
+	memset(shdr0, 0, sizeof(*shdr0));
+
+	shdr0->sh_type = SHT_NULL;
+	shdr0->sh_size = elf->e_shnum;
+	shdr0->sh_link = elf->e_shstrndx;
+	shdr0->sh_info = segs;
 }

 /*
@@ -1879,8 +1880,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 	loff_t offset = 0, dataoff, foffset;
 	struct elf_note_info info;
 	struct elf_phdr *phdr4note = NULL;
-	struct elf_shdr *shdr4extnum = NULL;
-	Elf_Half e_phnum;
+	struct elf_shdr *shdr0 = NULL;

 	/*
 	 * We no longer stop all VM operations.
@@ -1912,16 +1912,11 @@ static int elf_core_dump(struct coredump_params *cprm)
 	/* for notes section */
 	segs++;

-	/* If segs > PN_XNUM(0xffff), then e_phnum overflows. To avoid
-	 * this, kernel supports extended numbering. Have a look at
-	 * include/linux/elf.h for further information. */
-	e_phnum = segs > PN_XNUM ? PN_XNUM : segs;
-
 	/*
 	 * Collect all the non-memory information about the process for the
 	 * notes.  This also sets up the file header.
 	 */
-	if (!fill_note_info(elf, e_phnum, &info, cprm->signr, cprm->regs))
+	if (!fill_note_info(elf, segs, &info, cprm->signr, cprm->regs))
 		goto cleanup;

 	has_dumped = 1;
@@ -1930,11 +1925,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 	fs = get_fs();
 	set_fs(KERNEL_DS);

-	offset += sizeof(*elf);				/* Elf header */
-	if (e_phnum == PN_XNUM)				/* Section header */
-		offset += sizeof(struct elf_shdr);
-	offset += segs * sizeof(struct elf_phdr);	/* Program headers */
-	foffset = offset;
+	foffset = offset = elf->e_phoff + segs * elf->e_phentsize;

 	/* Write notes phdr entry */
 	{
@@ -1952,22 +1943,21 @@ static int elf_core_dump(struct coredump_params *cprm)

 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);

-	if (e_phnum == PN_XNUM) {
-		shdr4extnum = kmalloc(sizeof(*shdr4extnum), GFP_KERNEL);
-		if (!shdr4extnum)
+	if (elf->e_shoff) {
+		shdr0 = kmalloc(sizeof(*shdr0), GFP_KERNEL);
+		if (!shdr0)
 			goto end_coredump;
-		fill_extnum_info(elf, shdr4extnum, segs);
+		fill_section_header0(elf, shdr0, segs);
 	}

 	size += sizeof(*elf);
 	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
 		goto end_coredump;

-	if (e_phnum == PN_XNUM) {
-		size += sizeof(*shdr4extnum);
+	if (elf->e_shoff) {
+		size += sizeof(*shdr0);
 		if (size > cprm->limit
-		    || !dump_write(cprm->file, shdr4extnum,
-				   sizeof(*shdr4extnum)))
+		    || !dump_write(cprm->file, shdr0, sizeof(*shdr0)))
 			goto end_coredump;
 	}

@@ -2049,7 +2039,7 @@ end_coredump:

 cleanup:
 	free_note_info(&info);
-	kfree(shdr4extnum);
+	kfree(shdr0);
 	kfree(phdr4note);
 	kfree(elf);
 out:
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 715d12d..59c7284 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1326,19 +1326,26 @@ static inline void
fill_elf_fdpic_header(struct elfhdr *elf, int segs)
 	elf->e_machine = ELF_ARCH;
 	elf->e_version = EV_CURRENT;
 	elf->e_entry = 0;
-	elf->e_shoff = 0;
 	elf->e_flags = ELF_FDPIC_CORE_EFLAGS;
 	elf->e_ehsize = sizeof(struct elfhdr);
 	elf->e_phentsize = sizeof(struct elf_phdr);
-	elf->e_shentsize = 0;
-	elf->e_shnum = 0;
-	elf->e_shstrndx = 0;

+	/* If segs > PN_XNUM(0xffff), then e_phnum overflows. To avoid
+	 * this, kernel supports extended numbering. Have a look at
+	 * include/linux/elf.h for further information. */
 	if (segs < PN_XNUM) {
+		elf->e_shoff = 0;
+		elf->e_shentsize = 0;
+		elf->e_shnum = 0;
+		elf->e_shstrndx = 0;
 		elf->e_phoff = sizeof(struct elfhdr);
 		elf->e_phnum = segs;
 	} else {
-		elf->e_phoff = sizeof(struct elfhdr) + sizeof(struct elf_shdr);
+		elf->e_shoff = sizeof(struct elfhdr);
+		elf->e_shentsize = sizeof(struct elf_shdr);
+		elf->e_shnum = 1;
+		elf->e_shstrndx = SHN_UNDEF;
+		elf->e_phoff = elf->e_shoff + elf->e_shnum * elf->e_shentsize;
 		elf->e_phnum = PN_XNUM;
 	}

@@ -1501,21 +1508,15 @@ static int elf_dump_thread_status(long signr,
struct elf_thread_status *t)
 	return sz;
 }

-static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
-			     int segs)
+static void fill_section_header0(struct elfhdr *elf, struct elf_shdr *shdr0,
+				 int segs)
 {
-	elf->e_shoff = sizeof(*elf);
-	elf->e_shentsize = sizeof(*shdr4extnum);
-	elf->e_shnum = 1;
-	elf->e_shstrndx = SHN_UNDEF;
-	elf->e_phoff = elf->e_shoff + elf->e_shnum * elf->e_shentsize;
-
-	memset(shdr4extnum, 0, sizeof(*shdr4extnum));
-
-	shdr4extnum->sh_type = SHT_NULL;
-	shdr4extnum->sh_size = elf->e_shnum;
-	shdr4extnum->sh_link = elf->e_shstrndx;
-	shdr4extnum->sh_info = segs;
+	memset(shdr0, 0, sizeof(*shdr0));
+
+	shdr0->sh_type = SHT_NULL;
+	shdr0->sh_size = elf->e_shnum;
+	shdr0->sh_link = elf->e_shstrndx;
+	shdr0->sh_info = segs;
 }

 /*
@@ -1613,8 +1614,7 @@ static int elf_fdpic_core_dump(struct
coredump_params *cprm)
 	int thread_status_size = 0;
 	elf_addr_t *auxv;
 	struct elf_phdr *phdr4note = NULL;
-	struct elf_shdr *shdr4extnum = NULL;
-	Elf_Half e_phnum;
+	struct elf_shdr *shdr0 = NULL;

 	/*
 	 * We no longer stop all VM operations.
@@ -1684,13 +1684,8 @@ static int elf_fdpic_core_dump(struct
coredump_params *cprm)
 	/* for notes section */
 	segs++;

-	/* If segs > PN_XNUM(0xffff), then e_phnum overflows. To avoid
-	 * this, kernel supports extended numbering. Have a look at
-	 * include/linux/elf.h for further information. */
-	e_phnum = segs > PN_XNUM ? PN_XNUM : segs;
-
 	/* Set up header */
-	fill_elf_fdpic_header(elf, e_phnum);
+	fill_elf_fdpic_header(elf, segs);

 	has_dumped = 1;
 	current->flags |= PF_DUMPCORE;
@@ -1729,11 +1724,7 @@ static int elf_fdpic_core_dump(struct
coredump_params *cprm)
 	fs = get_fs();
 	set_fs(KERNEL_DS);

-	offset += sizeof(*elf);				/* Elf header */
-	if (e_phnum == PN_XNUM)				/* Section header */
-		offset += sizeof(struct elf_shdr);
-	offset += segs * sizeof(struct elf_phdr);	/* Program headers */
-	foffset = offset;
+	foffset = offset = elf->e_phoff + segs * elf->e_phentsize;

 	/* Write notes phdr entry */
 	{
@@ -1755,22 +1746,22 @@ static int elf_fdpic_core_dump(struct
coredump_params *cprm)
 	/* Page-align dumped data */
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);

-	if (e_phnum == PN_XNUM) {
-		shdr4extnum = kmalloc(sizeof(*shdr4extnum), GFP_KERNEL);
-		if (!shdr4extnum)
+	if (elf->e_shoff) {
+		shdr0 = kmalloc(sizeof(*shdr0), GFP_KERNEL);
+		if (!shdr0)
 			goto end_coredump;
-		fill_extnum_info(elf, shdr4extnum, segs);
+		fill_section_header0(elf, shdr0, segs);
 	}

 	size += sizeof(*elf);
 	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
 		goto end_coredump;

-	if (e_phnum == PN_XNUM) {
-		size += sizeof(*shdr4extnum);
+	if (elf->e_shoff) {
+		size += sizeof(*shdr0);
 		if (size > cprm->limit
-		    || !dump_write(cprm->file, shdr4extnum,
-				   sizeof(*shdr4extnum)))
+		    || !dump_write(cprm->file, shdr0,
+				   sizeof(*shdr0)))
 			goto end_coredump;
 	}

-- 
1.7.1
