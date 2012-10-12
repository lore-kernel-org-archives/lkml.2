Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647Ab2JLIje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 04:39:34 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59632 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933255Ab2JLIjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 04:39:31 -0400
Date: Fri, 12 Oct 2012 10:39:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf updates/fixes
Message-ID: <20121012083926.GA30327@gmail.com>
References: <20121012081947.GA20570@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121012081947.GA20570@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Linus,
> 
> Please pull the latest perf-urgent-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus
> 
>    HEAD: 95cf59ea72331d0093010543b8951bb43f262cac perf: Fix perf_cgroup_switch for sw-events

Note that if you merge it then there's a new semantic conflict 
with recent rbtree.c changes in your tree, causing a tools/perf/ 
build failure:

../../lib/rbtree.c:24:36: fatal error: linux/rbtree_augmented.h: No such file or directory compilation terminated.

See the fix below.

( If the __maybe_unused annotations are too ugly for 
  lib/rbtree.c then we'll fix that in tools/perf in a cleaner
  way, weakening the compiler checks for the rbtree build. We 
  are using stronger compiler checks in tools/perf/, which has 
  served us very well so far and is a big net win - the price is 
  the occasional extra annotation of dummy inline function 
  parameters. )

Thanks,

	Ingo

Signed-off-by: Ingo Molnar <mingo@kernel.org>

---
 lib/rbtree.c                                     | 7 ++++---
 tools/perf/util/include/linux/rbtree_augmented.h | 2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index 4f56a11..993ffcb 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -22,6 +22,7 @@
 */
 
 #include <linux/rbtree_augmented.h>
+#include <linux/compiler.h>
 #include <linux/export.h>
 
 /*
@@ -364,9 +365,9 @@ EXPORT_SYMBOL(__rb_erase_color);
  * out of the rb_insert_color() and rb_erase() function definitions.
  */
 
-static inline void dummy_propagate(struct rb_node *node, struct rb_node *stop) {}
-static inline void dummy_copy(struct rb_node *old, struct rb_node *new) {}
-static inline void dummy_rotate(struct rb_node *old, struct rb_node *new) {}
+static inline void dummy_propagate(struct rb_node *node __maybe_unused, struct rb_node *stop __maybe_unused) {}
+static inline void dummy_copy(struct rb_node *old __maybe_unused, struct rb_node *new __maybe_unused) {}
+static inline void dummy_rotate(struct rb_node *old __maybe_unused, struct rb_node *new __maybe_unused) {}
 
 static const struct rb_augment_callbacks dummy_callbacks = {
 	dummy_propagate, dummy_copy, dummy_rotate
diff --git a/tools/perf/util/include/linux/rbtree_augmented.h b/tools/perf/util/include/linux/rbtree_augmented.h
new file mode 100644
index 0000000..9d6fcdf
--- /dev/null
+++ b/tools/perf/util/include/linux/rbtree_augmented.h
@@ -0,0 +1,2 @@
+#include <stdbool.h>
+#include "../../../../include/linux/rbtree_augmented.h"

