Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1E0MrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:47:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:51980 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab1E0MrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:47:03 -0400
Date: Fri, 27 May 2011 12:46:03 GMT
From: tip-bot for Rabin Vincent <rabin@rab.in>
Message-ID: <tip-9905ce8ad7b79dddd23c7b4753d0b2cdb65bde3c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rabin@rab.in, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rabin@rab.in, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1305134631-31617-1-git-send-email-rabin@rab.in>
References: <1305134631-31617-1-git-send-email-rabin@rab.in>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] ftrace/recordmcount: Avoid STT_FUNC symbols as base on ARM
Git-Commit-ID: 9905ce8ad7b79dddd23c7b4753d0b2cdb65bde3c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 May 2011 12:46:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9905ce8ad7b79dddd23c7b4753d0b2cdb65bde3c
Gitweb:     http://git.kernel.org/tip/9905ce8ad7b79dddd23c7b4753d0b2cdb65bde3c
Author:     Rabin Vincent <rabin@rab.in>
AuthorDate: Wed, 11 May 2011 22:53:51 +0530
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 25 May 2011 19:56:33 -0400

ftrace/recordmcount: Avoid STT_FUNC symbols as base on ARM

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
