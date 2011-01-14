Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab1ANOoC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:44:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab1ANOn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:43:56 -0500
Date: Fri, 14 Jan 2011 15:43:54 +0100
From: Michal Marek <mmarek@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
Subject: Re: [PATCH 1/2] kbuild: asm-generic support
Message-ID: <20110114144354.GA23611@sepie.suse.cz>
References: <20110108130302.GA21698@merkur.ravnborg.org>
 <20110109192707.GA12387@merkur.ravnborg.org>
 <20110109192907.GA12403@merkur.ravnborg.org>
 <4D2F24CD.5040101@suse.cz>
 <20110113170131.GA28377@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110113170131.GA28377@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 06:01:31PM +0100, Sam Ravnborg wrote:
> On Thu, Jan 13, 2011 at 05:14:05PM +0100, Michal Marek wrote:
> > On 9.1.2011 20:29, Sam Ravnborg wrote:
> > > diff --git a/scripts/asm-generic.sh b/scripts/asm-generic.sh
> > > new file mode 100644
> > > index 0000000..d28127f
> > > --- /dev/null
> > > +++ b/scripts/asm-generic.sh
> > > @@ -0,0 +1,33 @@
> > > +#!/bin/sh
> > > +#
> > > +# include/asm-generic contains a lot of files that are used
> > > +# verbatim by several architectures.
> > > +#
> > > +# This scripts read the file arch/$(ARCH)/include/asm/Kbuild
> > > +# and for each file listed in this file with generic-y create
> > > +# a small wrapper file in arch/$(ARCH)/include/generated/
> > > +
> > > +# read list of header files form Kbuild
> > > +# The file has make syntax which looks like this:
> > > +#
> > > +# generic-y += <filename>
> > > +
> > > +srcdir=${srctree}/arch/$1/include/asm
> > > +gendir=arch/$1/include/generated/asm
> > > +
> > > +# Read the list of files (note that the list uses make syntax)
> > > +files=$( cat ${srcdir}/Kbuild | \
> > > +          grep -v ^# | grep generic-y | cut -d '=' -f 2)
> > 
> > Now that the list of required generic headers is in a Kbuild file, it
> > would be better to let make parse it, instead of enforcing one way to
> > construct the list (it is the preferred way, but C files that do not
> > conform to Documentation/CodingStyle are not rejected by the compiler
> > either). I will post a patch when I'm back online in the evening.
> Would be great!
> 
> Guan also pointed out a less than minor issue...
> I overwrite the files each time so that I force a rebuild.

Hi,

this should do the trick (the deletion of scripts/asm-generic.sh is left
out for brevity). I initially wanted to use this also from
Makefile.headersinst, but there we only want to export headers listed in
header-y, so I gave up on this idea.

Michal

diff --git a/Makefile b/Makefile
index 5a29426..6ede051 100644
--- a/Makefile
+++ b/Makefile
@@ -416,7 +416,7 @@ endif
 # Support for using generic headers in asm-generic
 PHONY += asm-generic
 asm-generic:
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/asm-generic.sh $(SRCARCH)
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.asm-generic obj=arch/$(SRCARCH)/include/generated/asm
 
 # To make sure we do not include .config for any of the *config targets
 # catch them early, and hand them over to scripts/kconfig/Makefile
diff --git a/scripts/Makefile.asm-generic b/scripts/Makefile.asm-generic
new file mode 100644
index 0000000..b4f2547
--- /dev/null
+++ b/scripts/Makefile.asm-generic
@@ -0,0 +1,26 @@
+# include/asm-generic contains a lot of files that are used
+# verbatim by several architectures.
+#
+# This Makefile reads the file arch/$(SRCARCH)/include/asm/Kbuild
+# and for each file listed in this file with generic-y creates
+# a small wrapper file in $(obj) (arch/$(SRCARCH)/include/generated/asm)
+
+kbuild-file := $(srctree)/arch/$(SRCARCH)/include/asm/Kbuild
+include $(kbuild-file)
+
+include scripts/Kbuild.include
+
+
+ifneq ($(KBUILD_SRC),)
+# Create output directory if not already present
+_dummy := $(shell [ -d $(obj) ] || mkdir -p $(obj))
+endif
+
+quiet_cmd_wrap = WRAP    $@
+cmd_wrap = echo "\#include <asm-generic/$*.h>" >$@
+
+all: $(patsubst %, $(obj)/%, $(generic-y))
+
+$(obj)/%.h:
+	$(call cmd,wrap)
+

