Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab1E3Ovb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:51:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214Ab1E3OvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:51:12 -0400
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] kbuild: Hack for depmod not handling X.Y versions
Date: Mon, 30 May 2011 16:50:52 +0200
Message-Id: <1306767052-15593-5-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306767052-15593-1-git-send-email-mmarek@suse.cz>
References: <1306767052-15593-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

depmod checks if the argument starts with <num>.<num>.<num>. Until
depmod is fixed, we cheat with a symlink.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 130e282..0d8d05e 100644
--- a/Makefile
+++ b/Makefile
@@ -1533,9 +1533,19 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files))
 quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
       cmd_depmod = \
 	if [ -r System.map -a -x $(DEPMOD) ]; then                              \
+		if test -z "$(SUBLEVEL)"; then					\
+			version=99.$(KERNELRELEASE);				\
+			ln -s $(KERNELRELEASE) 					\
+				$(INSTALL_MOD_PATH)/lib/modules/$$version;	\
+		else								\
+			version=$(KERNELRELEASE);				\
+		fi;								\
 		$(DEPMOD) -ae -F System.map                                     \
 		$(if $(strip $(INSTALL_MOD_PATH)), -b $(INSTALL_MOD_PATH) )     \
-		$(KERNELRELEASE);                                               \
+		$$version;                                               	\
+		ret=$$?;							\
+		rm -f $(INSTALL_MOD_PATH)/lib/modules/99.$(KERNELRELEASE);	\
+		exit $$ret;							\
 	fi
 
 # Create temporary dir for module support files
-- 
1.7.4.1

