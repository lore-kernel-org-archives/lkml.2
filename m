Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab1ELXue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 19:50:34 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13011 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758913Ab1ELXuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 19:50:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6344"; a="91115533"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH 8/9] x86: Implement strict user copy checks for x86_64
Date: Thu, 12 May 2011 16:50:11 -0700
Message-Id: <1305244212-19183-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.1.217.g4e3aa
In-Reply-To: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strict user copy checks are only really supported on x86_32 even
though the config option is selectable on x86_64. Add the
necessary support to the 64 bit code to trigger copy_from_user()
warnings at compile time.

Cc: x86@kernel.org
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/x86/include/asm/uaccess_64.h |   12 +++++++++---
 arch/x86/lib/usercopy_64.c        |    6 ++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 316708d..904684b 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -44,6 +44,14 @@ _copy_from_user(void *to, const void __user *from, unsigned len);
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
@@ -53,10 +61,8 @@ static inline unsigned long __must_check copy_from_user(void *to,
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

