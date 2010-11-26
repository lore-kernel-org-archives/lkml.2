Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab0KZVrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:47:33 -0500
Received: from canuck.infradead.org ([134.117.69.58]:57348 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0KZVrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:47:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@gnu.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/5] perf tools: Add GCC optimization to memory allocating functions
Date: Fri, 26 Nov 2010 19:47:19 -0200
Message-Id: <1290808041-16535-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1290808041-16535-1-git-send-email-acme@infradead.org>
References: <1290808041-16535-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

We can benefit from the alloc_size attribute in xrealloc and zalloc.

Quoting from http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html:

"The alloc_size attribute is used to tell the compiler that the function return
value points to memory, where the size is given by one or two of the functions
parameters. GCC uses this information to improve the correctness of
__builtin_object_size."

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290777864.2373.2.camel@cowboy>
Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7562707..41a5067 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -182,10 +182,11 @@ static inline char *gitstrchrnul(const char *s, int c)
  * Wrappers:
  */
 extern char *xstrdup(const char *str);
-extern void *xrealloc(void *ptr, size_t size) __attribute__((weak));
+extern void *xrealloc(void *ptr, size_t size) __attribute__((weak, alloc_size(2)));
 
 
-static inline void *zalloc(size_t size)
+static inline __attribute__((alloc_size(1)))
+void *zalloc(size_t size)
 {
 	return calloc(1, size);
 }
-- 
1.6.2.5

