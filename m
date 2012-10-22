Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab2JVXNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 19:13:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48714 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab2JVXNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 19:13:06 -0400
Date: Tue, 23 Oct 2012 01:13:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Build install-man target when installing
Message-ID: <20121022231301.GA13994@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120925174658.GD9320@aftab.osrc.amd.com>
 <1348854427-12746-1-git-send-email-bp@amd64.org>
 <20121020111625.GB17563@liondog.tnic>
 <87mwzfj7dn.fsf@sejong.aot.lge.com>
 <20121022100719.GA8352@liondog.tnic>
 <20121022140339.GA8775@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121022140339.GA8775@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 07:03:39AM -0700, Arnaldo Carvalho de Melo wrote:
> Em Mon, Oct 22, 2012 at 12:07:19PM +0200, Borislav Petkov escreveu:
> > On Mon, Oct 22, 2012 at 04:25:24PM +0900, Namhyung Kim wrote:
> > > It will add additional dependencies of asciidoc, docbook-xsl and/or
> > > something to default perf install command. I don't know it matters
> > > much, but just wanted to say. What if a user want to install the perf
> > > but the required packages for documents are not installed?
>  
> > Ok, this is a valid point, more or less.
> 
> Yes, its a valid point, to address it I think we should just do as we
> with other features, like, say, when python-devel is not installed warn
> the user that python support won't be included, i.e. if asciidoc, etc
> are not installed, tell the user that documentation will not be
> installed, install package A, B and C to have documentation installed.

Ok, how's that: we check the presence of executables on the system and
error out if not in the path. I found some helpful make functions in
config/utilities.mak and decided to reuse them because I'm lazy :)

--
diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index 9f2e44f2b17a..a2bfd6e3cce4 100644
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
@@ -170,7 +173,11 @@ pdf: $(OUTPUT)user-manual.pdf
 
 install: install-man
 
-install-man: man
+check-man-tools:
+	$(call check-executable-or-error-out,$(ASCIIDOC))
+	$(call check-executable-or-error-out,$(XMLTO))
+
+install-man: check-man-tools man
 	$(INSTALL) -d -m 755 $(DESTDIR)$(man1dir)
 #	$(INSTALL) -d -m 755 $(DESTDIR)$(man5dir)
 #	$(INSTALL) -d -m 755 $(DESTDIR)$(man7dir)
@@ -246,7 +253,7 @@ $(MAN_HTML): $(OUTPUT)%.html : %.txt
 
 $(OUTPUT)%.1 $(OUTPUT)%.5 $(OUTPUT)%.7 : $(OUTPUT)%.xml
 	$(QUIET_XMLTO)$(RM) $@ && \
-	xmlto -o $(OUTPUT) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
+	$(XMLTO) -o $(OUTPUT) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
 
 $(OUTPUT)%.xml : %.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index 8046182a19eb..f8b5d713ff15 100644
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

-- 
Regards/Gruss,
    Boris.
