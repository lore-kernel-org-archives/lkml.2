Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab1GKEUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 00:20:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47528 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1GKEUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 00:20:40 -0400
Message-ID: <4E1A7A0D.8000806@gmail.com>
Date: Sun, 10 Jul 2011 22:20:29 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, peterz@infradead.org
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, paulus@samba.org,
        tglx@linutronix.de
Subject: Re: [PATCH 3/6] perf: add reference time event
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com> <1307490946-24673-1-git-send-email-dsahern@gmail.com> <20110617133230.GC25197@somewhere.redhat.com> <4DFB5F0B.4020903@gmail.com> <20110617141707.GE25197@somewhere.redhat.com>
In-Reply-To: <20110617141707.GE25197@somewhere.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2011 08:17 AM, Frederic Weisbecker wrote:
> On Fri, Jun 17, 2011 at 08:04:59AM -0600, David Ahern wrote:
>>
>>
>> On 06/17/2011 07:32 AM, Frederic Weisbecker wrote:
>>> On Tue, Jun 07, 2011 at 05:55:46PM -0600, David Ahern wrote:
>>>> For initial perf_clock to time-of-day correlation.
>>>>
>>>> Signed-off-by: David Ahern <dsahern@gmail.com>
>>>> ---
>>>>  tools/perf/util/event.c   |    1 +
>>>>  tools/perf/util/event.h   |    8 ++++++++
>>>>  tools/perf/util/session.c |    4 ++++
>>>>  tools/perf/util/session.h |    3 ++-
>>>>  4 files changed, 15 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
>>>> index 3c1b8a6..1a89a04 100644
>>>> --- a/tools/perf/util/event.c
>>>> +++ b/tools/perf/util/event.c
>>>> @@ -24,6 +24,7 @@ static const char *perf_event__names[] = {
>>>>  	[PERF_RECORD_HEADER_TRACING_DATA]	= "TRACING_DATA",
>>>>  	[PERF_RECORD_HEADER_BUILD_ID]		= "BUILD_ID",
>>>>  	[PERF_RECORD_FINISHED_ROUND]		= "FINISHED_ROUND",
>>>> +	[PERF_RECORD_REFTIME]			= "REF_TIME",
>>>>  };
>>>>  
>>>>  const char *perf_event__name(unsigned int id)
>>>> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
>>>> index 1d7f664..f481f90 100644
>>>> --- a/tools/perf/util/event.h
>>>> +++ b/tools/perf/util/event.h
>>>> @@ -98,6 +98,7 @@ enum perf_user_event_type { /* above any possible kernel type */
>>>>  	PERF_RECORD_HEADER_TRACING_DATA		= 66,
>>>>  	PERF_RECORD_HEADER_BUILD_ID		= 67,
>>>>  	PERF_RECORD_FINISHED_ROUND		= 68,
>>>> +	PERF_RECORD_REFTIME			= 69,
>>>
>>> We would like to avoid adding more custom events like these. They were very convenient
>>> but they steal the kernel event type space. They are deemed for removal in the long term.
>>>
>>> Another idea to achieve what you want would be to create a new perf event header feature,
>>> like HEADER_TRACE_INFO or HEADER_BUILD_ID are. Then use that to create a space in the perf
>>> file to save that couple of clocks initial values.
>>
>> you mean like this:
>> https://lkml.org/lkml/2010/12/7/813
>>
>> David
> 
> Exactly, why did you change?

Finally getting back to this.

The answer to the 'why' is that putting a reference timestamp in the
header field does not work for file appends across reboots. ie., the case:
perf record --tod ...
reboot
perf record -A --tod ...

perf_clock timestamps change across reboots so the reference time
created by the first invocation is not valid for the append case. The
discussion then drifted towards having a kernel side event which per
past patch sets has its own issues.

So to summarize the options proposed to date and issues with the proposals:
1. reference timestamp in header
   - does not work for appends across reboots

2. synthesized events
   - preference against them

3. kernel side event
   - cannot generate an initial sample (with counter value and
perf_clock timestamp) on demand - e.g., start of session; a proposal to
use an ioctl to add one to the event stream was shot down

At this point the only idea that comes to mind is to use a combination
of 2 and 3: add the kernel side clock event
(https://lkml.org/lkml/2011/2/18/11), read the realtime clock counter,
read the monotonic clock timestamp (ie., perf_clock value), and
synthesize a perf sample that is written to the file. The append case
(with mismatch in --tod options between record invocations) would be
handled by having the kernel side clock event in the event list
(perf_evlist__equal would fail if --tod was not used for all invocations).

David
