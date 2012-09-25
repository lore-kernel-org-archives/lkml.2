Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab2IYXcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:32:46 -0400
Received: from nm4-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.190]:20990 "HELO
	nm4-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756101Ab2IYXcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:32:43 -0400
X-Yahoo-Newman-Id: 217945.41329.bm@omp1028.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ZtCYr7EVM1mJMMAK3jNU8T_CKLfvnQC3wl4ZYF8kLcGB1D6
 kcdAPSA8gAi2PZTb1nidVOp0ewuFPYcO0lUcla4QLq1epwaRV0jYSAxL3VvS
 DaUv7jYh7ac1tdKRRMe7_IDdvcgpSlbz1ZP3c8aXwYqHUBlOqq6lT1BTbHs3
 f5pZ5rzwoIRMauPHoativ6BnM3xpJmQKZgSB01K25HlJrMWd.FH1.Mf8VUK9
 y3a3Vl.fqpRKzF0EwyRqxCWcZqP_ffcxcVy78OwAfsYGgOyAk_AID6XdMKDQ
 4hlJT00Ti2isEtvLVjfA9PcdECNy2fkslx.RbdUVnmnUAWJdargxufRoW5R2
 j0AhtrmpD0FlrJk4Rys5AAAaGhPUtjlPoURnvkptRaQ.mhSFkxlDdT27lJoq
 Hex8ZJ8w2sXMgd6QTvJOQENaGlel.aZ_9egfe3iQyrhDsMeOrzkfn
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Daniel Santos <daniel.santos@pobox.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 25/25] rbtree.h: (optional?) Add RB_INSERT_DUPE_RIGHT flag
Date: Tue, 25 Sep 2012 18:32:35 -0500
Message-Id: <1348615955-10788-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure if this is needed anywhere in the kernel. If not, it will
cause inserts run on older compilers to slow down very slightly.

This flag affects the behavior of inserts in trees where duplicate keys
are allowed.  It's generally assumed that the new node will be added to
the head of a group of nodes with the same key value.  However, this
behavior may not always be desired and this flag offers the option to
choose them to be inserted at the tail of such a group.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/rbtree.h |   79 ++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index f1fbdea..2ca553b 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -264,6 +264,11 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
  * @RB_INSERT_REPLACES:	When set, the rb_insert() will replace a value if it
  * 			matches the supplied one (valid only when
  * 			RB_UNIQUE_KEYS is set).
+ * @RB_INSERT_DUPE_RIGHT: Normally, when inserting a duplicate value into a
+ * 			tree with non-unique keys, the new value is inserted at
+ * 			the the head of the group same-value objects.  This
+ * 			flag causes inserts in such cases to put the new value
+ * 			at the tail of the group.
  * @RB_IS_AUGMENTED:	is an augmented tree
  * @RB_VERIFY_USAGE:	Perform checks upon node insertion for a small run-time
  * 			overhead. This has other usage restrictions, so read
@@ -300,12 +305,14 @@ enum rb_flags {
 	RB_HAS_COUNT		= 0x00000004,
 	RB_UNIQUE_KEYS		= 0x00000008,
 	RB_INSERT_REPLACES	= 0x00000010,
+	RB_INSERT_DUPE_RIGHT	= 0x00000020,
 	RB_IS_AUGMENTED		= 0x00000040,
 	RB_VERIFY_USAGE		= 0x00000080 & __RB_DEBUG_ENABLE_MASK,
 	RB_VERIFY_INTEGRITY	= 0x00000100 & __RB_DEBUG_ENABLE_MASK,
 	RB_ALL_FLAGS		= RB_HAS_LEFTMOST | RB_HAS_RIGHTMOST
 			| RB_HAS_COUNT | RB_UNIQUE_KEYS
 			| RB_INSERT_REPLACES | RB_IS_AUGMENTED
+			| RB_INSERT_DUPE_RIGHT
 			| RB_VERIFY_USAGE | RB_VERIFY_INTEGRITY,
 };
 
@@ -504,15 +511,19 @@ void __rb_assert_good_rel(const struct rb_relationship *rel)
 	/* Due to a bug in versions of gcc prior to 4.6, the following
 	 * expressions are always evalulated at run-time:
 	 *
+	 * ((rel->flags & RB_UNIQUE_KEYS) && (rel->flags & RB_INSERT_DUPE_RIGHT))
 	 * (!(rel->flags & RB_UNIQUE_KEYS) && (rel->flags & RB_INSERT_REPLACES))
 	 *
 	 * The work-around for this bug is separate each bitwise AND test using
 	 * an if/else construct and evaluate only the last test with the
 	 * BUILD_BUG_ON macro.
 	 */
-
-	if (rel->flags & RB_INSERT_REPLACES)
-		BUILD_BUG_ON42(!(rel->flags & RB_UNIQUE_KEYS));
+	if (rel->flags & RB_UNIQUE_KEYS)
+		/* only with non-unique keys */
+		BUILD_BUG_ON42(rel->flags & RB_INSERT_DUPE_RIGHT);
+	else
+		/* only with unique keys */
+		BUILD_BUG_ON42(rel->flags & RB_INSERT_REPLACES);
 }
 
 
@@ -840,6 +851,7 @@ struct rb_node *__rb_find_subtree(
 				 */
 				break;
 			else if (!diff) {
+				/* FIXME: non-unique keys broken here on inserts */
 				/* exact match */
 				*matched = go_left
 					 ? RB_MATCH_LEFT
@@ -1022,16 +1034,34 @@ struct rb_node *rb_insert(
 
 		parent = *p;
 
-		if (diff > 0) {
-			p = &(*p)->rb_right;
-			if (rel->flags & RB_HAS_LEFTMOST)
-				leftmost = 0;
-		} else if (!(rel->flags & RB_UNIQUE_KEYS) || diff < 0) {
-			p = &(*p)->rb_left;
-			if (rel->flags & RB_HAS_RIGHTMOST)
-				rightmost = 0;
-		} else
-			break;
+		/* when using non-unique keys, a new same-key objects is
+		 * inserted at the head of any existing same-key objects unless
+		 * RB_INSERT_DUPE_RIGHT is specified, which causes them to be
+		 * inserted at the tail.
+		 */
+		if (rel->flags & RB_INSERT_DUPE_RIGHT) {
+			if (diff < 0) {
+				p = &(*p)->rb_left;
+				if (rel->flags & RB_HAS_RIGHTMOST)
+					rightmost = 0;
+			} else if (!(rel->flags & RB_UNIQUE_KEYS) || diff > 0) {
+				p = &(*p)->rb_right;
+				if (rel->flags & RB_HAS_LEFTMOST)
+					leftmost = 0;
+			} else
+				break;
+		} else {
+			if (diff > 0) {
+				p = &(*p)->rb_right;
+				if (rel->flags & RB_HAS_LEFTMOST)
+					leftmost = 0;
+			} else if (!(rel->flags & RB_UNIQUE_KEYS) || diff < 0) {
+				p = &(*p)->rb_left;
+				if (rel->flags & RB_HAS_RIGHTMOST)
+					rightmost = 0;
+			} else
+				break;
+		}
 	}
 
 	if ((rel->flags & RB_HAS_LEFTMOST) && leftmost) {
@@ -1087,12 +1117,23 @@ struct rb_node *rb_insert_near(
 			diff   = rel->compare(__rb_node_to_key(*p, rel), key);
 			parent = *p;
 
-			if (diff > 0)
-				p = &(*p)->rb_right;
-			else if (!(rel->flags & RB_UNIQUE_KEYS) || diff < 0)
-				p = &(*p)->rb_left;
-			else
-				break;
+			if (rel->flags & RB_INSERT_REPLACES) {
+				if (diff < 0)
+					p = &(*p)->rb_left;
+				else if (!(rel->flags & RB_UNIQUE_KEYS) ||
+						diff > 0)
+					p = &(*p)->rb_right;
+				else
+					break;
+			} else {
+				if (diff > 0)
+					p = &(*p)->rb_right;
+				else if (!(rel->flags & RB_UNIQUE_KEYS) ||
+						diff < 0)
+					p = &(*p)->rb_left;
+				else
+					break;
+			}
 		}
 		ret = *p;
 	}
-- 
1.7.3.4

