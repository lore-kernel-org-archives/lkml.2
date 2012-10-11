Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab2JKW6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:58:25 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:57839 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab2JKW6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:58:23 -0400
MIME-Version: 1.0
In-Reply-To: <1349988183.24256.68.camel@gandalf.local.home>
References: <1349148680-9509-1-git-send-email-dhsharp@google.com>
 <1349148680-9509-3-git-send-email-dhsharp@google.com> <1349988183.24256.68.camel@gandalf.local.home>
From: David Sharp <dhsharp@google.com>
Date: Thu, 11 Oct 2012 15:58:01 -0700
Message-ID: <CAJL_eksyriD3Jmikd5RLMSd2_PSgsnGoruDpZz_CBiZ-Ya603Q@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] tracing: Format non-nanosec times from tsc clock
 without a decimal point.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 1:43 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2012-10-01 at 20:31 -0700, David Sharp wrote:
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
>> +     }
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
>> +     } else if (!verbose && in_ns) {
>> +             ret = trace_seq_printf(
>> +                             s, " %4lldus: ",
>
> Missing %c.
>
>> +                             abs_ts,
>> +                             rel_ts > preempt_mark_thresh_us ? '!' :
>> +                               rel_ts > 1 ? '+' : ' ');
>> +     } else { /* !verbose && !in_ns */
>> +             ret = trace_seq_printf(s, " %4lld%s%c: ", abs_ts);
>
> Um, "%s%c" with no matching arguments.

Sorry for being so sloppy on these patches... Wonder why I didn't see
the printf warnings.

I'll send out an new patchset with this fixed, and include Yoshihiro
Yunomae's patches.

>
> -- Steve
>
>> +     }
>> +     return ret;
>>  }
>>
>
>
