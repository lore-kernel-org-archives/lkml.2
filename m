Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964957Ab2JXTle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:41:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:39128 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab2JXTlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:41:31 -0400
Date: Wed, 24 Oct 2012 12:41:17 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Build install-man target when installing
Message-ID: <20121024194117.GE13993@ghostprotocols.net>
References: <20120925174658.GD9320@aftab.osrc.amd.com>
 <1348854427-12746-1-git-send-email-bp@amd64.org>
 <20121020111625.GB17563@liondog.tnic>
 <87mwzfj7dn.fsf@sejong.aot.lge.com>
 <20121022100719.GA8352@liondog.tnic>
 <20121022140339.GA8775@ghostprotocols.net>
 <20121022231301.GA13994@liondog.tnic>
 <20121023133951.GA11351@ghostprotocols.net>
 <20121024170316.GA13993@ghostprotocols.net>
 <20121024193046.GB17945@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024193046.GB17945@liondog.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 24, 2012 at 09:30:46PM +0200, Borislav Petkov escreveu:
> On Wed, Oct 24, 2012 at 10:03:16AM -0700, Arnaldo Carvalho de Melo wrote:
> > The 'install-man' target will use your check-executable-or-error-out
> > stuff, but the main 'install' target will call just 'try-install-man',
> > that will not stop the build if there are missing tools to generate
> > the man pages.
> >
> > Installing just xmlto makes it ask just for asciidoc, install both and
> > it generates the man pages, please try to check if it works for you so
> > that I can have your Tested-by.
> 
> Ok, then this can be done even simpler, I went and simplified your
> version and we don't need that check-executable-or-error-out helper
> anymore, I'm including it below.
> 
> For it you can have my
> 
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> Tested-by: Borislav Petkov <bp@alien8.de>
> 
> Btw, I keep seeing those errors when building on your perf/core branch:

That is fixed in the perf/urgent one, I'm reworking my perf/core branch
on top of Ingo's tip/perf/core, that already merged tip/perf/urgent so
has that fix.

Testing your new version now, thanks!

- Arnaldo
 
> ...
>     FLEX util/pmu-flex.c
>     FLEX util/parse-events-flex.c
>     CC util/pmu-flex.o
>     CC util/pmu.o
>     CC util/parse-events.o
> gcc: error: python_ext_build/tmp//../../libtraceevent.a: No such file or directory
> error: command 'gcc' failed with exit status 1
> cp: cannot stat `python_ext_build/lib/perf.so': No such file or directory
> make: *** [python/perf.so] Error 1
> make: *** Waiting for unfinished jobs....
> Makefile:513: No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99
> Makefile:568: No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev
> Makefile:579: newt not found, disables TUI support. Please install newt-devel or libnewt-dev
>     SUBDIR ../lib/traceevent/
> 
> ...
> 
> Thanks.
> 
> ---
> diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
> index 9f2e44f2b17a..ef6d22e879eb 100644
> --- a/tools/perf/Documentation/Makefile
> +++ b/tools/perf/Documentation/Makefile
> @@ -1,3 +1,5 @@
> +include ../config/utilities.mak
> +
>  OUTPUT := ./
>  ifeq ("$(origin O)", "command line")
>    ifneq ($(O),)
> @@ -64,6 +66,7 @@ MAKEINFO=makeinfo
>  INSTALL_INFO=install-info
>  DOCBOOK2X_TEXI=docbook2x-texi
>  DBLATEX=dblatex
> +XMLTO=xmlto
>  ifndef PERL_PATH
>  	PERL_PATH = /usr/bin/perl
>  endif
> @@ -71,6 +74,16 @@ endif
>  -include ../config.mak.autogen
>  -include ../config.mak
>  
> +_tmp_tool_path := $(call get-executable,$(ASCIIDOC))
> +ifeq ($(_tmp_tool_path),)
> +	missing_tools = $(ASCIIDOC)
> +endif
> +
> +_tmp_tool_path := $(call get-executable,$(XMLTO))
> +ifeq ($(_tmp_tool_path),)
> +	missing_tools += $(XMLTO)
> +endif
> +
>  #
>  # For asciidoc ...
>  #	-7.1.2,	no extra settings are needed.
> @@ -170,7 +183,12 @@ pdf: $(OUTPUT)user-manual.pdf
>  
>  install: install-man
>  
> -install-man: man
> +check-man-tools:
> +ifdef missing_tools
> +	$(error "You need to install $(missing_tools) for man pages")
> +endif
> +
> +do-install-man: man
>  	$(INSTALL) -d -m 755 $(DESTDIR)$(man1dir)
>  #	$(INSTALL) -d -m 755 $(DESTDIR)$(man5dir)
>  #	$(INSTALL) -d -m 755 $(DESTDIR)$(man7dir)
> @@ -178,6 +196,15 @@ install-man: man
>  #	$(INSTALL) -m 644 $(DOC_MAN5) $(DESTDIR)$(man5dir)
>  #	$(INSTALL) -m 644 $(DOC_MAN7) $(DESTDIR)$(man7dir)
>  
> +install-man: check-man-tools man
> +
> +try-install-man:
> +ifdef missing_tools
> +	$(warning Please install $(missing_tools) to have the man pages installed)
> +else
> +	$(MAKE) do-install-man
> +endif
> +
>  install-info: info
>  	$(INSTALL) -d -m 755 $(DESTDIR)$(infodir)
>  	$(INSTALL) -m 644 $(OUTPUT)perf.info $(OUTPUT)perfman.info $(DESTDIR)$(infodir)
> @@ -246,7 +273,7 @@ $(MAN_HTML): $(OUTPUT)%.html : %.txt
>  
>  $(OUTPUT)%.1 $(OUTPUT)%.5 $(OUTPUT)%.7 : $(OUTPUT)%.xml
>  	$(QUIET_XMLTO)$(RM) $@ && \
> -	xmlto -o $(OUTPUT) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
> +	$(XMLTO) -o $(OUTPUT) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
>  
>  $(OUTPUT)%.xml : %.txt
>  	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 76190a7e2934..3252563bfca7 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -1038,7 +1038,7 @@ perfexec_instdir = $(prefix)/$(perfexecdir)
>  endif
>  perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
>  
> -install: all install-man
> +install: all try-install-man
>  	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
>  	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
>  	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
> @@ -1064,6 +1064,9 @@ install-doc:
>  install-man:
>  	$(MAKE) -C Documentation install-man
>  
> +try-install-man:
> +	$(MAKE) -C Documentation try-install-man
> +
>  install-html:
>  	$(MAKE) -C Documentation install-html
>  
> 
> -- 
> Regards/Gruss,
>     Boris.
