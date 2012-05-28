Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab2E1DaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:30:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52152 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754021Ab2E1D34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:56 -0400
Message-Id: <20120528031218.606218331@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 114/117] x86, relocs: When printing an error, say relative or absolute
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 24ab82bd9bf18f3efc69a131d73577940941e1b7 upstream.

When the relocs tool throws an error, let the error message say if it
is an absolute or relative symbol.  This should make it a lot more
clear what action the programmer needs to take and should help us find
the reason if additional symbol bugs show up.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/tools/relocs.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index c3cfbb2..b43cfcd 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -563,10 +563,14 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym),
 			Elf32_Sym *sym;
 			unsigned r_type;
 			const char *symname;
+			int shn_abs;
+
 			rel = &sec->reltab[j];
 			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
 			r_type = ELF32_R_TYPE(rel->r_info);
 
+			shn_abs = sym->st_shndx == SHN_ABS;
+
 			switch (r_type) {
 			case R_386_NONE:
 			case R_386_PC32:
@@ -582,7 +586,7 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym),
 				symname = sym_name(sym_strtab, sym);
 				if (!use_real_mode)
 					goto bad;
-				if (sym->st_shndx == SHN_ABS) {
+				if (shn_abs) {
 					if (is_reloc(S_ABS, symname))
 						break;
 					else if (!is_reloc(S_SEG, symname))
@@ -598,7 +602,7 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym),
 
 			case R_386_32:
 				symname = sym_name(sym_strtab, sym);
-				if (sym->st_shndx == SHN_ABS) {
+				if (shn_abs) {
 					if (is_reloc(S_ABS, symname))
 						break;
 					else if (!is_reloc(S_REL, symname))
@@ -616,7 +620,8 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym),
 				break;
 			bad:
 				symname = sym_name(sym_strtab, sym);
-				die("Invalid %s relocation: %s\n",
+				die("Invalid %s %s relocation: %s\n",
+				    shn_abs ? "absolute" : "relative",
 				    rel_type(r_type), symname);
 			}
 		}


