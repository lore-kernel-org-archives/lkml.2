Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab0HUAl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 20:41:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37644 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab0HUAlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 20:41:03 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 2/2] perf: fix build with -Wl,--as-needed
Date: Sat, 21 Aug 2010 03:38:21 +0300
Message-Id: <1282351101-8879-2-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282351101-8879-1-git-send-email-kirill@shutemov.name>
References: <1282351101-8879-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to put all libraries at the end of linking command to be able to
use -Wl,--as-needed (default in some distributions).

python-config --ldconfig also prints -lpython*, but we need to put it
to EXTLIBS, not to ALL_LDFLAGS.

Let's add call of python-config --libs and put its output to EXTLIBS.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 tools/perf/Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 496a0d6..a5972f6 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -605,12 +605,14 @@ ifdef NO_LIBPYTHON
 	BASIC_CFLAGS += -DNO_LIBPYTHON
 else
 	PYTHON_EMBED_LDOPTS = `python-config --ldflags 2>/dev/null`
+	PYTHON_EMBED_LIBS = `python-config --libs 2>/dev/null`
 	PYTHON_EMBED_CCOPTS = `python-config --cflags 2>/dev/null`
-	FLAGS_PYTHON_EMBED=$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
+	FLAGS_PYTHON_EMBED=$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS) $(PYTHON_EMBED_LIBS)
 	ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
 		BASIC_CFLAGS += -DNO_LIBPYTHON
 	else
 		ALL_LDFLAGS += $(PYTHON_EMBED_LDOPTS)
+		EXTLIBS += $(PYTHON_EMBED_LIBS)
 		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
 		LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
 	endif
-- 
1.7.2.1

