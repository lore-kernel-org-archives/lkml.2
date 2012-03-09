Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab2CIWCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:02:15 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46158 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534Ab2CIWCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:02:09 -0500
From: Alan Ott <alan@signal11.us>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH 1/2] Makefile: Add INSTALL_MOD_PATH to the environment used by depmod
Date: Fri,  9 Mar 2012 17:02:02 -0500
Message-Id: <1331330522-15129-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add INSTALL_MOD_PATH explicitly to the environment given to depmod.  This
way putting an INSTALL_MOD_PATH line into a GNUmakefile (along with things
like CROSS_COMPILE) will work properly.

Signed-off-by: Alan Ott <alan@signal11.us>
---

It seems to be a common practice to put make variables into a file named
GNUmakefile in the top level of the kernel tree (and then include the normal
Makefile[1] from GNUmakefile).  These are typically variables needed for a
cross-compiling environment (such as ARCH and CROSS_COMPILE).  The idea
is that when make is invoked, GNUmakefile will be read first and thus
able to set up the environment without the user having to type:
	make ARCH=arm CROSS_COMPILE=arm-linux-
every single time they want to make a build.

INSTALL_MOD_PATH doesn't work when put into a GNUmakefile like this. The
difference is that when variables go on the command line like above, they
get put into the environment of the make process as environment variables,
which would then get passed to processes which make spawns (such as depmod),
since they're part of make's environment.  When they're put into the
GNUmakefile instead, they become make variables only, and not part of the
environment, and thus not automatically passed to spawned processes such as
depmod.

In the current implementation, if INSTALL_MOD_PATH is put into a
GNUmakefile, then when make modules_install is called, the modules are put
into the right place (because this operation relies on the make variable),
but depmod then can't find the modules (because it doesn't get
INSTALL_MOD_PATH put into its environment).

This patch explicitly adds INSTALL_MOD_PATH to the environment when the
depmod script gets started.

I fully realize that there may very well be a better way to fix this which
I'm not aware of.

Alan.

[1] For example, here's my GNUmakefile, which I put in the root of the
kernel tree:
	ARCH=arm
	INSTALL_MOD_PATH=/home/alan/work/rootfs
	CROSS_COMPILE=arm-linux-
	include Makefile
---
 Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 5f1739b..c9c9ac0 100644
--- a/Makefile
+++ b/Makefile
@@ -1525,7 +1525,8 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files))
 
 # Run depmod only if we have System.map and depmod is executable
 quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
-      cmd_depmod = $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh $(DEPMOD) \
+      cmd_depmod = INSTALL_MOD_PATH=$(INSTALL_MOD_PATH) $(CONFIG_SHELL) \
+                   $(srctree)/scripts/depmod.sh $(DEPMOD) \
                    $(KERNELRELEASE)
 
 # Create temporary dir for module support files
-- 
1.7.0.4

