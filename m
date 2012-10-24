Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935196Ab2JXRDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:03:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:36658 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab2JXRD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:03:28 -0400
Date: Wed, 24 Oct 2012 10:03:16 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Build install-man target when installing
Message-ID: <20121024170316.GA13993@ghostprotocols.net>
References: <20120925174658.GD9320@aftab.osrc.amd.com>
 <1348854427-12746-1-git-send-email-bp@amd64.org>
 <20121020111625.GB17563@liondog.tnic>
 <87mwzfj7dn.fsf@sejong.aot.lge.com>
 <20121022100719.GA8352@liondog.tnic>
 <20121022140339.GA8775@ghostprotocols.net>
 <20121022231301.GA13994@liondog.tnic>
 <20121023133951.GA11351@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20121023133951.GA11351@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Tue, Oct 23, 2012 at 06:39:51AM -0700, Arnaldo Carvalho de Melo escreveu:
> > Ok, how's that: we check the presence of executables on the system and
> > error out if not in the path. I found some helpful make functions in
> > config/utilities.mak and decided to reuse them because I'm lazy :)

> Better now:

> Makefile:177: *** asciidoc not found, please install it on your distro.
> Stop.
> make[1]: Leaving directory `/home/git/linux/tools/perf/Documentation'
> make: *** [install-man] Error 2
> make: Leaving directory `/home/git/linux/tools/perf'
> [acme@sandy linux]$ 

> But it shouldn't stop the build, just warn the user that Documentation
> is not going to be installed. It should error like that if 'make
> install-man' is called.

> Trying to do that now.

[acme@sandy linux]$ make -j8 -C tools/perf/ O=/home/acme/git/build/perf try-install-man
make: Entering directory `/home/git/linux/tools/perf'
make -C Documentation try-install-man
make[1]: Entering directory `/home/git/linux/tools/perf/Documentation'
make[2]: Entering directory `/home/git/linux/tools/perf'
make[2]: `/home/acme/git/build/perf/PERF-VERSION-FILE' is up to date.
make[2]: Leaving directory `/home/git/linux/tools/perf'
Makefile:202: Please install the asciidoc package to have the man pages installed
Makefile:202: Please install the xmlto package to have the man pages installed
make[1]: `try-install-man' is up to date.
make[1]: Leaving directory `/home/git/linux/tools/perf/Documentation'
make: Leaving directory `/home/git/linux/tools/perf'
[acme@sandy linux]$

The 'install-man' target will use your check-executable-or-error-out
stuff, but the main 'install' target will call just 'try-install-man',
that will not stop the build if there are missing tools to generate the
man pages.

Installing just xmlto makes it ask just for asciidoc, install both and it
generates the man pages, please try to check if it works for you so that I can
have your Tested-by.

- Arnaldo

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="has_xmlto.patch"

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index 9f2e44f..8cb65ea 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -1,3 +1,5 @@
+include ../config/utilities.mak
+
 OUTPUT := ./
 ifeq ("$(origin O)", "command line")
   ifneq ($(O),)
@@ -64,6 +66,7 @@ MAKEINFO=makeinfo
 INSTALL_INFO=install-info
 DOCBOOK2X_TEXI=docbook2x-texi
 DBLATEX=dblatex
+XMLTO=xmlto
 ifndef PERL_PATH
 	PERL_PATH = /usr/bin/perl
 endif
@@ -71,6 +74,15 @@ endif
 -include ../config.mak.autogen
 -include ../config.mak
 
+have_asciidoc := $(call get-executable,$(ASCIIDOC))
+have_xmlto := $(call get-executable,$(XMLTO))
+ifeq ($(have_asciidoc),)
+	missing_tools = true
+endif
+ifeq ($(have_xmlto),)
+	missing_tools = true
+endif
+
 #
 # For asciidoc ...
 #	-7.1.2,	no extra settings are needed.
@@ -170,7 +182,11 @@ pdf: $(OUTPUT)user-manual.pdf
 
 install: install-man
 
-install-man: man
+check-man-tools:
+	$(call check-executable-or-error-out,$(ASCIIDOC))
+	$(call check-executable-or-error-out,$(XMLTO))
+
+do-install-man: man
 	$(INSTALL) -d -m 755 $(DESTDIR)$(man1dir)
 #	$(INSTALL) -d -m 755 $(DESTDIR)$(man5dir)
 #	$(INSTALL) -d -m 755 $(DESTDIR)$(man7dir)
@@ -178,6 +194,20 @@ install-man: man
 #	$(INSTALL) -m 644 $(DOC_MAN5) $(DESTDIR)$(man5dir)
 #	$(INSTALL) -m 644 $(DOC_MAN7) $(DESTDIR)$(man7dir)
 
+install-man: check-man-tools man
+
+try-install-man:
+ifdef missing_tools
+ifeq ($(have_asciidoc),)
+	$(warning Please install the asciidoc package to have the man pages installed)
+endif
+ifeq ($(have_xmlto),)
+	$(warning Please install the xmlto package to have the man pages installed)
+endif
+else
+	$(MAKE) do-install-man
+endif
+
 install-info: info
 	$(INSTALL) -d -m 755 $(DESTDIR)$(infodir)
 	$(INSTALL) -m 644 $(OUTPUT)perf.info $(OUTPUT)perfman.info $(DESTDIR)$(infodir)
@@ -246,7 +276,7 @@ $(MAN_HTML): $(OUTPUT)%.html : %.txt
 
 $(OUTPUT)%.1 $(OUTPUT)%.5 $(OUTPUT)%.7 : $(OUTPUT)%.xml
 	$(QUIET_XMLTO)$(RM) $@ && \
-	xmlto -o $(OUTPUT) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
+	$(XMLTO) -o $(OUTPUT) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
 
 $(OUTPUT)%.xml : %.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 404fdb4..b14eeb8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -1041,7 +1041,7 @@ perfexec_instdir = $(prefix)/$(perfexecdir)
 endif
 perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
 
-install: all install-man
+install: all try-install-man
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
@@ -1067,6 +1067,9 @@ install-doc:
 install-man:
 	$(MAKE) -C Documentation install-man
 
+try-install-man:
+	$(MAKE) -C Documentation try-install-man
+
 install-html:
 	$(MAKE) -C Documentation install-html
 
diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index ea853c2..42e264a 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -168,6 +168,8 @@ _is-executable-sh = $(call shell-sq,test -f $(1) -a -x $(1) && echo y)
 get-executable = $(if $(1),$(if $(is-absolute),$(_ge-abspath),$(lookup)))
 _ge-abspath = $(if $(is-executable),$(1))
 
+check-executable-or-error-out = $(if $(call get-executable,$(1)),,$(error $(1) not found, please install it on your distro))
+
 # get-supplied-or-default-executable
 #
 # Usage: absolute-executable-path-or-empty = $(call get-executable-or-default,variable,default)

--YiEDa0DAkWCtVeE4--
