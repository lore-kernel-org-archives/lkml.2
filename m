Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab0HVGn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 02:43:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35684 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab0HVGny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 02:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VguqlAN0uk85MrXdPQ5eZIxtoSX60fB2CldBDGSzybPxJe5qSt3mHhN3aCTDVsDqDW
         cyThsdH6v6ggWEucF5d393C4ctGRG5Qmx2wnA9sKdlzTlk6v6Z5yU9wa6e3xM0pb7D+d
         NhczaCdW575gAC6d4XCdSvnqEdPGakyLwv9Uk=
Subject: Re: [PATCH] perf tools: Fix linking errors with --as-needed flag
From: Tom Zanussi <tzanussi@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ozan =?UTF-8?Q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20100821172433.GF2973@ghostprotocols.net>
References: <1279449937-29115-1-git-send-email-ozan@pardus.org.tr>
	 <4C42DFC0.1090708@pardus.org.tr> <20100821172433.GF2973@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Aug 2010 01:43:52 -0500
Message-ID: <1282459432.11398.53.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 2010-08-21 at 14:24 -0300, Arnaldo Carvalho de Melo wrote:
> Em Sun, Jul 18, 2010 at 02:04:32PM +0300, Ozan Çağlayan escreveu:
> > On 18.07.2010 13:45, Ozan Çağlayan wrote:
> > > External shared libraries should never be appended to the LDFLAGS as
> > > this messes the linking order. As EXTLIBS collects those libraries,
> > > it seems that perl and python libraries  should also be appended
> > > to EXTLIBS.
> > > 
> > > Also fix the broken linking order.
> > 
> > Hm actually the PERL_EMBED_LDOPTS may contain LDFLAGS and LIBADD according
> > to distribution's perl package configuration's goodness/badness. On my system
> > the return value is crap which bloats the linking process:
> > 
> >  -rdynamic -Wl,-rpath,/usr/lib/perl5/5.10.1/i686-linux-thread-multi/CORE  -fstack-protector -L/usr/local/lib  -L/usr/lib/perl5/5.10.1/i686-linux-thread-multi/CORE -lperl -lpthread -lnsl -ldl -lm -lcrypt -lutil -lc
> > 
> > PYTHON_EMBED_LDOPTS evaluates python-config --ldflags and adds these to 
> > ALL_LDFLAGS. (--libs and --ldflags are synonyms for python-config). According
> > to python-config this code *never* returns LDFLAGS so it's safe to put them in
> > EXTLIBS.
> > 
> > So the cure may be more than this patch for perl stuff, but at least it fixes my
> > linking problems with -Wl, --as-needed.
> 
> Can you refresh this patch? I had it in the back of my mind, remembered
> it when considering a similar patch by Kirill, but his covers just the
> python case.
> 
> Tom, can you please check Ozan's and Kirill's patches and tell me if I
> can stick your Acked-by to them?
> 

I refreshed Ozan's patch against tip and tried both with and without
-Wl,--as-needed and it worked fine for both Perl and Python, on my
Ubuntu 9.10 system.  The refreshed patch I used is included below.

It wasn't clear to me whether Ozan's PERL_EMBED_LDOPTS output still
caused link errors; here's mine, which didn't:

trz@tropicana:~$ perl -MExtUtils::Embed -e ldopts
-Wl,-E  -L/usr/local/lib  -L/usr/lib/perl/5.10/CORE -lperl -ldl -lm
-lpthread -lc -lcrypt

In any case, since neither ExtUtils::Embed nor python-config seem to
have a way to get the LDFLAGS and LIBADD components separately, we'll
have to find some other way to do that if necessary.

trz@tropicana:~$ python-config --libs
-lpthread -ldl -lutil -lm -lpython2.6
trz@tropicana:~$ python-config --ldflags
-L/usr/lib/python2.6/config -lpthread -ldl -lutil -lm -lpython2.6


Acked-by: Tom Zanussi <tzanussi@gmail.com>

---
 tools/perf/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4f1fa77..f35e784 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -595,7 +595,7 @@ else
 	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED)),y)
 		BASIC_CFLAGS += -DNO_LIBPERL
 	else
-		ALL_LDFLAGS += $(PERL_EMBED_LDOPTS)
+		EXTLIBS += $(PERL_EMBED_LDOPTS)
 		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
 		LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
 	endif
@@ -610,7 +610,7 @@ else
 	ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
 		BASIC_CFLAGS += -DNO_LIBPYTHON
 	else
-		ALL_LDFLAGS += $(PYTHON_EMBED_LDOPTS)
+		EXTLIBS += $(PYTHON_EMBED_LDOPTS)
 		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
 		LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
 	endif
@@ -910,8 +910,8 @@ $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 		$(ALL_CFLAGS) -c $(filter %.c,$^) -o $@
 
 $(OUTPUT)perf$X: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
-	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(OUTPUT)perf.o \
-		$(BUILTIN_OBJS) $(ALL_LDFLAGS) $(LIBS)
+	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(OUTPUT)perf.o \
+		$(BUILTIN_OBJS) $(LIBS) -o $@
 
 $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
-- 
1.6.4.GIT



