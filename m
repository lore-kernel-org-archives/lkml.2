Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0GABkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 21:40:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34072 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab0GABkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 21:40:39 -0400
X-Authority-Analysis: v=1.1 cv=jfMbZ+4tkgrYlaJBi3iJCtg6TDszHDHJJpQ3TdTfnr0= c=1 sm=0 a=rrc4SAMfR1kA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=1EZYRgFDiBohhUdhB6cA:9 a=PKKLIv8FU-eRQRaiFlUA:7 a=-34yZdvF7seyVTLOgE2ye1xJMocA:4 a=PUjeQqilurYA:10 a=WDtyTDSDkcMvSxWU:21 a=FYuSqRkW09uSbEh2:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: shrink max latency ringbuffer if unnecessary
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100630120419.391D.A69D9226@jp.fujitsu.com>
References: <20100630120419.391D.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 30 Jun 2010 21:40:36 -0400
Message-ID: <1277948436.25782.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki,

FYI, could you send emails to my goodmis account. I can easily miss
emails sent to my RH account since it is usually flooded with RH
Bugzilla reports.

(more below)

On Wed, 2010-06-30 at 12:06 +0900, KOSAKI Motohiro wrote:
> Documentation/trace/ftrace.txt says
> 
>   buffer_size_kb:
> 
>         This sets or displays the number of kilobytes each CPU
>         buffer can hold. The tracer buffers are the same size
>         for each CPU. The displayed number is the size of the
>         CPU buffer and not total size of all buffers. The
>         trace buffers are allocated in pages (blocks of memory
>         that the kernel uses for allocation, usually 4 KB in size).
>         If the last page allocated has room for more bytes
>         than requested, the rest of the page will be used,
>         making the actual allocation bigger than requested.
>         ( Note, the size may not be a multiple of the page size
>           due to buffer management overhead. )
> 
>         This can only be updated when the current_tracer
>         is set to "nop".
> 
> But it's incorrect. currently total memory consumption is
> 'buffer_size_kb x CPUs x 2'.
> 
> Why two times difference is there? because ftrace implicitly allocate
> the buffer for max latency too.
> 
> That makes sad result when admin want to use large buffer. (If admin
> want full logging and makes detail analysis). example, If admin
> have 24 CPUs machine and write 200MB to buffer_size_kb, the system
> consume ~10GB memory (200MB x 24 x 2). umm.. 5GB memory waste is
> usually unacceptable.
> 
> Fortunatelly, almost all users don't use max latency feature.
> The max latency buffer can be disabled easily.
> 
> This patch shrink buffer size of the max latency buffer if
> unnecessary.

Actually, what would be better is to add a "use_max_tr" field to the
struct tracer in trace.h.  Then the latency tracers (irqsoff,
preemptoff, preemptirqsoff, wakeup, and wakeup_rt) can have this field
set.

Then, we can resize or even remove the max ring buffer when the
"use_max_tr" is not set (and on bootup). On enabling a latency tracer,
we can allocate the buffer. When we enable another tracer (or nop) if
the use_max_tr is not set, then we can remove the buffer.

Would you be able to do something like that?

Thanks,

-- Steve


