Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934398Ab2DLPXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:23:11 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:50127 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933900Ab2DLPXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:23:09 -0400
Date: Thu, 12 Apr 2012 17:22:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 5/5] tools: Connect to the kernel build system
Message-ID: <20120412152256.GH24549@aftab>
References: <1334162178-17152-1-git-send-email-bp@amd64.org>
 <1334162178-17152-6-git-send-email-bp@amd64.org>
 <20120411180434.GH16257@infradead.org>
 <20120411180837.GJ16257@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411180837.GJ16257@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 03:08:37PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Apr 11, 2012 at 03:04:34PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Wed, Apr 11, 2012 at 06:36:18PM +0200, Borislav Petkov escreveu:
> > > From: Borislav Petkov <borislav.petkov@amd.com>
> > > 
> > > Now you can do
> > > 
> > > $ make tools/<toolname>
> > > 
> > > from the toplevel kernel directory and have the respective tool built.
> > > 
> > > If you want to build and install it, do
> > > 
> > > $ make tools/<toolname>_install
> > 
> > [acme@sandy linux]$ make -j8 O=/home/git/build/perf tools/perf_install
> > [acme@sandy linux]$ ls -la tools/perf/*.o | wc -l
> > 22
> > 
> > It should have honoured O=
> > 
> > Can you fix this one please? :)
> 
> But that can be on top of this series as the way I use it:

How about the patch below? Sam, it touches the toplevel Makefile because
it needs to not set KBUILD_OUTPUT when we're building tools/* targets.
Pls, let me know if this is ok?

Thanks.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 12 Apr 2012 17:18:10 +0200
Subject: [PATCH] tools, Makefile: Fix O= building

Make sure

$ make O=/tmp/somedir tools/perf

works with the current toplevel Makefile integration.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 Makefile                       |    9 +++++++--
 tools/scripts/Makefile.include |   18 +++++++++++++++---
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 23b9ce5a2c2c..2cb2ee2dc6ae 100644
--- a/Makefile
+++ b/Makefile
@@ -98,8 +98,13 @@ ifeq ($(KBUILD_SRC),)
 
 # OK, Make called in directory where kernel src resides
 # Do we want to locate output files in a separate directory?
+#
+# Also, we don't want to set KBUILD_OUTPUT if we're building stuff
+# in tools/
 ifeq ("$(origin O)", "command line")
-  KBUILD_OUTPUT := $(O)
+  ifneq ($(findstring tools/,$(MAKECMDGOALS)),tools/)
+    KBUILD_OUTPUT := $(O)
+  endif
 endif
 
 ifeq ("$(origin W)", "command line")
@@ -1473,7 +1478,7 @@ tools/: FORCE
 	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/
 
 tools/%: FORCE
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/ $*
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(O) -C $(src)/tools/ $*
 
 # Single targets
 # ---------------------------------------------------------------------------
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 87b55a729a5f..297b51d8e4be 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -38,11 +38,18 @@ else
 NO_SUBDIR = :
 endif
 
-QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
-QUIET_SUBDIR1  =
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
-ifndef V
+ifdef V
+	QUIET_SUBDIR0  = +$(MAKE)
+	QUIET_SUBDIR1  =
+
+	ifdef O
+	  QUIET_SUBDIR0 += O=$(O)
+	endif
+
+	QUIET_SUBDIR0 += -C # space to separate -C and subdir
+else
 	QUIET_CC       = @echo '   ' CC $@;
 	QUIET_AR       = @echo '   ' AR $@;
 	QUIET_LINK     = @echo '   ' LINK $@;
@@ -51,6 +58,11 @@ ifndef V
 	QUIET_SUBDIR0  = +@subdir=
 	QUIET_SUBDIR1  = ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
 			 $(MAKE) $(PRINT_DIR) -C $$subdir
+
+	ifdef O
+	  QUIET_SUBDIR1 += O=$(O)
+	endif
+
 	QUIET_FLEX     = @echo '   ' FLEX $@;
 	QUIET_BISON    = @echo '   ' BISON $@;
 endif
-- 
1.7.9.3.362.g71319


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
