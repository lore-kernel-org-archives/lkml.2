Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab1ERQKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:10:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338Ab1ERQJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:09:11 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=i-jVDoGxYtUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=SyI_GHdlAAAA:8 a=meVymXHHAAAA:8 a=x_Ifd8Fu6S5net2r914A:9 a=jMF_CumaCT_4PRh5ycQA:7 a=UQxMgyrMzRwA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110518160909.372894152@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 12:08:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Reiser <jreiser@bitwagon.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 13/15] ftrace/recordmcount: mcount address adjustment
References: <20110518160809.724215604@goodmis.org>
Content-Disposition: inline; filename=0013-ftrace-recordmcount-mcount-address-adjustment.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Introduce mcount_adjust{,_32,_64} to the C implementation of
recordmcount analog to $mcount_adjust in the perl script.
The adjustment is added to the address of the relocations
against the mcount symbol. If this adjustment is done by
recordmcount at compile time the ftrace_call_adjust function
can be turned into a nop.

Cc: John Reiser <jreiser@bitwagon.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 3c00fab..4be6036 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -22,6 +22,7 @@
 #undef is_fake_mcount
 #undef fn_is_fake_mcount
 #undef MIPS_is_fake_mcount
+#undef mcount_adjust
 #undef sift_rel_mcount
 #undef nop_mcount
 #undef find_secsym_ndx
@@ -63,6 +64,7 @@
 # define is_fake_mcount		is_fake_mcount64
 # define fn_is_fake_mcount	fn_is_fake_mcount64
 # define MIPS_is_fake_mcount	MIPS64_is_fake_mcount
+# define mcount_adjust		mcount_adjust_64
 # define Elf_Addr		Elf64_Addr
 # define Elf_Ehdr		Elf64_Ehdr
 # define Elf_Shdr		Elf64_Shdr
@@ -94,6 +96,7 @@
 # define is_fake_mcount		is_fake_mcount32
 # define fn_is_fake_mcount	fn_is_fake_mcount32
 # define MIPS_is_fake_mcount	MIPS32_is_fake_mcount
+# define mcount_adjust		mcount_adjust_32
 # define Elf_Addr		Elf32_Addr
 # define Elf_Ehdr		Elf32_Ehdr
 # define Elf_Shdr		Elf32_Shdr
@@ -132,6 +135,8 @@ static void fn_ELF_R_INFO(Elf_Rel *const rp, unsigned sym, unsigned type)
 }
 static void (*Elf_r_info)(Elf_Rel *const rp, unsigned sym, unsigned type) = fn_ELF_R_INFO;
 
+static int mcount_adjust = 0;
+
 /*
  * MIPS mcount long call has 2 _mcount symbols, only the position of the 1st
  * _mcount symbol is needed for dynamic function tracer, with it, to disable
@@ -317,8 +322,8 @@ static uint_t *sift_rel_mcount(uint_t *mlocp,
 			mcountsym = get_mcountsym(sym0, relp, str0);
 
 		if (mcountsym == Elf_r_sym(relp) && !is_fake_mcount(relp)) {
-			uint_t const addend = _w(_w(relp->r_offset) - recval);
-
+			uint_t const addend =
+				_w(_w(relp->r_offset) - recval + mcount_adjust);
 			mrelp->r_offset = _w(offbase
 				+ ((void *)mlocp - (void *)mloc0));
 			Elf_r_info(mrelp, recsym, reltype);
-- 
1.7.4.4


