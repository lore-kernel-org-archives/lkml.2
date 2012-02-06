Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab2BFTDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:03:47 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40614 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2BFTDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:03:46 -0500
Date: Mon, 6 Feb 2012 17:03:37 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH Try #2] perf doc: allow producing documentation in a
 specified output directory
Message-ID: <20120206190337.GG30158@infradead.org>
References: <1328541443-18003-1-git-send-email-fbuihuu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328541443-18003-1-git-send-email-fbuihuu@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 06, 2012 at 04:17:23PM +0100, Franck Bui-Huu escreveu:
> Currently we can put the object files in a different directory by
> using 'O=' comand line argument.
> 
> However the generated documentation files don't honor this directive,
> 
> This patch fixes that. It's been tested for man target but the others
> seems currently broken so no tests have been done on them so far.

xml as well works for me, just had to install the xmlto package:

[acme@aninha linux]$ l ~/git/build/perf/*.xml | wc -l
25
[acme@aninha linux]$ l ~/git/build/perf/*.1 | wc -l
25
[acme@aninha linux]$ 

Thanks, applied.
 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> ---
> 
>  Hi,
> 
>  The previous version used to pass the command line argument 'O' down
>  to the doc sub makefile which was unneeded.
> 
>  Please consider.
> 
>  tools/perf/Documentation/Makefile |   86 ++++++++++++++++++++++--------------
>  1 files changed, 52 insertions(+), 34 deletions(-)
> 
> diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
> index 4626a39..ca600e0 100644
> --- a/tools/perf/Documentation/Makefile
> +++ b/tools/perf/Documentation/Makefile
> @@ -1,3 +1,10 @@
> +OUTPUT := ./
> +ifeq ("$(origin O)", "command line")
> +  ifneq ($(O),)
> +	OUTPUT := $(O)/
> +  endif
> +endif
> +
>  MAN1_TXT= \
>  	$(filter-out $(addsuffix .txt, $(ARTICLES) $(SP_ARTICLES)), \
>  		$(wildcard perf-*.txt)) \
> @@ -6,10 +13,11 @@ MAN5_TXT=
>  MAN7_TXT=
>  
>  MAN_TXT = $(MAN1_TXT) $(MAN5_TXT) $(MAN7_TXT)
> -MAN_XML=$(patsubst %.txt,%.xml,$(MAN_TXT))
> -MAN_HTML=$(patsubst %.txt,%.html,$(MAN_TXT))
> +_MAN_XML=$(patsubst %.txt,%.xml,$(MAN_TXT))
> +_MAN_HTML=$(patsubst %.txt,%.html,$(MAN_TXT))
>  
> -DOC_HTML=$(MAN_HTML)
> +MAN_XML=$(addprefix $(OUTPUT),$(_MAN_XML))
> +MAN_HTML=$(addprefix $(OUTPUT),$(_MAN_HTML))
>  
>  ARTICLES =
>  # with their own formatting rules.
> @@ -18,11 +26,17 @@ API_DOCS = $(patsubst %.txt,%,$(filter-out technical/api-index-skel.txt technica
>  SP_ARTICLES += $(API_DOCS)
>  SP_ARTICLES += technical/api-index
>  
> -DOC_HTML += $(patsubst %,%.html,$(ARTICLES) $(SP_ARTICLES))
> +_DOC_HTML = $(_MAN_HTML)
> +_DOC_HTML+=$(patsubst %,%.html,$(ARTICLES) $(SP_ARTICLES))
> +DOC_HTML=$(addprefix $(OUTPUT),$(_DOC_HTML))
>  
> -DOC_MAN1=$(patsubst %.txt,%.1,$(MAN1_TXT))
> -DOC_MAN5=$(patsubst %.txt,%.5,$(MAN5_TXT))
> -DOC_MAN7=$(patsubst %.txt,%.7,$(MAN7_TXT))
> +_DOC_MAN1=$(patsubst %.txt,%.1,$(MAN1_TXT))
> +_DOC_MAN5=$(patsubst %.txt,%.5,$(MAN5_TXT))
> +_DOC_MAN7=$(patsubst %.txt,%.7,$(MAN7_TXT))
> +
> +DOC_MAN1=$(addprefix $(OUTPUT),$(_DOC_MAN1))
> +DOC_MAN5=$(addprefix $(OUTPUT),$(_DOC_MAN5))
> +DOC_MAN7=$(addprefix $(OUTPUT),$(_DOC_MAN7))
>  
>  # Make the path relative to DESTDIR, not prefix
>  ifndef DESTDIR
> @@ -150,9 +164,9 @@ man1: $(DOC_MAN1)
>  man5: $(DOC_MAN5)
>  man7: $(DOC_MAN7)
>  
> -info: perf.info perfman.info
> +info: $(OUTPUT)perf.info $(OUTPUT)perfman.info
>  
> -pdf: user-manual.pdf
> +pdf: $(OUTPUT)user-manual.pdf
>  
>  install: install-man
>  
> @@ -166,7 +180,7 @@ install-man: man
>  
>  install-info: info
>  	$(INSTALL) -d -m 755 $(DESTDIR)$(infodir)
> -	$(INSTALL) -m 644 perf.info perfman.info $(DESTDIR)$(infodir)
> +	$(INSTALL) -m 644 $(OUTPUT)perf.info $(OUTPUT)perfman.info $(DESTDIR)$(infodir)
>  	if test -r $(DESTDIR)$(infodir)/dir; then \
>  	  $(INSTALL_INFO) --info-dir=$(DESTDIR)$(infodir) perf.info ;\
>  	  $(INSTALL_INFO) --info-dir=$(DESTDIR)$(infodir) perfman.info ;\
> @@ -176,7 +190,7 @@ install-info: info
>  
>  install-pdf: pdf
>  	$(INSTALL) -d -m 755 $(DESTDIR)$(pdfdir)
> -	$(INSTALL) -m 644 user-manual.pdf $(DESTDIR)$(pdfdir)
> +	$(INSTALL) -m 644 $(OUTPUT)user-manual.pdf $(DESTDIR)$(pdfdir)
>  
>  #install-html: html
>  #	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(DESTDIR)$(htmldir)
> @@ -189,14 +203,14 @@ install-pdf: pdf
>  #
>  # Determine "include::" file references in asciidoc files.
>  #
> -doc.dep : $(wildcard *.txt) build-docdep.perl
> +$(OUTPUT)doc.dep : $(wildcard *.txt) build-docdep.perl
>  	$(QUIET_GEN)$(RM) $@+ $@ && \
>  	$(PERL_PATH) ./build-docdep.perl >$@+ $(QUIET_STDERR) && \
>  	mv $@+ $@
>  
> --include doc.dep
> +-include $(OUPTUT)doc.dep
>  
> -cmds_txt = cmds-ancillaryinterrogators.txt \
> +_cmds_txt = cmds-ancillaryinterrogators.txt \
>  	cmds-ancillarymanipulators.txt \
>  	cmds-mainporcelain.txt \
>  	cmds-plumbinginterrogators.txt \
> @@ -205,32 +219,36 @@ cmds_txt = cmds-ancillaryinterrogators.txt \
>  	cmds-synchelpers.txt \
>  	cmds-purehelpers.txt \
>  	cmds-foreignscminterface.txt
> +cmds_txt=$(addprefix $(OUTPUT),$(_cmds_txt))
>  
> -$(cmds_txt): cmd-list.made
> +$(cmds_txt): $(OUTPUT)cmd-list.made
>  
> -cmd-list.made: cmd-list.perl ../command-list.txt $(MAN1_TXT)
> +$(OUTPUT)cmd-list.made: cmd-list.perl ../command-list.txt $(MAN1_TXT)
>  	$(QUIET_GEN)$(RM) $@ && \
>  	$(PERL_PATH) ./cmd-list.perl ../command-list.txt $(QUIET_STDERR) && \
>  	date >$@
>  
>  clean:
> -	$(RM) *.xml *.xml+ *.html *.html+ *.1 *.5 *.7
> -	$(RM) *.texi *.texi+ *.texi++ perf.info perfman.info
> -	$(RM) howto-index.txt howto/*.html doc.dep
> -	$(RM) technical/api-*.html technical/api-index.txt
> -	$(RM) $(cmds_txt) *.made
> -
> -$(MAN_HTML): %.html : %.txt
> +	$(RM) $(MAN_XML) $(addsuffix +,$(MAN_XML))
> +	$(RM) $(MAN_HTML) $(addsuffix +,$(MAN_HTML))
> +	$(RM) $(DOC_HTML) $(DOC_MAN1) $(DOC_MAN5) $(DOC_MAN7)
> +	$(RM) $(OUTPUT)*.texi $(OUTPUT)*.texi+ $(OUTPUT)*.texi++
> +	$(RM) $(OUTPUT)perf.info $(OUTPUT)perfman.info
> +	$(RM) $(OUTPUT)howto-index.txt $(OUTPUT)howto/*.html $(OUTPUT)doc.dep
> +	$(RM) $(OUTPUT)technical/api-*.html $(OUTPUT)technical/api-index.txt
> +	$(RM) $(cmds_txt) $(OUTPUT)*.made
> +
> +$(MAN_HTML): $(OUTPUT)%.html : %.txt
>  	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
>  	$(ASCIIDOC) -b xhtml11 -d manpage -f asciidoc.conf \
>  		$(ASCIIDOC_EXTRA) -aperf_version=$(PERF_VERSION) -o $@+ $< && \
>  	mv $@+ $@
>  
> -%.1 %.5 %.7 : %.xml
> +$(OUTPUT)%.1 $(OUTPUT)%.5 $(OUTPUT)%.7 : $(OUTPUT)%.xml
>  	$(QUIET_XMLTO)$(RM) $@ && \
> -	xmlto -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
> +	xmlto -o $(OUTPUT) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
>  
> -%.xml : %.txt
> +$(OUTPUT)%.xml : %.txt
>  	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
>  	$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
>  		$(ASCIIDOC_EXTRA) -aperf_version=$(PERF_VERSION) -o $@+ $< && \
> @@ -239,25 +257,25 @@ $(MAN_HTML): %.html : %.txt
>  XSLT = docbook.xsl
>  XSLTOPTS = --xinclude --stringparam html.stylesheet docbook-xsl.css
>  
> -user-manual.html: user-manual.xml
> +$(OUTPUT)user-manual.html: $(OUTPUT)user-manual.xml
>  	$(QUIET_XSLTPROC)xsltproc $(XSLTOPTS) -o $@ $(XSLT) $<
>  
> -perf.info: user-manual.texi
> -	$(QUIET_MAKEINFO)$(MAKEINFO) --no-split -o $@ user-manual.texi
> +$(OUTPUT)perf.info: $(OUTPUT)user-manual.texi
> +	$(QUIET_MAKEINFO)$(MAKEINFO) --no-split -o $@ $(OUTPUT)user-manual.texi
>  
> -user-manual.texi: user-manual.xml
> +$(OUTPUT)user-manual.texi: $(OUTPUT)user-manual.xml
>  	$(QUIET_DB2TEXI)$(RM) $@+ $@ && \
> -	$(DOCBOOK2X_TEXI) user-manual.xml --encoding=UTF-8 --to-stdout >$@++ && \
> +	$(DOCBOOK2X_TEXI) $(OUTPUT)user-manual.xml --encoding=UTF-8 --to-stdout >$@++ && \
>  	$(PERL_PATH) fix-texi.perl <$@++ >$@+ && \
>  	rm $@++ && \
>  	mv $@+ $@
>  
> -user-manual.pdf: user-manual.xml
> +$(OUTPUT)user-manual.pdf: $(OUTPUT)user-manual.xml
>  	$(QUIET_DBLATEX)$(RM) $@+ $@ && \
>  	$(DBLATEX) -o $@+ -p /etc/asciidoc/dblatex/asciidoc-dblatex.xsl -s /etc/asciidoc/dblatex/asciidoc-dblatex.sty $< && \
>  	mv $@+ $@
>  
> -perfman.texi: $(MAN_XML) cat-texi.perl
> +$(OUTPUT)perfman.texi: $(MAN_XML) cat-texi.perl
>  	$(QUIET_DB2TEXI)$(RM) $@+ $@ && \
>  	($(foreach xml,$(MAN_XML),$(DOCBOOK2X_TEXI) --encoding=UTF-8 \
>  		--to-stdout $(xml) &&) true) > $@++ && \
> @@ -265,7 +283,7 @@ perfman.texi: $(MAN_XML) cat-texi.perl
>  	rm $@++ && \
>  	mv $@+ $@
>  
> -perfman.info: perfman.texi
> +$(OUTPUT)perfman.info: $(OUTPUT)perfman.texi
>  	$(QUIET_MAKEINFO)$(MAKEINFO) --no-split --no-validate $*.texi
>  
>  $(patsubst %.txt,%.texi,$(MAN_TXT)): %.texi : %.xml
> -- 
> 1.7.7.4
