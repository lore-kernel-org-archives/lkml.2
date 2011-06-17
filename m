Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873Ab1FQONY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:13:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41206 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab1FQONV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:13:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FKRV91R0GTCMKXLUmm7HzwW3xoFmzgptnp3Zihu/OzCiFWTFdwybxbaGGXs+0sPKua
         D9uqpahhKrQMc2W5eK5Id6pvW92asUn0go3yE6ce28wjrmm471ahkgQ628ZrvfTMVzWA
         K6E6LGrnJfkSZNk+NWgv8QxXVmXUVjQs0Jw3c=
Message-ID: <4DFB60FF.1080500@gmail.com>
Date: Fri, 17 Jun 2011 08:13:19 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de, johnstul@us.ibm.com,
        rostedt@goodmis.org
Subject: Re: [PATCH 1/6] trace: add tracepoints to timekeeping code - xtime
 changes
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com> <1307490903-24600-1-git-send-email-dsahern@gmail.com> <20110617132322.GB25197@somewhere.redhat.com>
In-Reply-To: <20110617132322.GB25197@somewhere.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/17/2011 07:23 AM, Frederic Weisbecker wrote:
> On Tue, Jun 07, 2011 at 05:55:03PM -0600, David Ahern wrote:
>> Trace points in timekeeping.c where xtime is modified by a user
>> or ntp.
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> ---
>>  include/trace/events/timekeeping.h |   43 ++++++++++++++++++++++++++++++++++++
>>  kernel/time/timekeeping.c          |    8 ++++++
>>  2 files changed, 51 insertions(+), 0 deletions(-)
>>  create mode 100644 include/trace/events/timekeeping.h
>>
>> diff --git a/include/trace/events/timekeeping.h b/include/trace/events/timekeeping.h
>> new file mode 100644
>> index 0000000..3d5d083
>> --- /dev/null
>> +++ b/include/trace/events/timekeeping.h
>> @@ -0,0 +1,43 @@
>> +#undef TRACE_SYSTEM
>> +#define TRACE_SYSTEM timekeeping
>> +
>> +#if !defined(_TRACE_TIMEKEEP_H) || defined(TRACE_HEADER_MULTI_READ)
>> +#define _TRACE_TIMEKEEP_H
>> +
>> +#include <linux/tracepoint.h>
>> +#include <linux/time.h>
>> +
>> +DECLARE_EVENT_CLASS(tod_template,
>> +
>> +	TP_PROTO(const struct timespec *tv),
>> +
>> +	TP_ARGS(tv),
>> +
>> +	TP_STRUCT__entry(
>> +		__field( __kernel_time_t,	tv_sec)
>> +		__field( long,			tv_nsec)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->tv_sec  = tv->tv_sec;
>> +		__entry->tv_nsec = tv->tv_nsec;
>> +	),
>> +
>> +	TP_printk("tv_sec=%ld tv_nsec=%ld", __entry->tv_sec, __entry->tv_nsec)
>> +);
>> +
>> +DEFINE_EVENT(tod_template, settimeofday,
>> +	TP_PROTO(const struct timespec *tv),
>> +	TP_ARGS(tv));
>> +
>> +DEFINE_EVENT(tod_template, timekeeping_inject_offset,
>> +	TP_PROTO(const struct timespec *tv),
>> +	TP_ARGS(tv));
>> +
>> +DEFINE_EVENT(tod_template, timekeeping_inject_sleeptime,
>> +	TP_PROTO(const struct timespec *tv),
>> +	TP_ARGS(tv));
> 
> Does the fact it's any of the three way of updating xtime make any
> difference from the user point of view?

This use case only cares that xtime is updated.

> 
> If not can we rather factorize that in a single settimeofday tracepoint?
> Or update_time_of_day if we don't want to confuse the user with the
> syscall.

Peter and Thomas expressed interest in timekeeping tracepoints. How the
update happens might be wanted. If desired I can consolidate xtime = *tv
into a single update function and put the trace point there.

David
