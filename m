Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1HSHtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 03:49:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45730 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab1HSHtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 03:49:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=U8S0J8RDL8QEagYgOCh0k1QfcMBzWTa5nZrqOFOEGt7MhkqHylKarJKmRFdoJA3MM
	qwmpU/PRLwEqPjWkFc9nw==
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH 7/9] rcu: rcu_get_gp_cookie() / rcu_gp_cookie_elapsed() stand-ins
Date: Fri, 19 Aug 2011 00:48:29 -0700
Message-Id: <1313740111-27446-8-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313740111-27446-1-git-send-email-walken@google.com>
References: <1313740111-27446-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prototypes for the proposed rcu_get_gp_cookie() / rcu_gp_cookie_elapsed()
functionality as discussed in http://marc.info/?l=linux-mm&m=131316547914194

(This is not a correct implementation of the proposed API;
Paul McKenney is to provide that as a follow-up to this RFC)

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 include/linux/rcupdate.h |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 99f9aa7..315a0f1 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -865,4 +865,39 @@ static inline void __rcu_reclaim(struct rcu_head *head)
 #define kfree_rcu(ptr, rcu_head)					\
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
 
+struct rcu_cookie {long x; };
+
+/*
+ * rcu_get_gp_cookie() / rcu_gp_cookie_elapsed()
+ *
+ * rcu_get_gp_cookie() stores an opaque cookie to the provided location.
+ *
+ * rcu_gp_cookie_elapsed() returns true if it can guarantee that
+ * an rcu grace period has elapsed since the provided cookie was
+ * created by rcu_get_gp_cookie(). A return value of false indicates
+ * that rcu_gp_cookie_elapsed() does not know if an rcu grace period has
+ * elapsed or not - the call site is then expected to drop locks as desired,
+ * call rcu_synchronize(), and retry.
+ *
+ * Note that call sites are allowed to assume that rcu_gp_cookie_elapsed()
+ * will return true if they try enough times. An implementation that always
+ * returns false would be incorrect.
+ *
+ * The implementation below is also incorrect (may return false positives),
+ * however it does test that one always calls rcu_get_gp_cookie() before
+ * rcu_gp_cookie_elapsed() and that rcu_gp_cookie_elapsed() call sites
+ * are ready to handle both possible cases.
+ */
+static inline void rcu_get_gp_cookie(struct rcu_cookie *rcp)
+{
+	rcp->x = 12345678;
+}
+
+static inline bool rcu_gp_cookie_elapsed(struct rcu_cookie *rcp)
+{
+	static int count = 0;
+	BUG_ON(rcp->x != 12345678);
+	return (count++ % 16) != 0;
+}
+
 #endif /* __LINUX_RCUPDATE_H */
-- 
1.7.3.1

