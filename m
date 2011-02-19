Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1BSJcx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 04:32:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:50495 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab1BSJct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 04:32:49 -0500
Date: Sat, 19 Feb 2011 09:32:36 GMT
From: tip-bot for Michael Witten <mfwitten@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, mfwitten@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, mfwitten@gmail.com, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Makefile: Remove various and sundry cruft
Message-ID: <tip-a3d1ee10d1bf4520af3d44c1aa6cd46956ec4fd7@git.kernel.org>
Git-Commit-ID: a3d1ee10d1bf4520af3d44c1aa6cd46956ec4fd7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Feb 2011 09:32:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3d1ee10d1bf4520af3d44c1aa6cd46956ec4fd7
Gitweb:     http://git.kernel.org/tip/a3d1ee10d1bf4520af3d44c1aa6cd46956ec4fd7
Author:     Michael Witten <mfwitten@gmail.com>
AuthorDate: Wed, 2 Feb 2011 14:22:08 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 18 Feb 2011 07:43:06 -0200

perf tools: Makefile: Remove various and sundry cruft

This commit squashes several commits that remove:

 unnecessary uname calls
 `sh -c'
 BUILT_INS and QUIET_BUILT_IN

    They have no effect, and the `fixup-builtins' and `check-builtins.sh'
    scripts don't even exist.

 RUNTIME_PREFIX

    It's currently never anything but unset, and it's apparently
    only meaningful when Microsoft Windows is the operating system
    (according to the source for git).

 TEST_PROGRAMS
 EXTRA_PROGRAMS
 unused SHELL_PATH_SQ portions
 unused test for V=2
 useless exports

    Only when `V' is undefined (that is, only when the value of `V'
    is empty) is `export V' performed, which just has the effect of
    placing the empty-valued variable `V' in the environment.

    The only other script to make use of `V' is `Documentation/Makefile',
    which only checks whether `V' is undefined (that is, whether the value
    of `V' is empty); hence, the `export V' has no effect whatsoever.

    Similarly, `export QUIET_GEN' is useless because it will only have
    a non-empty value when `V' has an empty-value, and when `V' has
    an empty-value, `QUIET_GEN' is always explicitly set in every
    script in which it is used.

    `DESTDIR' is only ever defined by the user via the environment
    or the command line, both of which are automatically exported
    to sub-make processes. Furthermore, no non-make sub-scripts
    make use of `DESTDIR' as an environment variable.

    No other scripts use `perfexec_instdir'.

 unused QUIET_SUBDIR{0,1}
 TAR and RPMBUILD
 PTHREAD_LIBS
 Maintainer's dist rules and commands
 distclean target
 Test suite coverage testing
 PRINT_DIR and NO_SUBDIR
 `configure' target
 NO_CURL
 @@PERF_VERSION@@ substitution

    Without the sed command, all of the rule's commands can be reduced
    to a single line that copies a file and sets the permissions properly
    in the process.

 `make test' echo line
 template_instdir
 PERF-BUILD-OPTIONS
 double-colon rules

    The use of double-colon rules seems misguided or vestigial git.

 Essentially hard-coded $(SCRIPTS) expansion

Signed-off-by: Michael Witten <mfwitten@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/.gitignore      |    1 -
 tools/perf/Makefile        |  213 ++-----------------------------------------
 tools/perf/util/exec_cmd.c |   19 ----
 3 files changed, 10 insertions(+), 223 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index cb43289..416684b 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -1,4 +1,3 @@
-PERF-BUILD-OPTIONS
 PERF-CFLAGS
 PERF-GUI-VARS
 PERF-VERSION-FILE
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index fde196f..9b84218 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -3,7 +3,7 @@ ifeq ("$(origin O)", "command line")
 endif
 
 # The default target of this Makefile is...
-all::
+all:
 
 ifneq ($(OUTPUT),)
 # check that the output directory actually exists
@@ -11,8 +11,7 @@ OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
 $(if $(OUTDIR),, $(error output directory "$(OUTPUT)" does not exist))
 endif
 
-# Define V=1 to have a more verbose compile.
-# Define V=2 to have an even more verbose compile.
+# Define V to have a more verbose compile.
 #
 # Define ASCIIDOC8 if you want to format documentation with AsciiDoc 8
 #
@@ -28,12 +27,7 @@ $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
 -include $(OUTPUT)PERF-VERSION-FILE
 
-uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')
-uname_M := $(shell sh -c 'uname -m 2>/dev/null || echo not')
-uname_O := $(shell sh -c 'uname -o 2>/dev/null || echo not')
-uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
-uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
-uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
+uname_M := $(shell uname -m 2>/dev/null || echo not)
 
 ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 				  -e s/arm.*/arm/ -e s/sa110/arm/ \
@@ -52,8 +46,6 @@ ifeq ($(ARCH),x86_64)
 	ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S
 endif
 
-# CFLAGS and LDFLAGS are for the users to override from the command line.
-
 #
 # Include saner warnings here, which can catch bugs:
 #
@@ -131,22 +123,13 @@ CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 RM = rm -f
 MKDIR = mkdir
-TAR = tar
 FIND = find
 INSTALL = install
-RPMBUILD = rpmbuild
-PTHREAD_LIBS = -lpthread
 
 # sparse is architecture-neutral, which means that we need to tell it
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
-ifeq ($(V), 2)
-	QUIET_STDERR = ">/dev/null"
-else
-	QUIET_STDERR = ">/dev/null 2>&1"
-endif
-
 -include feature-tests.mak
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
@@ -171,12 +154,10 @@ BASIC_LDFLAGS =
 
 # Guard against environment variables
 BUILTIN_OBJS =
-BUILT_INS =
 LIB_H =
 LIB_OBJS =
 PYRF_OBJS =
 SCRIPT_SH =
-TEST_PROGRAMS =
 
 SCRIPT_SH += perf-archive.sh
 
@@ -192,12 +173,6 @@ $(OUTPUT)python/perf.so: $(PYRF_OBJS)
 
 SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
 
-# Empty...
-EXTRA_PROGRAMS =
-
-# ... and all the rest that could be moved out of bindir to perfexecdir
-PROGRAMS += $(EXTRA_PROGRAMS)
-
 #
 # Single 'perf' binary right now:
 #
@@ -205,10 +180,6 @@ PROGRAMS += $(OUTPUT)perf
 
 LANG_BINDINGS =
 
-# List built-in command $C whose implementation cmd_$C() is not in
-# builtin-$C.o but is linked in as part of some other command.
-#
-
 # what 'all' will build and 'install' will install, in perfexecdir
 ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS)
 
@@ -565,33 +536,13 @@ else
 	endif
 endif
 
-ifdef RUNTIME_PREFIX
-	COMPAT_CFLAGS += -DRUNTIME_PREFIX
-endif
-
-QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
-QUIET_SUBDIR1  =
-
-ifneq ($(findstring $(MAKEFLAGS),w),w)
-PRINT_DIR = --no-print-directory
-else # "make -w"
-NO_SUBDIR = :
-endif
-
 ifneq ($(findstring $(MAKEFLAGS),s),s)
 ifndef V
 	QUIET_CC       = @echo '   ' CC $@;
 	QUIET_AR       = @echo '   ' AR $@;
 	QUIET_LINK     = @echo '   ' LINK $@;
 	QUIET_MKDIR    = @echo '   ' MKDIR $@;
-	QUIET_BUILT_IN = @echo '   ' BUILTIN $@;
 	QUIET_GEN      = @echo '   ' GEN $@;
-	QUIET_SUBDIR0  = +@subdir=
-	QUIET_SUBDIR1  = ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
-			 $(MAKE) $(PRINT_DIR) -C $$subdir
-	export V
-	export QUIET_GEN
-	export QUIET_BUILT_IN
 endif
 endif
 
@@ -621,16 +572,14 @@ ALL_CFLAGS += $(BASIC_CFLAGS)
 ALL_CFLAGS += $(ARCH_CFLAGS)
 ALL_LDFLAGS += $(BASIC_LDFLAGS)
 
-export TAR INSTALL DESTDIR SHELL_PATH
+export INSTALL SHELL_PATH
 
 
 ### Build rules
 
 SHELL = $(SHELL_PATH)
 
-all:: shell_compatibility_test $(ALL_PROGRAMS) $(LANG_BINDINGS) $(BUILT_INS) $(OTHER_PROGRAMS) $(OUTPUT)PERF-BUILD-OPTIONS
-
-all::
+all: shell_compatibility_test $(ALL_PROGRAMS) $(LANG_BINDINGS) $(OTHER_PROGRAMS)
 
 please_set_SHELL_PATH_to_a_more_modern_shell:
 	@$$(:)
@@ -661,37 +610,17 @@ $(OUTPUT)builtin-timechart.o: builtin-timechart.c $(OUTPUT)common-cmds.h $(OUTPU
 		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
 		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
 
-$(BUILT_INS): $(OUTPUT)perf$X
-	$(QUIET_BUILT_IN)$(RM) $@ && \
-	ln perf$X $@ 2>/dev/null || \
-	ln -s perf$X $@ 2>/dev/null || \
-	cp perf$X $@
-
 $(OUTPUT)common-cmds.h: util/generate-cmdlist.sh command-list.txt
 
 $(OUTPUT)common-cmds.h: $(wildcard Documentation/perf-*.txt)
 	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ $@
 
-$(patsubst %.sh,%,$(SCRIPT_SH)) : % : %.sh
-	$(QUIET_GEN)$(RM) $(OUTPUT)$@ $(OUTPUT)$@+ && \
-	sed -e '1s|#!.*/sh|#!$(SHELL_PATH_SQ)|' \
-	    -e 's|@SHELL_PATH@|$(SHELL_PATH_SQ)|' \
-	    -e 's/@@PERF_VERSION@@/$(PERF_VERSION)/g' \
-	    -e 's/@@NO_CURL@@/$(NO_CURL)/g' \
-	    $@.sh > $(OUTPUT)$@+ && \
-	chmod +x $(OUTPUT)$@+ && \
-	mv $(OUTPUT)$@+ $(OUTPUT)$@
-
-configure: configure.ac
-	$(QUIET_GEN)$(RM) $@ $<+ && \
-	sed -e 's/@@PERF_VERSION@@/$(PERF_VERSION)/g' \
-	    $< > $<+ && \
-	autoconf -o $@ $<+ && \
-	$(RM) $<+
+$(SCRIPTS) : % : %.sh
+	$(QUIET_GEN)$(INSTALL) '$@.sh' '$(OUTPUT)$@'
 
 # These can record PERF_VERSION
 $(OUTPUT)perf.o perf.spec \
-	$(patsubst %.sh,%,$(SCRIPT_SH)) \
+	$(SCRIPTS) \
 	: $(OUTPUT)PERF-VERSION-FILE
 
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
@@ -826,23 +755,8 @@ $(OUTPUT)PERF-CFLAGS: .FORCE-PERF-CFLAGS
 		echo "$$FLAGS" >$(OUTPUT)PERF-CFLAGS; \
             fi
 
-# We need to apply sq twice, once to protect from the shell
-# that runs $(OUTPUT)PERF-BUILD-OPTIONS, and then again to protect it
-# and the first level quoting from the shell that runs "echo".
-$(OUTPUT)PERF-BUILD-OPTIONS: .FORCE-PERF-BUILD-OPTIONS
-	@echo SHELL_PATH=\''$(subst ','\'',$(SHELL_PATH_SQ))'\' >$@
-	@echo TAR=\''$(subst ','\'',$(subst ','\'',$(TAR)))'\' >>$@
-	@echo NO_CURL=\''$(subst ','\'',$(subst ','\'',$(NO_CURL)))'\' >>$@
-
 ### Testing rules
 
-#
-# None right now:
-#
-# TEST_PROGRAMS += test-something$X
-
-all:: $(TEST_PROGRAMS)
-
 # GNU make supports exporting all variables by "export" without parameters.
 # However, the environment gets quite big, and some programs have problems
 # with that.
@@ -855,29 +769,17 @@ check: $(OUTPUT)common-cmds.h
 			sparse $(ALL_CFLAGS) $(SPARSE_FLAGS) $$i || exit; \
 		done; \
 	else \
-		echo 2>&1 "Did you mean 'make test'?"; \
 		exit 1; \
 	fi
 
-remove-dashes:
-	./fixup-builtins $(BUILT_INS) $(PROGRAMS) $(SCRIPTS)
-
 ### Installation rules
 
-ifneq ($(filter /%,$(firstword $(template_dir))),)
-template_instdir = $(template_dir)
-else
-template_instdir = $(prefix)/$(template_dir)
-endif
-export template_instdir
-
 ifneq ($(filter /%,$(firstword $(perfexecdir))),)
 perfexec_instdir = $(perfexecdir)
 else
 perfexec_instdir = $(prefix)/$(perfexecdir)
 endif
 perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
-export perfexec_instdir
 
 install: all
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
@@ -894,14 +796,6 @@ install: all
 	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
 	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
 
-ifdef BUILT_INS
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
-	$(INSTALL) $(BUILT_INS) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
-ifneq (,$X)
-	$(foreach p,$(patsubst %$X,%,$(filter %$X,$(ALL_PROGRAMS) $(BUILT_INS) $(OUTPUT)perf$X)), $(RM) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/$p';)
-endif
-endif
-
 install-doc:
 	$(MAKE) -C Documentation install
 
@@ -926,104 +820,17 @@ quick-install-man:
 quick-install-html:
 	$(MAKE) -C Documentation quick-install-html
 
-
-### Maintainer's dist rules
-#
-# None right now
-#
-#
-# perf.spec: perf.spec.in
-#	sed -e 's/@@VERSION@@/$(PERF_VERSION)/g' < $< > $@+
-#	mv $@+ $@
-#
-# PERF_TARNAME=perf-$(PERF_VERSION)
-# dist: perf.spec perf-archive$(X) configure
-#	./perf-archive --format=tar \
-#		--prefix=$(PERF_TARNAME)/ HEAD^{tree} > $(PERF_TARNAME).tar
-#	@mkdir -p $(PERF_TARNAME)
-#	@cp perf.spec configure $(PERF_TARNAME)
-#	@echo $(PERF_VERSION) > $(PERF_TARNAME)/version
-#	$(TAR) rf $(PERF_TARNAME).tar \
-#		$(PERF_TARNAME)/perf.spec \
-#		$(PERF_TARNAME)/configure \
-#		$(PERF_TARNAME)/version
-#	@$(RM) -r $(PERF_TARNAME)
-#	gzip -f -9 $(PERF_TARNAME).tar
-#
-# htmldocs = perf-htmldocs-$(PERF_VERSION)
-# manpages = perf-manpages-$(PERF_VERSION)
-# dist-doc:
-#	$(RM) -r .doc-tmp-dir
-#	mkdir .doc-tmp-dir
-#	$(MAKE) -C Documentation WEBDOC_DEST=../.doc-tmp-dir install-webdoc
-#	cd .doc-tmp-dir && $(TAR) cf ../$(htmldocs).tar .
-#	gzip -n -9 -f $(htmldocs).tar
-#	:
-#	$(RM) -r .doc-tmp-dir
-#	mkdir -p .doc-tmp-dir/man1 .doc-tmp-dir/man5 .doc-tmp-dir/man7
-#	$(MAKE) -C Documentation DESTDIR=./ \
-#		man1dir=../.doc-tmp-dir/man1 \
-#		man5dir=../.doc-tmp-dir/man5 \
-#		man7dir=../.doc-tmp-dir/man7 \
-#		install
-#	cd .doc-tmp-dir && $(TAR) cf ../$(manpages).tar .
-#	gzip -n -9 -f $(manpages).tar
-#	$(RM) -r .doc-tmp-dir
-#
-# rpm: dist
-#	$(RPMBUILD) -ta $(PERF_TARNAME).tar.gz
-
 ### Cleaning rules
 
-distclean: clean
-#	$(RM) configure
-
 clean:
 	$(RM) $(OUTPUT){*.o,*/*.o,*/*/*.o,*/*/*/*.o,$(LIB_FILE),perf-archive}
-	$(RM) $(ALL_PROGRAMS) $(BUILT_INS) perf
-	$(RM) $(TEST_PROGRAMS)
+	$(RM) $(ALL_PROGRAMS) perf
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
-	$(RM) -r $(PERF_TARNAME) .doc-tmp-dir
-	$(RM) $(PERF_TARNAME).tar.gz perf-core_$(PERF_VERSION)-*.tar.gz
-	$(RM) $(htmldocs).tar.gz $(manpages).tar.gz
 	$(MAKE) -C Documentation/ clean
-	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-BUILD-OPTIONS
+	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
 	@python util/setup.py clean --build-lib='$(OUTPUT)python' \
 				   --build-temp='$(OUTPUT)python/temp'
 
 .PHONY: all install clean strip
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
-.PHONY: .FORCE-PERF-BUILD-OPTIONS
-
-### Make sure built-ins do not have dups and listed in perf.c
-#
-check-builtins::
-	./check-builtins.sh
-
-### Test suite coverage testing
-#
-# None right now
-#
-# .PHONY: coverage coverage-clean coverage-build coverage-report
-#
-# coverage:
-#	$(MAKE) coverage-build
-#	$(MAKE) coverage-report
-#
-# coverage-clean:
-#	rm -f *.gcda *.gcno
-#
-# COVERAGE_CFLAGS = $(CFLAGS) -O0 -ftest-coverage -fprofile-arcs
-# COVERAGE_LDFLAGS = $(CFLAGS)  -O0 -lgcov
-#
-# coverage-build: coverage-clean
-#	$(MAKE) CFLAGS="$(COVERAGE_CFLAGS)" LDFLAGS="$(COVERAGE_LDFLAGS)" all
-#	$(MAKE) CFLAGS="$(COVERAGE_CFLAGS)" LDFLAGS="$(COVERAGE_LDFLAGS)" \
-#		-j1 test
-#
-# coverage-report:
-#	gcov -b *.c */*.c
-#	grep '^function.*called 0 ' *.c.gcov */*.c.gcov \
-#		| sed -e 's/\([^:]*\)\.gcov: *function \([^ ]*\) called.*/\1: \2/' \
-#		| tee coverage-untested-functions
diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
index 67eeff5..7adf4ad 100644
--- a/tools/perf/util/exec_cmd.c
+++ b/tools/perf/util/exec_cmd.c
@@ -11,31 +11,12 @@ static const char *argv0_path;
 
 const char *system_path(const char *path)
 {
-#ifdef RUNTIME_PREFIX
-	static const char *prefix;
-#else
 	static const char *prefix = PREFIX;
-#endif
 	struct strbuf d = STRBUF_INIT;
 
 	if (is_absolute_path(path))
 		return path;
 
-#ifdef RUNTIME_PREFIX
-	assert(argv0_path);
-	assert(is_absolute_path(argv0_path));
-
-	if (!prefix &&
-	    !(prefix = strip_path_suffix(argv0_path, PERF_EXEC_PATH)) &&
-	    !(prefix = strip_path_suffix(argv0_path, BINDIR)) &&
-	    !(prefix = strip_path_suffix(argv0_path, "perf"))) {
-		prefix = PREFIX;
-		fprintf(stderr, "RUNTIME_PREFIX requested, "
-				"but prefix computation failed.  "
-				"Using static fallback '%s'.\n", prefix);
-	}
-#endif
-
 	strbuf_addf(&d, "%s/%s", prefix, path);
 	path = strbuf_detach(&d, NULL);
 	return path;
