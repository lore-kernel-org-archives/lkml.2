Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab2EDHJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 03:09:34 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46265 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab2EDHJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 03:09:33 -0400
Date: Fri, 4 May 2012 09:09:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>, David Miller <davem@davemloft.net>,
        namhyung.kim@lge.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [patch] perf: Fix build failure on OpenSuse userspace
Message-ID: <20120504070928.GA18351@gmail.com>
References: <20120503215748.GA18995@kroah.com>
 <87sjfgafqj.fsf@sejong.aot.lge.com>
 <20120503.215020.954262287222794218.davem@davemloft.net>
 <CACqU3MVqpz=azeUOUfmtoLEPvqngfJHSHFe7ujemeRT1-B=osA@mail.gmail.com>
 <CACqU3MWLKMhTdh-HUh0MhE_hZmwNPG5FOxWarjO4BsRemmG8sA@mail.gmail.com>
 <CACqU3MVVgo7R8CmGwi6utE0F0urf5NW58s23bmNU_rSQAg2pww@mail.gmail.com>
 <20120504024706.GA10461@kroah.com>
 <CACqU3MUwDaRXwAd3fu7sUmM2ApH+pfu4rf1-TNKt1ja+wYpJ9w@mail.gmail.com>
 <20120504031614.GA12048@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120504031614.GA12048@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@linuxfoundation.org> wrote:

> On Thu, May 03, 2012 at 11:01:54PM -0400, Arnaud Lacombe wrote:
> > Hi,
> > 
> > On Thu, May 3, 2012 at 10:47 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > On Thu, May 03, 2012 at 10:35:02PM -0400, Arnaud Lacombe wrote:
> > >> Hi,
> > >>
> > >> On Thu, May 3, 2012 at 10:29 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> > >> > [...]
> > >> > [0]: http://pkgs.fedoraproject.org/gitweb/?p=flex.git;a=blob;f=flex-2.5.35-hardening.patch;h=7d608ea2371fa3295bdb8eb97c15eeb03029c02b;hb=HEAD
> > >> >
> > >> as a side note, this patch sounds more being about "silencing" than
> > >> "hardening"...
> > >
> > > That's nice, but I can build the perf version in 3.3 just fine, so
> > > something broke here (hint, build regression.)  Do I have to bisect it
> > > down to find the problem?
> > >
> > there is most likely nothing to bisect, `perf' seems to have never
> > required any parser before 3.4. The way the rest of the tools
> > (especially `kconfig', `genksyms' and `dtc') manage parsers is via
> > pre-generated .[ch]_shipped version of the lexer/tokenizer. It's been
> > working well for a long time as such. `perf' will certainly have to
> > follow the same path.
> 
> Well, it can allow bison to run, but just don't break the build if the
> generated code it creates happens to contain warnings.
> 
> I'm using bison 2.5 and flex 2.5.35, and my phone number is...
> 
> Like this really matters?  This needs to work for everyone, if not, you
> better put the specific version numbers you need to require in the
> Documentation/Changes file.
> 
> So, how do I fix this?

Does the (untested) patch below help?

If not then please paste me the build failure output (it will 
most likely change due to the patch), and until we fix this 
build regression on OpenSuse userspace you can work it around 
via:

  make WERROR=0

Thanks,

	Ingo

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7055a00..3174e9b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -729,10 +729,10 @@ $(OUTPUT)perf.o perf.spec \
 # over the general rule for .o
 
 $(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function -Wno-unused-parameter $<
 
 $(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function -Wno-unused-parameter $<
 
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
