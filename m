Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1GHFV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:21:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab1GHFAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:00:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:53 2011
Message-Id: <20110708001653.241790532@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>
Subject: [005/107] bug.h: Add WARN_RATELIMIT
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Joe Perches <joe@perches.com>

[ Upstream commit b3eec79b0776e5340a3db75b34953977c7e5086e ]

Add a generic mechanism to ratelimit WARN(foo, fmt, ...) messages
using a hidden per call site static struct ratelimit_state.

Also add an __WARN_RATELIMIT variant to be able to use a specific
struct ratelimit_state.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/asm-generic/bug.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -165,6 +165,22 @@ extern void warn_slowpath_null(const cha
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
 /*
  * WARN_ON_SMP() is for cases that the warning is either
  * meaningless for !SMP or may even cause failures.


