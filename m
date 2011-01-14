Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab1ANJ4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:56:33 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33431 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1ANJ4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:56:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=I5qUEHYzGvtty3gRJ4QcYmjxxE94YAAoeX3y8MpfEPJPSt9vyYluyB5TmM+ua+SnNu
         bnJpE1mfcOLBTjdNy0XjcVtqh81f+af7wW9VUjuKRMABrf88GMV2p9/NUyIWOnUOF3wL
         NIaf1m4DSsZZb3JKqOLMRhxxybNVvp2E2poPk=
MIME-Version: 1.0
Date: Fri, 14 Jan 2011 17:56:23 +0800
Message-ID: <AANLkTi=BPra1SJ3BHN0L1e6L9MKj3EJ0agjaA+m7CkGj@mail.gmail.com>
Subject: [PATCH] kbuild: add global tags generation (fixed signed-off-by)
From: Jianbin Kang <kjbmail@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild: add global tags generation

gnu global (http://www.gnu.org/software/global/) is a source code tagging system
It is really cheap to support it in kbuild system.

    Signed-off-by: Jianbin Kang <kjbmail@gmail.com>

diff --git a/Makefile b/Makefile
index 74b2555..127a371 100644
--- a/Makefile
+++ b/Makefile
@@ -420,7 +420,7 @@ endif
 # of make so .config is not included in this case either (for *config).

 no-dot-config-targets := clean mrproper distclean \
-			 cscope TAGS tags help %docs check% coccicheck \
+			 cscope gtags TAGS tags help %docs check% coccicheck \
 			 include/linux/version.h headers_% \
 			 kernelversion %src-pkg

@@ -1134,7 +1134,7 @@ CLEAN_FILES +=	vmlinux System.map \
 MRPROPER_DIRS  += include/config usr/include include/generated
 MRPROPER_FILES += .config .config.old .version .old_version             \
                   include/linux/version.h                               \
-		  Module.symvers tags TAGS cscope*
+		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS

 # clean - Delete most, but leave enough to build external modules
 #
@@ -1221,6 +1221,7 @@ help:
 	@echo  '  modules_prepare - Set up for building external modules'
 	@echo  '  tags/TAGS	  - Generate tags file for editors'
 	@echo  '  cscope	  - Generate cscope index'
+	@echo  '  gtags           - Generate global index'
 	@echo  '  kernelrelease	  - Output the release version string'
 	@echo  '  kernelversion	  - Output the version stored in Makefile'
 	@echo  '  headers_install - Install sanitised kernel headers to
INSTALL_HDR_PATH'; \
@@ -1379,7 +1380,7 @@ clean: $(clean-dirs)
 quiet_cmd_tags = GEN     $@
       cmd_tags = $(CONFIG_SHELL) $(srctree)/scripts/tags.sh $@

-tags TAGS cscope: FORCE
+tags TAGS cscope gtags: FORCE
 	$(call cmd,tags)

 # Scripts to check various things for consistency
diff --git a/scripts/tags.sh b/scripts/tags.sh
index bbbe584..0a64ea4 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -114,6 +114,11 @@ docscope()
 	cscope -b -f cscope.out
 }

+dogtags()
+{
+	all_sources | gtags -f -
+}
+
 exuberant()
 {
 	all_sources | xargs $1 -a                               \
@@ -187,6 +192,10 @@ case "$1" in
 		docscope
 		;;

+	"gtags")
+		dogtags
+		;;
+
 	"tags")
 		rm -f tags
 		xtags ctags
