Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965820Ab2EOCvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:51:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:49663 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965119Ab2EOCRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 099/179] bug.h: Add WARN_RATELIMIT
Date: Mon, 14 May 2012 22:13:15 -0400
Message-ID: <1337048075-6132-100-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b3eec79b0776e5340a3db75b34953977c7e5086e upstream.

Add a generic mechanism to ratelimit WARN(foo, fmt, ...) messages
using a hidden per call site static struct ratelimit_state.

Also add an __WARN_RATELIMIT variant to be able to use a specific
struct ratelimit_state.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/asm-generic/bug.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 18c435d..bf58d4c 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -135,6 +135,22 @@ extern void warn_slowpath_null(const char *file, const int line);
 #define WARN_ON_RATELIMIT(condition, state)			\
 		WARN_ON((condition) && __ratelimit(state))
 
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
 #ifdef CONFIG_SMP
 # define WARN_ON_SMP(x)			WARN_ON(x)
 #else
-- 
1.7.9.6

