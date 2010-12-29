Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab0L2V03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 16:26:29 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46744 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab0L2V01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 16:26:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dlck9zoq0llWLPbELB1xQYux/Z3f3kX+dGtAafT8KgA/bHosLsK/SW+biEMBxap24Y
         ALlgmIZzYUhx5LFgEJzuq9NxdfXh/qgae54ltSZ9T6yr9iBbWKE3BfYWUnG1bQrsqtVS
         iRrsPkpbaBZa3YEca7dBOGPIO0DNg3V02+P2M=
MIME-Version: 1.0
In-Reply-To: <AANLkTimK9gh_LVW2faCbVMpwMeBFOJLRXHJkA4_3Oi6=@mail.gmail.com>
References: <AANLkTimK9gh_LVW2faCbVMpwMeBFOJLRXHJkA4_3Oi6=@mail.gmail.com>
Date: Thu, 30 Dec 2010 06:19:51 +0900
Message-ID: <AANLkTimKUAH3VA6-=moR5nTrmn-yi4D_yoLQtU1ygYAh@mail.gmail.com>
Subject: [PATCH 1/4] elf core: Write section header table first
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

Change a position of section header table from the last to the next to
ELF header. Because section header table offset is located at next to
ELF header and ELF header size is constant, section header table
offset is also constant if exists; so is program header table
offset. We no longer need to calculate vma data size in advance.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 fs/binfmt_elf.c       |   42 ++++++++++++++++++++++--------------------
 fs/binfmt_elf_fdpic.c |   43 +++++++++++++++++++++++--------------------
 2 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 6884e19..5ab062c 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1234,11 +1234,17 @@ static void fill_elf_header(struct elfhdr
*elf, int segs,
 	elf->e_type = ET_CORE;
 	elf->e_machine = machine;
 	elf->e_version = EV_CURRENT;
-	elf->e_phoff = sizeof(struct elfhdr);
 	elf->e_flags = flags;
 	elf->e_ehsize = sizeof(struct elfhdr);
 	elf->e_phentsize = sizeof(struct elf_phdr);
-	elf->e_phnum = segs;
+
+	if (segs < PN_XNUM) {
+		elf->e_phoff = sizeof(struct elfhdr);
+		elf->e_phnum = segs;
+	} else {
+		elf->e_phoff = sizeof(struct elfhdr) + sizeof(struct elf_shdr);
+		elf->e_phnum = PN_XNUM;
+	}

 	return;
 }
@@ -1839,12 +1845,13 @@ static struct vm_area_struct *next_vma(struct
vm_area_struct *this_vma,
 }

 static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
-			     elf_addr_t e_shoff, int segs)
+			     int segs)
 {
-	elf->e_shoff = e_shoff;
+	elf->e_shoff = sizeof(*elf);
 	elf->e_shentsize = sizeof(*shdr4extnum);
 	elf->e_shnum = 1;
 	elf->e_shstrndx = SHN_UNDEF;
+	elf->e_phoff = elf->e_shoff + elf->e_shnum * elf->e_shentsize;

 	memset(shdr4extnum, 0, sizeof(*shdr4extnum));

@@ -1886,7 +1893,6 @@ static int elf_core_dump(struct coredump_params *cprm)
 	struct elf_phdr *phdr4note = NULL;
 	struct elf_shdr *shdr4extnum = NULL;
 	Elf_Half e_phnum;
-	elf_addr_t e_shoff;

 	/*
 	 * We no longer stop all VM operations.
@@ -1937,6 +1943,8 @@ static int elf_core_dump(struct coredump_params *cprm)
 	set_fs(KERNEL_DS);

 	offset += sizeof(*elf);				/* Elf header */
+	if (e_phnum == PN_XNUM)				/* Section header */
+		offset += sizeof(struct elf_shdr);
 	offset += segs * sizeof(struct elf_phdr);	/* Program headers */
 	foffset = offset;

@@ -1956,23 +1964,25 @@ static int elf_core_dump(struct coredump_params *cprm)

 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);

-	offset += elf_core_vma_data_size(gate_vma, cprm->mm_flags);
-	offset += elf_core_extra_data_size();
-	e_shoff = offset;
-
 	if (e_phnum == PN_XNUM) {
 		shdr4extnum = kmalloc(sizeof(*shdr4extnum), GFP_KERNEL);
 		if (!shdr4extnum)
 			goto end_coredump;
-		fill_extnum_info(elf, shdr4extnum, e_shoff, segs);
+		fill_extnum_info(elf, shdr4extnum, segs);
 	}

-	offset = dataoff;
-
 	size += sizeof(*elf);
 	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
 		goto end_coredump;

+	if (e_phnum == PN_XNUM) {
+		size += sizeof(*shdr4extnum);
+		if (size > cprm->limit
+		    || !dump_write(cprm->file, shdr4extnum,
+				   sizeof(*shdr4extnum)))
+			goto end_coredump;
+	}
+
 	size += sizeof(*phdr4note);
 	if (size > cprm->limit
 	    || !dump_write(cprm->file, phdr4note, sizeof(*phdr4note)))
@@ -2046,14 +2056,6 @@ static int elf_core_dump(struct coredump_params *cprm)
 	if (!elf_core_write_extra_data(cprm->file, &size, cprm->limit))
 		goto end_coredump;

-	if (e_phnum == PN_XNUM) {
-		size += sizeof(*shdr4extnum);
-		if (size > cprm->limit
-		    || !dump_write(cprm->file, shdr4extnum,
-				   sizeof(*shdr4extnum)))
-			goto end_coredump;
-	}
-
 end_coredump:
 	set_fs(fs);

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 63039ed..9ff6bef 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1326,15 +1326,22 @@ static inline void
fill_elf_fdpic_header(struct elfhdr *elf, int segs)
 	elf->e_machine = ELF_ARCH;
 	elf->e_version = EV_CURRENT;
 	elf->e_entry = 0;
-	elf->e_phoff = sizeof(struct elfhdr);
 	elf->e_shoff = 0;
 	elf->e_flags = ELF_FDPIC_CORE_EFLAGS;
 	elf->e_ehsize = sizeof(struct elfhdr);
 	elf->e_phentsize = sizeof(struct elf_phdr);
-	elf->e_phnum = segs;
 	elf->e_shentsize = 0;
 	elf->e_shnum = 0;
 	elf->e_shstrndx = 0;
+
+	if (segs < PN_XNUM) {
+		elf->e_phoff = sizeof(struct elfhdr);
+		elf->e_phnum = segs;
+	} else {
+		elf->e_phoff = sizeof(struct elfhdr) + sizeof(struct elf_shdr);
+		elf->e_phnum = PN_XNUM;
+	}
+
 	return;
 }

@@ -1495,12 +1502,13 @@ static int elf_dump_thread_status(long signr,
struct elf_thread_status *t)
 }

 static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
-			     elf_addr_t e_shoff, int segs)
+			     int segs)
 {
-	elf->e_shoff = e_shoff;
+	elf->e_shoff = sizeof(*elf);
 	elf->e_shentsize = sizeof(*shdr4extnum);
 	elf->e_shnum = 1;
 	elf->e_shstrndx = SHN_UNDEF;
+	elf->e_phoff = elf->e_shoff + elf->e_shnum * elf->e_shentsize;

 	memset(shdr4extnum, 0, sizeof(*shdr4extnum));

@@ -1618,7 +1626,6 @@ static int elf_fdpic_core_dump(struct
coredump_params *cprm)
 	struct elf_phdr *phdr4note = NULL;
 	struct elf_shdr *shdr4extnum = NULL;
 	Elf_Half e_phnum;
-	elf_addr_t e_shoff;

 	/*
 	 * We no longer stop all VM operations.
@@ -1734,6 +1741,8 @@ static int elf_fdpic_core_dump(struct
coredump_params *cprm)
 	set_fs(KERNEL_DS);

 	offset += sizeof(*elf);				/* Elf header */
+	if (e_phnum == PN_XNUM)				/* Section header */
+		offset += sizeof(struct elf_shdr);
 	offset += segs * sizeof(struct elf_phdr);	/* Program headers */
 	foffset = offset;

@@ -1757,23 +1766,25 @@ static int elf_fdpic_core_dump(struct
coredump_params *cprm)
 	/* Page-align dumped data */
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);

-	offset += elf_core_vma_data_size(cprm->mm_flags);
-	offset += elf_core_extra_data_size();
-	e_shoff = offset;
-
 	if (e_phnum == PN_XNUM) {
 		shdr4extnum = kmalloc(sizeof(*shdr4extnum), GFP_KERNEL);
 		if (!shdr4extnum)
 			goto end_coredump;
-		fill_extnum_info(elf, shdr4extnum, e_shoff, segs);
+		fill_extnum_info(elf, shdr4extnum, segs);
 	}

-	offset = dataoff;
-
 	size += sizeof(*elf);
 	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
 		goto end_coredump;

+	if (e_phnum == PN_XNUM) {
+		size += sizeof(*shdr4extnum);
+		if (size > cprm->limit
+		    || !dump_write(cprm->file, shdr4extnum,
+				   sizeof(*shdr4extnum)))
+			goto end_coredump;
+	}
+
 	size += sizeof(*phdr4note);
 	if (size > cprm->limit
 	    || !dump_write(cprm->file, phdr4note, sizeof(*phdr4note)))
@@ -1834,14 +1845,6 @@ static int elf_fdpic_core_dump(struct
coredump_params *cprm)
 	if (!elf_core_write_extra_data(cprm->file, &size, cprm->limit))
 		goto end_coredump;

-	if (e_phnum == PN_XNUM) {
-		size += sizeof(*shdr4extnum);
-		if (size > cprm->limit
-		    || !dump_write(cprm->file, shdr4extnum,
-				   sizeof(*shdr4extnum)))
-			goto end_coredump;
-	}
-
 	if (cprm->file->f_pos != offset) {
 		/* Sanity check */
 		printk(KERN_WARNING
-- 
1.7.1
