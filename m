Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab2IYUtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 16:49:07 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56129 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab2IYUtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 16:49:04 -0400
MIME-Version: 1.0
In-Reply-To: <1348543635.22822.9.camel@gandalf.local.home>
References: <1348148044.13080.59.camel@gandalf.local.home> <1348181550-21931-1-git-send-email-dhsharp@google.com>
 <1348181550-21931-3-git-send-email-dhsharp@google.com> <1348543635.22822.9.camel@gandalf.local.home>
From: David Sharp <dhsharp@google.com>
Date: Tue, 25 Sep 2012 13:48:42 -0700
Message-ID: <CAJL_eks01XMbcXJ3+EXy16Jy3hpX0Ti-BA57vH3fvYWmKS8=9g@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] tracing: format non-nanosec times from tsc clock
 without a decimal point.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 8:27 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2012-09-20 at 15:52 -0700, David Sharp wrote:
>> With the addition of the "tsc" clock, formatting timestamps to look like
>> fractional seconds is misleading. Mark clocks as either in nanoseconds or
>> not, and format non-nanosecond timestamps as decimal integers.
>
> I got this:
>
> /work/autotest/nobackup/linux-test.git/kernel/trace/trace_output.c:636: undefined reference to `__umoddi3'
> /work/autotest/nobackup/linux-test.git/kernel/trace/trace_output.c:636: undefined reference to `__udivdi3'
> /work/autotest/nobackup/linux-test.git/kernel/trace/trace_output.c:636: undefined reference to `__umoddi3'
> /work/autotest/nobackup/linux-test.git/kernel/trace/trace_output.c:636: undefined reference to `__umoddi3'
> /work/autotest/nobackup/linux-test.git/kernel/trace/trace_output.c:636: undefined reference to `__udivdi3'
> /work/autotest/nobackup/linux-test.git/kernel/trace/trace_output.c:636: undefined reference to `__umoddi3'
> /work/autotest/nobackup/linux-test.git/kernel/trace/trace_output.c:636: undefined reference to `__udivdi3'
>
> when building for x86_32.
>
>> +     int ret;
>> +     struct trace_seq *s = &iter->seq;
>> +     unsigned long verbose = trace_flags & TRACE_ITER_VERBOSE;
>> +     unsigned long in_ns = iter->iter_flags & TRACE_FILE_TIME_IN_NS;
>> +     unsigned long long abs_ts = iter->ts - iter->tr->time_start;
>> +     unsigned long long rel_ts = next_ts - iter->ts;
>> +     unsigned long mark_thresh;
>> +
>> +     if (in_ns) {
>> +             abs_ts = ns2usecs(abs_ts);
>> +             rel_ts = ns2usecs(rel_ts);
>> +             mark_thresh = preempt_mark_thresh_us;
>> +     } else
>> +             mark_thresh = preempt_mark_thresh_cycles;
>> +
>> +     if (verbose && in_ns) {
>> +             ret = trace_seq_printf(
>> +                             s, "[%08llx] %lld.%03lldms (+%lld.%03lldms): ",
>> +                             ns2usecs(iter->ts),
>> +                             abs_ts / USEC_PER_MSEC,
>> +                             abs_ts % USEC_PER_MSEC,
>> +                             rel_ts / USEC_PER_MSEC,
>
> You can't divide 64 bit numbers in the kernel. It breaks on 32bit archs.

I didn't realize that. Sorry. Not sure why I changed them to long long
in the first place.

Although, that does mean that it is currently overflowing every 4.29
seconds. I may as well fix that.

>
> -- Steve
>
>> +                             rel_ts % USEC_PER_MSEC);
>> +     } else if (verbose && !in_ns) {
>> +             ret = trace_seq_printf(
>> +                             s, "[%016llx] %lld (+%lld): ",
>> +                             iter->ts, abs_ts, rel_ts);
>> +     } else { /* !verbose */
>> +             ret = trace_seq_printf(
>> +                             s, " %4lld%s%c: ",
>> +                             abs_ts,
>> +                             in_ns ? "us" : "",
>> +                             rel_ts > mark_thresh ? '!' :
>> +                               rel_ts > 1 ? '+' : ' ');
>> +     }
>> +     return ret;
>>  }
>>
>>  int trace_print_context(struct trace_iterator *iter)
>>  {
>>       struct trace_seq *s = &iter->seq;
>>       struct trace_entry *entry = iter->ent;
>> -     unsigned long long t = ns2usecs(iter->ts);
>> -     unsigned long usec_rem = do_div(t, USEC_PER_SEC);
>> -     unsigned long secs = (unsigned long)t;
>> +     unsigned long long t;
>> +     unsigned long secs, usec_rem;
>>       char comm[TASK_COMM_LEN];
>>       int ret;
>>
>> @@ -644,8 +677,13 @@ int trace_print_context(struct trace_iterator *iter)
>>                       return 0;
>>       }
>>
>> -     return trace_seq_printf(s, " %5lu.%06lu: ",
>> -                             secs, usec_rem);
>> +     if (iter->iter_flags & TRACE_FILE_TIME_IN_NS) {
>> +             t = ns2usecs(iter->ts);
>> +             usec_rem = do_div(t, USEC_PER_SEC);
>> +             secs = (unsigned long)t;
>> +             return trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
>> +     } else
>> +             return trace_seq_printf(s, "%12llu: ", iter->ts);
>>  }
>>
>>  int trace_print_lat_context(struct trace_iterator *iter)
>> @@ -659,36 +697,30 @@ int trace_print_lat_context(struct trace_iterator *iter)
>>                          *next_entry = trace_find_next_entry(iter, NULL,
>>                                                              &next_ts);
>>       unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
>> -     unsigned long abs_usecs = ns2usecs(iter->ts - iter->tr->time_start);
>> -     unsigned long rel_usecs;
>> +
>>
>>       /* Restore the original ent_size */
>>       iter->ent_size = ent_size;
>>
>>       if (!next_entry)
>>               next_ts = iter->ts;
>> -     rel_usecs = ns2usecs(next_ts - iter->ts);
>>
>>       if (verbose) {
>>               char comm[TASK_COMM_LEN];
>>
>>               trace_find_cmdline(entry->pid, comm);
>>
>> -             ret = trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08llx]"
>> -                                    " %ld.%03ldms (+%ld.%03ldms): ", comm,
>> -                                    entry->pid, iter->cpu, entry->flags,
>> -                                    entry->preempt_count, iter->idx,
>> -                                    ns2usecs(iter->ts),
>> -                                    abs_usecs / USEC_PER_MSEC,
>> -                                    abs_usecs % USEC_PER_MSEC,
>> -                                    rel_usecs / USEC_PER_MSEC,
>> -                                    rel_usecs % USEC_PER_MSEC);
>> +             ret = trace_seq_printf(
>> +                             s, "%16s %5d %3d %d %08x %08lx ",
>> +                             comm, entry->pid, iter->cpu, entry->flags,
>> +                             entry->preempt_count, iter->idx);
>>       } else {
>>               ret = lat_print_generic(s, entry, iter->cpu);
>> -             if (ret)
>> -                     ret = lat_print_timestamp(s, abs_usecs, rel_usecs);
>>       }
>>
>> +     if (ret)
>> +             ret = lat_print_timestamp(iter, next_ts);
>> +
>>       return ret;
>>  }
>>
>
>
