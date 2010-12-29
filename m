Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab0L2V0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 16:26:01 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56205 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab0L2V0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 16:26:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=L9HFL9HjPfIwl3hSDbeCVwdMyEhupKw46Znrnups1LF3YeYEahujhZEHTOcBJj+5WK
         WJDP6gvBIanRGkXD5jhKdF+1SNFb7N+/eZcbllnW9Bc/0OEpu/RfNGMx7bA8UtjBL8m8
         iS54wdDzBen8x6rQ6HAruDsw3C5SMf6SZtcz4=
MIME-Version: 1.0
Date: Thu, 30 Dec 2010 06:25:58 +0900
Message-ID: <AANLkTim+dt2BxCUqcKa=d+mzn+PS+3a9XyYnRsy-ZOQB@mail.gmail.com>
Subject: [PATCH 4/4] elf core: Rewrite offset and segs initialization simply
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

Offset handling here has so far been scattered so difficult to
understand how foffset and dataoff variables are initialized at first
sight. Now section header table moved to next to ELF header, offset
handling can be rewritten more simply. This patch initializes foffset
and dataoff variables without using offset variable. Also, rewrite
segs initialization simply.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 fs/binfmt_elf.c       |   44 ++++++++++++++++++--------------------------
 fs/binfmt_elf_fdpic.c |   42 ++++++++++++++++--------------------------
 2 files changed, 34 insertions(+), 52 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 3ba6838..710abdc 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1874,10 +1874,10 @@ static int elf_core_dump(struct coredump_params *cprm)
 	int has_dumped = 0;
 	mm_segment_t fs;
 	int segs;
-	size_t size = 0;
+	size_t size = 0, note_size;
 	struct vm_area_struct *vma, *gate_vma;
 	struct elfhdr *elf = NULL;
-	loff_t offset = 0, dataoff, foffset;
+	loff_t offset, dataoff, foffset;
 	struct elf_note_info info;
 	struct elf_phdr *phdr4note = NULL;
 	struct elf_shdr *shdr0 = NULL;
@@ -1898,19 +1898,17 @@ static int elf_core_dump(struct coredump_params *cprm)
 	elf = kmalloc(sizeof(*elf), GFP_KERNEL);
 	if (!elf)
 		goto out;
+
+	gate_vma = get_gate_vma(current);
+
 	/*
 	 * The number of segs are recored into ELF header as 16bit value.
 	 * Please check DEFAULT_MAX_MAP_COUNT definition when you modify here.
 	 */
-	segs = current->mm->map_count;
-	segs += elf_core_extra_phdrs();
-
-	gate_vma = get_gate_vma(current);
-	if (gate_vma != NULL)
-		segs++;
-
-	/* for notes section */
-	segs++;
+	segs = current->mm->map_count
+		+ elf_core_extra_phdrs()
+		+ (gate_vma ? 1 : 0)
+		+ 1; /* for notes section */

 	/*
 	 * Collect all the non-memory information about the process for the
@@ -1925,23 +1923,17 @@ static int elf_core_dump(struct coredump_params *cprm)
 	fs = get_fs();
 	set_fs(KERNEL_DS);

-	foffset = offset = elf->e_phoff + segs * elf->e_phentsize;
+	note_size = get_note_info_size(&info)
+		+ elf_coredump_extra_notes_size();

-	/* Write notes phdr entry */
-	{
-		size_t sz = get_note_info_size(&info);
+	foffset = elf->e_phoff + segs * elf->e_phentsize;
+	dataoff = roundup(foffset + note_size, ELF_EXEC_PAGESIZE);
+	offset = dataoff;

-		sz += elf_coredump_extra_notes_size();
-
-		phdr4note = kmalloc(sizeof(*phdr4note), GFP_KERNEL);
-		if (!phdr4note)
-			goto end_coredump;
-
-		fill_elf_note_phdr(phdr4note, sz, offset);
-		offset += sz;
-	}
-
-	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
+	phdr4note = kmalloc(sizeof(*phdr4note), GFP_KERNEL);
+	if (!phdr4note)
+		goto end_coredump;
+	fill_elf_note_phdr(phdr4note, note_size, foffset);

 	if (elf->e_shoff) {
 		shdr0 = kmalloc(sizeof(*shdr0), GFP_KERNEL);
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 59c7284..971a39e 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1596,11 +1596,11 @@ static int elf_fdpic_core_dump(struct
coredump_params *cprm)
 	int has_dumped = 0;
 	mm_segment_t fs;
 	int segs;
-	size_t size = 0;
+	size_t size = 0, note_size;
 	int i;
 	struct vm_area_struct *vma;
 	struct elfhdr *elf = NULL;
-	loff_t offset = 0, dataoff, foffset;
+	loff_t offset, dataoff, foffset;
 	int numnote;
 	struct memelfnote *notes = NULL;
 	struct elf_prstatus *prstatus = NULL;	/* NT_PRSTATUS */
@@ -1678,11 +1678,9 @@ static int elf_fdpic_core_dump(struct
coredump_params *cprm)
 	fill_prstatus(prstatus, current, cprm->signr);
 	elf_core_copy_regs(&prstatus->pr_reg, cprm->regs);

-	segs = current->mm->map_count;
-	segs += elf_core_extra_phdrs();
-
-	/* for notes section */
-	segs++;
+	segs = current->mm->map_count
+		+ elf_core_extra_phdrs()
+		+ 1; /* for notes section */

 	/* Set up header */
 	fill_elf_fdpic_header(elf, segs);
@@ -1724,27 +1722,19 @@ static int elf_fdpic_core_dump(struct
coredump_params *cprm)
 	fs = get_fs();
 	set_fs(KERNEL_DS);

-	foffset = offset = elf->e_phoff + segs * elf->e_phentsize;
-
-	/* Write notes phdr entry */
-	{
-		int sz = 0;
-
-		for (i = 0; i < numnote; i++)
-			sz += notesize(notes + i);
-
-		sz += thread_status_size;
-
-		phdr4note = kmalloc(sizeof(*phdr4note), GFP_KERNEL);
-		if (!phdr4note)
-			goto end_coredump;
+	note_size = 0;
+	for (i = 0; i < numnote; i++)
+		note_size += notesize(notes + i);
+	note_size += thread_status_size;

-		fill_elf_note_phdr(phdr4note, sz, offset);
-		offset += sz;
-	}
+	foffset = offset = elf->e_phoff + segs * elf->e_phentsize;
+	dataoff = roundup(foffset + note_size, ELF_EXEC_PAGESIZE);
+	offset = dataoff;

-	/* Page-align dumped data */
-	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
+	phdr4note = kmalloc(sizeof(*phdr4note), GFP_KERNEL);
+	if (!phdr4note)
+		goto end_coredump;
+	fill_elf_note_phdr(phdr4note, note_size, foffset);

 	if (elf->e_shoff) {
 		shdr0 = kmalloc(sizeof(*shdr0), GFP_KERNEL);
-- 
1.7.1
