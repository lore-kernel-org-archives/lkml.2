Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab0KIJGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:06:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52110 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab0KIJGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:06:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Yw4pu1l9WdCMyZUmU+HyflK9xAvFKppRFstWY2X8SzoaVBRt0tKv/ELlBmGhNiKHI0
         FWUePpQNGNEzYLjRCitVsQC6jxO29jMdm0PRPxtJ24kvJdtaZXKta44C/VQUP/2+UFnu
         vk1xsWBsO5UFtowOyYLygqM1A2zV/U5beuDeI=
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <ext-mika.1.westerberg@nokia.com>
Subject: [PATCH 1/4] proc/vmcore: allow archs to override vmcore_elf_check_arch()
Date: Tue,  9 Nov 2010 11:06:10 +0200
Message-Id: <df680f67f33d8b0ef815045b53f205b3ff35de63.1289292124.git.mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289292124.git.mika.westerberg@iki.fi>
References: <cover.1289292124.git.mika.westerberg@iki.fi>
In-Reply-To: <cover.1289292124.git.mika.westerberg@iki.fi>
References: <cover.1289292124.git.mika.westerberg@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <ext-mika.1.westerberg@nokia.com>

Allow architectures to redefine this macro if needed. This is useful for
example in architectures where 64-bit ELF vmcores are not supported.
Specifying zero vmcore_elf64_check_arch() allows compiler to optimize
away unnecessary parts of parse_crash_elf64_headers().

We also rename the macro to vmcore_elf64_check_arch() to reflect that it
is used for 64-bit vmcores only.

Signed-off-by: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
---
 fs/proc/vmcore.c           |    2 +-
 include/linux/crash_dump.h |    9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 2367fb3..74802bc5 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -499,7 +499,7 @@ static int __init parse_crash_elf64_headers(void)
 	/* Do some basic Verification. */
 	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0 ||
 		(ehdr.e_type != ET_CORE) ||
-		!vmcore_elf_check_arch(&ehdr) ||
+		!vmcore_elf64_check_arch(&ehdr) ||
 		ehdr.e_ident[EI_CLASS] != ELFCLASS64 ||
 		ehdr.e_ident[EI_VERSION] != EV_CURRENT ||
 		ehdr.e_version != EV_CURRENT ||
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 0026f26..088cd4a 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -20,7 +20,14 @@ extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 #define vmcore_elf_check_arch_cross(x) 0
 #endif
 
-#define vmcore_elf_check_arch(x) (elf_check_arch(x) || vmcore_elf_check_arch_cross(x))
+/*
+ * Architecture code can redefine this if there are any special checks
+ * needed for 64-bit ELF vmcores. In case of 32-bit only architecture,
+ * this can be set to zero.
+ */
+#ifndef vmcore_elf64_check_arch
+#define vmcore_elf64_check_arch(x) (elf_check_arch(x) || vmcore_elf_check_arch_cross(x))
+#endif
 
 /*
  * is_kdump_kernel() checks whether this kernel is booting after a panic of
-- 
1.7.2.3

