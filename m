Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab0HRTKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:10:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36509 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab0HRTKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:10:09 -0400
Date: Wed, 18 Aug 2010 16:09:59 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Bernd Petrovitsch <bernd@sysprog.at>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
Message-ID: <20100818190959.GI9410@ghostprotocols.net>
References: <20100817181835.GA21083@ghostprotocols.net>
 <20100818123713.1F02414C03B@msa103.auone-net.jp>
 <1282135224.1926.3936.camel@laptop>
 <20100818141611.GE9410@ghostprotocols.net>
 <1282141665.1926.4053.camel@laptop>
 <20100818165642.GF9410@ghostprotocols.net>
 <20100818170158.GG9410@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818170158.GG9410@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 18, 2010 at 02:01:58PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Wed, Aug 18, 2010 at 01:56:42PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Wed, Aug 18, 2010 at 04:27:45PM +0200, Peter Zijlstra escreveu:
> > > On Wed, 2010-08-18 at 11:16 -0300, Arnaldo Carvalho de Melo wrote:
> > > > rm -rf ~/build
> > > > make O=~/build
> > > > 
> > > > and have everything work? Saving some keystrokes 8)
> > > 
> > > The turn side is that if you typo the output dir you'll probably not
> > > ever find it again.. and you could have typed: rm -rf ~/build/* instead.
> > 
> > Not something I'll argue too much :)

Ok, here it is, stolen directly from the toplevel kernel Makefile, will push to
Ingo today:

[acme@emilia linux-2.6-tip]$ rm -rf ~/git/build/perf
[acme@emilia linux-2.6-tip]$ make -j9 O=~/git/build/perf -C tools/perf
/bin/sh: line 0: cd: /home/acme/git/build/perf/: No such file or directory
make: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
Makefile:12: *** output directory "/home/acme/git/build/perf/" does not exist.  Stop.
make: Leaving directory `/home/acme/git/linux-2.6-tip/tools/perf'
[acme@emilia linux-2.6-tip]$ mkdir ~/git/build/perf 
[acme@emilia linux-2.6-tip]$ make -j9 O=~/git/build/perf -C tools/perf
make: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
    MKDIR /home/acme/git/build/perf/bench
<SNIP>
PERF_VERSION = 2.6.36.rc1.2.g033a273.dirty
make: Leaving directory `/home/acme/git/linux-2.6-tip/tools/perf'
make: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
    GEN /home/acme/git/build/perf/common-cmds.h
    * new build flags or prefix
    GEN perf-archive
    CC /home/acme/git/build/perf/builtin-annotate.o
<SNIP>
    AR /home/acme/git/build/perf/libperf.a
    LINK /home/acme/git/build/perf/perf
make: Leaving directory `/home/acme/git/linux-2.6-tip/tools/perf'
[acme@emilia linux-2.6-tip]$

- Arnaldo

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index dcb9700..4f1fa77 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -5,6 +5,12 @@ endif
 # The default target of this Makefile is...
 all::
 
+ifneq ($(OUTPUT),)
+# check that the output directory actually exists
+OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
+$(if $(OUTDIR),, $(error output directory "$(OUTPUT)" does not exist))
+endif
+
 # Define V=1 to have a more verbose compile.
 # Define V=2 to have an even more verbose compile.
 #
@@ -931,15 +937,15 @@ $(OUTPUT)common-cmds.h: $(wildcard Documentation/perf-*.txt)
 	$(QUIET_GEN). util/generate-cmdlist.sh > $@+ && mv $@+ $@
 
 $(patsubst %.sh,%,$(SCRIPT_SH)) : % : %.sh
-	$(QUIET_GEN)$(RM) $@ $@+ && \
+	$(QUIET_GEN)$(RM) $(OUTPUT)$@ $(OUTPUT)$@+ && \
 	sed -e '1s|#!.*/sh|#!$(SHELL_PATH_SQ)|' \
 	    -e 's|@SHELL_PATH@|$(SHELL_PATH_SQ)|' \
 	    -e 's|@@PERL@@|$(PERL_PATH_SQ)|g' \
 	    -e 's/@@PERF_VERSION@@/$(PERF_VERSION)/g' \
 	    -e 's/@@NO_CURL@@/$(NO_CURL)/g' \
-	    $@.sh >$@+ && \
-	chmod +x $@+ && \
-	mv $@+ $(OUTPUT)$@
+	    $@.sh > $(OUTPUT)$@+ && \
+	chmod +x $(OUTPUT)$@+ && \
+	mv $(OUTPUT)$@+ $(OUTPUT)$@
 
 configure: configure.ac
 	$(QUIET_GEN)$(RM) $@ $<+ && \
diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
index ddb68e6..7a7b608 100644
--- a/tools/perf/feature-tests.mak
+++ b/tools/perf/feature-tests.mak
@@ -113,7 +113,7 @@ endef
 # try-cc
 # Usage: option = $(call try-cc, source-to-build, cc-options)
 try-cc = $(shell sh -c						  \
-	'TMP="$(TMPOUT).$$$$";			 		  \
+	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
 	 echo "$(1)" |						  \
 	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
 	 rm -f "$$TMP"')
