Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985Ab0KPWRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:17:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40436 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab0KPWRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:17:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jrpeQwmqTPFHHCJS8bTikRJUjBGNitnQ03gQHD7+guRd2Lw9ePRktuy5UpZPtH/1qK
         6bARzT+8/7VOv1PKh9ZRxqGErWctjfw+AwwkEwmpPdnBPYhkRMLC2zkCtU3n8C1n9DOa
         oMrcowDGhKmL5soaTZjLVOO7UmkrmVPRu771I=
Date: Tue, 16 Nov 2010 23:17:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
Message-ID: <20101116221726.GB26243@nowhere>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <4CE2F747.4060406@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE2F747.4060406@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 01:27:35PM -0800, Darren Hart wrote:
> On 11/16/2010 01:04 PM, Thomas Gleixner wrote:
>> We are pleased to announce a new tracing tool called 'trace'.
>>
>
> Hi Thomas, Ingo - Congrats and Thanks!
>
>> At this point we'd like to ask for feedback from other users of tracing tools,
>> which workflow components would you like to see in addition to what the 'trace'
>> tool is offering?
>>
>> Comments, bug reports, suggestions welcome,
>
> The first thing that comes to mind is trace_marker:
>
> echo "Test point A" > /sys/kernel/debug/tracing/trace_marker
>
> I've found this sort of markup to be useful using ftrace (with C  
> equivalents embedded in the test case). Is this supported?


No, the trace_marker file sends trace_printk events. And trace_printk
events needs to be converted to use the unified trace event interface
(ie: implement a struct ftrace_event_call).

This shouldn't be so hard, and there are several ways we could do this.

An idea is to reproduce the kernel file hierarchy in a "printk" event
subsystem, but this implies to allow subsystems nesting.

Imagine you have two trace_printk(), one in kernel/sched.c:117
and one in kernel/time/tick-sched.c:228
The result would be:

$ ls /sys/kernel/debug/tracing/events/printk

/sys/kernel/debug/tracing/events/printk:
enable  filter  kernel/

/sys/kernel/debug/tracing/events/printk/kernel:
enable  filter sched.c/ time/

/sys/kernel/debug/tracing/events/printk/kernel/sched.c:
enable  filter  117/

/sys/kernel/debug/tracing/events/printk/kernel/sched.c/117:
enable filter format id

/sys/kernel/debug/tracing/events/printk/kernel/time:
enable  filter tick-sched.c/

/sys/kernel/debug/tracing/events/printk/kernel/time/tick-sched.c:
enable  filter  228/

/sys/kernel/debug/tracing/events/printk/kernel/time/tick-sched.c/228:
enable filter format id


The format would be quite easy, and only one field for the whole string (strloc).

Not sure what to do with trace_marker. I just think we can add it as:
/sys/kernel/debug/tracing/events/printk/sys/kernel/debug/tracing/trace_marker

<:o)


But may be the whole idea is just fancy and nobody will care, and would just
a simple single event in a printk subsystem, on which you can use a kind of
virtual filter:

	echo "path != kernel/whatever.c:226" > /sys/kernel/debug/tracing/events/printk/filter

would turn on every trace_printk() but the one in the given path.

Dunno, I like both ideas. I prefer the first one which looks to me more flexible: could be
useful to list the user his trace_printks for example and implement an interface for him
to quickly select the trace_printk he wants.

For example I'm currently working with dozens of trace_printk() and I would be very happy
to turn some of them off half of the time.

