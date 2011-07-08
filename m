Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1GIGEg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:04:36 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:32980 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753710Ab1GIGBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:01:18 -0400
X-Sasl-enc: SgpCvloI1NUYyVIuAkMDC5zg0wv+fv0VlJ5aYO+cJXyW 1310191278
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 16:01:12 2011
Message-Id: <20110708230112.410345593@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 16:00:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>
Subject: [29/35] bug.h: Add WARN_RATELIMIT
In-Reply-To: <20110708230122.GA18807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -50,6 +50,22 @@ struct bug_entry {
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


