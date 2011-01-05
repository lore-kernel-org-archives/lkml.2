Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab1AEPC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:02:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50865 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1AEPC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:02:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tHHmxYUzL01256Pf3FiaMOtsT/A7GUOQXyztCLrcIr2rOy6hqPfyT5WUoiof/ikZE3
         CKvhq4LxfJIowvJLdhQhp7noihOGK49uyFTCA6Lj1Q0NUYaP1dGQAb0YJqDv73HeO0mk
         TJZ3dWr5qdfTM5WrptLOKxs1Qjm8KotSLLTQ0=
Date: Wed, 5 Jan 2011 16:02:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 3/5] ftrace trace event add missing semicolumn
Message-ID: <20110105150245.GA1692@nowhere>
References: <20110104231629.996422888@efficios.com>
 <20110104232419.441463699@efficios.com>
 <20110105000005.GE2911@nowhere>
 <20110105001837.GA9737@Krystal>
 <20110105020759.GG2911@nowhere>
 <20110105023541.GA12950@Krystal>
 <20110105025848.GH2911@nowhere>
 <20110105135242.GC31831@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105135242.GC31831@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 08:52:42AM -0500, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > Hardly, as the real cleanup requires dozens of patches to clean every trace
> > events.
> 
> I know, but it's hardly a large change in terms of lines of code, not
> complexity.

Given the big coverage of such change, requiring routing pieces to relevant
maintainers, care about conflicts, etc... As a reason I'd expect more than just
a semicolon in files.i that almost nobody looks at, except few tracing people
when things break. 

I guess the win is more hiding in the Lttng tree that needs this API requirement
change? It's perfectly fine. But you should come up with stronger arguments to
convince people that the change improves the mainline tracing. The same problem
happened with your __assign() changes lately.

That said I personally don't oppose about the change.


> > So what are these arrays of events you have in mind?
> 
> Currently, Ftrace is creating a "ftrace_define_fields_##call" function for each
> event to define the event fields, which consumes space. It also has the
> ".fields" list head to keep a dynamically generated list of event fields.
> 
> By allowing creation of arrays of events, we can do the following: turn the
> dynamically created list of event fields into a first-level const array listing
> event fields. We can use ARRAY_SIZE() on this array to know its size,
> statically. Then, in a following trace event stage, we can create another const
> array containing tuples of (pointers to the event-specific arrays, array size).
> 
> So we get all the same information Ftrace currently gets with much less code
> overall, much less read-write data, and less dynamic initialization code.
> 
> The following relevant code snippets does the trick. It's extracted from my
> LTTng git tree. Feel free to use any variation of it if you want.
> 
> Thanks,
> 
> Mathieu
> 
> /*
>  * Stage 1 of the trace events.
>  *
>  * Create event field type metadata section.
>  * Each event produce an array of fields.
>  */
> 
> #include "lttng-events-reset.h" /* Reset all macros within TRACE_EVENT */
> 
> /* Named field types must be defined in lttng-types.h */
> 
> #undef __field
> #define __field(_type, _item)                                   \
>         { .name = #_item, .type = { .atype = atype_integer, .name = #_type} },
> 
> [... same for __array, __dynamic_array, __string, ...]
> 
> #undef TP_STRUCT__entry
> #define TP_STRUCT__entry(args...) args  /* Only one used in this phase */
> 
> #undef DECLARE_EVENT_CLASS
> #define DECLARE_EVENT_CLASS(_name, _proto, _args, _tstruct, _assign, _print) \
>         static const struct lttng_event_field __event_fields___##_name[] = { \
>                 _tstruct                                                     \
>         };
> 
> #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
> 
> 
> /*
>  * Stage 2 of the trace events.
>  *
>  * Create an array of events.
>  */
> 
> /* Named field types must be defined in lttng-types.h */
> 
> #include "lttng-events-reset.h" /* Reset all macros within TRACE_EVENT */
> 
> #undef DEFINE_EVENT
> #define DEFINE_EVENT(_template, _name, _proto, _args)                          \
>                 {                                                              \
>                         .fields = __event_fields___##_template,                \
>                         .name = #_name,                                        \
>                         .nr_fields = ARRAY_SIZE(__event_fields___##_template), \
>                 },
> 
> #define TP_ID1(_token, _system) _token##_system
> #define TP_ID(_token, _system)  TP_ID1(_token, _system)
> 
> static const struct lttng_event_desc TP_ID(__event_desc___, TRACE_SYSTEM)[] = {
> #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
> };
> 
> #undef TP_ID1
> #undef TP_ID

Looks good!

I might be missing corner things but it seems this would reduce the code
footprint (one function less) and turn more rw into ro datas.

So it seems to be a very valuable reason to change the semicolon requirement
all over the place.

If you come up with this feature along the massive semicolon requirement change,
we will probably happily apply the whole.

But coming with only the semicolon change is more like an empty shell.
