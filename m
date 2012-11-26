Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab2KZMd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 07:33:28 -0500
Received: from bero.eu ([88.198.22.18]:46639 "EHLO mail.bero.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab2KZMd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 07:33:27 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Nov 2012 07:33:26 EST
From: Bernhard Rosenkraenzer <bernhard.rosenkranzer@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        paulus@samba.org
Subject: [PATCH v3] Perf on Android
Date: Mon, 26 Nov 2012 13:22:54 +0100
Message-ID: <1862420.pfk1K7vu4q@localhost.localdomain>
Organization: Linaro
User-Agent: KMail/4.9.2 (Linux/3.4.1-1.4-desktop; KDE/4.9.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another attempt at getting perf ot work on Android - it's rebased to 
3.7-rc6 and cleaned up from the earlier version. Also adds support for Android 
4.2.

Signed-off-by: Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>
---
 tools/perf/Makefile                 |  17 +++++-
 tools/perf/builtin-record.c         |  33 +++++++++++
 tools/perf/builtin-test.c           |   7 +++
 tools/perf/compat-android.h         | 106 
++++++++++++++++++++++++++++++++++++
 tools/perf/config/feature-tests.mak |  13 +++++
 tools/perf/util/util.h              |   2 +
 6 files changed, 175 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/compat-android.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 00deed4d..f74ea4b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -104,7 +104,7 @@ ifdef PARSER_DEBUG
 endif
 
 CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -
std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) 
$(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
-EXTLIBS = -lpthread -lrt -lelf -lm
+EXTLIBS = -lpthread -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -
D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
@@ -471,7 +471,14 @@ FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
 ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF)),y)
 	FLAGS_GLIBC=$(ALL_CFLAGS) $(ALL_LDFLAGS)
 	ifneq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC)),y)
-		msg := $(error No gnu/libc-version.h found, please install glibc-
dev[el]/glibc-static);
+		ifeq ($(call try-cc,$(SOURCE_BIONIC),$(FLAGS_GLIBC)),y)
+			# Found Bionic instead of glibc...
+			# That works too, but needs a bit of special treatment
+			BASIC_CFLAGS += -DANDROID -DHAVE_STRLCPY -include $(CURDIR)/compat-
android.h
+			ANDROID := 1
+		else
+			msg := $(error No gnu/libc-version.h found, please install glibc-
dev[el]/glibc-static);
+		endif
 	else
 		NO_LIBELF := 1
 		NO_DWARF := 1
@@ -486,6 +493,10 @@ else
 endif # SOURCE_LIBELF
 endif # NO_LIBELF
 
+ifneq ($(ANDROID),1)
+EXTLIBS += -lrt
+endif
+
 ifndef NO_LIBUNWIND
 # for linking with debug library, run like:
 # make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
@@ -920,7 +931,7 @@ $(LIB_FILE): $(LIB_OBJS)
 
 # libtraceevent.a
 $(LIBTRACEEVENT):
-	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) 
libtraceevent.a
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) CFLAGS="$(ALL_CFLAGS)" 
O=$(OUTPUT) libtraceevent.a
 
 $(LIBTRACEEVENT)-clean:
 	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e9231659..451db23 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -27,10 +27,43 @@
 #include "util/cpumap.h"
 #include "util/thread_map.h"
 
+#include <stdlib.h>
 #include <unistd.h>
 #include <sched.h>
 #include <sys/mman.h>
 
+#ifdef ANDROID
+/* While stdlib.h has a prototype for it,
+   Bionic doesn't actually implement on_exit() */
+#ifndef ATEXIT_MAX
+#define ATEXIT_MAX 32
+#endif
+static int __on_exit_count = 0;
+typedef void (*on_exit_func_t)(int, void*);
+static on_exit_func_t __on_exit_funcs[ATEXIT_MAX];
+static void *__on_exit_args[ATEXIT_MAX];
+static int __exitcode = 0;
+static void __handle_on_exit_funcs();
+static int on_exit(on_exit_func_t function, void *arg);
+#define exit(x) (exit)(__exitcode = (x))
+
+static int on_exit(on_exit_func_t function, void *arg) {
+	if(__on_exit_count == ATEXIT_MAX)
+		return ENOMEM;
+	else if(__on_exit_count == 0)
+		atexit(__handle_on_exit_funcs);
+	__on_exit_funcs[__on_exit_count] = function;
+	__on_exit_args[__on_exit_count++] = arg;
+	return 0;
+}
+
+static void __handle_on_exit_funcs() {
+	for(int i=0; i<__on_exit_count; i++) {
+		__on_exit_funcs[i](__exitcode, __on_exit_args[i]);
+	}
+}
+#endif
+
 enum write_mode_t {
 	WRITE_FORCE,
 	WRITE_APPEND
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 484f26c..70a9cd6 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -471,10 +471,17 @@ static int test__basic_mmap(void)
 		.watermark	= 0,
 	};
 	cpu_set_t cpu_set;
+#ifndef ANDROID
 	const char *syscall_names[] = { "getsid", "getppid", "getpgrp",
 					"getpgid", };
 	pid_t (*syscalls[])(void) = { (void *)getsid, getppid, getpgrp,
 				      (void*)getpgid };
+#else
+	/* No getsid() on Android */
+	const char *syscall_names[] = { "getppid", "getpgrp",
+					"getpgid", };
+	pid_t (*syscalls[])(void) = { getppid, getpgrp, (void*)getpgid };
+#endif
 #define nsyscalls ARRAY_SIZE(syscall_names)
 	int ids[nsyscalls];
 	unsigned int nr_events[nsyscalls],
diff --git a/tools/perf/compat-android.h b/tools/perf/compat-android.h
new file mode 100644
index 0000000..b8fb936
--- /dev/null
+++ b/tools/perf/compat-android.h
@@ -0,0 +1,106 @@
+/* Android compatibility header
+ * Provides missing bits in Bionic on Android, ignored
+ * on regular Linux.
+ *
+ * Written by Bernhard.Rosenkranzer@linaro.org
+ *
+ * Released into the public domain. Do with this file
+ * whatever you want.
+ */
+#ifdef ANDROID
+/* Bionic has its own idea about ALIGN, and kills other definitions.
+ * Done outside the multiple-inclusion wrapper to make sure we
+ * can override Bionic's ALIGN by simply including compat-android.h
+ * again after including Bionic headers.
+ */
+#undef ALIGN
+#undef __ALIGN_MASK
+#define ALIGN(x,a)              __ALIGN_MASK(x,(typeof(x))(a)-1)
+#define __ALIGN_MASK(x,mask)    (((x)+(mask))&~(mask))
+
+#ifndef _COMPAT_ANDROID_H_
+#define _COMPAT_ANDROID_H_ 1
+#include <stdio.h>
+#include <signal.h>
+#include <asm/page.h> /* for PAGE_SIZE */
+#include <asm/termios.h> /* for winsize */
+
+#ifndef __WORDSIZE
+#include <stdint.h>
+#define __WORDSIZE _BITSIZE
+#endif
+
+#ifndef roundup
+#define roundup(x, y)   ((((x)+((y)-1))/(y))*(y))
+#endif
+
+#ifndef __force
+#define __force
+#endif
+
+#ifndef __le32
+#define __le32 uint32_t
+#endif
+
+/* Assorted functions that are missing from Bionic */
+/* Android prior to 4.2 lacks psignal().
+ * What we're doing here is fairly evil - but necessary since
+ * Bionic doesn't export any version identifier or the likes.
+ * We do know that 4.2 is the version introducing psignal() and
+ * also KLOG_CONSOLE_OFF -- completely unrelated, but something
+ * we can check for...
+ */
+#include <sys/klog.h>
+#ifndef KLOG_CONSOLE_OFF
+static void psignal(int sig, const char *s)
+{
+	if(sig >= 0 && sig < NSIG) {
+		if(s)
+			fprintf(stderr, "%s: %s\n", s, sys_siglist[sig]);
+		else
+			fprintf(stderr, "%s\n", sys_siglist[sig]);
+	} else {
+		if(s)
+			fprintf(stderr, "%s: invalid signal\n", s);
+		else
+			fputs("invalid signal\n", stderr);
+	}
+}
+#endif
+
+static ssize_t getline(char **lineptr, size_t *n, FILE *stream)
+{
+	size_t ret = 0;
+
+	if (!lineptr || !n || !stream)
+		return -1;
+
+	if(!*lineptr) {
+		*n = 128;
+		*lineptr = (char*)malloc(*n);
+		if(!*lineptr)
+			return -1;
+	}
+
+	while(!feof(stream) && !ferror(stream)) {
+		int c;
+		if(ret == *n) {
+			*n += 128;
+			*lineptr = (char*)realloc(*lineptr, *n);
+			if(!*lineptr) {
+				*n = 0;
+				return -1;
+			}
+		}
+		c = fgetc(stream);
+		if(c == EOF)
+			break;
+		*lineptr[ret++] = c;
+		if(c == '\n')
+			break;
+	}
+	*lineptr[ret] = 0;
+	return ret;
+}
+#endif
+#endif
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-
tests.mak
index 4add41b..76ec8bf 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -43,6 +43,19 @@ int main(void)
 }
 endef
 
+define SOURCE_BIONIC
+#include <android/api-level.h>
+
+int main(void)
+{
+#ifndef __ANDROID_API__
+	error out
+#else
+	return 0;
+#endif
+}
+endef
+
 define SOURCE_ELF_MMAP
 #include <libelf.h>
 int main(void)
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 70fa70b..10e8a47 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -72,7 +72,9 @@
 #include <inttypes.h>
 #include <linux/magic.h>
 #include "types.h"
+#ifndef ANDROID
 #include <sys/ttydefaults.h>
+#endif
 
 extern const char *graph_line;
 extern const char *graph_dotted_line;
-- 
1.7.11.3


