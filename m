Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab0JDUhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:37:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:38592 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322Ab0JDUhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:37:20 -0400
Date: Mon, 4 Oct 2010 20:36:15 GMT
From: tip-bot for Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, bp@alien8.de, ryan@innosecc.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, bp@alien8.de, ryan@innosecc.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20101004073127.GA20305@liondog.tnic>
References: <20101004073127.GA20305@liondog.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Fix X86_FEATURE_NOPL
Message-ID: <tip-366d4a43b1a7a861c356a0e407c4f03f454d42ea@git.kernel.org>
Git-Commit-ID: 366d4a43b1a7a861c356a0e407c4f03f454d42ea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:36:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  366d4a43b1a7a861c356a0e407c4f03f454d42ea
Gitweb:     http://git.kernel.org/tip/366d4a43b1a7a861c356a0e407c4f03f454d42ea
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Mon, 4 Oct 2010 09:31:27 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 4 Oct 2010 11:22:24 -0700

x86, cpu: Fix X86_FEATURE_NOPL

ba0593bf553c450a03dbc5f8c1f0ff58b778a0c8 cleared the aforementioned
cpuid bit only on 32-bit due to various problems with Virtual PC. This
somehow got lost during the 32- + 64-bit merge so restore the feature
bit on 64-bit. For that, set it explicitly for non-constant arguments of
cpu_has(). Update comment for future reference.

Signed-off-by: Borislav Petkov <bp@alien8.de>
LKML-Reference: <20101004073127.GA20305@liondog.tnic>
Cc: Ryan O'Neill <ryan@innosecc.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/common.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f2f9ac7..927e630 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -704,16 +704,21 @@ void __init early_cpu_init(void)
 }
 
 /*
- * The NOPL instruction is supposed to exist on all CPUs with
- * family >= 6; unfortunately, that's not true in practice because
- * of early VIA chips and (more importantly) broken virtualizers that
- * are not easy to detect.  In the latter case it doesn't even *fail*
- * reliably, so probing for it doesn't even work.  Disable it completely
+ * The NOPL instruction is supposed to exist on all CPUs of family >= 6;
+ * unfortunately, that's not true in practice because of early VIA
+ * chips and (more importantly) broken virtualizers that are not easy
+ * to detect. In the latter case it doesn't even *fail* reliably, so
+ * probing for it doesn't even work. Disable it completely on 32-bit
  * unless we can find a reliable way to detect all the broken cases.
+ * Enable it explicitly on 64-bit for non-constant inputs of cpu_has().
  */
 static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_32
 	clear_cpu_cap(c, X86_FEATURE_NOPL);
+#else
+	set_cpu_cap(c, X86_FEATURE_NOPL);
+#endif
 }
 
 static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
