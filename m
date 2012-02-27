Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab2B0PKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 10:10:41 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:45295 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab2B0PKj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Mon, 27 Feb 2012 10:10:39 -0500
Message-Id: <4F4BAAFA0200007800074F8F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 27 Feb 2012 15:10:34 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] consolidate WARN_...ONCE() static variables
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the alignment of following variables, these typically consume
more than just the single byte that 'bool' requires, and as there are
a few hundred instances, the cache pollution (not so much the waste of
memory) sums up. Put these variables into their own section, outside
of any half way frequently used memory range.

v2: Do the same also to the __warned variable of rcu_lockdep_assert().
(Don't, however, include the ones used by printk_once() and alike, as
they can potentially be hot.)

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 include/asm-generic/bug.h         |    6 +++---
 include/asm-generic/vmlinux.lds.h |    1 +
 include/linux/rcupdate.h          |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

--- 3.3-rc5/include/asm-generic/bug.h
+++ 3.3-rc5-warn-once-flag-cold/include/asm-generic/bug.h
@@ -134,7 +134,7 @@ extern void warn_slowpath_null(const cha
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
-	static bool __warned;					\
+	static bool __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
@@ -144,7 +144,7 @@ extern void warn_slowpath_null(const cha
 })
 
 #define WARN_ONCE(condition, format...)	({			\
-	static bool __warned;					\
+	static bool __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
@@ -154,7 +154,7 @@ extern void warn_slowpath_null(const cha
 })
 
 #define WARN_TAINT_ONCE(condition, taint, format...)	({	\
-	static bool __warned;					\
+	static bool __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
--- 3.3-rc5/include/asm-generic/vmlinux.lds.h
+++ 3.3-rc5-warn-once-flag-cold/include/asm-generic/vmlinux.lds.h
@@ -167,6 +167,7 @@
 	CPU_KEEP(exit.data)						\
 	MEM_KEEP(init.data)						\
 	MEM_KEEP(exit.data)						\
+	*(.data.unlikely)						\
 	STRUCT_ALIGN();							\
 	*(__tracepoints)						\
 	/* implement dynamic printk debug */				\
--- 3.3-rc5/include/linux/rcupdate.h
+++ 3.3-rc5-warn-once-flag-cold/include/linux/rcupdate.h
@@ -374,7 +374,7 @@ extern int rcu_my_thread_group_empty(voi
  */
 #define rcu_lockdep_assert(c, s)					\
 	do {								\
-		static bool __warned;					\
+		static bool __section(.data.unlikely) __warned;		\
 		if (debug_lockdep_rcu_enabled() && !__warned && !(c)) {	\
 			__warned = true;				\
 			lockdep_rcu_suspicious(__FILE__, __LINE__, s);	\



