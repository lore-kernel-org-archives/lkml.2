Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab2EDPVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:21:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab2EDPVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:21:04 -0400
Date: Fri, 4 May 2012 17:02:11 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>, namhyung.kim@lge.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [patch] perf: Fix build failure on OpenSuse userspace
Message-ID: <20120504150211.GA2995@m.brq.redhat.com>
References: <87sjfgafqj.fsf@sejong.aot.lge.com>
 <20120503.215020.954262287222794218.davem@davemloft.net>
 <CACqU3MVqpz=azeUOUfmtoLEPvqngfJHSHFe7ujemeRT1-B=osA@mail.gmail.com>
 <CACqU3MWLKMhTdh-HUh0MhE_hZmwNPG5FOxWarjO4BsRemmG8sA@mail.gmail.com>
 <CACqU3MVVgo7R8CmGwi6utE0F0urf5NW58s23bmNU_rSQAg2pww@mail.gmail.com>
 <20120504024706.GA10461@kroah.com>
 <CACqU3MUwDaRXwAd3fu7sUmM2ApH+pfu4rf1-TNKt1ja+wYpJ9w@mail.gmail.com>
 <20120504031614.GA12048@kroah.com>
 <20120504070928.GA18351@gmail.com>
 <CACqU3MXRGP3Ep2sJwAB+aOTp9ezifRy+FhVkGjZpzTSW2PhCqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACqU3MXRGP3Ep2sJwAB+aOTp9ezifRy+FhVkGjZpzTSW2PhCqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 10:44:28AM -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Fri, May 4, 2012 at 3:09 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Greg KH <gregkh@linuxfoundation.org> wrote:
> >

SNIP

> > diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> > index 7055a00..3174e9b 100644
> > --- a/tools/perf/Makefile
> > +++ b/tools/perf/Makefile
> > @@ -729,10 +729,10 @@ $(OUTPUT)perf.o perf.spec \
> >  # over the general rule for .o
> >
> >  $(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
> > -       $(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
> > +       $(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function -Wno-unused-parameter $<
> >
> >  $(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
> > -       $(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
> > +       $(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function -Wno-unused-parameter $<
> >
> >  $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
> >        $(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
> >
> You can find the build failure log in
> <20120503215748.GA18995@kroah.com>, pasted here for reference:
> 
>     CC util/parse-events-flex.o
> <stdout>: In function â€˜yy_get_next_bufferâ€™:
> <stdout>:1510:3: error: comparison between signed and unsigned integer
> expressions [-Werror=sign-compare]
> util/parse-events.l: In function â€˜parse_events_lexâ€™:
> util/parse-events.l:122:1: error: ignoring return value of
> â€˜fwriteâ€™, declared with attribute warn_unused_result
> [-Werror=unused-result]
> cc1: all warnings being treated as errors
> 
> So I doubt -Wno-unused-parameter will do any good here.
I think we need also -Wno-sign-compare, please check the attached patch

jirka


---
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7055a00..8f7b6cf 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -729,10 +729,10 @@ $(OUTPUT)perf.o perf.spec \
 # over the general rule for .o
 
 $(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function -Wno-unused-parameter -Wno-sign-compare $<
 
 $(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -Iutil/ -Wno-redundant-decls -Wno-switch-default -Wno-unused-function -Wno-unused-parameter -Wno-sign-compare $<
 
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
