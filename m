Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab2BJO2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:28:30 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56884 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2BJO23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:28:29 -0500
Date: Fri, 10 Feb 2012 12:28:21 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf tools: Allow multiple threads or processes in
 record, stat, top
Message-ID: <20120210142821.GH2526@infradead.org>
References: <1328718772-16688-1-git-send-email-dsahern@gmail.com>
 <4F331F14.5070100@gmail.com>
 <4F3334F7.70809@gmail.com>
 <20120209073727.GA18152@elte.hu>
 <20120209143449.GA2526@infradead.org>
 <20120209144451.GB2526@infradead.org>
 <4F34AE29.5010202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F34AE29.5010202@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 10, 2012 at 02:42:01PM +0900, Namhyung Kim escreveu:
> 2012-02-09 11:44 PM, Arnaldo Carvalho de Melo wrote:
> > [root@aninha linux]# tools/perf/python/twatch.py
> > Traceback (most recent call last):
> >    File "tools/perf/python/twatch.py", line 16, in<module>
> >      import perf
> > ImportError: /home/acme/git/build/perf/python/perf.so: undefined symbol: ui__error

> > it breaks, I'll check an alternative way to report problems without
> > calling ui__ methods from thread_map.
> 
> I have a different result:
>  $ git checkout tip/perf/core
>  HEAD is now at c98fdeaa9273... x86/sched/perf/AMD: Set sched_clock_stable
>  $ patch -p1 < perf-allow-multiple-threads.patch
>  patching file tools/perf/Documentation/perf-record.txt
<SNIP>
>  $ cd tools/perf
>  $ make -j8
<SNIP>
>  $ sudo python/twatch.py
>  Traceback (most recent call last):
>    File "python/twatch.py", line 41, in <module>
>      main()
>    File "python/twatch.py", line 25, in main
>      evsel.open(cpus = cpus, threads = threads);
>  OSError: [Errno 22] Invalid argument

This is another problem and one I would appreciate if you could fix :-)

I mentioned it to David in a private message and there was at least one
instance where Linus was involved and I promised to fix this but haven't
find the time to do so.

The problem is that one needs to research how to make the python binding
to be rebuilt when one of the files that are linked into it changes.

Please take a look at tools/perf/util/setup.py and you'll see:

perf = Extension('perf',
          sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
                     'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
                     'util/util.c', 'util/xyarray.c', 'util/cgroup.c',
                     'util/debugfs.c'],
          include_dirs = ['util/include'],
          extra_compile_args = cflags,
        )

	Probably is something simple in the Makefiles.

	So please try again after doing:

  cd tools/perf
  rm -rf python/perf.so
  make

	And you should get the same problem. Also check
/proc/sys/kernel/perf_event_paranoid as this script does syswide sampling.

	I'll try to fix this problem now that I took the time to think about it
8-)

- Arnaldo
