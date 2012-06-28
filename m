Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2F1Oxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 10:53:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44242 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2F1Oxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 10:53:36 -0400
Message-ID: <4FEC6F7E.2030905@gmail.com>
Date: Thu, 28 Jun 2012 08:51:42 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, psuriset@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf kvm: fix segfault with default guest arguments
References: <1340599286-89757-1-git-send-email-dsahern@gmail.com> <20120628144418.GG4038@infradead.org>
In-Reply-To: <20120628144418.GG4038@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/12 8:44 AM, Arnaldo Carvalho de Melo wrote:
> Em Sun, Jun 24, 2012 at 10:41:26PM -0600, David Ahern escreveu:
>> File generated with:
>> $ perf kvm --host --guest --guestkallsyms=/tmp/guest-kallsyms
>>      --guestmodules=/tmp/guest-modules record -a
>>
>> The report command:
>> $ perf kvm --host --guest --guestkallsyms=/tmp/guest-kallsyms
>>      --guestmodules=/tmp/guest-modules report
>>
>> dies with a SEGFAULT:
>> Program received signal SIGSEGV, Segmentation fault.
>> 0x000000000046dd7b in machine__mmap_name (self=0x0, bf=0x7fffffffbd20 "q\021", size=4096) at util/map.c:715
>> 715			snprintf(bf, size, "[%s.%d]", "guest.kernel.kallsyms", self->pid);
>>
>> (gdb) bt
>> 0  0x000000000046dd7b in machine__mmap_name (self=0x0, bf=0x7fffffffbd20 "q\021", size=4096) at util/map.c:715
>> 1  0x0000000000444161 in perf_event__process_kernel_mmap (tool=0x7fffffffdd80, event=0x7ffff7fb4120, machine=0x0) at util/event.c:562
>
> I think that this should be handled at perf_event__process_kernel_mmap,
> i.e. tools can conceivably handle this situation in their specific
> handlers.
>
>>   @@ -976,6 +976,8 @@ static int perf_session_deliver_event(struct perf_session *session,
>>   		}
>>   		return tool->sample(tool, event, sample, evsel, machine);
>>   	case PERF_RECORD_MMAP:
>> +		if (machine == NULL)
>> +			return 0;
>>   		return tool->mmap(tool, event, sample, machine);
>>
> - Arnaldo
>

Ok. Doing it in perf_session_deliver_event makes it consistent with the 
SAMPLE case.

David
