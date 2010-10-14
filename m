Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab0JNHmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:42:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:37746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab0JNHmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:42:51 -0400
Date: Thu, 14 Oct 2010 07:42:14 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, jeremy.fitzhardinge@citrix.com, jeremy@goop.org,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jeremy.fitzhardinge@citrix.com, jeremy@goop.org,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu
In-Reply-To: <4CB6AB24.9020504@kernel.org>
References: <4CB6AB24.9020504@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/memblock] x86-64: Only set max_pfn_mapped to 512 MiB if we enter via head_64.S
Message-ID: <tip-67e87f0a1c5cbc750f81ebf6a128e8ff6f4376cc@git.kernel.org>
Git-Commit-ID: 67e87f0a1c5cbc750f81ebf6a128e8ff6f4376cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Oct 2010 07:42:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67e87f0a1c5cbc750f81ebf6a128e8ff6f4376cc
Gitweb:     http://git.kernel.org/tip/67e87f0a1c5cbc750f81ebf6a128e8ff6f4376cc
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Wed, 13 Oct 2010 16:34:15 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Oct 2010 09:06:49 +0200

x86-64: Only set max_pfn_mapped to 512 MiB if we enter via head_64.S

head_64.S maps up to 512 MiB, but that is not necessarity true for
other entry paths, such as Xen.

Thus, co-locate the setting of max_pfn_mapped with the code to
actually set up the page tables in head_64.S.  The 32-bit code is
already so co-located.  (The Xen code already sets max_pfn_mapped
correctly for its own use case.)

-v2:

 Yinghai fixed the following bug in this patch:

 |
 | max_pfn_mapped is in .bss section, so we need to set that
 | after bss get cleared. Without that we crash on bootup.
 |
 | That is safe because Xen does not call x86_64_start_kernel().
 |

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Fixed-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <4CB6AB24.9020504@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/head64.c |    2 ++
 arch/x86/kernel/setup.c  |    1 -
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 97adf98..2d2673c 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -80,6 +80,8 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	/* Cleanup the over mapped high alias */
 	cleanup_highmap();
 
+	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
+
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
 #ifdef CONFIG_EARLY_PRINTK
 		set_intr_gate(i, &early_idt_handlers[i]);
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
