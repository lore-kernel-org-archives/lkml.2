Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab1KQWhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:37:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:12670 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab1KQWhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:37:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="77077669"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org, kbuild@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 1/8] kbuild: Add support for installing generated asm headers
Date: Thu, 17 Nov 2011 14:37:19 -0800
Message-Id: <1321569446-20433-2-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Generated asm headers are supposed to live in
arch/*/include/generated/asm, but objhdr-y expect them to live in the
same directory they are generated in.  Instead of trying to cut that
particular Gordian knot, introduce genhdr-y that takes this into
account; the sole user of objhdr-y, linux/version.h, should be
migrated over at some later date.

Suggested-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: David Woodhouse <dwmw2@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 scripts/Makefile.headersinst |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index a57f5bd..d3bae5e 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -4,12 +4,16 @@
 # header-y  - list files to be installed. They are preprocessed
 #             to remove __KERNEL__ section of the file
 # objhdr-y  - Same as header-y but for generated files
+# genhdr-y  - Same as objhdr-y but in a generated/ directory
 #
 # ==========================================================================
 
 # called may set destination dir (when installing to asm/)
 _dst := $(if $(dst),$(dst),$(obj))
 
+# generated header directory
+gen := $(if $(gen),$(gen),$(subst include/,include/generated/,$(obj)))
+
 kbuild-file := $(srctree)/$(obj)/Kbuild
 include $(kbuild-file)
 
@@ -33,9 +37,10 @@ wrapper-files := $(filter $(header-y), $(generic-y))
 
 # all headers files for this dir
 header-y      := $(filter-out $(generic-y), $(header-y))
-all-files     := $(header-y) $(objhdr-y) $(wrapper-files)
+all-files     := $(header-y) $(objhdr-y) $(genhdr-y) $(wrapper-files)
 input-files   := $(addprefix $(srctree)/$(obj)/,$(header-y)) \
-                 $(addprefix $(objtree)/$(obj)/,$(objhdr-y))
+                 $(addprefix $(objtree)/$(obj)/,$(objhdr-y)) \
+                 $(addprefix $(objtree)/$(gen)/,$(genhdr-y))
 output-files  := $(addprefix $(install)/, $(all-files))
 
 # Work out what needs to be removed
@@ -52,6 +57,7 @@ quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files))\
       cmd_install = \
         $(PERL) $< $(srctree)/$(obj) $(install) $(SRCARCH) $(header-y); \
         $(PERL) $< $(objtree)/$(obj) $(install) $(SRCARCH) $(objhdr-y); \
+        $(PERL) $< $(objtree)/$(gen) $(install) $(SRCARCH) $(genhdr-y); \
         for F in $(wrapper-files); do                                   \
                 echo "\#include <asm-generic/$$F>" > $(install)/$$F;    \
         done;                                                           \
-- 
1.7.6.4

