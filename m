Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab2JLJTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:19:03 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:48067 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620Ab2JLJS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:18:59 -0400
Date: Fri, 12 Oct 2012 11:18:55 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf updates/fixes
Message-ID: <20121012091855.GA246@x4>
References: <20121012081947.GA20570@gmail.com>
 <20121012083926.GA30327@gmail.com>
 <20121012090810.GA11763@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121012090810.GA11763@x1.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.10.12 at 11:08 +0200, Borislav Petkov wrote:
> On Fri, Oct 12, 2012 at 10:39:26AM +0200, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@kernel.org> wrote:
> > 
> > > Linus,
> > > 
> > > Please pull the latest perf-urgent-for-linus git tree from:
> > > 
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus
> > > 
> > >    HEAD: 95cf59ea72331d0093010543b8951bb43f262cac perf: Fix perf_cgroup_switch for sw-events
> > 
> > Note that if you merge it then there's a new semantic conflict 
> > with recent rbtree.c changes in your tree, causing a tools/perf/ 
> > build failure:
> > 
> > ../../lib/rbtree.c:24:36: fatal error: linux/rbtree_augmented.h: No such file or directory compilation terminated.
> > 
> > See the fix below.
> > 
> > ( If the __maybe_unused annotations are too ugly for 
> >   lib/rbtree.c then we'll fix that in tools/perf in a cleaner
> >   way, weakening the compiler checks for the rbtree build. We 
> >   are using stronger compiler checks in tools/perf/, which has 
> >   served us very well so far and is a big net win - the price is 
> >   the occasional extra annotation of dummy inline function 
> >   parameters. )
> 
> Btw,
> 
> Markus fixed it that way recently:
> 
> http://marc.info/?l=linux-kernel&m=134980573527738
> 
> by adding the -Wno-unused-parameter switch only to lib/rbtree.o when
> built from within perf.
> 
> I see now though that his patch has some unrelated changes to
> trace-event-perl.c's permissions which shouldn't be there.

Yes that was part of a different issue:

    CC util/scripting-engines/trace-event-perl.o
util/scripting-engines/trace-event-perl.c: In function ‘perl_process_tracepoint’:
util/scripting-engines/trace-event-perl.c:285:3: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 2 has type ‘__u64’ [-Werror=format]
   die("ug! no event found for type %" PRIu64, evsel->attr.config);
   ^
cc1: all warnings being treated as errors

Which I fixed locally like this:

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index f80605e..f53889d 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -282,7 +282,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 
 	event = find_cache_event(evsel);
 	if (!event)
-		die("ug! no event found for type %" PRIu64, evsel->attr.config);
+		die("ug! no event found for type %" PRIu64, (unsigned long)evsel->attr.config);
 
 	pid = raw_field_value(event, "common_pid", data);
 
-- 
Markus
