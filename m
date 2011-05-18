Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab1ERQJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:09:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43579 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab1ERQJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:09:07 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=vhdKIqpQuCYA:10 a=fXMwQ1MyjGQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=SyI_GHdlAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=lMqj8fhCrX4AHx-tP2wA:9 a=nAlqhnsGnT5ZfKZc3A8A:7 a=jEp0ucaQiEUA:10 a=UQxMgyrMzRwA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110518160906.416749788@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 12:08:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Reiser <jreiser@bitwagon.com>
Subject: [PATCH 02/15] ftrace/trivial: Clean up recordmcount.c to use Linux style
References: <20110518160809.724215604@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-trivial-Clean-up-recordmcount.c-to-use-Linux-.patch
 comparisons
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The Linux ftrace subsystem style for comparing is:

  var == 1
  var > 0

and not:

  1 == var
  0 < var

It is considered that Linux developers are smart enough not to do the

  if (var = 1)

mistake.

Cc: John Reiser <jreiser@bitwagon.com>
Link: http://lkml.kernel.org/r/20110421023737.290712238@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.c |   48 ++++++++++++++++++++++++------------------------
 scripts/recordmcount.h |   16 ++++++++--------
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index f9f6f52..37afe0e 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -78,7 +78,7 @@ static off_t
 ulseek(int const fd, off_t const offset, int const whence)
 {
 	off_t const w = lseek(fd, offset, whence);
-	if ((off_t)-1 == w) {
+	if (w == (off_t)-1) {
 		perror("lseek");
 		fail_file();
 	}
@@ -111,7 +111,7 @@ static void *
 umalloc(size_t size)
 {
 	void *const addr = malloc(size);
-	if (0 == addr) {
+	if (addr == 0) {
 		fprintf(stderr, "malloc failed: %zu bytes\n", size);
 		fail_file();
 	}
@@ -136,7 +136,7 @@ static void *mmap_file(char const *fname)
 	void *addr;
 
 	fd_map = open(fname, O_RDWR);
-	if (0 > fd_map || 0 > fstat(fd_map, &sb)) {
+	if (fd_map < 0 || fstat(fd_map, &sb) < 0) {
 		perror(fname);
 		fail_file();
 	}
@@ -147,7 +147,7 @@ static void *mmap_file(char const *fname)
 	addr = mmap(0, sb.st_size, PROT_READ|PROT_WRITE, MAP_PRIVATE,
 		    fd_map, 0);
 	mmap_failed = 0;
-	if (MAP_FAILED == addr) {
+	if (addr == MAP_FAILED) {
 		mmap_failed = 1;
 		addr = umalloc(sb.st_size);
 		uread(fd_map, addr, sb.st_size);
@@ -206,12 +206,12 @@ static uint32_t (*w2)(uint16_t);
 static int
 is_mcounted_section_name(char const *const txtname)
 {
-	return 0 == strcmp(".text",           txtname) ||
-		0 == strcmp(".ref.text",      txtname) ||
-		0 == strcmp(".sched.text",    txtname) ||
-		0 == strcmp(".spinlock.text", txtname) ||
-		0 == strcmp(".irqentry.text", txtname) ||
-		0 == strcmp(".text.unlikely", txtname);
+	return strcmp(".text",           txtname) == 0 ||
+		strcmp(".ref.text",      txtname) == 0 ||
+		strcmp(".sched.text",    txtname) == 0 ||
+		strcmp(".spinlock.text", txtname) == 0 ||
+		strcmp(".irqentry.text", txtname) == 0 ||
+		strcmp(".text.unlikely", txtname) == 0;
 }
 
 /* 32 bit and 64 bit are very similar */
@@ -270,7 +270,7 @@ do_file(char const *const fname)
 		fail_file();
 	} break;
 	case ELFDATA2LSB: {
-		if (1 != *(unsigned char const *)&endian) {
+		if (*(unsigned char const *)&endian != 1) {
 			/* main() is big endian, file.o is little endian. */
 			w = w4rev;
 			w2 = w2rev;
@@ -278,7 +278,7 @@ do_file(char const *const fname)
 		}
 	} break;
 	case ELFDATA2MSB: {
-		if (0 != *(unsigned char const *)&endian) {
+		if (*(unsigned char const *)&endian != 0) {
 			/* main() is little endian, file.o is big endian. */
 			w = w4rev;
 			w2 = w2rev;
@@ -286,9 +286,9 @@ do_file(char const *const fname)
 		}
 	} break;
 	}  /* end switch */
-	if (0 != memcmp(ELFMAG, ehdr->e_ident, SELFMAG)
-	||  ET_REL != w2(ehdr->e_type)
-	||  EV_CURRENT != ehdr->e_ident[EI_VERSION]) {
+	if (memcmp(ELFMAG, ehdr->e_ident, SELFMAG) != 0
+	||  w2(ehdr->e_type) != ET_REL
+	||  ehdr->e_ident[EI_VERSION] != EV_CURRENT) {
 		fprintf(stderr, "unrecognized ET_REL file %s\n", fname);
 		fail_file();
 	}
@@ -321,15 +321,15 @@ do_file(char const *const fname)
 		fail_file();
 	} break;
 	case ELFCLASS32: {
-		if (sizeof(Elf32_Ehdr) != w2(ehdr->e_ehsize)
-		||  sizeof(Elf32_Shdr) != w2(ehdr->e_shentsize)) {
+		if (w2(ehdr->e_ehsize) != sizeof(Elf32_Ehdr)
+		||  w2(ehdr->e_shentsize) != sizeof(Elf32_Shdr)) {
 			fprintf(stderr,
 				"unrecognized ET_REL file: %s\n", fname);
 			fail_file();
 		}
-		if (EM_S390 == w2(ehdr->e_machine))
+		if (w2(ehdr->e_machine) == EM_S390)
 			reltype = R_390_32;
-		if (EM_MIPS == w2(ehdr->e_machine)) {
+		if (w2(ehdr->e_machine) == EM_MIPS) {
 			reltype = R_MIPS_32;
 			is_fake_mcount32 = MIPS32_is_fake_mcount;
 		}
@@ -337,15 +337,15 @@ do_file(char const *const fname)
 	} break;
 	case ELFCLASS64: {
 		Elf64_Ehdr *const ghdr = (Elf64_Ehdr *)ehdr;
-		if (sizeof(Elf64_Ehdr) != w2(ghdr->e_ehsize)
-		||  sizeof(Elf64_Shdr) != w2(ghdr->e_shentsize)) {
+		if (w2(ghdr->e_ehsize) != sizeof(Elf64_Ehdr)
+		||  w2(ghdr->e_shentsize) != sizeof(Elf64_Shdr)) {
 			fprintf(stderr,
 				"unrecognized ET_REL file: %s\n", fname);
 			fail_file();
 		}
-		if (EM_S390 == w2(ghdr->e_machine))
+		if (w2(ghdr->e_machine) == EM_S390)
 			reltype = R_390_64;
-		if (EM_MIPS == w2(ghdr->e_machine)) {
+		if (w2(ghdr->e_machine) == EM_MIPS) {
 			reltype = R_MIPS_64;
 			Elf64_r_sym = MIPS64_r_sym;
 			Elf64_r_info = MIPS64_r_info;
@@ -371,7 +371,7 @@ main(int argc, char const *argv[])
 	}
 
 	/* Process each file in turn, allowing deep failure. */
-	for (--argc, ++argv; 0 < argc; --argc, ++argv) {
+	for (--argc, ++argv; argc > 0; --argc, ++argv) {
 		int const sjval = setjmp(jmpenv);
 		int len;
 
diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index baf187b..ac7b330 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -275,12 +275,12 @@ static uint_t *sift_rel_mcount(uint_t *mlocp,
 			Elf_Sym const *const symp =
 				&sym0[Elf_r_sym(relp)];
 			char const *symname = &str0[w(symp->st_name)];
-			char const *mcount = '_' == gpfx ? "_mcount" : "mcount";
+			char const *mcount = gpfx == '_' ? "_mcount" : "mcount";
 
-			if ('.' == symname[0])
+			if (symname[0] == '.')
 				++symname;  /* ppc64 hack */
-			if (0 == strcmp(mcount, symname) ||
-			    (altmcount && 0 == strcmp(altmcount, symname)))
+			if (strcmp(mcount, symname) == 0 ||
+			    (altmcount && strcmp(altmcount, symname) == 0))
 				mcountsym = Elf_r_sym(relp);
 		}
 
@@ -290,7 +290,7 @@ static uint_t *sift_rel_mcount(uint_t *mlocp,
 			mrelp->r_offset = _w(offbase
 				+ ((void *)mlocp - (void *)mloc0));
 			Elf_r_info(mrelp, recsym, reltype);
-			if (sizeof(Elf_Rela) == rel_entsize) {
+			if (rel_entsize == sizeof(Elf_Rela)) {
 				((Elf_Rela *)mrelp)->r_addend = addend;
 				*mlocp++ = 0;
 			} else
@@ -354,12 +354,12 @@ __has_rel_mcount(Elf_Shdr const *const relhdr,  /* is SHT_REL or SHT_RELA */
 	Elf_Shdr const *const txthdr = &shdr0[w(relhdr->sh_info)];
 	char const *const txtname = &shstrtab[w(txthdr->sh_name)];
 
-	if (0 == strcmp("__mcount_loc", txtname)) {
+	if (strcmp("__mcount_loc", txtname) == 0) {
 		fprintf(stderr, "warning: __mcount_loc already exists: %s\n",
 			fname);
 		succeed_file();
 	}
-	if (SHT_PROGBITS != w(txthdr->sh_type) ||
+	if (w(txthdr->sh_type) != SHT_PROGBITS ||
 	    !is_mcounted_section_name(txtname))
 		return NULL;
 	return txtname;
@@ -370,7 +370,7 @@ static char const *has_rel_mcount(Elf_Shdr const *const relhdr,
 				  char const *const shstrtab,
 				  char const *const fname)
 {
-	if (SHT_REL  != w(relhdr->sh_type) && SHT_RELA != w(relhdr->sh_type))
+	if (w(relhdr->sh_type) != SHT_REL && w(relhdr->sh_type) != SHT_RELA)
 		return NULL;
 	return __has_rel_mcount(relhdr, shdr0, shstrtab, fname);
 }
-- 
1.7.4.4


