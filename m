Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab2ARKRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:17:44 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56271 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab2ARKRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:17:42 -0500
Date: Wed, 18 Jan 2012 15:37:52 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v9 3.2 7/9] tracing: uprobes trace_event interface
Message-ID: <20120118100752.GF15447@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com>
 <20120110114943.17610.28293.sendpatchset@srdronam.in.ibm.com>
 <20120116131137.GB5265@m.brq.redhat.com>
 <20120117092838.GB10397@elte.hu>
 <20120117102231.GB15447@linux.vnet.ibm.com>
 <20120117122133.GB4959@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120117122133.GB4959@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011810-5518-0000-0000-0000019CFFAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Have you tried to use 'perf probe' to achieve any useful 
> instrumentation on a real app?
> 
> I just tried out the 'glibc:free' usecase and it's barely 
> usable.
> 

Thanks for trying.

Yes, I have actually place probes on free and malloc while building a
kernel and it has worked for me.

> Firstly, the recording very frequently produces overruns:
> 
>  $ perf record -e probe_libc:free -aR sleep 1
>  [ perf record: Woken up 169 times to write data ]
>  [ perf record: Captured and wrote 89.674 MB perf.data (~3917919 samples) ]
>  Warning:Processed 1349133 events and lost 1 chunks!
> 

I have seen the "lost chunks" but thats not always and mostly when I
have run perf record for a very long time. But I have seen this even
with just kernel probes too. So I didnt debug that.

> Using -m 4096 made it work better.
> 
> Adding -g for call-graph profiling caused 'perf report' to lock 
> up:
> 
>   perf record -m 4096 -e probe_libc:free -agR sleep 1
>   perf report
>   [ loops forever ]
> 

This actually works for me.
I had CONFIG_PREEMPT not set. So I set it and tried with and without
Jiri's fix. It still worked for me. Can you pass me your config that
shows this hang so that I can try and fix it.

> I've sent a testcase to Arnaldo separately. Note that perf 
> report --stdio appears to work.

There are no changes in perf report because of uprobes. So the data
collected from uprobes could trigger the hang. I was speculating that
not disabling preemption that Jiri pointed out could be causing this. So
I tried with and without but couldnt reproduce. Can I request you to see
if Jiri's patch helps?

Today with -g option, on one machine I do see a 
$ sudo perf report
perf: Floating point exception

I will take a look at this too. Other machines dont seem to show this
error.

> Regular '-e cycles -g' works fine, so this is a uprobes specific 
> bug.
> 

-- 
Thanks and Regards
Srikar

