Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab1G0VvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:51:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:10471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843Ab1G0Vtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="30901148"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: joe@perches.com, davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [89/99] bug.h: Add WARN_RATELIMIT
Message-Id: <20110727214928.DFC1C2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/asm-generic/bug.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: linux-2.6.35.y/include/asm-generic/bug.h
===================================================================
--- linux-2.6.35.y.orig/include/asm-generic/bug.h
+++ linux-2.6.35.y/include/asm-generic/bug.h
@@ -53,6 +53,22 @@ struct bug_entry {
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
 #endif
 
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
  * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
  * significant issues that need prompt attention if they should ever
