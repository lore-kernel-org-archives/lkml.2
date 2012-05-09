Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab2EIIz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:55:29 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41873 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab2EIIz0 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 9 May 2012 04:55:26 -0400
Message-Id: <4FAA3CBA02000078000826DD@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 09 May 2012 08:45:30 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <acme@ghostprotocols.net>,
        <paulus@samba.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: generalize makefile
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part2709CF8A.4__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__Part2709CF8A.4__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

As indicated before, in order to be able to consistently build
individual object, pre-processed, or assembly files under tools/perf/,
the make logic needs to be adjusted: Commands should only come from
pattern rules, and individual targets should merely override compiler
flags. This requires the introduction of a single additional stub
source file (so the pattern rules would cover the respective object or
intermediate file generation).

Further, adjust some dependencies to actually have the intended effect
of re-building in case of them having got touched, also requiring some
re-ordering within the file.

Additionally omit the (redundant and confusing) $(OUTPUT)/ portion of
the build progress messages (just like the normal kernel build does).

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 tools/perf/Makefile      |  135 ++++++++++++++++++++++--------------------=
-----
 tools/perf/util/rbtree.c |    1=20
 2 files changed, 65 insertions(+), 71 deletions(-)

--- 3.4-rc6/tools/perf/Makefile
+++ 3.4-rc6-perf-makefile-generalize/tools/perf/Makefile
@@ -189,7 +189,7 @@ BASIC_LDFLAGS =3D
 BUILTIN_OBJS =3D
 LIB_H =3D
 LIB_OBJS =3D
-PYRF_OBJS =3D
+PYRF_SRC =3D
 SCRIPT_SH =3D
=20
 SCRIPT_SH +=3D perf-archive.sh
@@ -200,16 +200,11 @@ strip-libs =3D $(filter-out -l%,$(1))
 PYTHON_EXT_SRCS :=3D $(shell grep -v ^\# util/python-ext-sources)
 PYTHON_EXT_DEPS :=3D util/python-ext-sources util/setup.py
=20
-$(OUTPUT)python/perf.so: $(PYRF_OBJS) $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS=
)
-	$(QUIET_GEN)CFLAGS=3D'$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py=
 \
-	  --quiet build_ext; \
-	mkdir -p $(OUTPUT)python && \
-	cp $(PYTHON_EXTBUILD_LIB)perf.so $(OUTPUT)python/
 #
 # No Perl scripts right now:
 #
=20
-SCRIPTS =3D $(patsubst %.sh,%,$(SCRIPT_SH))
+SCRIPTS =3D $(patsubst %.sh,$(OUTPUT)%,$(SCRIPT_SH))
=20
 #
 # Single 'perf' binary right now:
@@ -436,14 +431,14 @@ PERFLIBS =3D $(LIB_FILE)
 # This has to be in sync with what is in the 'sources' variable in
 # tools/perf/util/setup.py
=20
-PYRF_OBJS +=3D $(OUTPUT)util/cpumap.o
-PYRF_OBJS +=3D $(OUTPUT)util/ctype.o
-PYRF_OBJS +=3D $(OUTPUT)util/evlist.o
-PYRF_OBJS +=3D $(OUTPUT)util/evsel.o
-PYRF_OBJS +=3D $(OUTPUT)util/python.o
-PYRF_OBJS +=3D $(OUTPUT)util/thread_map.o
-PYRF_OBJS +=3D $(OUTPUT)util/util.o
-PYRF_OBJS +=3D $(OUTPUT)util/xyarray.o
+PYRF_SRC +=3D util/cpumap.c
+PYRF_SRC +=3D util/ctype.c
+PYRF_SRC +=3D util/evlist.c
+PYRF_SRC +=3D util/evsel.c
+PYRF_SRC +=3D util/python.c
+PYRF_SRC +=3D util/thread_map.c
+PYRF_SRC +=3D util/util.c
+PYRF_SRC +=3D util/xyarray.c
=20
 #
 # Platform specific tweaks
@@ -680,13 +675,13 @@ endif
=20
 ifneq ($(findstring $(MAKEFLAGS),s),s)
 ifndef V
-	QUIET_CC       =3D @echo '   ' CC $@;
-	QUIET_AR       =3D @echo '   ' AR $@;
-	QUIET_LINK     =3D @echo '   ' LINK $@;
-	QUIET_MKDIR    =3D @echo '   ' MKDIR $@;
-	QUIET_GEN      =3D @echo '   ' GEN $@;
-	QUIET_FLEX     =3D @echo '   ' FLEX $@;
-	QUIET_BISON    =3D @echo '   ' BISON $@;
+	QUIET_CC       =3D @echo '   ' CC $(patsubst $(OUTPUT)%,%,$@);
+	QUIET_AR       =3D @echo '   ' AR $(patsubst $(OUTPUT)%,%,$@);
+	QUIET_LINK     =3D @echo '   ' LINK $(patsubst $(OUTPUT)%,%,$@);
+	QUIET_MKDIR    =3D @echo '   ' MKDIR $(patsubst $(OUTPUT)%,%,$@);
+	QUIET_GEN      =3D @echo '   ' GEN $(patsubst $(OUTPUT)%,%,$@);
+	QUIET_FLEX     =3D @echo '   ' FLEX $(patsubst $(OUTPUT)%,%,$@);
+	QUIET_BISON    =3D @echo '   ' BISON $(patsubst $(OUTPUT)%,%,$@);
 endif
 endif
=20
@@ -733,39 +728,22 @@ shell_compatibility_test: please_set_SHE
 strip: $(PROGRAMS) $(OUTPUT)perf
 	$(STRIP) $(STRIP_OPTS) $(PROGRAMS) $(OUTPUT)perf
=20
-$(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -DPERF_VERSION=3D'"$(PERF_VERSION)"' \
-		'-DPERF_HTML_PATH=3D"$(htmldir_SQ)"' \
-		$(ALL_CFLAGS) -c $(filter %.c,$^) -o $@
-
 $(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(OUTPUT)perf.o \
                $(BUILTIN_OBJS) $(LIBS) -o $@
=20
-$(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PE=
RF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
-		'-DPERF_HTML_PATH=3D"$(htmldir_SQ)"' \
-		'-DPERF_MAN_PATH=3D"$(mandir_SQ)"' \
-		'-DPERF_INFO_PATH=3D"$(infodir_SQ)"' $<
-
-$(OUTPUT)builtin-timechart.o: builtin-timechart.c $(OUTPUT)common-cmds.h =
$(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
-		'-DPERF_HTML_PATH=3D"$(htmldir_SQ)"' \
-		'-DPERF_MAN_PATH=3D"$(mandir_SQ)"' \
-		'-DPERF_INFO_PATH=3D"$(infodir_SQ)"' $<
+$(OUTPUT)python/perf.so: $(PYRF_SRC) $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)=

+	$(QUIET_GEN)CFLAGS=3D'$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py=
 \
+	  --$(if $(V),verbose,quiet) build_ext; \
+	mkdir -p $(@D) && mv $(PYTHON_EXTBUILD_LIB)perf.so $(@D)/
=20
 $(OUTPUT)common-cmds.h: util/generate-cmdlist.sh command-list.txt
=20
 $(OUTPUT)common-cmds.h: $(wildcard Documentation/perf-*.txt)
 	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ $@
=20
-$(SCRIPTS) : % : %.sh
-	$(QUIET_GEN)$(INSTALL) '$@.sh' '$(OUTPUT)$@'
-
-# These can record PERF_VERSION
-$(OUTPUT)perf.o perf.spec \
-	$(SCRIPTS) \
-	: $(OUTPUT)PERF-VERSION-FILE
+$(SCRIPTS) : $(OUTPUT)% : %.sh
+	$(QUIET_GEN)$(INSTALL) '$<' '$@'
=20
 .SUFFIXES:
 .SUFFIXES: .o .c .S .s
@@ -790,42 +768,57 @@ $(OUTPUT)%.o: %.S
 $(OUTPUT)%.s: %.S
 	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) $<
=20
-$(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
-		'-DPERF_EXEC_PATH=3D"$(perfexecdir_SQ)"' \
-		'-DBINDIR=3D"$(bindir_relative_SQ)"' \
-		'-DPREFIX=3D"$(prefix_SQ)"' \
-		$<
+ifneq ($(OUTPUT),)
+PHONY_ALL  :=3D $(filter (OUTPUT)%,$(ALL_PROGRAMS) $(LANG_BINDINGS))
+PHONY_OBJS :=3D $(patsubst $(OUTPUT)%,%,$(BUILTIN_OBJS) $(LIB_OBJS))
+PHONY_ASMS :=3D $(patsubst %.o,%.s,$(PHONY_OBJS))
+PHONY_CPPS :=3D $(patsubst %.o,%.i,$(PHONY_OBJS))
+PHONY_ALL  +=3D $(PHONY_OBJS) $(PHONY_ASMS) $(PHONY_CPPS)
+.PHONY: $(PHONY_ALL)
+$(PHONY_ALL): %: $(OUTPUT)%
+endif
+
+output =3D $(foreach ext,o i s,$(OUTPUT)$(1).$(ext))
+
+# These can record PERF_VERSION
+$(call output,perf) $(SCRIPTS): $(OUTPUT)PERF-VERSION-FILE
=20
-$(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG=3D'"$(ETC_=
PERFCONFIG_SQ)"' $<
+$(call output,perf) $(call output,builtin-help): $(OUTPUT)common-cmds.h
=20
-$(OUTPUT)util/ui/browser.o: util/ui/browser.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+$(call output,perf): ALL_CFLAGS +=3D '-DPERF_VERSION=3D"$(PERF_VERSION)"' =
\
+		'-DPERF_HTML_PATH=3D"$(htmldir_SQ)"'
=20
-$(OUTPUT)util/ui/browsers/annotate.o: util/ui/browsers/annotate.c =
$(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+$(call output,builtin-help) $(call output,builtin-timechart): ALL_CFLAGS =
+=3D \
+		'-DPERF_HTML_PATH=3D"$(htmldir_SQ)"' \
+		'-DPERF_MAN_PATH=3D"$(mandir_SQ)"' \
+		'-DPERF_INFO_PATH=3D"$(infodir_SQ)"'
+
+$(call output,util/exec_cmd): ALL_CFLAGS +=3D \
+		'-DPERF_EXEC_PATH=3D"$(perfexecdir_SQ)"' \
+		'-DBINDIR=3D"$(bindir_relative_SQ)"' \
+		'-DPREFIX=3D"$(prefix_SQ)"'
=20
-$(OUTPUT)util/ui/browsers/hists.o: util/ui/browsers/hists.c $(OUTPUT)PERF-=
CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+$(call output,util/config) $(call output,util/rbtree): ALL_CFLAGS +=3D \
+		'-DETC_PERFCONFIG=3D"$(ETC_PERFCONFIG_SQ)"'
=20
-$(OUTPUT)util/ui/browsers/map.o: util/ui/browsers/map.c $(OUTPUT)PERF-CFLA=
GS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
+$(call output,util/rbtree): ../../lib/rbtree.c
=20
-$(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG=3D'"$(ETC_=
PERFCONFIG_SQ)"' $<
+$(call output,util/ui/browser) $(call output,util/ui/browsers/annotate) \
+	$(call output,util/ui/browsers/hists) \
+	$(call output,util/ui/browsers/map): ALL_CFLAGS +=3D \
+		-DENABLE_SLFUTURE_CONST
=20
-$(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines=
/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) =
-Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter =
-Wno-shadow $<
+$(call output,util/scripting-engines/trace-event-perl): ALL_CFLAGS +=3D \
+	$(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes =
-Wno-unused-parameter -Wno-shadow
=20
-$(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-U=
til/Context.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) =
-Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter =
-Wno-nested-externs $<
+$(call output,scripts/perl/Perf-Trace-Util/Context): ALL_CFLAGS +=3D \
+	$(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes =
-Wno-unused-parameter -Wno-nested-externs
=20
-$(OUTPUT)util/scripting-engines/trace-event-python.o: util/scripting-engin=
es/trace-event-python.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PYTHON_EMBED_CCOPTS) =
-Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter =
-Wno-shadow $<
+$(call output,util/scripting-engines/trace-event-python): ALL_CFLAGS +=3D =
\
+	$(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes =
-Wno-unused-parameter -Wno-shadow
=20
-$(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Tra=
ce-Util/Context.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PYTHON_EMBED_CCOPTS) =
-Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter =
-Wno-nested-externs $<
+$(call output,scripts/python/Perf-Trace-Util/Context): ALL_CFLAGS +=3D \
+	$(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes =
-Wno-unused-parameter -Wno-nested-externs
=20
 $(OUTPUT)perf-%: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(ALL_LDFLAGS) $(filter =
%.o,$^) $(LIBS)
--- /home/jbeulich/tmp/linux-3.4-rc6/tools/perf/util/rbtree.c	1970-01-01 =
01:00:00.000000000 +0100
+++ 3.4-rc6-perf-makefile-generalize/tools/perf/util/rbtree.c
@@ -0,0 +1 @@
+#include "../../../lib/rbtree.c"



--=__Part2709CF8A.4__=
Content-Type: text/plain; name="linux-3.4-rc6-perf-makefile-generalize.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-3.4-rc6-perf-makefile-generalize.patch"

perf: generalize makefile=0A=0AAs indicated before, in order to be able to =
consistently build=0Aindividual object, pre-processed, or assembly files =
under tools/perf/,=0Athe make logic needs to be adjusted: Commands should =
only come from=0Apattern rules, and individual targets should merely =
override compiler=0Aflags. This requires the introduction of a single =
additional stub=0Asource file (so the pattern rules would cover the =
respective object or=0Aintermediate file generation).=0A=0AFurther, adjust =
some dependencies to actually have the intended effect=0Aof re-building in =
case of them having got touched, also requiring some=0Are-ordering within =
the file.=0A=0AAdditionally omit the (redundant and confusing) $(OUTPUT)/ =
portion of=0Athe build progress messages (just like the normal kernel =
build does).=0A=0ASigned-off-by: Jan Beulich <jbeulich@suse.com>=0A=0A---=
=0A tools/perf/Makefile      |  135 ++++++++++++++++++++++-----------------=
--------=0A tools/perf/util/rbtree.c |    1 =0A 2 files changed, 65 =
insertions(+), 71 deletions(-)=0A=0A--- 3.4-rc6/tools/perf/Makefile=0A+++ =
3.4-rc6-perf-makefile-generalize/tools/perf/Makefile=0A@@ -189,7 +189,7 @@ =
BASIC_LDFLAGS =3D=0A BUILTIN_OBJS =3D=0A LIB_H =3D=0A LIB_OBJS =3D=0A-PYRF_=
OBJS =3D=0A+PYRF_SRC =3D=0A SCRIPT_SH =3D=0A =0A SCRIPT_SH +=3D perf-archiv=
e.sh=0A@@ -200,16 +200,11 @@ strip-libs =3D $(filter-out -l%,$(1))=0A =
PYTHON_EXT_SRCS :=3D $(shell grep -v ^\# util/python-ext-sources)=0A =
PYTHON_EXT_DEPS :=3D util/python-ext-sources util/setup.py=0A =0A-$(OUTPUT)=
python/perf.so: $(PYRF_OBJS) $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)=0A-	=
$(QUIET_GEN)CFLAGS=3D'$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \=0A-	=
  --quiet build_ext; \=0A-	mkdir -p $(OUTPUT)python && \=0A-	cp =
$(PYTHON_EXTBUILD_LIB)perf.so $(OUTPUT)python/=0A #=0A # No Perl scripts =
right now:=0A #=0A =0A-SCRIPTS =3D $(patsubst %.sh,%,$(SCRIPT_SH))=0A+SCRIP=
TS =3D $(patsubst %.sh,$(OUTPUT)%,$(SCRIPT_SH))=0A =0A #=0A # Single =
'perf' binary right now:=0A@@ -436,14 +431,14 @@ PERFLIBS =3D $(LIB_FILE)=
=0A # This has to be in sync with what is in the 'sources' variable in=0A =
# tools/perf/util/setup.py=0A =0A-PYRF_OBJS +=3D $(OUTPUT)util/cpumap.o=0A-=
PYRF_OBJS +=3D $(OUTPUT)util/ctype.o=0A-PYRF_OBJS +=3D $(OUTPUT)util/evlist=
.o=0A-PYRF_OBJS +=3D $(OUTPUT)util/evsel.o=0A-PYRF_OBJS +=3D $(OUTPUT)util/=
python.o=0A-PYRF_OBJS +=3D $(OUTPUT)util/thread_map.o=0A-PYRF_OBJS +=3D =
$(OUTPUT)util/util.o=0A-PYRF_OBJS +=3D $(OUTPUT)util/xyarray.o=0A+PYRF_SRC =
+=3D util/cpumap.c=0A+PYRF_SRC +=3D util/ctype.c=0A+PYRF_SRC +=3D =
util/evlist.c=0A+PYRF_SRC +=3D util/evsel.c=0A+PYRF_SRC +=3D util/python.c=
=0A+PYRF_SRC +=3D util/thread_map.c=0A+PYRF_SRC +=3D util/util.c=0A+PYRF_SR=
C +=3D util/xyarray.c=0A =0A #=0A # Platform specific tweaks=0A@@ -680,13 =
+675,13 @@ endif=0A =0A ifneq ($(findstring $(MAKEFLAGS),s),s)=0A ifndef =
V=0A-	QUIET_CC       =3D @echo '   ' CC $@;=0A-	QUIET_AR       =3D =
@echo '   ' AR $@;=0A-	QUIET_LINK     =3D @echo '   ' LINK $@;=0A-	=
QUIET_MKDIR    =3D @echo '   ' MKDIR $@;=0A-	QUIET_GEN      =3D @echo ' =
  ' GEN $@;=0A-	QUIET_FLEX     =3D @echo '   ' FLEX $@;=0A-	QUIET_BISON=
    =3D @echo '   ' BISON $@;=0A+	QUIET_CC       =3D @echo '   ' CC =
$(patsubst $(OUTPUT)%,%,$@);=0A+	QUIET_AR       =3D @echo '   ' AR =
$(patsubst $(OUTPUT)%,%,$@);=0A+	QUIET_LINK     =3D @echo '   ' =
LINK $(patsubst $(OUTPUT)%,%,$@);=0A+	QUIET_MKDIR    =3D @echo '   ' =
MKDIR $(patsubst $(OUTPUT)%,%,$@);=0A+	QUIET_GEN      =3D @echo '   ' GEN =
$(patsubst $(OUTPUT)%,%,$@);=0A+	QUIET_FLEX     =3D @echo '   ' =
FLEX $(patsubst $(OUTPUT)%,%,$@);=0A+	QUIET_BISON    =3D @echo '   ' =
BISON $(patsubst $(OUTPUT)%,%,$@);=0A endif=0A endif=0A =0A@@ -733,39 =
+728,22 @@ shell_compatibility_test: please_set_SHE=0A strip: $(PROGRAMS) =
$(OUTPUT)perf=0A 	$(STRIP) $(STRIP_OPTS) $(PROGRAMS) $(OUTPUT)perf=0A=
 =0A-$(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS=0A=
-	$(QUIET_CC)$(CC) -DPERF_VERSION=3D'"$(PERF_VERSION)"' \=0A-		=
'-DPERF_HTML_PATH=3D"$(htmldir_SQ)"' \=0A-		$(ALL_CFLAGS) -c =
$(filter %.c,$^) -o $@=0A-=0A $(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS=
) $(PERFLIBS)=0A 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) =
$(OUTPUT)perf.o \=0A                $(BUILTIN_OBJS) $(LIBS) -o $@=0A =
=0A-$(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h =
$(OUTPUT)PERF-CFLAGS=0A-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) =
\=0A-		'-DPERF_HTML_PATH=3D"$(htmldir_SQ)"' \=0A-		=
'-DPERF_MAN_PATH=3D"$(mandir_SQ)"' \=0A-		'-DPERF_INFO_PATH=
=3D"$(infodir_SQ)"' $<=0A-=0A-$(OUTPUT)builtin-timechart.o: builtin-timecha=
rt.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS=0A-	$(QUIET_CC)$(CC) =
-o $@ -c $(ALL_CFLAGS) \=0A-		'-DPERF_HTML_PATH=3D"$(htmldir_SQ)"=
' \=0A-		'-DPERF_MAN_PATH=3D"$(mandir_SQ)"' \=0A-		=
'-DPERF_INFO_PATH=3D"$(infodir_SQ)"' $<=0A+$(OUTPUT)python/perf.so: =
$(PYRF_SRC) $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)=0A+	$(QUIET_GEN)CFLAGS=
=3D'$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \=0A+	  --$(if $(V),verbo=
se,quiet) build_ext; \=0A+	mkdir -p $(@D) && mv $(PYTHON_EXTBUILD_LIB)=
perf.so $(@D)/=0A =0A $(OUTPUT)common-cmds.h: util/generate-cmdlist.sh =
command-list.txt=0A =0A $(OUTPUT)common-cmds.h: $(wildcard Documentation/pe=
rf-*.txt)=0A 	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ =
$@=0A =0A-$(SCRIPTS) : % : %.sh=0A-	$(QUIET_GEN)$(INSTALL) '$@.sh' =
'$(OUTPUT)$@'=0A-=0A-# These can record PERF_VERSION=0A-$(OUTPUT)perf.o =
perf.spec \=0A-	$(SCRIPTS) \=0A-	: $(OUTPUT)PERF-VERSION-FILE=0A+$(S=
CRIPTS) : $(OUTPUT)% : %.sh=0A+	$(QUIET_GEN)$(INSTALL) '$<' '$@'=0A =0A =
.SUFFIXES:=0A .SUFFIXES: .o .c .S .s=0A@@ -790,42 +768,57 @@ $(OUTPUT)%.o: =
%.S=0A $(OUTPUT)%.s: %.S=0A 	$(QUIET_CC)$(CC) -o $@ -E $(ALL_CFLAGS) =
$<=0A =0A-$(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS=0A=
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \=0A-		'-DPERF_EXE=
C_PATH=3D"$(perfexecdir_SQ)"' \=0A-		'-DBINDIR=3D"$(bindir_relat=
ive_SQ)"' \=0A-		'-DPREFIX=3D"$(prefix_SQ)"' \=0A-		=
$<=0A+ifneq ($(OUTPUT),)=0A+PHONY_ALL  :=3D $(filter (OUTPUT)%,$(ALL_PROGRA=
MS) $(LANG_BINDINGS))=0A+PHONY_OBJS :=3D $(patsubst $(OUTPUT)%,%,$(BUILTIN_=
OBJS) $(LIB_OBJS))=0A+PHONY_ASMS :=3D $(patsubst %.o,%.s,$(PHONY_OBJS))=0A+=
PHONY_CPPS :=3D $(patsubst %.o,%.i,$(PHONY_OBJS))=0A+PHONY_ALL  +=3D =
$(PHONY_OBJS) $(PHONY_ASMS) $(PHONY_CPPS)=0A+.PHONY: $(PHONY_ALL)=0A+$(PHON=
Y_ALL): %: $(OUTPUT)%=0A+endif=0A+=0A+output =3D $(foreach ext,o i =
s,$(OUTPUT)$(1).$(ext))=0A+=0A+# These can record PERF_VERSION=0A+$(call =
output,perf) $(SCRIPTS): $(OUTPUT)PERF-VERSION-FILE=0A =0A-$(OUTPUT)util/co=
nfig.o: util/config.c $(OUTPUT)PERF-CFLAGS=0A-	$(QUIET_CC)$(CC) -o $@ -c =
$(ALL_CFLAGS) -DETC_PERFCONFIG=3D'"$(ETC_PERFCONFIG_SQ)"' $<=0A+$(call =
output,perf) $(call output,builtin-help): $(OUTPUT)common-cmds.h=0A =
=0A-$(OUTPUT)util/ui/browser.o: util/ui/browser.c $(OUTPUT)PERF-CFLAGS=0A-	=
$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<=0A+$(cal=
l output,perf): ALL_CFLAGS +=3D '-DPERF_VERSION=3D"$(PERF_VERSION)"' \=0A+	=
	'-DPERF_HTML_PATH=3D"$(htmldir_SQ)"'=0A =0A-$(OUTPUT)util/ui/browse=
rs/annotate.o: util/ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS=0A-	=
$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<=0A+$(cal=
l output,builtin-help) $(call output,builtin-timechart): ALL_CFLAGS +=3D =
\=0A+		'-DPERF_HTML_PATH=3D"$(htmldir_SQ)"' \=0A+		=
'-DPERF_MAN_PATH=3D"$(mandir_SQ)"' \=0A+		'-DPERF_INFO_PATH=
=3D"$(infodir_SQ)"'=0A+=0A+$(call output,util/exec_cmd): ALL_CFLAGS +=3D =
\=0A+		'-DPERF_EXEC_PATH=3D"$(perfexecdir_SQ)"' \=0A+		=
'-DBINDIR=3D"$(bindir_relative_SQ)"' \=0A+		'-DPREFIX=3D"$(pref=
ix_SQ)"'=0A =0A-$(OUTPUT)util/ui/browsers/hists.o: util/ui/browsers/hists.c=
 $(OUTPUT)PERF-CFLAGS=0A-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) =
-DENABLE_SLFUTURE_CONST $<=0A+$(call output,util/config) $(call output,util=
/rbtree): ALL_CFLAGS +=3D \=0A+		'-DETC_PERFCONFIG=3D"$(ETC_PERFCONF=
IG_SQ)"'=0A =0A-$(OUTPUT)util/ui/browsers/map.o: util/ui/browsers/map.c =
$(OUTPUT)PERF-CFLAGS=0A-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) =
-DENABLE_SLFUTURE_CONST $<=0A+$(call output,util/rbtree): ../../lib/rbtree.=
c=0A =0A-$(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS=0A=
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG=3D'"$(ETC_=
PERFCONFIG_SQ)"' $<=0A+$(call output,util/ui/browser) $(call output,util/ui=
/browsers/annotate) \=0A+	$(call output,util/ui/browsers/hists) =
\=0A+	$(call output,util/ui/browsers/map): ALL_CFLAGS +=3D \=0A+		=
-DENABLE_SLFUTURE_CONST=0A =0A-$(OUTPUT)util/scripting-engines/trace-event-=
perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS=0A-	=
$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant=
-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<=0A+$(cal=
l output,util/scripting-engines/trace-event-perl): ALL_CFLAGS +=3D \=0A+	=
$(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unuse=
d-parameter -Wno-shadow=0A =0A-$(OUTPUT)scripts/perl/Perf-Trace-Util/Contex=
t.o: scripts/perl/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS=0A-	=
$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant=
-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs =
$<=0A+$(call output,scripts/perl/Perf-Trace-Util/Context): ALL_CFLAGS +=3D =
\=0A+	$(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes =
-Wno-unused-parameter -Wno-nested-externs=0A =0A-$(OUTPUT)util/scripting-en=
gines/trace-event-python.o: util/scripting-engines/trace-event-python.c =
$(OUTPUT)PERF-CFLAGS=0A-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) =
$(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes =
-Wno-unused-parameter -Wno-shadow $<=0A+$(call output,util/scripting-engine=
s/trace-event-python): ALL_CFLAGS +=3D \=0A+	$(PYTHON_EMBED_CCOPTS) =
-Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter =
-Wno-shadow=0A =0A-$(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: =
scripts/python/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS=0A-	=
$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redunda=
nt-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs =
$<=0A+$(call output,scripts/python/Perf-Trace-Util/Context): ALL_CFLAGS =
+=3D \=0A+	$(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-pro=
totypes -Wno-unused-parameter -Wno-nested-externs=0A =0A $(OUTPUT)perf-%: =
%.o $(PERFLIBS)=0A 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(ALL_LDFLAG=
S) $(filter %.o,$^) $(LIBS)=0A--- /home/jbeulich/tmp/linux-3.4-rc6/tools/pe=
rf/util/rbtree.c	1970-01-01 01:00:00.000000000 +0100=0A+++ =
3.4-rc6-perf-makefile-generalize/tools/perf/util/rbtree.c=0A@@ -0,0 +1 =
@@=0A+#include "../../../lib/rbtree.c"=0A
--=__Part2709CF8A.4__=--
