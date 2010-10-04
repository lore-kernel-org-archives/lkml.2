Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab0JDHbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 03:31:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53200 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab0JDHbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 03:31:35 -0400
Date: Mon, 4 Oct 2010 09:31:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, cpu: Fix X86_FEATURE_NOPL
Message-ID: <20101004073127.GA20305@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	lkml <linux-kernel@vger.kernel.org>
References: <20101003093701.GB3733@liondog.tnic>
 <4CA89681.8000202@zytor.com>
 <20101003152212.GA13233@liondog.tnic>
 <a3fce0e5-e6c5-4bf0-b8c0-4954825a7065@email.android.com>
 <20101003201139.GA16532@liondog.tnic>
 <dc1a5ce2-0414-4f15-9e7b-fcfa4435adb5@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dc1a5ce2-0414-4f15-9e7b-fcfa4435adb5@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ba0593bf553c450a03dbc5f8c1f0ff58b778a0c8 cleared the aforementioned
cpuid bit only on 32-bit due to various problems with Virtual PC. This
somehow got lost during the 32- + 64-bit merge so restore the feature
bit on 64-bit. For that, set it explicitly for non-constant arguments of
cpu_has(). Update comment for future reference.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/kernel/cpu/common.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index caa967d..4b68bda 100644
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
-- 
1.7.2.3

-- 
Regards/Gruss,
    Boris.
