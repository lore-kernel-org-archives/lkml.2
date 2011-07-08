Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab1GHFAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:00:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab1GHFAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:00:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:53 2011
Message-Id: <20110708001653.550611163@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: [008/107] bug.h: Move ratelimit warn interfaces to ratelimit.h
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 86e4ca66e81bba0f8640f1fa19b8b8f72cbd0561 ]

As reported by Ingo Molnar, we still have configuration combinations
where use of the WARN_RATELIMIT interfaces break the build because
dependencies don't get met.

Instead of going down the long road of trying to make it so that
ratelimit.h can get included by kernel.h or asm-generic/bug.h,
just move the interface into ratelimit.h and make users have
to include that.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/asm-generic/bug.h |   40 ----------------------------------------
 include/linux/ratelimit.h |   40 ++++++++++++++++++++++++++++++++++++++++
 net/core/filter.c         |    1 +
 3 files changed, 41 insertions(+), 40 deletions(-)

--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -162,46 +162,6 @@ extern void warn_slowpath_null(const cha
 	unlikely(__ret_warn_once);				\
 })
 
-#ifdef CONFIG_PRINTK
-
-#define WARN_ON_RATELIMIT(condition, state)			\
-		WARN_ON((condition) && __ratelimit(state))
-
-#define __WARN_RATELIMIT(condition, state, format...)		\
-({								\
-	int rtn = 0;						\
-	if (unlikely(__ratelimit(state)))			\
-		rtn = WARN(condition, format);			\
-	rtn;							\
-})
-
-#define WARN_RATELIMIT(condition, format...)			\
-({								\
-	static DEFINE_RATELIMIT_STATE(_rs,			\
-				      DEFAULT_RATELIMIT_INTERVAL,	\
-				      DEFAULT_RATELIMIT_BURST);	\
-	__WARN_RATELIMIT(condition, &_rs, format);		\
-})
-
-#else
-
-#define WARN_ON_RATELIMIT(condition, state)			\
-	WARN_ON(condition)
-
-#define __WARN_RATELIMIT(condition, state, format...)		\
-({								\
-	int rtn = WARN(condition, format);			\
-	rtn;							\
-})
-
-#define WARN_RATELIMIT(condition, format...)			\
-({								\
-	int rtn = WARN(condition, format);			\
-	rtn;							\
-})
-
-#endif
-
 /*
  * WARN_ON_SMP() is for cases that the warning is either
  * meaningless for !SMP or may even cause failures.
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -41,4 +41,44 @@ extern struct ratelimit_state printk_rat
 extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
 #define __ratelimit(state) ___ratelimit(state, __func__)
 
+#ifdef CONFIG_PRINTK
+
+#define WARN_ON_RATELIMIT(condition, state)			\
+		WARN_ON((condition) && __ratelimit(state))
+
+#define __WARN_RATELIMIT(condition, state, format...)		\
+({								\
+	int rtn = 0;						\
+	if (unlikely(__ratelimit(state)))			\
+		rtn = WARN(condition, format);			\
+	rtn;							\
+})
+
+#define WARN_RATELIMIT(condition, format...)			\
+({								\
+	static DEFINE_RATELIMIT_STATE(_rs,			\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);	\
+	__WARN_RATELIMIT(condition, &_rs, format);		\
+})
+
+#else
+
+#define WARN_ON_RATELIMIT(condition, state)			\
+	WARN_ON(condition)
+
+#define __WARN_RATELIMIT(condition, state, format...)		\
+({								\
+	int rtn = WARN(condition, format);			\
+	rtn;							\
+})
+
+#define WARN_RATELIMIT(condition, format...)			\
+({								\
+	int rtn = WARN(condition, format);			\
+	rtn;							\
+})
+
+#endif
+
 #endif /* _LINUX_RATELIMIT_H */
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -38,6 +38,7 @@
 #include <asm/unaligned.h>
 #include <linux/filter.h>
 #include <linux/reciprocal_div.h>
+#include <linux/ratelimit.h>
 
 enum {
 	BPF_S_RET_K = 1,


