Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965467Ab2FAQW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:22:26 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16696 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965438Ab2FAQWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:22:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6729"; a="194516777"
From: David Brown <davidb@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jon Masters <jonathan@jonmasters.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Paulo Marques <pmarques@grupopie.com>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH variant 2] ARM: Prevent KALLSYM size mismatch on ARM.
Date: Fri,  1 Jun 2012 09:22:01 -0700
Message-Id: <1338567721-19514-3-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338567721-19514-1-git-send-email-davidb@codeaurora.org>
References: <1338567721-19514-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM builds seem to be plagued by an occasional build error:

    Inconsistent kallsyms data
    This is a bug - please report about it
    Try "make KALLSYMS_EXTRA_PASS=1" as a workaround

The problem has to do with alignment of some sections by the linker.
The kallsyms data is built in two passes by first linking the kernel
without it, and then linking the kernel again with the symbols
included.  Normally, this just shifts the symbols, without changing
their order, and the compression used by the kallsyms gives the same
result.

On non SMP, the per CPU data is empty.  Depending on the where the
alignment ends up, it can come out as either:

   +-------------------+
   | last text segment |
   +-------------------+
   /* padding */
   +-------------------+     <- L1_CACHE_BYTES alignemnt
   | per cpu (empty)   |
   +-------------------+
__per_cpu_end:
   /* padding */
__data_loc:
   +-------------------+     <- THREAD_SIZE alignment
   | data              |
   +-------------------+

or

   +-------------------+
   | last text segment |
   +-------------------+
   /* padding */
   +-------------------+     <- L1_CACHE_BYTES alignemnt
   | per cpu (empty)   |
   +-------------------+
__per_cpu_end:
   /* no padding */
__data_loc:
   +-------------------+     <- THREAD_SIZE alignment
   | data              |
   +-------------------+

if the alignment satisfies both.  Because symbols that have the same
address are sorted by 'nm -n', the second case will be in a different
order than the first case.  This changes the compression, changing the
size of the kallsym data, causing the build failure.

The KALLSYMS_EXTRA_PASS=1 workaround usually works, but it is still
possible to have the alignment change between the second and third
pass.  It's probably even possible for it to never reach a fixedpoint.

The problem only occurs on non-SMP, when the per-cpu data is empty,
and when the data segment has alignment (and immediately follows the
text segments).  Fix this by only including the per_cpu section on
SMP, when it is not empty.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/kernel/vmlinux.lds.S |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 43a31fb..36ff15b 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -183,7 +183,9 @@ SECTIONS
 	}
 #endif
 
+#ifdef CONFIG_SMP
 	PERCPU_SECTION(L1_CACHE_BYTES)
+#endif
 
 #ifdef CONFIG_XIP_KERNEL
 	__data_loc = ALIGN(4);		/* location in binary */
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

