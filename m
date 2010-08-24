Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab0HXFX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 01:23:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41953 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab0HXFXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 01:23:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=w6rAxlCSamq0l8miRnKilL36ixf/V5+eWJVcsm3ZfOxZ0YroS6XucLG/7JC6bEoKda
         h97/AC7rQyU05O71cBSjPhKnV0e3QJnUxd6xN9EX5vI1hQY2AZ59UCif7b69QlNLQhfZ
         WUEN0MsaHNPh+v2tNj1irHOV6adiuTtH5rX20=
Subject: Re: [PATCH] perf tools: Fix linking errors with --as-needed flag
From: Tom Zanussi <tzanussi@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ozan =?UTF-8?Q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
        linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20100823165319.GA19611@shutemov.name>
References: <1279449937-29115-1-git-send-email-ozan@pardus.org.tr>
	 <4C42DFC0.1090708@pardus.org.tr> <20100821172433.GF2973@ghostprotocols.net>
	 <1282459432.11398.53.camel@tropicana> <1282531453.30047.8.camel@tropicana>
	 <20100823165319.GA19611@shutemov.name>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 00:23:50 -0500
Message-ID: <1282627430.28324.8.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 19:53 +0300, Kirill A. Shutemov wrote:
> On Sun, Aug 22, 2010 at 09:44:13PM -0500, Tom Zanussi wrote:
> > On Sun, 2010-08-22 at 01:43 -0500, Tom Zanussi wrote:
> > > Hi,
> > > 
> > > On Sat, 2010-08-21 at 14:24 -0300, Arnaldo Carvalho de Melo wrote:
> > > > Em Sun, Jul 18, 2010 at 02:04:32PM +0300, Ozan Çağlayan escreveu:
> > > > > On 18.07.2010 13:45, Ozan Çağlayan wrote:
> > > > > > External shared libraries should never be appended to the LDFLAGS as
> > > > > > this messes the linking order. As EXTLIBS collects those libraries,
> > > > > > it seems that perl and python libraries  should also be appended
> > > > > > to EXTLIBS.
> > > > > > 
> > > > > > Also fix the broken linking order.
> > > > > 
> > > > > Hm actually the PERL_EMBED_LDOPTS may contain LDFLAGS and LIBADD according
> > > > > to distribution's perl package configuration's goodness/badness. On my system
> > > > > the return value is crap which bloats the linking process:
> > > > > 
> > > > >  -rdynamic -Wl,-rpath,/usr/lib/perl5/5.10.1/i686-linux-thread-multi/CORE  -fstack-protector -L/usr/local/lib  -L/usr/lib/perl5/5.10.1/i686-linux-thread-multi/CORE -lperl -lpthread -lnsl -ldl -lm -lcrypt -lutil -lc
> > > > > 
> > > > > PYTHON_EMBED_LDOPTS evaluates python-config --ldflags and adds these to 
> > > > > ALL_LDFLAGS. (--libs and --ldflags are synonyms for python-config). According
> > > > > to python-config this code *never* returns LDFLAGS so it's safe to put them in
> > > > > EXTLIBS.
> > > > > 
> > > > > So the cure may be more than this patch for perl stuff, but at least it fixes my
> > > > > linking problems with -Wl, --as-needed.
> > > > 
> > > > Can you refresh this patch? I had it in the back of my mind, remembered
> > > > it when considering a similar patch by Kirill, but his covers just the
> > > > python case.
> > > > 
> > > > Tom, can you please check Ozan's and Kirill's patches and tell me if I
> > > > can stick your Acked-by to them?
> > > > 
> > > 
> > > I refreshed Ozan's patch against tip and tried both with and without
> > > -Wl,--as-needed and it worked fine for both Perl and Python, on my
> > > Ubuntu 9.10 system.  The refreshed patch I used is included below.
> > > 
> > > It wasn't clear to me whether Ozan's PERL_EMBED_LDOPTS output still
> > > caused link errors; here's mine, which didn't:
> > > 
> > > trz@tropicana:~$ perl -MExtUtils::Embed -e ldopts
> > > -Wl,-E  -L/usr/local/lib  -L/usr/lib/perl/5.10/CORE -lperl -ldl -lm
> > > -lpthread -lc -lcrypt
> > > 
> > > In any case, since neither ExtUtils::Embed nor python-config seem to
> > > have a way to get the LDFLAGS and LIBADD components separately, we'll
> > > have to find some other way to do that if necessary.
> > > 
> > 
> > Looking into it a bit further, both ExtUtils::Embed -e ldopts and
> > python-config --ldflags put the libs at the end, so we should be able to
> > parse the output of those and take only the parts we need for each
> > component.  How about something like this instead?
> > 
> > Tom 
> > 
> > ---
> > 
> > [PATCH] Refresh of Ozan Çağlayan's patch: perf tools: Fix linking errors
> > with --as-needed flag:
> > 
> > External shared libraries should never be appended to the LDFLAGS as
> > this messes the linking order. As EXTLIBS collects those libraries,
> > it seems that perl and python libraries  should also be appended
> > to EXTLIBS.
> > 
> > Also fix the broken linking order.
> > 
> > v2: add commands to separate out LDFLAGS and libs from both Perl and
> > Python LDOPTS (Tom Zanussi)
> > 
> > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 
> Tested-by: Kirill A. Shutemov <kirill@shutemov.name>
> 
> But, probably better to do it with make:
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 4f1fa77..03a53a9 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -313,6 +313,9 @@ TEST_PROGRAMS =
>  
>  SCRIPT_SH += perf-archive.sh
>  
> +grep-libs = $(filter -l%,$(1))
> +strip-libs = $(filter-out -l%,$(1))
> +
>  #
>  # No Perl scripts right now:
>  #
> @@ -588,14 +591,17 @@ endif
>  ifdef NO_LIBPERL
>         BASIC_CFLAGS += -DNO_LIBPERL
>  else
> -       PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts 2>/dev/null`
> +       PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
> +       PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
> +       PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
>         PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
>         FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
>  
>         ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED)),y)
>                 BASIC_CFLAGS += -DNO_LIBPERL
>         else
> -               ALL_LDFLAGS += $(PERL_EMBED_LDOPTS)
> +               ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
> +               EXTLIBS += $(PERL_EMBED_LIBADD)
>                 LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
>                 LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
>         endif
> @@ -604,13 +610,16 @@ endif
>  ifdef NO_LIBPYTHON
>         BASIC_CFLAGS += -DNO_LIBPYTHON
>  else
> -       PYTHON_EMBED_LDOPTS = `python-config --ldflags 2>/dev/null`
> +       PYTHON_EMBED_LDOPTS = $(shell python-config --ldflags 2>/dev/null)
> +       PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
> +       PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
>         PYTHON_EMBED_CCOPTS = `python-config --cflags 2>/dev/null`
>         FLAGS_PYTHON_EMBED=$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
>         ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
>                 BASIC_CFLAGS += -DNO_LIBPYTHON
>         else
> -               ALL_LDFLAGS += $(PYTHON_EMBED_LDOPTS)
> +               ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
> +               EXTLIBS += $(PYTHON_EMBED_LIBADD)
>                 LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
>                 LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
>         endif
> @@ -910,8 +919,8 @@ $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
>                 $(ALL_CFLAGS) -c $(filter %.c,$^) -o $@
>  
>  $(OUTPUT)perf$X: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
> -       $(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(OUTPUT)perf.o \
> -               $(BUILTIN_OBJS) $(ALL_LDFLAGS) $(LIBS)
> +       $(QUIET_LINK)$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(OUTPUT)perf.o \
> +               $(BUILTIN_OBJS) $(LIBS) -o $@
>  
>  $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
>         $(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \

Yes, much better, thanks!

Tested-by: Tom Zanussi <tzanussi@gmail.com>

BTW, I had some problems applying that patch, had to use -l and fix up a missing tab:

---
 tools/perf/Makefile |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 26a3f2e..fe1e307 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -313,6 +313,9 @@ TEST_PROGRAMS =
 
 SCRIPT_SH += perf-archive.sh
 
+grep-libs = $(filter -l%,$(1))
+strip-libs = $(filter-out -l%,$(1))
+
 #
 # No Perl scripts right now:
 #
@@ -588,14 +591,17 @@ endif
 ifdef NO_LIBPERL
 	BASIC_CFLAGS += -DNO_LIBPERL
 else
-	PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts 2>/dev/null`
+       PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
+       PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
+       PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
 	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
 	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
 	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED)),y)
 		BASIC_CFLAGS += -DNO_LIBPERL
 	else
-		ALL_LDFLAGS += $(PERL_EMBED_LDOPTS)
+               ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
+               EXTLIBS += $(PERL_EMBED_LIBADD)
 		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
 		LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
 	endif
@@ -604,13 +610,16 @@ endif
 ifdef NO_LIBPYTHON
 	BASIC_CFLAGS += -DNO_LIBPYTHON
 else
-	PYTHON_EMBED_LDOPTS = `python-config --ldflags 2>/dev/null`
+       PYTHON_EMBED_LDOPTS = $(shell python-config --ldflags 2>/dev/null)
+       PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
+       PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
 	PYTHON_EMBED_CCOPTS = `python-config --cflags 2>/dev/null`
 	FLAGS_PYTHON_EMBED=$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
 	ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
 		BASIC_CFLAGS += -DNO_LIBPYTHON
 	else
-		ALL_LDFLAGS += $(PYTHON_EMBED_LDOPTS)
+               ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
+               EXTLIBS += $(PYTHON_EMBED_LIBADD)
 		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
 		LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
 	endif
@@ -919,8 +928,8 @@ $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 		$(ALL_CFLAGS) -c $(filter %.c,$^) -o $@
 
 $(OUTPUT)perf$X: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
-	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(OUTPUT)perf.o \
-		$(BUILTIN_OBJS) $(ALL_LDFLAGS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(OUTPUT)perf.o \
+               $(BUILTIN_OBJS) $(LIBS) -o $@
 
 $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
-- 
1.6.4.GIT




