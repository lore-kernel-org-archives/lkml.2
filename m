Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2IZVEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 17:04:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59603 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2IZVEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 17:04:08 -0400
MIME-Version: 1.0
In-Reply-To: <1348684250.22822.59.camel@gandalf.local.home>
References: <CAJL_ekvRFSDkFMmTyKD1-RTE2J=ajTdhb0s5TKmbVVKLRzakmw@mail.gmail.com>
 <1348612174-19881-1-git-send-email-dhsharp@google.com> <1348684250.22822.59.camel@gandalf.local.home>
From: David Sharp <dhsharp@google.com>
Date: Wed, 26 Sep 2012 14:03:46 -0700
Message-ID: <CAJL_ekvgPZJqXx5Mosq-WOiUNj+1XFiMGLzoy1M8Cr3h=++LGQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] tracing: format non-nanosec times from tsc clock
 without a decimal point.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 11:30 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2012-09-25 at 15:29 -0700, David Sharp wrote:
>
>>  static int
>> -lat_print_timestamp(struct trace_seq *s, u64 abs_usecs,
>> -                 unsigned long rel_usecs)
>> +lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
>>  {
>> -     return trace_seq_printf(s, " %4lldus%c: ", abs_usecs,
>> -                             rel_usecs > preempt_mark_thresh ? '!' :
>> -                               rel_usecs > 1 ? '+' : ' ');
>> +     unsigned long verbose = trace_flags & TRACE_ITER_VERBOSE;
>> +     unsigned long in_ns = iter->iter_flags & TRACE_FILE_TIME_IN_NS;
>> +     unsigned long long abs_ts = iter->ts - iter->tr->time_start;
>> +     unsigned long long rel_ts = next_ts - iter->ts;
>> +     struct trace_seq *s = &iter->seq;
>> +     unsigned long mark_thresh;
>> +     int ret;
>> +
>> +     if (in_ns) {
>> +             abs_ts = ns2usecs(abs_ts);
>> +             rel_ts = ns2usecs(rel_ts);
>> +             mark_thresh = preempt_mark_thresh_us;
>> +     } else
>> +             mark_thresh = preempt_mark_thresh_cycles;
>> +
>> +     if (verbose && in_ns) {
>> +             unsigned long abs_msec = abs_ts;
>> +             unsigned long abs_usec = do_div(abs_msec, USEC_PER_MSEC);
>> +             unsigned long rel_msec = rel_ts;
>> +             unsigned long rel_usec = do_div(rel_msec, USEC_PER_MSEC);
>> +
>> +             ret = trace_seq_printf(
>> +                             s, "[%08llx] %ld.%03ldms (+%ld.%03ldms): ",
>> +                             ns2usecs(iter->ts),
>> +                             abs_msec, abs_usec,
>> +                             rel_msec, rel_usec);
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
>
> I still think the annotations are meaningless for counters. Even if the
> counter is a timer like the tsc, as it does not coincide with real time
> (us), I say just don't print it for counters.

Sounds fine to me, as that's the easiest modification anyway. Done.

>
> This is not helpful:
>
> <snip>

Agreed. The other way to fix it would have been to change the "+"
threshold from 1 to ~2000.

>
>
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
>> @@ -644,8 +680,13 @@ int trace_print_context(struct trace_iterator *iter)
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
>
> You took away the space before %5.
>
>> +     } else
>> +             return trace_seq_printf(s, "%12llu: ", iter->ts);
>
> here too.

Don't know why I would have changed that... Fixed.

>>  }
>>
>>  int trace_print_lat_context(struct trace_iterator *iter)
>> @@ -659,36 +700,29 @@ int trace_print_lat_context(struct trace_iterator *iter)
>>                          *next_entry = trace_find_next_entry(iter, NULL,
>>                                                              &next_ts);
>>       unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
>> -     unsigned long abs_usecs = ns2usecs(iter->ts - iter->tr->time_start);
>> -     unsigned long rel_usecs;
>>
>>       /* Restore the original ent_size */
>>       iter->ent_size = ent_size;
>>
>>       if (!next_entry)
>>               next_ts = iter->ts;
>> -     rel_usecs = ns2usecs(next_ts - iter->ts);
>
>
