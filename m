Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1BBHI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 02:08:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:49354 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab1BBHI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 02:08:26 -0500
Date: Wed, 2 Feb 2011 07:08:03 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Don't try to build python bindings if Python.h not available
Message-ID: <tip-978f626c4e5b9524d1898788d8e34d86dfa00795@git.kernel.org>
Git-Commit-ID: 978f626c4e5b9524d1898788d8e34d86dfa00795
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 07:08:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  978f626c4e5b9524d1898788d8e34d86dfa00795
Gitweb:     http://git.kernel.org/tip/978f626c4e5b9524d1898788d8e34d86dfa00795
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 1 Feb 2011 16:40:51 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 1 Feb 2011 16:40:51 -0200

perf tools: Don't try to build python bindings if Python.h not available

Just leverage the test done for python support in 'python script',
emitting a warning about losing those features if python-dev[el] is not
installed.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 85f6549..4c9499c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -348,14 +348,14 @@ PROGRAMS += $(EXTRA_PROGRAMS)
 #
 PROGRAMS += $(OUTPUT)perf
 
-LANG_BINDINGS = $(OUTPUT)python/perf.so
+LANG_BINDINGS =
 
 # List built-in command $C whose implementation cmd_$C() is not in
 # builtin-$C.o but is linked in as part of some other command.
 #
 
 # what 'all' will build and 'install' will install, in perfexecdir
-ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS) $(LANG_BINDINGS)
+ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS)
 
 # what 'all' will build but not install in perfexecdir
 OTHER_PROGRAMS = $(OUTPUT)perf$X
@@ -664,12 +664,14 @@ else
 	PYTHON_EMBED_CCOPTS = `python-config --cflags 2>/dev/null`
 	FLAGS_PYTHON_EMBED=$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
 	ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
+		msg := $(warning No Python.h found, install python-dev[el] to have python support in 'perf script' and to build the python bindings)
 		BASIC_CFLAGS += -DNO_LIBPYTHON
 	else
                ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
                EXTLIBS += $(PYTHON_EMBED_LIBADD)
 		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
 		LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
+		LANG_BINDINGS += $(OUTPUT)python/perf.so
 	endif
 endif
 
@@ -956,7 +958,7 @@ export TAR INSTALL DESTDIR SHELL_PATH
 
 SHELL = $(SHELL_PATH)
 
-all:: shell_compatibility_test $(ALL_PROGRAMS) $(BUILT_INS) $(OTHER_PROGRAMS) $(OUTPUT)PERF-BUILD-OPTIONS
+all:: shell_compatibility_test $(ALL_PROGRAMS) $(LANG_BINDINGS) $(BUILT_INS) $(OTHER_PROGRAMS) $(OUTPUT)PERF-BUILD-OPTIONS
 ifneq (,$X)
 	$(foreach p,$(patsubst %$X,%,$(filter %$X,$(ALL_PROGRAMS) $(BUILT_INS) perf$X)), test '$p' -ef '$p$X' || $(RM) '$p';)
 endif
