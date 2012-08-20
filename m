Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab2HTEqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:46:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab2HTEpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:45:12 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        David Ahern <dsahern@gmail.com>
Subject: [RFC PATCH 3/7] perf: make python support based on CONFIG_LIBPYTHON
Date: Sun, 19 Aug 2012 22:44:47 -0600
Message-Id: <1345437891-78830-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1345437891-78830-1-git-send-email-dsahern@gmail.com>
References: <1345437891-78830-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile                     |  117 ++++++++++++++-----------------
 tools/perf/config/feature-tests.mak     |    2 +-
 tools/perf/util/trace-event-scripting.c |   17 ++---
 3 files changed, 60 insertions(+), 76 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a447aa8..35448ef 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -16,8 +16,6 @@ include config/utilities.mak
 #
 # Define CROSS_COMPILE as prefix name of compiler if you want cross-builds.
 #
-# Define NO_LIBPYTHON to disable python script extension.
-#
 # Define PYTHON to point to the python binary if the default
 # `python' is not correct; for example: PYTHON=python2
 #
@@ -630,78 +628,67 @@ ifdef CONFIG_LIBPERL
        LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
 endif
 
-disable-python = $(eval $(disable-python_code))
-define disable-python_code
-  BASIC_CFLAGS += -DNO_LIBPYTHON
-  $(if $(1),$(warning No $(1) was found))
-  $(warning Python support won't be built)
-endef
-
-override PYTHON := \
-  $(call get-executable-or-default,PYTHON,python)
-
-ifndef PYTHON
-  $(call disable-python,python interpreter)
-  python-clean :=
-else
+ifdef CONFIG_LIBPYTHON
+    override PYTHON := \
+        $(call get-executable-or-default,PYTHON,python)
 
-  PYTHON_WORD := $(call shell-wordify,$(PYTHON))
+    ifndef PYTHON
+        $(warning python interpreter not found.)
+        $(warning Install it or unset CONFIG_LIBPYTHON to continue.)
+        $(error )
+    endif
 
-  # python extension build directories
-  PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
-  PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
-  PYTHON_EXTBUILD_TMP := $(PYTHON_EXTBUILD)tmp/
-  export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
+    PYTHON_WORD := $(call shell-wordify,$(PYTHON))
 
-  python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
+    # python extension build directories
+    PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
+    PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
+    PYTHON_EXTBUILD_TMP := $(PYTHON_EXTBUILD)tmp/
+    export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
 
-  ifdef NO_LIBPYTHON
-    $(call disable-python)
-  else
+    python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
 
     override PYTHON_CONFIG := \
-      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
+        $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
 
     ifndef PYTHON_CONFIG
-      $(call disable-python,python-config tool)
-    else
-
-      PYTHON_CONFIG_SQ := $(call shell-sq,$(PYTHON_CONFIG))
-
-      PYTHON_EMBED_LDOPTS := $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
-      PYTHON_EMBED_LDFLAGS := $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
-      PYTHON_EMBED_LIBADD := $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
-      PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
-      FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
-
-      ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
-        $(call disable-python,Python.h (for Python 2.x))
-      else
-
-        ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED)),y)
-          $(warning Python 3 is not yet supported; please set)
-          $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
-          $(warning If you also have Python 2 installed, then)
-          $(warning try something like:)
-          $(warning $(and ,))
-          $(warning $(and ,)  make PYTHON=python2)
-          $(warning $(and ,))
-          $(warning Otherwise, disable Python support entirely:)
-          $(warning $(and ,))
-          $(warning $(and ,)  make NO_LIBPYTHON=1)
-          $(warning $(and ,))
-          $(error   $(and ,))
-        else
-          ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
-          EXTLIBS += $(PYTHON_EMBED_LIBADD)
-          LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
-          LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
-          LANG_BINDINGS += $(OUTPUT)python/perf.so
-        endif
-
-      endif
+        $(warning python-config not found.)
+        $(warning Install it or unset CONFIG_LIBPYTHON to continue.)
+        $(error )
     endif
-  endif
+
+    PYTHON_CONFIG_SQ := $(call shell-sq,$(PYTHON_CONFIG))
+
+    PYTHON_EMBED_LDOPTS := $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
+    PYTHON_EMBED_LDFLAGS := $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
+    PYTHON_EMBED_LIBADD := $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
+    PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
+    FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
+
+    ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
+        $(warning Failed to detect python development kit.)
+        $(warning Install it or unset CONFIG_LIBPYTHON to continue.)
+        $(warning e.g., apt-get install python-dev (ubuntu).)
+        $(warning       yum install python-devel (Fedora).)
+        $(error )
+    endif
+
+    ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED)),y)
+        $(warning Python 3 is not yet supported; please set)
+        $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
+        $(warning If you also have Python 2 installed, then)
+        $(warning try something like:)
+        $(warning $(and ,))
+        $(warning $(and ,)  make PYTHON=python2)
+        $(warning $(and ,))
+        $(warning Otherwise, disable Python support entirely by unsetting CONFIG_LIBPYTHON.)
+    endif
+
+    ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
+    EXTLIBS += $(PYTHON_EMBED_LIBADD)
+    LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
+    LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
+    LANG_BINDINGS += $(OUTPUT)python/perf.so
 endif
 
 ifdef NO_DEMANGLE
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 0145c05..dbf1127 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -106,7 +106,7 @@ return 0;
 endef
 endif
 
-ifndef NO_LIBPYTHON
+ifdef CONFIG_LIBPYTHON
 define SOURCE_PYTHON_VERSION
 #include <Python.h>
 #if PY_VERSION_HEX >= 0x03000000
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index edaed05..85115b8 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -46,11 +46,8 @@ static void process_event_unsupported(union perf_event *event __unused,
 
 static void print_python_unsupported_msg(void)
 {
-	fprintf(stderr, "Python scripting not supported."
-		"  Install libpython and rebuild perf to enable it.\n"
-		"For example:\n  # apt-get install python-dev (ubuntu)"
-		"\n  # yum install python-devel (Fedora)"
-		"\n  etc.\n");
+	fprintf(stderr, "Python scripting not supported.\n"
+		"Enable CONFIG_LIBPYTHON and rebuild perf to enable it.\n");
 }
 
 static int python_start_script_unsupported(const char *script __unused,
@@ -92,17 +89,17 @@ static void register_python_scripting(struct scripting_ops *scripting_ops)
 	scripting_context = malloc(sizeof(struct scripting_context));
 }
 
-#ifdef NO_LIBPYTHON
+#ifdef CONFIG_LIBPYTHON
+extern struct scripting_ops python_scripting_ops;
+
 void setup_python_scripting(void)
 {
-	register_python_scripting(&python_scripting_unsupported_ops);
+	register_python_scripting(&python_scripting_ops);
 }
 #else
-extern struct scripting_ops python_scripting_ops;
-
 void setup_python_scripting(void)
 {
-	register_python_scripting(&python_scripting_ops);
+	register_python_scripting(&python_scripting_unsupported_ops);
 }
 #endif
 
-- 
1.7.10.1

