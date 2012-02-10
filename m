Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab2BJFmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:42:25 -0500
Received: from plane.gmane.org ([80.91.229.3]:53793 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab2BJFmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:42:21 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] perf tools: Allow multiple threads or processes in record,
 stat, top
Date: Fri, 10 Feb 2012 14:42:01 +0900
Message-ID: <4F34AE29.5010202@gmail.com>
References: <1328718772-16688-1-git-send-email-dsahern@gmail.com> <4F331F14.5070100@gmail.com> <4F3334F7.70809@gmail.com> <20120209073727.GA18152@elte.hu> <20120209143449.GA2526@infradead.org> <20120209144451.GB2526@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
X-Gmane-NNTP-Posting-Host: 121.50.20.41
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
In-Reply-To: <20120209144451.GB2526@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2012-02-09 11:44 PM, Arnaldo Carvalho de Melo wrote:
> Em Thu, Feb 09, 2012 at 12:34:49PM -0200, Arnaldo Carvalho de Melo escreveu:
>> Em Thu, Feb 09, 2012 at 08:37:27AM +0100, Ingo Molnar escreveu:
>>>
>>> * David Ahern<dsahern@gmail.com>  wrote:
>>>
>>>>> I was trying to remove ctype.h, you might use util.h here.
>>>>
>>>> Right, knew that. But, in this case I am adding a call to
>>>> isdigit which means a direct dependency on ctype.h. I would
>>>> prefer a direct relationship versus an indirect via util.h
>>>
>>> Please just remove ctype.h *altogether* from perf, it's just an
>>> insane header.
>>>
>>> Have a look at how Git solves these types of problems, it
>>> defines sane string functions in git-compat-util.h:
>>
>> Yeah, these are in util.h, that doesn't includes ctype.h
>>
>> I'm fixing this up and also that s/UUID/UID/g Kim pointed out,
>> then testing if the python binding still is ok with these changes.
> 
> [root@aninha linux]# tools/perf/python/twatch.py
> Traceback (most recent call last):
>    File "tools/perf/python/twatch.py", line 16, in<module>
>      import perf
> ImportError: /home/acme/git/build/perf/python/perf.so: undefined symbol:
> ui__error
> [root@aninha linux]#
> 
> it breaks, I'll check an alternative way to report problems without
> calling ui__ methods from thread_map.
> 
> - Arnaldo

I have a different result:

 $ git checkout tip/perf/core
 ...
 HEAD is now at c98fdeaa9273... x86/sched/perf/AMD: Set sched_clock_stable
 $
 $ patch -p1 < perf-allow-multiple-threads.patch
 patching file tools/perf/Documentation/perf-record.txt
 patching file tools/perf/Documentation/perf-stat.txt
 patching file tools/perf/Documentation/perf-top.txt
 patching file tools/perf/builtin-record.c
 patching file tools/perf/builtin-stat.c
 patching file tools/perf/builtin-test.c
 patching file tools/perf/builtin-top.c
 patching file tools/perf/perf.h
 patching file tools/perf/util/evlist.c
 patching file tools/perf/util/evlist.h
 patching file tools/perf/util/evsel.c
 patching file tools/perf/util/thread_map.c
 patching file tools/perf/util/thread_map.h
 patching file tools/perf/util/top.c
 patching file tools/perf/util/top.h
 patching file tools/perf/util/usage.c
 patching file tools/perf/util/util.h
 patch unexpectedly ends in middle of line
 $
 $ cd tools/perf
 $ make -j8
 Makefile:417: No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support.
               Please install new elfutils-devel/libdw-dev
 Makefile:604: No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling
     GEN common-cmds.h
 ...
     AR libperf.a
     LINK perf
 $
 $ sudo python/twatch.py
 Traceback (most recent call last):
   File "python/twatch.py", line 41, in <module>
     main()
   File "python/twatch.py", line 25, in main
     evsel.open(cpus = cpus, threads = threads);
 OSError: [Errno 22] Invalid argument


Thanks,
Namhyung


 

