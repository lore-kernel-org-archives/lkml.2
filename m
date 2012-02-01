Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab2BALIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 06:08:34 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47717 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2BALIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 06:08:31 -0500
From: Franck Bui-Huu <fbuihuu@gmail.com>
To: linux@dominikbrodowski.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] cpupower tool: allow to build in a separate directory
Date: Wed,  1 Feb 2012 12:08:20 +0100
Message-Id: <1328094500-19393-4-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1328094500-19393-1-git-send-email-fbuihuu@gmail.com>
References: <1328094500-19393-1-git-send-email-fbuihuu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows cpupower tool to generate its output files in a
seperate directory. This is now possible by passing the 'O=<path>' to
the command line.

This can be usefull for a normal user if the kernel source code is
located a in read only location.

This is patch stole some bits of the perf makefile.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/power/cpupower/Makefile       |   87 ++++++++++++++++++++++------------
 tools/power/cpupower/bench/Makefile |   23 ++++++---
 2 files changed, 71 insertions(+), 39 deletions(-)

diff --git a/tools/power/cpupower/Makefile b/tools/power/cpupower/Makefile
index f1fe491..9b7725a 100644
--- a/tools/power/cpupower/Makefile
+++ b/tools/power/cpupower/Makefile
@@ -19,6 +19,16 @@
 # along with this program; if not, write to the Free Software
 # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 #
+OUTPUT=./
+ifeq ("$(origin O)", "command line")
+	OUTPUT := $(O)/
+endif
+
+ifneq ($(OUTPUT),)
+# check that the output directory actually exists
+OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
+$(if $(OUTDIR),, $(error output directory "$(OUTPUT)" does not exist))
+endif
 
 # --- CONFIGURATION BEGIN ---
 
@@ -87,6 +97,7 @@ AR = $(CROSS)ar
 STRIP = $(CROSS)strip
 RANLIB = $(CROSS)ranlib
 HOSTCC = gcc
+MKDIR = mkdir
 
 
 # Now we set up the build system
@@ -95,7 +106,7 @@ HOSTCC = gcc
 # set up PWD so that older versions of make will work with our build.
 PWD = $(shell pwd)
 
-GMO_FILES = ${shell for HLANG in ${LANGUAGES}; do echo po/$$HLANG.gmo; done;}
+GMO_FILES = ${shell for HLANG in ${LANGUAGES}; do echo $(OUTPUT)po/$$HLANG.gmo; done;}
 
 export CROSS CC AR STRIP RANLIB CFLAGS LDFLAGS LIB_OBJS
 
@@ -122,15 +133,18 @@ UTIL_OBJS =  utils/helpers/amd.o utils/helpers/topology.o utils/helpers/msr.o \
 	utils/cpupower.o utils/cpufreq-info.o utils/cpufreq-set.o \
 	utils/cpupower-set.o utils/cpupower-info.o utils/cpuidle-info.o
 
+UTIL_SRC := $(UTIL_OBJS:.o=.c)
+
+UTIL_OBJS := $(addprefix $(OUTPUT),$(UTIL_OBJS))
+
 UTIL_HEADERS = utils/helpers/helpers.h utils/idle_monitor/cpupower-monitor.h \
 	utils/helpers/bitmask.h \
 	utils/idle_monitor/idle_monitors.h utils/idle_monitor/idle_monitors.def
 
-UTIL_SRC := $(UTIL_OBJS:.o=.c)
-
 LIB_HEADERS = 	lib/cpufreq.h lib/sysfs.h
 LIB_SRC = 	lib/cpufreq.c lib/sysfs.c
 LIB_OBJS = 	lib/cpufreq.o lib/sysfs.o
+LIB_OBJS :=	$(addprefix $(OUTPUT),$(LIB_OBJS))
 
 CFLAGS +=	-pipe
 
@@ -168,79 +182,90 @@ endif
 
 # the actual make rules
 
-all: libcpupower cpupower $(COMPILE_NLS) $(COMPILE_BENCH)
+all: libcpupower $(OUTPUT)cpupower $(COMPILE_NLS) $(COMPILE_BENCH)
 
-lib/%.o: $(LIB_SRC) $(LIB_HEADERS)
+$(OUTPUT)lib/%.o: $(LIB_SRC) $(LIB_HEADERS)
 	$(ECHO) "  CC      " $@
 	$(QUIET) $(CC) $(CFLAGS) -fPIC -o $@ -c lib/$*.c
 
-libcpupower.so.$(LIB_MAJ): $(LIB_OBJS)
+$(OUTPUT)libcpupower.so.$(LIB_MAJ): $(LIB_OBJS)
 	$(ECHO) "  LD      " $@
 	$(QUIET) $(CC) -shared $(CFLAGS) $(LDFLAGS) -o $@ \
 		-Wl,-soname,libcpupower.so.$(LIB_MIN) $(LIB_OBJS)
-	@ln -sf $@ libcpupower.so
-	@ln -sf $@ libcpupower.so.$(LIB_MIN)
+	@ln -sf $(@F) $(OUTPUT)libcpupower.so
+	@ln -sf $(@F) $(OUTPUT)libcpupower.so.$(LIB_MIN)
 
-libcpupower: libcpupower.so.$(LIB_MAJ)
+libcpupower: $(OUTPUT)libcpupower.so.$(LIB_MAJ)
 
 # Let all .o files depend on its .c file and all headers
 # Might be worth to put this into utils/Makefile at some point of time
 $(UTIL_OBJS): $(UTIL_HEADERS)
 
-.c.o:
+$(OUTPUT)%.o: %.c
 	$(ECHO) "  CC      " $@
 	$(QUIET) $(CC) $(CFLAGS) -I./lib -I ./utils -o $@ -c $*.c
 
-cpupower: $(UTIL_OBJS) libcpupower.so.$(LIB_MAJ)
+$(OUTPUT)cpupower: $(UTIL_OBJS) $(OUTPUT)libcpupower.so.$(LIB_MAJ)
 	$(ECHO) "  CC      " $@
-	$(QUIET) $(CC) $(CFLAGS) $(LDFLAGS) -lcpupower -lrt -lpci -L. -o $@ $(UTIL_OBJS)
+	$(QUIET) $(CC) $(CFLAGS) $(LDFLAGS) -lcpupower -lrt -lpci -L$(OUTPUT) -o $@ $(UTIL_OBJS)
 	$(QUIET) $(STRIPCMD) $@
 
-po/$(PACKAGE).pot: $(UTIL_SRC)
+$(OUTPUT)po/$(PACKAGE).pot: $(UTIL_SRC)
 	$(ECHO) "  GETTEXT " $@
 	$(QUIET) xgettext --default-domain=$(PACKAGE) --add-comments \
 		--keyword=_ --keyword=N_ $(UTIL_SRC) -p $(@D) -o $(@F)
 
-po/%.gmo: po/%.po
+$(OUTPUT)po/%.gmo: po/%.po
 	$(ECHO) "  MSGFMT  " $@
 	$(QUIET) msgfmt -o $@ po/$*.po
 
 create-gmo: ${GMO_FILES}
 
-update-po: po/$(PACKAGE).pot
+update-po: $(OUTPUT)po/$(PACKAGE).pot
 	$(ECHO) "  MSGMRG  " $@
 	$(QUIET) @for HLANG in $(LANGUAGES); do \
 		echo -n "Updating $$HLANG "; \
-		if msgmerge po/$$HLANG.po po/$(PACKAGE).pot -o \
-		   po/$$HLANG.new.po; then \
-			mv -f po/$$HLANG.new.po po/$$HLANG.po; \
+		if msgmerge po/$$HLANG.po $< -o \
+		   $(OUTPUT)po/$$HLANG.new.po; then \
+			mv -f $(OUTPUT)po/$$HLANG.new.po $(OUTPUT)po/$$HLANG.po; \
 		else \
 			echo "msgmerge for $$HLANG failed!"; \
-			rm -f po/$$HLANG.new.po; \
+			rm -f $(OUTPUT)po/$$HLANG.new.po; \
 		fi; \
 	done;
 
-compile-bench: libcpupower.so.$(LIB_MAJ)
-	@V=$(V) confdir=$(confdir) $(MAKE) -C bench
+compile-bench: $(OUTPUT)libcpupower.so.$(LIB_MAJ)
+	@V=$(V) confdir=$(confdir) $(MAKE) -C bench O=$(OUTPUT)
+
+# we compile into subdirectories. if the target directory is not the
+# source directory, they might not exists. So we depend the various
+# files onto their directories.
+DIRECTORY_DEPS = $(LIB_OBJS) $(UTIL_OBJS) $(GMO_FILES)
+$(DIRECTORY_DEPS): | $(sort $(dir $(DIRECTORY_DEPS)))
+
+# In the second step, we make a rule to actually create these directories
+$(sort $(dir $(DIRECTORY_DEPS))):
+	$(ECHO) "  MKDIR      " $@
+	$(QUIET) $(MKDIR) -p $@ 2>/dev/null
 
 clean:
-	-find . \( -not -type d \) -and \( -name '*~' -o -name '*.[oas]' \) -type f -print \
+	-find $(OUTPUT) \( -not -type d \) -and \( -name '*~' -o -name '*.[oas]' \) -type f -print \
 	 | xargs rm -f
-	-rm -f cpupower
-	-rm -f libcpupower.so*
-	-rm -rf po/*.gmo po/*.pot
-	$(MAKE) -C bench clean
+	-rm -f $(OUTPUT)cpupower
+	-rm -f $(OUTPUT)libcpupower.so*
+	-rm -rf $(OUTPUT)po/*.{gmo,pot}
+	$(MAKE) -C bench O=$(OUTPUT) clean
 
 
 install-lib:
 	$(INSTALL) -d $(DESTDIR)${libdir}
-	$(CP) libcpupower.so* $(DESTDIR)${libdir}/
+	$(CP) $(OUTPUT)libcpupower.so* $(DESTDIR)${libdir}/
 	$(INSTALL) -d $(DESTDIR)${includedir}
 	$(INSTALL_DATA) lib/cpufreq.h $(DESTDIR)${includedir}/cpufreq.h
 
 install-tools:
 	$(INSTALL) -d $(DESTDIR)${bindir}
-	$(INSTALL_PROGRAM) cpupower $(DESTDIR)${bindir}
+	$(INSTALL_PROGRAM) $(OUTPUT)cpupower $(DESTDIR)${bindir}
 
 install-man:
 	$(INSTALL_DATA) -D man/cpupower.1 $(DESTDIR)${mandir}/man1/cpupower.1
@@ -253,13 +278,13 @@ install-man:
 install-gmo:
 	$(INSTALL) -d $(DESTDIR)${localedir}
 	for HLANG in $(LANGUAGES); do \
-		echo '$(INSTALL_DATA) -D po/$$HLANG.gmo $(DESTDIR)${localedir}/$$HLANG/LC_MESSAGES/cpupower.mo'; \
-		$(INSTALL_DATA) -D po/$$HLANG.gmo $(DESTDIR)${localedir}/$$HLANG/LC_MESSAGES/cpupower.mo; \
+		echo '$(INSTALL_DATA) -D $(OUTPUT)po/$$HLANG.gmo $(DESTDIR)${localedir}/$$HLANG/LC_MESSAGES/cpupower.mo'; \
+		$(INSTALL_DATA) -D $(OUTPUT)po/$$HLANG.gmo $(DESTDIR)${localedir}/$$HLANG/LC_MESSAGES/cpupower.mo; \
 	done;
 
 install-bench:
 	@#DESTDIR must be set from outside to survive
-	@sbindir=$(sbindir) bindir=$(bindir) docdir=$(docdir) confdir=$(confdir) $(MAKE) -C bench install
+	@sbindir=$(sbindir) bindir=$(bindir) docdir=$(docdir) confdir=$(confdir) $(MAKE) -C bench O=$(OUTPUT) install
 
 install: all install-lib install-tools install-man $(INSTALL_NLS) $(INSTALL_BENCH)
 
diff --git a/tools/power/cpupower/bench/Makefile b/tools/power/cpupower/bench/Makefile
index 2b67606..7ec7021 100644
--- a/tools/power/cpupower/bench/Makefile
+++ b/tools/power/cpupower/bench/Makefile
@@ -1,29 +1,36 @@
-LIBS = -L../ -lm -lcpupower
+OUTPUT := ./
+ifeq ("$(origin O)", "command line")
+ifneq ($(O),)
+	OUTPUT := $(O)/
+endif
+endif
 
-OBJS = main.o parse.o system.o benchmark.o
+LIBS = -L../ -L$(OUTPUT) -lm -lcpupower
+
+OBJS = $(OUTPUT)main.o $(OUTPUT)parse.o $(OUTPUT)system.o $(OUTPUT)benchmark.o
 CFLAGS += -D_GNU_SOURCE -I../lib -DDEFAULT_CONFIG_FILE=\"$(confdir)/cpufreq-bench.conf\"
 
-%.o : %.c
+$(OUTPUT)%.o : %.c
 	$(ECHO) "  CC      " $@
 	$(QUIET) $(CC) -c $(CFLAGS) $< -o $@
 
-cpufreq-bench: $(OBJS)
+$(OUTPUT)cpufreq-bench: $(OBJS)
 	$(ECHO) "  CC      " $@
 	$(QUIET) $(CC) -o $@ $(CFLAGS) $(OBJS) $(LIBS)
 
-all: cpufreq-bench
+all: $(OUTPUT)cpufreq-bench
 
 install:
 	mkdir -p $(DESTDIR)/$(sbindir)
 	mkdir -p $(DESTDIR)/$(bindir)
 	mkdir -p $(DESTDIR)/$(docdir)
 	mkdir -p $(DESTDIR)/$(confdir)
-	install -m 755 cpufreq-bench $(DESTDIR)/$(sbindir)/cpufreq-bench
+	install -m 755 $(OUTPUT)cpufreq-bench $(DESTDIR)/$(sbindir)/cpufreq-bench
 	install -m 755 cpufreq-bench_plot.sh $(DESTDIR)/$(bindir)/cpufreq-bench_plot.sh
 	install -m 644 README-BENCH $(DESTDIR)/$(docdir)/README-BENCH
 	install -m 755 cpufreq-bench_script.sh $(DESTDIR)/$(docdir)/cpufreq-bench_script.sh
 	install -m 644 example.cfg $(DESTDIR)/$(confdir)/cpufreq-bench.conf
 
 clean:
-	rm -f *.o
-	rm -f cpufreq-bench
+	rm -f $(OUTPUT)*.o
+	rm -f $(OUTPUT)cpufreq-bench
-- 
1.7.7.4

