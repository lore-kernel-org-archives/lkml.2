Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab1AKS41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 13:56:27 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:43403 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab1AKS4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 13:56:24 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMo2LE2rRN+J/2dsb2JhbACkOXOjZJhqhUwEhGiGJoMg
Message-ID: <4D2CA7D6.2070203@cisco.com>
Date: Tue, 11 Jan 2011 11:56:22 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-perf-users@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf timechart broken
References: <201101071104.37576.trenn@suse.de> <20110111013625.GE2570@nowhere> <201101110955.37560.trenn@suse.de>
In-Reply-To: <201101110955.37560.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/11/11 01:55, Thomas Renninger wrote:
> On Tuesday 11 January 2011 02:36:28 Frederic Weisbecker wrote:
>> On Fri, Jan 07, 2011 at 11:04:37AM +0100, Thomas Renninger wrote:
>>> Hi,
>>>
>>> Latest x86 tip has another perf timechart issue introduce
>>> by latest commits.
>>>
>>> ./perf timechart
>>> gives me:
>>> "no trace data in the file"
>>>
>>> I reverted  the latest changes and things seem to break
>>> between d854861c4292a4e675a5d3bfd862c5f7421c81e8
>>> and
>>> 69aad6f1ee69546dea8535ab8f3da9f445d57328
>>> (linux-2.6-x86 tree ids)
>>>
>>> Be aware that ./perf timechart is currently broken
>>> and segfaults on idle events (in 2.6.36 and 2.6.37).
>>
>> You mean .36 perf tools faults on .37 kernel? or the opposite?
>> Is it because power_idle events weren't present on old tools?
>> Do you have a pointer to those patches?
> perf timechart
> will segfault if perf.data has power_{start,end} events included
> on 2.6.36 and 2.6.37 kernels.

Is this the same segfault you are seeing?

http://www.mail-archive.com/linux-perf-users@vger.kernel.org/msg00057.html

David


> 
>>> I submitted a patch to stable@ but it did not get accepted,
>>> becaust it's not mainline yet.
>>> I concentrated on my latest patches instead of making sure
>>> the tiny fix gets into 2.6.37 first.
>>>
>>> Ingo: It's a bit late for 2.6.37, if there is any chance
>>> to still get it in, the patch below is against linus master...
>>> otherwise I'll submit it for stable 36+37 asap.
>>
>> It's too late for .37, but it's fine, we just need to add
>> a "Cc: stable@kernel.org" tag in the patch for it to be
>> backported.
> I'll submit it to stable@ (it wasn't taken because
> the patch which included the fix wasn't mainline yet and I
> forgot to submit it for 2.6.37-rcX). 
> 
> I can take care of that, but it would be great if someone
> could look at the issue that perf timechart shows:
> "no trace data in the file"
> in x86/tip which seems introduced by one of Arnaldo's latest
> commits. Reverting some of his latest patches, solved it for
> me.
> 
>>> Anyway to test above regression this mail is about, first
>>> apply below patch otherwise you get a segfault if idle
>>> (power_start/end) events got logged.
>>>
>>> Thanks,
>>>
>>>    Thomas
>>>
>>> ---
>>> perf timechart: Fix segfault on cpu idle (power_start/end) events
>>>
>>> power_end event does not have type and other attributes and thus does
>>> not match struct power_event.
>>> Another struct could be created, but data.cpu is fine for fixing the segfault
>>> and will work as long as C-states got initiated on the same CPU the idle state
>>> takes place which is the case for all recent HW.
>>>
>>> The power_start/end events get deprecated anyway, thus this is an easy,
>>> riskless and sufficient solution for the segfault problem.
>>>
>>> Signed-off-by: Thomas Renninger <trenn@suse.de>
>>> CC: mingo@elte.hu
>>> CC: arjan@linux.intel.com
>>>
>>> ---
>>>  tools/perf/builtin-timechart.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
>>> index 9bcc38f..b3028eb 100644
>>> --- a/tools/perf/builtin-timechart.c
>>> +++ b/tools/perf/builtin-timechart.c
>>> @@ -502,7 +502,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
>>>  			c_state_start(pe->cpu_id, data.time, pe->value);
>>>  
>>>  		if (strcmp(event_str, "power:power_end") == 0)
>>> -			c_state_end(pe->cpu_id, data.time);
>>> +			c_state_end(data.cpu, data.time);
>>
>> On which tree is this based of?
> Linus master (2.6.37-rc8).
> 
>> What I have by looking at tip/master is:
> Yes, this commit includes the patch (should have been a seperate one...):
> 20c457b8587bee4644d998331d9e13be82e05b4c
> perf timechart: Adjust perf timechart to the new power events
> 
>    Thomas
> 
>>
>> 		else if (strcmp(event_str, "power:power_end") == 0)
>> 			c_state_end(sample->cpu, sample->time);
>>
>>>  
>>>  		if (strcmp(event_str, "power:power_frequency") == 0)
>>>  			p_state_change(pe->cpu_id, data.time, pe->value);
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-perf-users" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-perf-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
