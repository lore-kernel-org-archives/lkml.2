Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2GWTu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 15:50:57 -0400
Received: from shutemov.name ([176.9.204.213]:44230 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab2GWTu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 15:50:56 -0400
Date: Mon, 23 Jul 2012 22:51:46 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: fix build error
Message-ID: <20120723195146.GA24938@shutemov.name>
References: <1343055645-24083-1-git-send-email-kirill@shutemov.name>
 <20120723180244.GB5418@infradead.org>
 <20120723181608.GA24558@shutemov.name>
 <20120723181849.GF6717@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120723181849.GF6717@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 08:18:49PM +0200, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jul 23, 2012 at 09:16:08PM +0300, Kirill A. Shutemov escreveu:
> > On Mon, Jul 23, 2012 at 08:02:44PM +0200, Arnaldo Carvalho de Melo wrote:
> > > Em Mon, Jul 23, 2012 at 06:00:44PM +0300, Kirill A. Shutemov escreveu:
> > > > util/parse-events.c:29:5: error: redundant redeclaration of ‘parse_events_parse’ [-Werror=redundant-decls]
> > > > util/parse-events-bison.h:99:5: note: previous declaration of ‘parse_events_parse’ was here
> > > > cc1: all warnings being treated as errors
> 
> > > Causes the build to fail for me:
> 
> > > cc1: warnings being treated as errors
> > > util/parse-events.c: In function ‘parse_events__scanner’:
> > > util/parse-events.c:701: error: implicit declaration of function ‘parse_events_parse’
> > > util/parse-events.c:701: error: nested extern declaration of ‘parse_events_parse’
> > > make: *** [/home/acme/git/build/perf/util/parse-events.o] Error 1
> > > make: *** Waiting for unfinished jobs....
> > > make: Leaving directory `/home/git/linux/tools/perf'
> > 
> > What bison version do you have?
> 
> [acme@sandy linux]$ rpm -q bison
> bison-2.4.1-5.el6.x86_64
> 

Could you test this one?

>From 461531d2166574e4a3abc7ae27ebbea864d9f5ea Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Date: Mon, 23 Jul 2012 17:39:11 +0300
Subject: [PATCH] perf: fix build error
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Bison 2.6 started to generate parse_events_parse() declaration in
header. In this case we have redundant redeclaration:

util/parse-events.c:29:5: error: redundant redeclaration of ‘parse_events_parse’ [-Werror=redundant-decls]
In file included from util/parse-events.c:14:0:
util/parse-events-bison.h:99:5: note: previous declaration of ‘parse_events_parse’ was here
cc1: all warnings being treated as errors

Let's disable -Wredundant-decls for util/parse-events.c since it
includes header we can't control.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 tools/perf/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 75d74e5..71c274f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -803,6 +803,9 @@ $(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+$(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-redundant-decls $<
+
 $(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
 
-- 
 Kirill A. Shutemov
