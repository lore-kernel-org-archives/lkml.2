Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab0HYFrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 01:47:52 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:40241 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab0HYFru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 01:47:50 -0400
X-AuditID: b753bd60-aa2deba000000a18-47-4c74ae836b45
Message-ID: <4C74AE7B.1010705@hitachi.com>
Date: Wed, 25 Aug 2010 14:47:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        2nddept-manager@sdl.hitachi.co.jp, Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Using perf probe with arguments throws a fatal error.
References: <20100824045758.GA14431@linux.vnet.ibm.com> <4C738411.8080602@hitachi.com> <20100824085401.GB14431@linux.vnet.ibm.com> <4C738F09.3080108@hitachi.com> <20100824095658.GC14431@linux.vnet.ibm.com>
In-Reply-To: <20100824095658.GC14431@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/08/24 18:56), Srikar Dronamraju wrote:
>>>
>>> 1000 [srikar@llm69 uprobesv3.git]$  cat
>>> /sys/kernel/debug/tracing/events/probe/do_fork/format
>>> name: do_fork
>>> ID: 817
>>> format:
>>>         field:unsigned short common_type;       offset:0; size:2; signed:0;
>>>         field:unsigned char common_flags;       offset:2; size:1; signed:0;
>>>         field:unsigned char common_preempt_count;       offset:3; size:1; signed:0;
>>>         field:int common_pid;   offset:4;       size:4; signed:1;
>>>         field:int common_lock_depth;    offset:8;       size:4; signed:1;
>>>
>>>         field:unsigned long __probe_ip; offset:16;      size:8; signed:0;
>>>         field:u64 %ip;  offset:24;      size:8; signed:0;
>>
>> Hmm, it could be caused by "u64"...
>> OK, maybe I should update perf to support those.
>>
>> BTW, let me check that you use perf for the latest kernel?
>>
> 
> 
> Yes, I am using perf from latest kernel and this happens on both x86
> and x86_64 boxes.
> 
> Just for curiosity I tried printing the format for perf probe
> do_fork ip=%ip and here it is 
> 
> 1001 [srikar@llm69 uprobesv3.git]$ sudo perf probe do_fork ip=%ip 
> 1001 [srikar@llm69 uprobesv3.git]$ cat /sys/kernel/debug/tracing/events/probe/do_fork/format 
> name: do_fork
> ID: 818
> format:
>         field:unsigned short common_type;       offset:0; size:2; signed:0;
>         field:unsigned char common_flags;       offset:2; size:1; signed:0;
>         field:unsigned char common_preempt_count;       offset:3; size:1; signed:0;
>         field:int common_pid;   offset:4;       size:4; signed:1;
>         field:int common_lock_depth;    offset:8;       size:4; signed:1;
> 
>         field:unsigned long __probe_ip; offset:16;      size:8; signed:0;
>         field:u64 ip;   offset:24;      size:8; signed:0;
> 	          ^^
> 
> print fmt: "(%lx) ip=%llx", REC->__probe_ip, REC->ip
>                   ^^				 ^^
> 
> The differences I see when a name is given we refer the name, while in
> the previous case we refer the register %ip.

Ah, I remembered that, yeah, perf doesn't support those raw regsiters,
dereferences, etc.
Hmm, this should be solved, but not so simple as just removing "%",
because there are also special variables ($retval, $stack) and
dereferences(+8(+10(%sp)), etc).

I think the simplest solution is just setting "argX" name for each
argument (if user omitted its name) in kprobe-tracer (because
trace-cmd will face same problem).
e.g.
 # echo "p do_fork %ip" > tracing/kprobe_events
will be translated as below
 # echo "p do_fork arg1=%ip" > tracing/kprobe_events

Thank you,


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
