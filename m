Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab1EXSSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:18:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41014 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab1EXSRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:17:23 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=fDkxai1E9WIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=hx00kFIsug2KyodYoQMA:9 a=DHQQ7jDAcw4A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110524181720.380386631@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 14:10:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 05/12] ftrace/recordmcount: Avoid STT_FUNC symbols as base on ARM
References: <20110524181032.382259739@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-recordmcount-Avoid-STT_FUNC-symbols-as-base-o.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin@rab.in>

While find_secsym_ndx often finds the unamed local STT_SECTION, if a
section has only one function in it, the ARM toolchain generates the
STT_FUNC symbol before the STT_SECTION, and recordmcount finds this
instead.

This is problematic on ARM because in ARM ELFs, "if a [STT_FUNC] symbol
addresses a Thumb instruction, its value is the address of the
instruction with bit zero set (in a relocatable object, the section
offset with bit zero set)".  This leads to incorrect mcount addresses
being recorded.

Fix this by not using STT_FUNC symbols as the base on ARM.

Signed-off-by: Rabin Vincent <rabin@rab.in>
Link: http://lkml.kernel.org/r/1305134631-31617-1-git-send-email-rabin@rab.in
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 4be6036..f40a6af6 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -43,6 +43,7 @@
 #undef ELF_R_INFO
 #undef Elf_r_info
 #undef ELF_ST_BIND
+#undef ELF_ST_TYPE
 #undef fn_ELF_R_SYM
 #undef fn_ELF_R_INFO
 #undef uint_t
@@ -76,6 +77,7 @@
 # define ELF_R_INFO		ELF64_R_INFO
 # define Elf_r_info		Elf64_r_info
 # define ELF_ST_BIND		ELF64_ST_BIND
+# define ELF_ST_TYPE		ELF64_ST_TYPE
 # define fn_ELF_R_SYM		fn_ELF64_R_SYM
 # define fn_ELF_R_INFO		fn_ELF64_R_INFO
 # define uint_t			uint64_t
@@ -108,6 +110,7 @@
 # define ELF_R_INFO		ELF32_R_INFO
 # define Elf_r_info		Elf32_r_info
 # define ELF_ST_BIND		ELF32_ST_BIND
+# define ELF_ST_TYPE		ELF32_ST_TYPE
 # define fn_ELF_R_SYM		fn_ELF32_R_SYM
 # define fn_ELF_R_INFO		fn_ELF32_R_INFO
 # define uint_t			uint32_t
@@ -427,6 +430,11 @@ static unsigned find_secsym_ndx(unsigned const txtndx,
 		if (txtndx == w2(symp->st_shndx)
 			/* avoid STB_WEAK */
 		    && (STB_LOCAL == st_bind || STB_GLOBAL == st_bind)) {
+			/* function symbols on ARM have quirks, avoid them */
+			if (w2(ehdr->e_machine) == EM_ARM
+			    && ELF_ST_TYPE(symp->st_info) == STT_FUNC)
+				continue;
+
 			*recvalp = _w(symp->st_value);
 			return symp - sym0;
 		}
-- 
1.7.4.4


