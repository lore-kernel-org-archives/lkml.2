Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab0HXWs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:48:59 -0400
Received: from kroah.org ([198.145.64.141]:59778 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283Ab0HXWre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:47:34 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:18:20 2010
Message-Id: <20100824221820.237973928@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:16:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Paul Smith" <psmith@gnu.org>, Sam Ravnborg <sam@ravnborg.org>,
        Thomas Backlund <tmb@mandriva.org>
Subject: [2/8] kbuild: fix make incompatibility
In-Reply-To: <20100824224631.GA5458@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1668
Lines: 58

From: Sam Ravnborg <sam@ravnborg.org>

commit 31110ebbec8688c6e9597b641101afc94e1c762a upstream.

"Paul Smith" <psmith@gnu.org> reported that we would fail
to build with a new check that may be enabled in an
upcoming version of make.

The error was:

      Makefile:442: *** mixed implicit and normal rules.  Stop.

The problem is that we did stuff like this:

config %config: ...

The solution was simple - the above was split into two with identical
prerequisites and commands.
With only three lines it was not worth to try to avoid the duplication.

Cc: "Paul Smith" <psmith@gnu.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Backlund <tmb@mandriva.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Makefile |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -440,7 +440,11 @@ ifeq ($(config-targets),1)
 include $(srctree)/arch/$(SRCARCH)/Makefile
 export KBUILD_DEFCONFIG
 
-config %config: scripts_basic outputmakefile FORCE
+config: scripts_basic outputmakefile FORCE
+	$(Q)mkdir -p include/linux include/config
+	$(Q)$(MAKE) $(build)=scripts/kconfig $@
+
+%config: scripts_basic outputmakefile FORCE
 	$(Q)mkdir -p include/linux include/config
 	$(Q)$(MAKE) $(build)=scripts/kconfig $@
 
@@ -1602,7 +1606,11 @@ endif
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 
 # Modules
-/ %/: prepare scripts FORCE
+/: prepare scripts FORCE
+	$(cmd_crmodverdir)
+	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
+	$(build)=$(build-dir)
+%/: prepare scripts FORCE
 	$(cmd_crmodverdir)
 	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
 	$(build)=$(build-dir)


