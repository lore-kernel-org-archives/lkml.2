Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1EKRXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:23:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43564 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab1EKRXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:23:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=v+gE5SJIXWVSuXx1zbnYr/uNAeefeXGSJZIQ6kk8fKukxT5m665ccI2sh5PTRWQnVy
         aCAfwOVO42bI3OFEB8xg1J3YX7LLycZf9KnPMp8s0XkU6KBTteC/J6q3GO6ntIqM6FSj
         T+TAn/EkhaOWvo/aCijOP98MGAShH5ZyVP6Ec=
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH] ftrace: recordmcount: avoid STT_FUNC symbols as base on ARM
Date: Wed, 11 May 2011 22:53:51 +0530
Message-Id: <1305134631-31617-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 scripts/recordmcount.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index baf187b..0e2944a 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -39,6 +39,7 @@
 #undef ELF_R_INFO
 #undef Elf_r_info
 #undef ELF_ST_BIND
+#undef ELF_ST_TYPE
 #undef fn_ELF_R_SYM
 #undef fn_ELF_R_INFO
 #undef uint_t
@@ -68,6 +69,7 @@
 # define ELF_R_INFO		ELF64_R_INFO
 # define Elf_r_info		Elf64_r_info
 # define ELF_ST_BIND		ELF64_ST_BIND
+# define ELF_ST_TYPE		ELF64_ST_TYPE
 # define fn_ELF_R_SYM		fn_ELF64_R_SYM
 # define fn_ELF_R_INFO		fn_ELF64_R_INFO
 # define uint_t			uint64_t
@@ -96,6 +98,7 @@
 # define ELF_R_INFO		ELF32_R_INFO
 # define Elf_r_info		Elf32_r_info
 # define ELF_ST_BIND		ELF32_ST_BIND
+# define ELF_ST_TYPE		ELF32_ST_TYPE
 # define fn_ELF_R_SYM		fn_ELF32_R_SYM
 # define fn_ELF_R_INFO		fn_ELF32_R_INFO
 # define uint_t			uint32_t
@@ -333,6 +336,11 @@ static unsigned find_secsym_ndx(unsigned const txtndx,
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
1.7.4.1

