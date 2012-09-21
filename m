Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab2IUQOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:14:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab2IUQOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:14:41 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Ky7_2ek-80sA:10 a=wbbZa8dPOpVhAwLHmpQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348244077.13080.84.camel@gandalf.local.home>
Subject: Re: TRACE_EVENT without ARGS
From: Steven Rostedt <rostedt@goodmis.org>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Fri, 21 Sep 2012 12:14:37 -0400
In-Reply-To: <505C8937.4040505@grandegger.com>
References: <505C8937.4040505@grandegger.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-21 at 17:35 +0200, Wolfgang Grandegger wrote:
> Hello,
> 
> I would like to define trace events for functions without arguments,
> e.g. my_yield(). But TRACE_EVENT requires at least one argument to be
> defined and I also have not found an example in the kernel sources,
> apart from:
> 
>   $ cat include/trace/events/xen.h
>   ...
>   TRACE_EVENT(xen_mmu_flush_tlb,
>               TP_PROTO(int x),
>               TP_ARGS(x),
>               TP_STRUCT__entry(__array(char, x, 0)),
>               TP_fast_assign((void)x),
>               TP_printk("%s", "")
>           );
> 
> It uses a dummy argument to work around the problem. Is that the
> recommended way to handle such cases?
> 

Right now this is the only way, because honestly, I was trying to avoid
people from doing this. I'm more worried about people littering the
kernel with these place markers, which give nothing but "I'm hit here".
It would be better to have a 'noinline' to the xen_flush_tlb() call, and
use function tracer to trace it:

	echo xen_flush_tlb > debug/tracing/set_ftrace_filter

But seeing that this just throws in a dummy argument, this doesn't make
things nicer. My worry is about bloat. Each TRACE_EVENT() can add up to
5k to the kernel. When you use the DECLARE_EVENT_CLASS() along with
DEFINE_EVENT(), most of that goes into the DECLARE_EVENT_CLASS, and each
DEFINE_EVENT() adds just about 250 bytes. This is why I push people to
use DEFINE_EVENT, as TRACE_EVENT() is really nothing more than:

#define TRACE_EVENT(...) \
	DECLARE_EVENT_CLASS(..) \
	DEFINE_EVENT(...)


Now maybe I can add something called:

TRACE_MARKER(name);

Where this will create an event that has no fields, and you call this
with: trace_name() and no parameters.

This way, I could probably hack something up that this will be much
smaller, and leave out the creation of fields and related code.

Heck, as it is saving no data, I could make it use a default trace and
perf function that does nothing but state that it was hit.

-- Steve


