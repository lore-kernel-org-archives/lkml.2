Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab0E0UNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:13:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:48199 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045Ab0E0UNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:13:12 -0400
Date: Thu, 27 May 2010 20:12:54 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eric.dumazet@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4BF2FF82.7090005@zytor.com>
References: <4BF2FF82.7090005@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, cpufeature: Unbreak compile with gcc 3.x
Message-ID: <tip-1ba4f22c426ba04b00fd717318d50620c621a0e1@git.kernel.org>
Git-Commit-ID: 1ba4f22c426ba04b00fd717318d50620c621a0e1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 May 2010 20:12:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ba4f22c426ba04b00fd717318d50620c621a0e1
Gitweb:     http://git.kernel.org/tip/1ba4f22c426ba04b00fd717318d50620c621a0e1
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 27 May 2010 12:02:00 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 27 May 2010 12:02:00 -0700

x86, cpufeature: Unbreak compile with gcc 3.x

gcc 3 is too braindamaged to be able to compile static_cpu_has() --
apparently it can't tell that a constant passed to an inline function
is still a constant -- so if we're using gcc 3, just use the dynamic
test.  This is bad for performance, but if you care about performance,
don't use an ancient, known-to-optimize-poorly compiler.

Reported-and-tested-by: Eric Dumazet <eric.dumazet@gmail.com>
LKML-Reference: <4BF2FF82.7090005@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index dca9c54..4681459 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -332,6 +332,7 @@ static __always_inline __pure bool __static_cpu_has(u8 bit)
 #endif
 }
 
+#if __GNUC__ >= 4
 #define static_cpu_has(bit)					\
 (								\
 	__builtin_constant_p(boot_cpu_has(bit)) ?		\
@@ -340,6 +341,12 @@ static __always_inline __pure bool __static_cpu_has(u8 bit)
 		__static_cpu_has(bit) :				\
 		boot_cpu_has(bit)				\
 )
+#else
+/*
+ * gcc 3.x is too stupid to do the static test; fall back to dynamic.
+ */
+#define static_cpu_has(bit) boot_cpu_has(bit)
+#endif
 
 #endif /* defined(__KERNEL__) && !defined(__ASSEMBLY__) */
 
