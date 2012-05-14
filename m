Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2ENLNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:13:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:54467 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab2ENLNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:13:30 -0400
Message-ID: <1336994000.2443.24.camel@twins>
Subject: Re: [GIT PULL 0/8] Annotation weekly ponies delivery
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 14 May 2012 13:13:20 +0200
In-Reply-To: <CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com>
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
	 <CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-12 at 13:40 -0700, Linus Torvalds wrote:
> The whole "-e cycles:pp" doesn't work any more. I don't get any nice
> PEBS information, I get the totally useless irq-based profiling.
> 
> The difference for a "make -j" profile is quite stunning:
> 
> Doing "perf record -f -e cycles:pp -F 20000 make -j"
> 
>  - my current git:
> 
>     [ perf record: Woken up 47 times to write data ]
>     [ perf record: Captured and wrote 11.890 MB perf.data (~519462 samples) ]
> 
>  - with the above tree pulled into my current git tree (but compiling
> the same old tree):
> 
>     [ perf record: Woken up 1 times to write data ]
>     [ perf record: Captured and wrote 0.031 MB perf.data (~1375 samples) ] 

The output simply suggests we're not getting enough samples not that
PEBS isn't working, in fact I can could reproduce without using PEBS.

This bisected to the below commit, the code has since been changed again
and all that evlist stuff gives me a head-ache. Acme, Namhyung ?


55261f46702cec96911a81aacfb3cba13434d304 is the first bad commit
commit 55261f46702cec96911a81aacfb3cba13434d304
Author: Namhyung Kim <namhyung.kim@lge.com>
Date:   Mon May 7 14:08:59 2012 +0900

    perf evlist: Fix creation of cpu map
    
    Currently, 'perf record -- sleep 1' creates a cpu map for all online
    cpus since it turns out calling cpu_map__new(NULL). Fix it.
    
    Also it is guaranteed that cpu_list is NULL if PID/TID is given by
    calling perf_target__validate(), so we can make the conditional bit
    simpler.
    
    This also fixes perf test 7 (Validate) failure on my 6 core machine:
    
      $ cat /sys/devices/system/cpu/online
      0-11
      $ ./perf test -v 7
       7: Validate PERF_RECORD_* events & perf_sample fields:
      --- start ---
      perf_evlist__mmap: Operation not permitted
      ---- end ----
      Validate PERF_RECORD_* events & perf_sample fields: FAILED!
    
    Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
    Reviewed-by: David Ahern <dsahern@gmail.com>
    Cc: David Ahern <dsahern@gmail.com>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Namhyung Kim <namhyung@gmail.com>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/r/1336367344-28071-3-git-send-email-namhyung.kim@lge.com
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>


