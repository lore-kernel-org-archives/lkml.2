Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab0EQOZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:25:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61161 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0EQOZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:25:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ShBqcalddMg+a9YWsV2GCPmNWQ87JqI0/VOz8EoIyvf6FPybmcIUcHoLNhm8zM4QC
	eqe48fStu6HEVcCBotHDA==
MIME-Version: 1.0
In-Reply-To: <1273589282.1810.10.camel@laptop>
References: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
	 <1273589282.1810.10.camel@laptop>
Date: Mon, 17 May 2010 16:25:26 +0200
Message-ID: <AANLkTimZrFv7YWOdy6dvtbzFmwB85FyPntZULmN0f6VN@mail.gmail.com>
Subject: Re: [RFC] perf: perf record sets inherit by default
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 4:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-05-11 at 16:04 +0200, Stephane Eranian wrote:
>> Hi,
>>
>>
>> I am confused by the inheritance cmd line option of perf record:
>>
>> $ perf record -h
>>  usage: perf record [<options>] [<command>]
>>     or: perf record [<options>] -- <command> [<options>]
>>
>>     -e, --event <event>   event selector. use 'perf list' to list
>> available events
>>         --filter <filter>
>>                           event filter
>>     -p, --pid <n>         record events on existing process id
>>     -t, --tid <n>         record events on existing thread id
>>     -r, --realtime <n>    collect data with this RT SCHED_FIFO priority
>>     -R, --raw-samples     collect raw sample records from all opened counters
>>     -a, --all-cpus        system-wide collection from all CPUs
>>     -A, --append          append to the output file to do incremental profiling
>>     -C, --profile_cpu <n>
>>                           CPU to profile on
>>     -f, --force           overwrite existing data file (deprecated)
>>     -c, --count           event period to sample
>>     -o, --output <file>   output file name
>>     -i, --inherit         child tasks inherit counters
>>
>> This leads to believe that by default inheritance in children is off.
>>
>> However, builtin-record.c says:
>>
>> static bool                     inherit                         =   true;
>>
>> If that's the case, what's the point of the -i option?
>
> Right, I think we should invert that, does --no-inherit work?
>
>> Another side effect of inheritance is that in per-thread mode,
>> perf creates as many "sessions" as you have CPUs. So
>> on a 16-way processor, sampling on cycles, perf creates
>> 16 events and 16 x 2-page sampling buffers. That's a lot of
>> resources consumed if I am just interested in monitoring
>> a single-threaded workload.
>
> Right, but I think the default of inherit is right, and once you do that
> you basically have to do the per-task-per-cpu thing, otherwise your
> fancy 16-way will start spending most of its time in cacheline bounces.
>
In that case, don't you think you should also ensure that the buffer is
allocated on the NUMA node of the designated per-thread-per-cpu?
I don't think it is the case today.
