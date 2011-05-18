Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab1ERSeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:34:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:44770 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933459Ab1ERSdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:33:54 -0400
Date: Wed, 18 May 2011 18:33:45 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-85356f802225fedeee8c3e65bdd93b263ace0a8b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, srostedt@redhat.com, mmarek@suse.cz,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        mmarek@suse.cz
In-Reply-To: <20110421023738.714956282@goodmis.org>
References: <20110421023738.714956282@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kbuild/recordmcount: Add RECORDMCOUNT_WARN to warn about mcount callers
Git-Commit-ID: 85356f802225fedeee8c3e65bdd93b263ace0a8b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 18:33:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85356f802225fedeee8c3e65bdd93b263ace0a8b
Gitweb:     http://git.kernel.org/tip/85356f802225fedeee8c3e65bdd93b263ace0a8b
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 12 Apr 2011 18:59:10 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 16 May 2011 14:45:03 -0400

kbuild/recordmcount: Add RECORDMCOUNT_WARN to warn about mcount callers

When mcount is called in a section that ftrace will not modify it into
a nop, we want to warn about this. But not warn about this always. Now
if the user builds the kernel with the option RECORDMCOUNT_WARN=1 then
the build will warn about mcount callers that are ignored and will just
waste execution time.

Acked-by: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Link: http://lkml.kernel.org/r/20110421023738.714956282@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Makefile               |    1 +
 scripts/Makefile.build |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 41ea6fb..e7d01ad 100644
--- a/Makefile
+++ b/Makefile
@@ -1268,6 +1268,7 @@ help:
 	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
 	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
 	@echo  '  make W=1   [targets] Enable extra gcc checks'
+	@echo  '  make RECORDMCOUNT_WARN=1 [targets] Warn about ignored mcount sections'
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5f925a..fdca952 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -244,13 +244,16 @@ endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
 ifdef BUILD_C_RECORDMCOUNT
+ifeq ("$(origin RECORDMCOUNT_WARN)", "command line")
+  RECORDMCOUNT_FLAGS = -w
+endif
 # Due to recursion, we must skip empty.o.
 # The empty.o file is created in the make process in order to determine
 #  the target endianness and word size. It is made before all other C
 #  files, including recordmcount.
 sub_cmd_record_mcount =					\
 	if [ $(@) != "scripts/mod/empty.o" ]; then	\
-		$(objtree)/scripts/recordmcount "$(@)";	\
+		$(objtree)/scripts/recordmcount $(RECORDMCOUNT_FLAGS) "$(@)";	\
 	fi;
 else
 sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
