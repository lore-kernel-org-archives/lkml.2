Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab0DFNiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:38:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:35403 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab0DFNh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:37:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] perf kmem: Fix breakage introduced by 5a0e3ad slab.h script
Date: Tue,  6 Apr 2010 10:37:33 -0300
Message-Id: <1270561053-14308-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The 5a0e3ad changeset added a '#include <linux/slab.h>' to
tools/perf/builtin-kmem.h because: that tool has lines like this:

        if (!strcmp(event->name, "kmalloc") ||
            !strcmp(event->name, "kmem_cache_alloc")) {
                process_alloc_event(data, event, cpu, timestamp, thread, 0);
                return;
        }

So, using the script regex:

>>> import re
>>> s = re.compile(r'^(|.*[^a-zA-Z0-9_])_*(slab_is_available|kmem_cache_|k[mzc]alloc|krealloc|kz?free|ksize|__getname|putname)')
>>> l = '   !strcmp(event->name, "kmem_cache_alloc")) {'
>>> s.search(l)
<_sre.SRE_Match object at 0xb77b1ad0>
>>>

Remove that file that is not available in the tools/perf include path and thus
builtin-kmem.c couldn't be compiled.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tejun Heo <tj@kernel.org>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 7d9e3a7..924a951 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -14,7 +14,6 @@
 #include "util/debug.h"
 
 #include <linux/rbtree.h>
-#include <linux/slab.h>
 
 struct alloc_stat;
 typedef int (*sort_fn_t)(struct alloc_stat *, struct alloc_stat *);
-- 
1.6.2.5

