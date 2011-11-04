Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab1KDL1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 07:27:00 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58211 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab1KDL0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 07:26:38 -0400
From: Borislav Petkov <bp@amd64.org>
To: linux-stable <stable@vger.kernel.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] x86-32, amd: Move va_align definition to unbreak 32-bit build
Date: Fri,  4 Nov 2011 12:26:35 +0100
Message-Id: <1320405995-10199-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <20111104112209.GB8020@aftab>
References: <20111104112209.GB8020@aftab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Upstream commit: 9387f774d61b01ab71bade85e6d0bfab0b3419bd

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
Link: http://lkml.kernel.org/r/1312633899-1131-1-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
1.7.8.rc0

