Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab2ENPGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 11:06:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43091 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab2ENPGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 11:06:35 -0400
Subject: Re: [GIT PULL 0/8] Annotation weekly ponies delivery
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20120514115551.GA6479@gmail.com>
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
	 <CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com>
	 <1336994000.2443.24.camel@twins>  <20120514115551.GA6479@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 00:06:25 +0900
Message-ID: <1337007985.1552.5.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-05-14 (월), 13:55 +0200, Ingo Molnar:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sat, 2012-05-12 at 13:40 -0700, Linus Torvalds wrote:
> > > The whole "-e cycles:pp" doesn't work any more. I don't get any nice
> > > PEBS information, I get the totally useless irq-based profiling.
> > > 
> > > The difference for a "make -j" profile is quite stunning:
> > > 
> > > Doing "perf record -f -e cycles:pp -F 20000 make -j"
> > > 
> > >  - my current git:
> > > 
> > >     [ perf record: Woken up 47 times to write data ]
> > >     [ perf record: Captured and wrote 11.890 MB perf.data (~519462 samples) ]
> > > 
> > >  - with the above tree pulled into my current git tree (but compiling
> > > the same old tree):
> > > 
> > >     [ perf record: Woken up 1 times to write data ]
> > >     [ perf record: Captured and wrote 0.031 MB perf.data (~1375 samples) ] 
> > 
> > The output simply suggests we're not getting enough samples 
> > not that PEBS isn't working, in fact I can could reproduce 
> > without using PEBS.
> > 
> > This bisected to the below commit, the code has since been 
> > changed again and all that evlist stuff gives me a head-ache. 
> > Acme, Namhyung ?
> > 
> > 55261f46702cec96911a81aacfb3cba13434d304 is the first bad commit
> > commit 55261f46702cec96911a81aacfb3cba13434d304
> > Author: Namhyung Kim <namhyung.kim@lge.com>
> > Date:   Mon May 7 14:08:59 2012 +0900
> > 
> >     perf evlist: Fix creation of cpu map
> 
> Another detail seems to be that the bug takes per-task-inherited 
> profiling. Doing:
> 
>    perf record -a -e cycles:pp make -j64 bzImage
> 
> produces the expected number of events. Without the '-a' the bug 
> Linus found triggers.
> 
> Similarly, 'perf top' does not trigger the bug - because it's 
> using per CPU, not per task (inherited) profiling.
> 

perf_evlist__config_attrs() has this:

	if (evlist->cpus->map[0] < 0)
		opts->no_inherit = true;

meaning that per task profiling won't enable event inheritance. I don't
know why it's needed though.


-- 
Regards,
Namhyung Kim


