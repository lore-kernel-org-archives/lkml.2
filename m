Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028Ab2BJTqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:46:46 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51030 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759958Ab2BJTqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:46:45 -0500
Message-ID: <4F357420.6030603@gmail.com>
Date: Fri, 10 Feb 2012 12:46:40 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf tools: Allow multiple threads or processes in record,
 stat, top
References: <1328718772-16688-1-git-send-email-dsahern@gmail.com> <20120210192402.GJ2526@infradead.org> <4F3570B9.5090708@gmail.com> <20120210193429.GL2526@infradead.org>
In-Reply-To: <20120210193429.GL2526@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/10/2012 12:34 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Feb 10, 2012 at 12:32:09PM -0700, David Ahern escreveu:
>>
>>
>> On 02/10/2012 12:24 PM, Arnaldo Carvalho de Melo wrote:
>>> Em Wed, Feb 08, 2012 at 09:32:52AM -0700, David Ahern escreveu:
>>>> Allow a user to collect events for multiple threads or processes
>>>> using a comma separated list.
>>>>
>>>> e.g., collect data on a VM and its vhost thread:
>>>>   perf top -p 21483,21485
>>>>   perf stat -p 21483,21485 -ddd
>>>>   perf record -p 21483,21485
>>>>
>>>> or monitoring vcpu threads
>>>>   perf top -t 21488,21489
>>>>   perf stat -t 21488,21489 -ddd
>>>>   perf record -t 21488,21489
>>>
>>> I found some problems below:
>>>  
>>>> diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
>>>> index 3d4b6c5..e793c16 100644
>>>> --- a/tools/perf/util/thread_map.c
>>>> +++ b/tools/perf/util/thread_map.c
>>>> +static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
>>>> +{
>>>> +	struct thread_map *threads = NULL;
>>> <SNIP>
>>>> +		if (threads)
>>>> +			threads = realloc(threads,
>>>> +					  sizeof(*threads) + sizeof(pid_t)*total_tasks);
>>>> +		else
>>>> +			threads = malloc(sizeof(*threads) + sizeof(pid_t)*items);
>>>
>>> If realloc fails and threads was allocated before... we leak memory.
>>
>> ok.
>>
>>>
>>> We don't need to use this if clause, realloc handles threads == NULL
>>> just fines and then works as malloc.
>>
>> ok.
>>
>>>
>>> Also I didn't use ctype altogether + that CSV parsing routine, we have
>>> strlist for that, it even will allow us to trow away duplicate pids/tids
>>> and also supports passing a file with a list of threads to monitor, for
>>> free.
>>
>> Interesting. I did look at strlist before going with the string parsing.
>> It was not obvious to me how to use it for this case.
>>
>>>
>>> Take a look at the modified patch below, if you're ok with it I can keep
>>> your autorship and put a [committer note: use strlist] or take autorship
>>> and state that it was based on a patch made by you, definetely your
>>> call. I'd go for the committer note.
>>
>> I'm fine with either one. Patch below looks fine. If needed:
>>
>> Acked-by: David Ahern <dsahern@gmail.com>
> 
> I assume you tested it in a few scenarios (I know I did, but hey, more
> testing is always good) and that I can add another stamp, a Tested-by:
> ya, right?
> 
> - Arnaldo

Hmmm... that was a radical idea. Build breaks on Fedora 16, x86_64:

util/thread_map.c: In function ‘thread_map__new_by_pid_str’:
util/thread_map.c:164:2: error: overflow in implicit constant conversion
[-Werror=overflow]
util/thread_map.c:175:3: error: comparison is always false due to
limited range of data type [-Werror=type-limits]
util/thread_map.c:175:3: error: comparison is always false due to
limited range of data type [-Werror=type-limits]
util/thread_map.c: In function ‘thread_map__new_by_tid_str’:
util/thread_map.c:223:2: error: overflow in implicit constant conversion
[-Werror=overflow]
util/thread_map.c:245:3: error: comparison is always false due to
limited range of data type [-Werror=type-limits]
util/thread_map.c:245:3: error: comparison is always false due to
limited range of data type [-Werror=type-limits]
cc1: all warnings being treated as errors


I think you want INT_MAX not LONG_MAX.
