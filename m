Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab2DXCTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 22:19:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:52428 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab2DXCTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 22:19:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="133067196"
Message-ID: <1335233988.14538.95.camel@ymzhang.sh.intel.com>
Subject: Re: [RFC 1/2] kernel patch for dump user space stack tool
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Date: Tue, 24 Apr 2012 10:19:48 +0800
In-Reply-To: <1334915668.2463.43.camel@laptop>
References: <EE928378561BF1449699C96571234A740FCED62F@SHSMSX101.ccr.corp.intel.com>
	 <4F8F8B9E.3040107@gmail.com>
	 <1334812653.14538.29.camel@ymzhang.sh.intel.com>
	 <1334915668.2463.43.camel@laptop>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 11:54 +0200, Peter Zijlstra wrote:
> On Thu, 2012-04-19 at 13:17 +0800, Yanmin Zhang wrote:
> > 1) We could collect the HEX-format call chain data and /proc/XXX/maps
> > of all the processes quickly, then parse them either after rebooting, or
> > after the issue is reported. It could catch the scene just at the time point
> > when the error happens. Our experiments shows the tool could collect the data
> > of all processes within 200ms.
> 
> No you can't, ever heard of address space randomization?
No. I googled it a moment ago. Here is my understanding.
ALSR is a security feature. OS arranges the mmap areas randomly. It means
the mmap space might be changed when the same executable runs twice.

Is my understanding correct?

Answer:
With our tool, we collect both user space stack data and /proc/XXX/maps,
and save them to a trace file. Then, parse them either immediately, or
after system reboots.

> 
> > 2) The new tool won't stop the processes and have less impact on them.
> > Considering a scenario of performance bottleneck investigation, statistics collection
> > shouldn't have big impact on running processes. 
> 
> Maybe.. on these tiny systems you're working on most tasks will not be
> runnable anyway since you only have 1 (maybe 2) cpus and what's running
> is your dumper process, so most everything isn't runnable, attaching and
> dumping stack of all tasks isn't really much more expensive than this.
I raised at least 2 usage scenarios. The one is Android OS ANR issue.
The other is the performance bottleneck investigation on _server_.
Android OS does run on a small system with 1 to 2 cpu (might with 4 cores,
but not popular now). It's not so simple like what you said to collect the
user space stacks of all processes by ptrace interface. We did the experiment
and the collection is time-consuming, sometimes even not endurable.

In addition, We extended the patch on our system to dump the user stacks of
all processes when system hangs. Current patch sent to LKML doesn't include it.

> the open/read/close you do on the proc files, along with the readdir
> etc.. are system-calls just like the ptrace alternative.
Good point.
1) With ptrace, there is a syscall when fetching only one call frame.
With our tool, there is only one mostly.
2) With ptrace, we need stop the processes. With Android OS on a small
system, it seems ok like what you said. But with performance tuning on
a large server, it's not ok.

> 
> > 3) It could support both i386 and x86-64. I tried pstack and it doesn't work
> > with x86-64.
> 
> Yeah, and you'll need to extend it to ARM/MIPS/etc..
It's a problem. We implement it on x86 firstly. If it's good, others would
port it to other platforms.

>  whereas there is
> plenty of userspace around that can already work on all those platforms
> -- if pstack cannot its weird, I'd think it would use all the regular
> binutils muck that already supports all the platforms.
Would you like to give me a pointer about the tools in binutils?

> 
> > 4) It follows /proc/XXX/stack interface and it's easy to use it.
> 
> Uhm, not so very much, see your ASLR issue. 


> Furthermore it requires all
> userspace be build with framepointers enabled -- which I think would be
> a good thing anyway -- but with which reality seems to disagree.
You are right indeed. The tool is for debugger and developers.

In addition, I am thinking if we might extend the tool to dump user stack
with blur (or not precise) data, which could just dump the stack from $esp.
The final symbol dump looks like the symbol lines with ? in the output of
dump_stack.
For example, we define the shorted distance between calling in the stack,
and check if the data in the stack maps in a real VMA.
With the blur data, developers could get some good hint at least. As you know,
sometimes, we couldn't get the source codes of some libraries and recompile
them.

Thanks for the kind comments.

Yanmin


