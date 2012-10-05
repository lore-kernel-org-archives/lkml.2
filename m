Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab2JEM5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:57:22 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:57290 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab2JEM5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:57:21 -0400
Date: Fri, 5 Oct 2012 14:57:17 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: [PATCH] Fix bogus "callbacks suppressed" messages
Message-ID: <20121005125717.GB245@x4>
References: <20121004092055.GA21028@aftab.osrc.amd.com>
 <20121004112347.GA245@x4>
 <20121004115157.GA245@x4>
 <20121004124025.GC21028@aftab.osrc.amd.com>
 <20121004131101.GA245@x4>
 <506EC1AE.6000201@suse.cz>
 <20121005122741.GB8019@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005122741.GB8019@aftab.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the current git tree one sees messages such as:
 tty_init_dev: 24 callbacks suppressed
 tty_init_dev: 3 callbacks suppressed

To fix this we need to look at condition before calling __ratelimit in
the WARN_RATELIMIT macro. While at it remove the superfluous
__WARN_RATELIMIT macros.

Original patch is from Joe Perches and Jiri Slaby.

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Acked-and-tested-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/ratelimit.h | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index e11ccb4..0a260d8 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -46,20 +46,17 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
 #define WARN_ON_RATELIMIT(condition, state)			\
 		WARN_ON((condition) && __ratelimit(state))
 
-#define __WARN_RATELIMIT(condition, state, format...)		\
-({								\
-	int rtn = 0;						\
-	if (unlikely(__ratelimit(state)))			\
-		rtn = WARN(condition, format);			\
-	rtn;							\
-})
-
-#define WARN_RATELIMIT(condition, format...)			\
+#define WARN_RATELIMIT(condition, format, ...)			\
 ({								\
 	static DEFINE_RATELIMIT_STATE(_rs,			\
 				      DEFAULT_RATELIMIT_INTERVAL,	\
 				      DEFAULT_RATELIMIT_BURST);	\
-	__WARN_RATELIMIT(condition, &_rs, format);		\
+	int rtn = !!(condition);				\
+								\
+	if (unlikely(rtn && __ratelimit(&_rs)))			\
+		WARN(rtn, format, ##__VA_ARGS__);		\
+								\
+	rtn;							\
 })
 
 #else
@@ -67,15 +64,9 @@ extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
 #define WARN_ON_RATELIMIT(condition, state)			\
 	WARN_ON(condition)
 
-#define __WARN_RATELIMIT(condition, state, format...)		\
-({								\
-	int rtn = WARN(condition, format);			\
-	rtn;							\
-})
-
-#define WARN_RATELIMIT(condition, format...)			\
+#define WARN_RATELIMIT(condition, format, ...)			\
 ({								\
-	int rtn = WARN(condition, format);			\
+	int rtn = WARN(condition, format, ##__VA_ARGS__);	\
 	rtn;							\
 })
 
-- 
Markus
