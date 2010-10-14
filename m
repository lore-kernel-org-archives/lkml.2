Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab0JNAcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:32:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:46204 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0JNAcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:32:04 -0400
Date: Thu, 14 Oct 2010 00:31:47 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4CB641F7.9040103@goop.org>
References: <4CB641F7.9040103@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/memblock] x86-64: Only set max_pfn_mapped to 512 MiB if we enter via head_64.S
Message-ID: <tip-859ee4f57fb4e91de8439496f62eb996f4a28ca8@git.kernel.org>
Git-Commit-ID: 859ee4f57fb4e91de8439496f62eb996f4a28ca8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Oct 2010 00:31:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  859ee4f57fb4e91de8439496f62eb996f4a28ca8
Gitweb:     http://git.kernel.org/tip/859ee4f57fb4e91de8439496f62eb996f4a28ca8
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Wed, 13 Oct 2010 16:34:15 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 13 Oct 2010 17:09:59 -0700

x86-64: Only set max_pfn_mapped to 512 MiB if we enter via head_64.S

head_64.S maps up to 512 MiB, but that is not necessarity true for
other entry paths, such as Xen.

Thus, co-locate the setting of max_pfn_mapped with the code to
actually set up the page tables in head_64.S.  The 32-bit code is
already so co-located.  (The Xen code already sets max_pfn_mapped
correctly for its own use case.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
LKML-Reference: <4CB641F7.9040103@goop.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head_64.S |    2 ++
 arch/x86/kernel/setup.c   |    1 -
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 239046b..b75c6f4 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -141,6 +141,8 @@ ident_complete:
 	addq	%rbp, trampoline_level4_pgt + (511*8)(%rip)
 #endif
 
+	movq    $KERNEL_IMAGE_SIZE / PAGE_SIZE, max_pfn_mapped(%rip)
+
 	/* Due to ENTRY(), sometimes the empty space gets filled with
 	 * zeros. Better take a jmp than relying on empty space being
 	 * filled with 0x90 (nop)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b11a238..c3cebfe 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -932,7 +932,6 @@ void __init setup_arch(char **cmdline_p)
 		max_low_pfn = max_pfn;
 
 	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
-	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
 #endif
 
 	/*
