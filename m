Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2JRN7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:59:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:59813 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab2JRN7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:59:08 -0400
Date: Thu, 18 Oct 2012 10:58:43 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 08/11] perf python: Initialize 'page_size' variable
Message-ID: <20121018135843.GB2057@infradead.org>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
 <1350494387-10987-9-git-send-email-acme@infradead.org>
 <87391c36r6.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87391c36r6.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 18, 2012 at 10:31:57AM +0900, Namhyung Kim escreveu:
> On Wed, 17 Oct 2012 14:19:44 -0300, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>

> > The commit 0c1fe6b:

> >  'perf tools: Have the page size value available for all tools'

> Is that commit in your perf/urgent branch?  I got this:

>     GEN python/perf.so

Ouch, brown paper bag grade stuff detected, I reverted it now in my perf/urgent
branch.

Ingo, I'm on a conference here in Brazil, just pushed this revert to
perf/urgent, up to you if you want to pull from it or apply all the
csets in this branch except for the one reverted:

commit 356712f6e296fdae1edae51b96b485ed830bdc0c
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Tue Oct 16 14:51:04 2012 -0300

    perf python: Initialize 'page_size' variable

-----------------------

I'll keep it on my perf/core branch, where it is needed.

Thanks Namhyung!

- Arnaldo

> util/python.c: In function ‘initperf’:
> util/python.c:1018:2: error: ‘page_size’ undeclared (first use in this function)
> util/python.c:1018:2: note: each undeclared identifier is reported only once for each function it appears in
> error: command 'gcc' failed with exit status 1
> cp: cannot stat `python_ext_build/lib/perf.so': No such file or directory
> make: *** [python/perf.so] Error 1
> 
> Adding '#include "util.h"' didn't work.  But manually adding 'extern
> unsigned int page_size;' did.
> 
> Thanks,
> Namhyung
> 
> 
> >
> > Broke the python binding because the global variable 'page_size' is
> > initialized on the main() routine, that is not called when using
> > just the python binding, causing evlist.mmap() to fail because it
> > expects that variable to be initialized to the system's page size.
> >
> > Fix it by initializing it on the binding init routine.
> >
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Namhyung Kim <namhyung@gmail.com>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Stephane Eranian <eranian@google.com>
> > Link: http://lkml.kernel.org/n/tip-vrvp3azmbfzexnpmkhmvtzzc@git.kernel.org
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > ---
> >  tools/perf/util/python.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
> > index 9181bf2..a2657fd 100644
> > --- a/tools/perf/util/python.c
> > +++ b/tools/perf/util/python.c
> > @@ -1015,6 +1015,8 @@ PyMODINIT_FUNC initperf(void)
> >  	    pyrf_cpu_map__setup_types() < 0)
> >  		return;
> >  
> > +	page_size = sysconf(_SC_PAGE_SIZE);
> > +
> >  	Py_INCREF(&pyrf_evlist__type);
> >  	PyModule_AddObject(module, "evlist", (PyObject*)&pyrf_evlist__type);
