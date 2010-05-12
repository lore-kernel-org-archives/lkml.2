Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0ELBHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 21:07:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:47004 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621Ab0ELBHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 21:07:13 -0400
Date: Wed, 12 May 2010 01:06:58 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, avi@redhat.com
In-Reply-To: <1273135546-29690-2-git-send-email-avi@redhat.com>
References: <1273135546-29690-2-git-send-email-avi@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: Use static_cpu_has() to implement use_xsave()
Message-ID: <tip-c9775b4cc522e5f1b40b1366a993f0f05f600f39@git.kernel.org>
Git-Commit-ID: c9775b4cc522e5f1b40b1366a993f0f05f600f39
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 12 May 2010 01:06:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9775b4cc522e5f1b40b1366a993f0f05f600f39
Gitweb:     http://git.kernel.org/tip/c9775b4cc522e5f1b40b1366a993f0f05f600f39
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 11 May 2010 17:49:54 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 11 May 2010 17:49:54 -0700

x86, fpu: Use static_cpu_has() to implement use_xsave()

use_xsave() is now just a special case of static_cpu_has(), so use
static_cpu_has().

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1273135546-29690-2-git-send-email-avi@redhat.com>
---
 arch/x86/include/asm/i387.h |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 8002e9c..c991b3a 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -18,6 +18,7 @@
 #include <linux/hardirq.h>
 #include <linux/slab.h>
 #include <asm/asm.h>
+#include <asm/cpufeature.h>
 #include <asm/processor.h>
 #include <asm/sigcontext.h>
 #include <asm/user.h>
@@ -57,16 +58,9 @@ extern int restore_i387_xstate_ia32(void __user *buf);
 
 #define X87_FSW_ES (1 << 7)	/* Exception Summary */
 
-static inline bool use_xsave(void)
+static __always_inline __pure bool use_xsave(void)
 {
-	u8 has_xsave;
-
-	alternative_io("mov $0, %0",
-		       "mov $1, %0",
-		       X86_FEATURE_XSAVE,
-		       "=qm" (has_xsave));
-
-	return has_xsave;
+	return static_cpu_has(X86_FEATURE_XSAVE);
 }
 
 #ifdef CONFIG_X86_64
