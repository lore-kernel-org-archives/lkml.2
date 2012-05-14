Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2ENLz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:55:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57096 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab2ENLz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:55:56 -0400
Date: Mon, 14 May 2012 13:55:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/8] Annotation weekly ponies delivery
Message-ID: <20120514115551.GA6479@gmail.com>
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
 <CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com>
 <1336994000.2443.24.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336994000.2443.24.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2012-05-12 at 13:40 -0700, Linus Torvalds wrote:
> > The whole "-e cycles:pp" doesn't work any more. I don't get any nice
> > PEBS information, I get the totally useless irq-based profiling.
> > 
> > The difference for a "make -j" profile is quite stunning:
> > 
> > Doing "perf record -f -e cycles:pp -F 20000 make -j"
> > 
> >  - my current git:
> > 
> >     [ perf record: Woken up 47 times to write data ]
> >     [ perf record: Captured and wrote 11.890 MB perf.data (~519462 samples) ]
> > 
> >  - with the above tree pulled into my current git tree (but compiling
> > the same old tree):
> > 
> >     [ perf record: Woken up 1 times to write data ]
> >     [ perf record: Captured and wrote 0.031 MB perf.data (~1375 samples) ] 
> 
> The output simply suggests we're not getting enough samples 
> not that PEBS isn't working, in fact I can could reproduce 
> without using PEBS.
> 
> This bisected to the below commit, the code has since been 
> changed again and all that evlist stuff gives me a head-ache. 
> Acme, Namhyung ?
> 
> 55261f46702cec96911a81aacfb3cba13434d304 is the first bad commit
> commit 55261f46702cec96911a81aacfb3cba13434d304
> Author: Namhyung Kim <namhyung.kim@lge.com>
> Date:   Mon May 7 14:08:59 2012 +0900
> 
>     perf evlist: Fix creation of cpu map

Another detail seems to be that the bug takes per-task-inherited 
profiling. Doing:

   perf record -a -e cycles:pp make -j64 bzImage

produces the expected number of events. Without the '-a' the bug 
Linus found triggers.

Similarly, 'perf top' does not trigger the bug - because it's 
using per CPU, not per task (inherited) profiling.

Thanks,

	Ingo
