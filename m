Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab1HFMbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 08:31:46 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:48919 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1HFMbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 08:31:45 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, Andre Przywara <Andre.Przywara@amd.com>,
        Martin Pohlack <Martin.Pohlack@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] x86, AMD: Fix 32-bit build after cache aliasing patch
Date: Sat,  6 Aug 2011 14:31:38 +0200
Message-Id: <1312633899-1131-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <4E3C8664.7050607@zytor.com>
References: <4E3C8664.7050607@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

hpa reported that dfb09f9b7ab03fd367740e541a5caf830ed56726 breaks 32-bit
builds with the following error message:

/home/hpa/kernel/linux-tip.cpu/arch/x86/kernel/cpu/amd.c:437: undefined
reference to `va_align'
/home/hpa/kernel/linux-tip.cpu/arch/x86/kernel/cpu/amd.c:436: undefined
reference to `va_align'

This is due to the fact that va_align is a global in a 64-bit only
compilation unit. Move it to mmap.c where it is visible to both
subarches.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/sys_x86_64.c |    4 ----
 arch/x86/mm/mmap.c           |    5 ++++-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index aaa8d09..fe7d2da 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -18,10 +18,6 @@
 #include <asm/ia32.h>
 #include <asm/syscalls.h>
 
-struct __read_mostly va_alignment va_align = {
-	.flags = -1,
-};
-
 /*
  * Align a virtual address to avoid aliasing in the I$ on AMD F15h.
  *
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index d4c0736..4b5ba85 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -31,6 +31,10 @@
 #include <linux/sched.h>
 #include <asm/elf.h>
 
+struct __read_mostly va_alignment va_align = {
+	.flags = -1,
+};
+
 static unsigned int stack_maxrandom_size(void)
 {
 	unsigned int max = 0;
@@ -42,7 +46,6 @@ static unsigned int stack_maxrandom_size(void)
 	return max;
 }
 
-
 /*
  * Top of mmap area (just below the process stack).
  *
-- 
1.7.4.rc2

