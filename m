Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2AQKbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:31:45 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:52802 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2AQKbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:31:43 -0500
Date: Tue, 17 Jan 2012 15:52:32 +0530
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
Message-ID: <20120117102231.GB15447@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com>
 <20120110114943.17610.28293.sendpatchset@srdronam.in.ibm.com>
 <20120116131137.GB5265@m.brq.redhat.com>
 <20120117092838.GB10397@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120117092838.GB10397@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12011710-3270-0000-0000-00000343FBB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > and commands like:
> >         perf record -a -e probe_libc:free  --filter "common_pid == 1127"
> >         perf record -e probe_libc:free --filter "arg1 == 0xa" ls
> > 
> > got me proper results.
> 
> Btw., Srikar, if that's the primary UI today then we'll need to 
> make it a *lot* more user-friendly than the above usage 
> workflow.
> 
> In particular this line:
> 
> >         echo "p:probe_libc/free /lib64/libc-2.13.so:0x7a4f0 %ax" > ./uprobe_events
> 
> is not something a mere mortal will be able to figure out.

Agree, perf probe is the primary interface to use uprobes.

> 
> There needs to be perf probe integration, that allows intuitive 
> usage, such as:
> 
>    perf probe add libc:free

Current usage is like perf probe -x <executable> -a <func1> -a <func2>
So we could use
perf probe -x /lib64/libc.so.6 free

or 
perf probe -x /lib64/libc.so.6 -a free -a malloc -a strcpy

The -x option helps perf to identify  that its a user space based probing.
This currently restricts that all probes defined per "perf probe"
invocation to just one executable. This usage was suggested by Masami.

Earlier we used perf probe free@/lib/libc.so.6 malloc@/lib/libc.so.6
The objection for this was that perf was already using @ to signify
source file. Similarly : is already used for Relative line number.

This also goes with perf probe -F -x /lib64/libc.so to list the
available probes in libc.

> 
> Using the perf symbols code it should first search a libc*so DSO 
> in the system, finding say /lib64/libc-2.15.so. The 'free' 
> symbol is readily available there:

While I understand the ease of using a libc instead of the full path, I
think it does have few issues.
- Do we need to keep checking if the new files created in the system
  match the pattern and if they match the pattern, dynamically add the
  files?

- Also the current model helps if the user wants to restrict his trace
  to particular executable where there are more that one executable with
  the same name.

> 
>   aldebaran:~> eu-readelf -s /lib64/libc-2.15.so  | grep ' free$'
>   7186: 00000039ff47f080    224 FUNC    GLOBAL DEFAULT       12 free
> 
> then the tool can automatically turn that symbol information 
> into the specific probe.
> 

Given a function in an executable, we are 

> Will it all work with DSO randomization, prelinking and default 
> placement as well?

Works with DSO randomization, I havent tried with prelinking.  did you
mean http://en.wikipedia.org/wiki/Placement_syntax#Default_placement
when you said default placement?


> 
> Users should not be expected to enter magic hexa numbers to get 
> a trivial usecase going ...

yes, that why we dont allow perf probe -x /lib/libc.so.6 0x1234

> 
> this bit:
> 
> >         perf record -a -e probe_libc:free  --filter "common_pid == 1127"
> >         perf record -e probe_libc:free --filter "arg1 == 0xa" ls
> 
> looks good and intuitive and 'perf list' should list all the 
> available uprobes.

Currently "perf probe -F -x /bin/zsh" lists all available functions in
zsh. perf probe --list has been enhanced to show uprobes that are
already registered.

Similar to kprobes based probes, available user space probes are not
part of "perf list".
> 
> Thanks,
> 
> 	Ingo
> 

