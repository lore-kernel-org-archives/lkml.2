Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab1EaSPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:15:40 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34308 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab1EaSOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:14:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6362"; a="94496922"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86: Implement strict user copy checks for x86_64
Date: Tue, 31 May 2011 11:14:32 -0700
Message-Id: <1306865673-20560-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.3.367.ga9930
In-Reply-To: <1306865673-20560-1-git-send-email-sboyd@codeaurora.org>
References: <1306865673-20560-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strict user copy checks are only really supported on x86_32 even
though the config option is selectable on x86_64. Add the
necessary support to the 64 bit code to trigger copy_from_user()
warnings at compile time.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/uaccess_64.h |   12 +++++++++---
 arch/x86/lib/usercopy_64.c        |    6 ++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 1c66d30..6ca53e5 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -43,6 +43,14 @@ _copy_from_user(void *to, const void __user *from, unsigned len);
 __must_check unsigned long
 copy_in_user(void __user *to, const void __user *from, unsigned len);
 
+extern void copy_from_user_overflow(void)
+#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
+	__compiletime_error("copy_from_user() buffer size is not provably correct")
+#else
+	__compiletime_warning("copy_from_user() buffer size is not provably correct")
+#endif
+;
+
 static inline unsigned long __must_check copy_from_user(void *to,
 					  const void __user *from,
 					  unsigned long n)
@@ -52,10 +60,8 @@ static inline unsigned long __must_check copy_from_user(void *to,
 	might_fault();
 	if (likely(sz == -1 || sz >= n))
 		n = _copy_from_user(to, from, n);
-#ifdef CONFIG_DEBUG_VM
 	else
-		WARN(1, "Buffer overflow detected!\n");
-#endif
+		copy_from_user_overflow();
 	return n;
 }
 
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index b7c2849..d7a5d9a 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -181,3 +181,9 @@ copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
 			break;
 	return len;
 }
+
+void copy_from_user_overflow(void)
+{
+	WARN(1, "Buffer overflow detected!\n");
+}
+EXPORT_SYMBOL(copy_from_user_overflow);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

