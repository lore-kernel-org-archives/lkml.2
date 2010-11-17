Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495Ab0KQPCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:02:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53676 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab0KQPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:02:45 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=2kSzP4yT2LoA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=FD8hK331BKvw8mrw_coA:9 a=ve-AGOkLlbpImW6calTJ5jzepTEA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <20101117141031.GH5464@nowhere>
References: <4CE2F747.4060406@linux.intel.com>
	 <20101116221726.GB26243@nowhere> <20101117083020.GA11336@elte.hu>
	 <1289993750.2109.718.camel@laptop> <20101117125344.GC5464@nowhere>
	 <1289998957.2109.751.camel@laptop> <20101117131023.GE27063@elte.hu>
	 <1290000976.2109.782.camel@laptop> <20101117134300.GG5464@nowhere>
	 <1290002029.2109.799.camel@laptop>  <20101117141031.GH5464@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 17 Nov 2010 10:02:41 -0500
Message-ID: <1290006161.30543.54.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 15:10 +0100, Frederic Weisbecker wrote:

> Yeah I have a strange workflow. I'm working on that CPU isolation thing
> and I have dozens of trace_printk all over the place for tons of
> things. And everytime I remove one to unwind some output or to focus
> on another one, I often have to restore it later because I need it
> again. Usually I even just comment it out instead of removing it.
> 
> If I could make this dynamically on a per line filtering, or sometimes on
> a per file granularity (as both are equally often the case for me), I would
> probably win some time.
> 
> I just don't know how many developers have a similar workflow than mine.

I usually wrap trace_printk() (or printk sometimes) in my own wrapper:

#define sprintk(on, x...) do { if (on) { trace_prinkt(x); } } while (0)

Then have things like:

#define SDR_DEBUG_IRQS 0
#define SDR_DEBUG_SCHED 1
[...]

and in the irq code I'll have:

	sprintk(SDR_DEBUG_IRQS, "printme"...);

and the sched code:

	sprintk(SDR_DEBUG_SCHED, "printthis"...);

And I can easily enable or disable the prints I want. Sometimes I'll
define it as a variable, and enable them either in certain code paths,
or export them in the debugfs system and enable or disable them from
userspace.

extern int sdr_debug_irqs;
#define SDR_DEBUG_IRQS sdr_debug_irqs

[...]
int sdr_debug_irqs;
[...]

	debugfs_create_bool("sdr_debug_sched", 0644, NULL, &sdr_debug_irqs);

Of course this is all for temporary debugging. I use SDR and sdr and
sprintk to search and delete the debugging output when done.

-- Steve


