Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab2JNI4Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 04:56:25 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34240 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2JNI4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 04:56:23 -0400
Date: Sun, 14 Oct 2012 10:56:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, paulus@samba.org, davem@davemloft.net,
        jaxboe@fusionio.com, tj@kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] perf: Fix UAPI fallout
Message-ID: <20121014085617.GA22544@gmail.com>
References: <11002.1350125310@warthog.procyon.org.uk>
 <CA+55aFzu83ktX=ereRACNa6stEU0H5vNxKObUN9bymYCCaHyew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzu83ktX=ereRACNa6stEU0H5vNxKObUN9bymYCCaHyew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Find below a stab at that, lightly tested.

Arnaldo: the way we include some of the include files directly 
into tools/perf/ .c files [such as hw_breakpoint.h] and 
represent others transparently via utils/include/ [such as 
rbtree.h] is a bit messy and ought to be cleaned up I suspect.

What we want in .c files are not ../.. inclusions but the 
'seemless' <linux/abc.h> inclusions. Which is the overwhelming 
majority, gladly. Do we want to make that the 100% majority?

We should probably also think about how to represent kernel 
versus UAPI headers in tools/perf/, plus the /usr/include/linux/ 
headers which are always an option to get picked up.

I think the best model would be to cleanly separate from any 
/usr/include/linux/ muck, which might be out of sync, and which 
might stand in the way of changes. Is it possible to exclude all 
of /usr/include/ and try to build purely from 
include/uapi/linux/, with a few exceptions (with clearly 
distinctive patterns) where we [currently] need to pick up 
include/linux/ headers, such as hw_breakpoint.h or rbtree.h?

This would clean up the code and would also make it easier to 
drive UAPI conversions: the bits that we still pick up from 
include/linux/ are candidates for (incremental, slow, well 
tested, please) UAPI conversions.

Thanks,

	Ingo

------------>
>From 957e49e521292324053809bb73173b82d9e42464 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@kernel.org>
Date: Sun, 14 Oct 2012 10:40:57 +0200
Subject: [PATCH] perf: Fix UAPI fallout

The UAPI commits forgot to test tooling builds such as tools/perf/,
and this fixes the fallout.

Manual conversion.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile                     | 4 ++--
 tools/perf/perf.h                       | 2 +-
 tools/perf/util/evsel.c                 | 2 +-
 tools/perf/util/evsel.h                 | 2 +-
 tools/perf/util/header.h                | 2 +-
 tools/perf/util/include/asm/byteorder.h | 2 +-
 tools/perf/util/include/linux/const.h   | 2 +-
 tools/perf/util/parse-events.h          | 2 +-
 tools/perf/util/pmu.h                   | 2 +-
 tools/perf/util/session.h               | 2 +-
 10 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2472645..f7c968a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -252,10 +252,10 @@ $(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
 
 LIB_FILE=$(OUTPUT)libperf.a
 
-LIB_H += ../../include/linux/perf_event.h
+LIB_H += ../../include/uapi/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
-LIB_H += ../../include/linux/const.h
+LIB_H += ../../include/uapi/linux/const.h
 LIB_H += ../../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index a89cbbb..2762877 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -112,7 +112,7 @@ void get_term_dimensions(struct winsize *ws);
 #include <sys/types.h>
 #include <sys/syscall.h>
 
-#include "../../include/linux/perf_event.h"
+#include "../../include/uapi/linux/perf_event.h"
 #include "util/types.h"
 #include <stdbool.h>
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ffdd94e..618d411 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -19,7 +19,7 @@
 #include "thread_map.h"
 #include "target.h"
 #include "../../../include/linux/hw_breakpoint.h"
-#include "../../include/linux/perf_event.h"
+#include "../../../include/uapi/linux/perf_event.h"
 #include "perf_regs.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3ead0d5..6f94d6d 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -3,7 +3,7 @@
 
 #include <linux/list.h>
 #include <stdbool.h>
-#include "../../../include/linux/perf_event.h"
+#include "../../../include/uapi/linux/perf_event.h"
 #include "types.h"
 #include "xyarray.h"
 #include "cgroup.h"
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 99bdd3a..879d215 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_HEADER_H
 #define __PERF_HEADER_H
 
-#include "../../../include/linux/perf_event.h"
+#include "../../../include/uapi/linux/perf_event.h"
 #include <sys/types.h>
 #include <stdbool.h>
 #include "types.h"
diff --git a/tools/perf/util/include/asm/byteorder.h b/tools/perf/util/include/asm/byteorder.h
index b722abe..2a9bdc0 100644
--- a/tools/perf/util/include/asm/byteorder.h
+++ b/tools/perf/util/include/asm/byteorder.h
@@ -1,2 +1,2 @@
 #include <asm/types.h>
-#include "../../../../include/linux/swab.h"
+#include "../../../../include/uapi/linux/swab.h"
diff --git a/tools/perf/util/include/linux/const.h b/tools/perf/util/include/linux/const.h
index 1b476c9..c10a35e 100644
--- a/tools/perf/util/include/linux/const.h
+++ b/tools/perf/util/include/linux/const.h
@@ -1 +1 @@
-#include "../../../../include/linux/const.h"
+#include "../../../../include/uapi/linux/const.h"
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index c356e44..839230c 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -7,7 +7,7 @@
 #include <linux/list.h>
 #include <stdbool.h>
 #include "types.h"
-#include "../../../include/linux/perf_event.h"
+#include "../../../include/uapi/linux/perf_event.h"
 #include "types.h"
 
 struct list_head;
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 53c7794..39f3aba 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -2,7 +2,7 @@
 #define __PMU_H
 
 #include <linux/bitops.h>
-#include "../../../include/linux/perf_event.h"
+#include "../../../include/uapi/linux/perf_event.h"
 
 enum {
 	PERF_PMU_FORMAT_VALUE_CONFIG,
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index aab414f..dd64261 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -7,7 +7,7 @@
 #include "symbol.h"
 #include "thread.h"
 #include <linux/rbtree.h>
-#include "../../../include/linux/perf_event.h"
+#include "../../../include/uapi/linux/perf_event.h"
 
 struct sample_queue;
 struct ip_callchain;
