Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1GROGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:06:08 -0400
Received: from mail.southpole.se ([193.12.106.18]:33378 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1GROGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:06:06 -0400
From: Jonas Bonn <jonas@southpole.se>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        <linux-arch@vger.kernel.org>, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 1/1] asm-generic: delay.h fix udelay and ndelay for 8 bit args
Date: Mon, 18 Jul 2011 16:05:37 +0200
Message-Id: <1310997937-26771-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310986975.21015.13.camel@needafix>
References: <1310986975.21015.13.camel@needafix>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Morton <akpm@linux-foundation.org>

With a non-constant 8-bit argument, a call to udelay() generates a warning:

drivers/gpu/drm/radeon/atom.c: In function 'atom_op_delay':
drivers/gpu/drm/radeon/atom.c:654: warning: comparison is always false due to limited range of data type

The code looks like it works OK with an 8-bit arg, and the calling code is
doing nothing wrong, so udelay() needs fixing.

Fixing it was rather tricky.  Simply typecasting `n' in the comparison with
20000 didn't change anything.  Hence the divide-by-20000 trick.

Using a do{}while loop didn't work because udelay() is used in ?: statements,
hence the ({...}) construct.

While I was there I replaced the brain-bending ?:?:?: mess with nice if/else
code.

Probably other architectures are generating the same warning and can use a
similar change.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jonas Bonn <jonas@southpole.se>
---

Here's a patch that should resolve the merge conflict.  This applies
Andrew's changes on top of the new asm-generic/delay.h instead of the x86
arch-specific one.  I've tested this for OpenRISC and the changed macros
don't cause any problems there.

Let me know if this is OK and I'll throw it into the OpenRISC tree together
with the other delay.h modifications.

Thanks,
Jonas

 include/asm-generic/delay.h |   33 +++++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/delay.h b/include/asm-generic/delay.h
index 6511b99..0f79054 100644
--- a/include/asm-generic/delay.h
+++ b/include/asm-generic/delay.h
@@ -10,14 +10,35 @@ extern void __ndelay(unsigned long nsecs);
 extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
+/*
+ * The weird n/20000 thing suppresses a "comparison is always false due to
+ * limited range of data type" warning with non-const 8-bit arguments.
+ */
+
 /* 0x10c7 is 2**32 / 1000000 (rounded up) */
-#define udelay(n) (__builtin_constant_p(n) ? \
-	((n) > 20000 ? __bad_udelay() : __const_udelay((n) * 0x10c7ul)) : \
-	__udelay(n))
+#define udelay(n)							\
+	({								\
+		if (__builtin_constant_p(n)) {				\
+			if ((n) / 20000 >= 1)				\
+				 __bad_udelay();			\
+			else						\
+				__const_udelay((n) * 0x10c7ul);		\
+		} else {						\
+			__udelay(n);					\
+		}							\
+	})
 
 /* 0x5 is 2**32 / 1000000000 (rounded up) */
-#define ndelay(n) (__builtin_constant_p(n) ? \
-	((n) > 20000 ? __bad_ndelay() : __const_udelay((n) * 5ul)) : \
-	__ndelay(n))
+#define ndelay(n)							\
+	({								\
+		if (__builtin_constant_p(n)) {				\
+			if ((n) / 20000 >= 1)				\
+				__bad_ndelay();				\
+			else						\
+				__const_udelay((n) * 5ul);		\
+		} else {						\
+			__ndelay(n);					\
+		}							\
+	})
 
 #endif /* __ASM_GENERIC_DELAY_H */
-- 
1.7.4.1

