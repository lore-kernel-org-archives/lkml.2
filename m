Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719Ab2J2LXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:23:21 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47318 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758683Ab2J2LXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:23:19 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] kbuild: Do not remove vmlinux when cleaning external module
Date: Mon, 29 Oct 2012 11:23:02 +0000
Message-Id: <1351509782-12462-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.7.10.4
X-OriginalArrivalTime: 29 Oct 2012 11:23:15.0677 (UTC) FILETIME=[CA0FE0D0:01CDB5C7]
X-MC-Unique: 112102911231704901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9TBNNqp004204

Since commit 1f2bfbd00e466ff3489b2ca5cc75b1cccd14c123 "kbuild:
link of vmlinux moved to a script" make clean with M=<dir>
argument (so cleaning external module) removes vmlinux,
System.map and couple of other files from the *main* kernel
build directory! This not what was happening before and almost
certainly not what one would expect.

This patch moves makes the clean target of the script called
only when !KBUILD_EXTMOD.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 Makefile |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 5be2ee8..fa16e12 100644
--- a/Makefile
+++ b/Makefile
@@ -1008,11 +1008,14 @@ clean: rm-dirs  := $(CLEAN_DIRS)
 clean: rm-files := $(CLEAN_FILES)
 clean-dirs      := $(addprefix _clean_, . $(vmlinux-alldirs) Documentation samples)
 
-PHONY += $(clean-dirs) clean archclean
+PHONY += $(clean-dirs) clean archclean vmlinuxclean
 $(clean-dirs):
 	$(Q)$(MAKE) $(clean)=$(patsubst _clean_%,%,$@)
 
-clean: archclean
+vmlinuxclean:
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
+
+clean: archclean vmlinuxclean
 
 # mrproper - Delete all generated files, including .config
 #
@@ -1239,7 +1242,6 @@ scripts: ;
 endif # KBUILD_EXTMOD
 
 clean: $(clean-dirs)
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
 	$(call cmd,rmdirs)
 	$(call cmd,rmfiles)
 	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
-- 
1.7.10.4


