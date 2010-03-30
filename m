Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0C3VfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 17:35:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47211 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab0C3VfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 17:35:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=uQbi/tGI4ZBbaquTQCQJL8L3qm7c1B7piw09ooPpr4IjWP9mhZX9FN6UfRd3PefnWE
         c6Z2gFz9TFoFoWYDU+daTwzYPB/HAxrcuu0W7bhCamGDTRQNRmDKoxZ9jaS+F8ETodX3
         SgIPw4qj/uBwz+xQ0sDN9TgC647vfW7orzpew=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <4BB22BB0.8030208@linux.vnet.ibm.com>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
	 <d3f22a1003290213x7d7904an59d50eb6a8616133@mail.gmail.com>
	 <1269934931.8575.6.camel@minggr.sh.intel.com>
	 <4BB22BB0.8030208@linux.vnet.ibm.com>
Date: Tue, 30 Mar 2010 23:28:42 +0200
Message-ID: <u2h7c86c4471003301428v9189ccbesec68ee149dfe9f@mail.gmail.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: stephane eranian <eranian@googlemail.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 6:49 PM, Corey Ashford
<cjashfor@linux.vnet.ibm.com> wrote:
> On 03/30/2010 12:42 AM, Lin Ming wrote:
>>
>> Hi, Corey
>>
>> How is this going now? Are you still working on this?
>> I'd like to help to add support for uncore, test, write code or anything
>> else.
>>
>> Thanks,
>> Lin Ming
>
> I haven't been actively working on adding infrastructure for nest PMUs yet.
>  At the moment we are working on supporting nest events for IBM's Wire-Speed
> processor, using the current infrastructure, because of the time
> limitations.  Using the existing infrastructure is definitely not ideal, but
> for this processor, it's workable.
>
> There are still a lot of issues to solve for adding this infrastructure:
>
> 1) Does perf_events need a new context type (in addition to per-task and
> per-cpu)?  This is partly because we don't want to be mixing the rotation of
> CPU-events with nest events.  Each PMU really ought to have its own event
> list.
>
I concur with the fact that you don't want to mix events form
different PMUs in the
same rotation list. There are some side effects of not doing this with
AMD64 Northbridge
events when you have multiple concurrent sessions. But this is a special case
where the "uncore" (nest) PMU is actually controlled via the core PMU. I think
that is okay for now, but you certainly don't want that for Nehalem uncore, for
instance.

> 2) How do we deal with accessing PMU's which require slow access methods
> (e.g. internal serial bus)?  The accesses may need to be placed on worker
> threads so that they don't affect the performance of context switches and
> system ticks.
>
> 3) How exactly do we represent the PMU's in the pseudofs (/sys or /proc)?
>  And how exactly does the user specify the PMU to perf_events?
> Peter Zijlstra and Stephane Eranian both recommended opening the PMU with
> open() and then passing the resulting fd in through the perf_event_attr
> struct.
>
> 4) How do we choose a CPU to do the housekeeping work for a particular nest
> PMU.  Peter thought that user space should still specify the it via
> open_perf_event() cpu parameter, but there's also an argument to be made for
> the kernel choosing the best CPU to handle the job, or at least make it
> optional for the user to choose the CPU.
>
One of the housekeeping task is to handle uncore PMU interrupts, for instance.
That is not a trivial task given that events are managed independently and
that you could be monitoring per-thread or system-wide. It may be that
some uncore PMU can only interrupt one core. Intel Nehalem can interrupt
many at once.
