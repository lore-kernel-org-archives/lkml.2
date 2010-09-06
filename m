Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0IFLst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 07:48:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:39538 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab0IFLsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 07:48:47 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] kbuild: Really don't clean bounds.h and asm-offsets.h
Date: Mon,  6 Sep 2010 13:48:14 +0200
Message-Id: <1283773696-3911-2-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283773696-3911-1-git-send-email-mmarek@suse.cz>
References: <1283773696-3911-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7d3cc8b tried to keep bounds.h and asm-offsets.h during make
clean by filtering these out of $(clean-files), but they are listed in
$(targets) and $(always) and thus removed automatically. Introduce a new
$(no-clean-files) variable to really skip such files in Makefile.clean.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Documentation/kbuild/makefiles.txt |    7 +++++++
 Kbuild                             |    4 ++--
 scripts/Makefile.clean             |    2 ++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 0135155..fcd1a98 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -779,6 +779,13 @@ This will delete the directory debian, including all subdirectories.
 Kbuild will assume the directories to be in the same relative path as the
 Makefile if no absolute path is specified (path does not start with '/').
 
+To exclude certain files from make clean, use the $(no-clean-files) variable.
+This is only a special case used in the top level Kbuild file:
+
+	Example:
+		#Kbuild
+		no-clean-files := $(bounds-file) $(offsets-file)
+
 Usually kbuild descends down in subdirectories due to "obj-* := dir/",
 but in the architecture makefiles where the kbuild infrastructure
 is not sufficient this sometimes needs to be explicit.
diff --git a/Kbuild b/Kbuild
index e3737ad..18a8bfb 100644
--- a/Kbuild
+++ b/Kbuild
@@ -94,5 +94,5 @@ PHONY += missing-syscalls
 missing-syscalls: scripts/checksyscalls.sh FORCE
 	$(call cmd,syscalls)
 
-# Delete all targets during make clean
-clean-files := $(addprefix $(objtree)/,$(filter-out $(bounds-file) $(offsets-file),$(targets)))
+# Keep these two files during make clean
+no-clean-files := $(bounds-file) $(offsets-file)
diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
index 6f89fbb..686cb0d 100644
--- a/scripts/Makefile.clean
+++ b/scripts/Makefile.clean
@@ -45,6 +45,8 @@ __clean-files	:= $(extra-y) $(always)                  \
 		   $(host-progs)                         \
 		   $(hostprogs-y) $(hostprogs-m) $(hostprogs-)
 
+__clean-files   := $(filter-out $(no-clean-files), $(__clean-files))
+
 # as clean-files is given relative to the current directory, this adds
 # a $(obj) prefix, except for absolute paths
 
-- 
1.7.1

