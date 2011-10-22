Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1JVQXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 12:23:34 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:34739 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab1JVQXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 12:23:33 -0400
X-Greylist: delayed 3603 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Oct 2011 12:23:33 EDT
Date: Sat, 22 Oct 2011 11:19:22 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Subject: [PATCH] kbuild: don't use a symlink for update-po-config
Message-id: <alpine.LNX.2.00.1110221117380.59156@linux>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes update-po-config to not create a symlink in arch/um 
because this fails with make O= builds.
It also improves the V=0 output. 

  GEN     /usr/src/lto/work/Makefile
  GEN config
ln: failed to create symbolic link `arch/um/Kconfig': No such file or directory
make[3]: *** [update-po-config] Error 1
make[2]: *** [update-po-config] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/kconfig/Makefile |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 82d2eb2..1d99a08 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -74,9 +74,8 @@ localyesconfig: $(obj)/streamline_config.pl $(obj)/conf
 
 # Create new linux.pot file
 # Adjust charset to UTF-8 in .po file to accept UTF-8 in Kconfig files
-# The symlink is used to repair a deficiency in arch/um
 update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
-	$(Q)echo "  GEN config"
+	$(Q)echo "  GEN     config.pot"
 	$(Q)xgettext --default-domain=linux                         \
 	    --add-comments --keyword=_ --keyword=N_                 \
 	    --from-code=UTF-8                                       \
@@ -84,16 +83,16 @@ update-po-config: $(obj)/kxgettext $(obj)/gconf.glade.h
 	    --directory=$(srctree) --directory=$(objtree)           \
 	    --output $(obj)/config.pot
 	$(Q)sed -i s/CHARSET/UTF-8/ $(obj)/config.pot
-	$(Q)ln -fs Kconfig.x86 arch/um/Kconfig
-	$(Q)(for i in `ls $(srctree)/arch/*/Kconfig`;    \
+	$(Q)(for i in `ls $(srctree)/arch/*/Kconfig`     \
+			$(srctree)/arch/um/Kconfig.x86;  \
 	    do                                           \
-		echo "  GEN $$i";                        \
+		echo "  GEN     $$i";                    \
 		$(obj)/kxgettext $$i                     \
 		     >> $(obj)/config.pot;               \
 	    done )
+	$(Q)echo "  GEN     linux.pot"
 	$(Q)msguniq --sort-by-file --to-code=UTF-8 $(obj)/config.pot \
 	    --output $(obj)/linux.pot
-	$(Q)rm -f $(srctree)/arch/um/Kconfig
 	$(Q)rm -f $(obj)/config.pot
 
 PHONY += allnoconfig allyesconfig allmodconfig alldefconfig randconfig
-- 
1.7.7

