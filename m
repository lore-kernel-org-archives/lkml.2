Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966Ab1EZSjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:39:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51739 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918Ab1EZSjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:39:03 -0400
Date: Thu, 26 May 2011 14:38:43 -0400 (EDT)
Message-Id: <20110526.143843.205897228685761536.davem@davemloft.net>
To: joe@perches.com
Cc: mingo@elte.hu, greearb@candelatech.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de, netdev@vger.kernel.org
Subject: Re: [patch] net/core/filter.c: Fix build error
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306423866.16087.10.camel@Joe-Laptop>
References: <efa062542c692c3f7743bf2d97b5987ab989e27e.1305999731.git.joe@perches.com>
	<20110526123153.GA16002@elte.hu>
	<1306423866.16087.10.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 May 2011 11:38:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 26 May 2011 08:31:06 -0700

> My suggestion would be to see about again adding
> #include <linux/ratelimit.h> somehow
> back to kernel.h which commit 3fff4c42bd0a removed
> in 2009 because of the spinlock issues.
> 
> Any suggestion on how best to fix it generically?

I don't think we want spinlock_t's definition being sucked
into kernel.h's dependency food chain.

Even if desirable, I think it'd be quite a bit of surgery,
too much to do at this stage.

So for now how about we make the ratelimit warn interfaces be a true,
instead of a pseudo, dependency on ratelimit.h by moving those
definitions into ratelimit.h?

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 9178484..dfb0ec6 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -162,46 +162,6 @@ extern void warn_slowpath_null(const char *file, const int line);
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
diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 03ff67b..2f00715 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -41,4 +41,44 @@ extern struct ratelimit_state printk_ratelimit_state;
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
diff --git a/net/core/filter.c b/net/core/filter.c
index 0e3622f..36f975f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -38,6 +38,7 @@
 #include <asm/unaligned.h>
 #include <linux/filter.h>
 #include <linux/reciprocal_div.h>
+#include <linux/ratelimit.h>
 
 /* No hurry in this branch */
 static void *__load_pointer(const struct sk_buff *skb, int k, unsigned int size)
