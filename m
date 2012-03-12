Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab2CLHPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 03:15:48 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44086 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2CLHPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 03:15:41 -0400
X-AuditID: 9c930179-b7b92ae000005ed3-c9-4f5da29657f8
Message-ID: <4F5DA294.6070700@lge.com>
Date: Mon, 12 Mar 2012 16:15:32 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.perf.user
To: Arun Sharma <asharma@fb.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
References: <1331160079-13821-1-git-send-email-asharma@fb.com> <20120308072901.GC20784@elte.hu> <20120308153130.GC7976@somewhere.redhat.com> <4F58FF47.6090504@fb.com>
In-Reply-To: <4F58FF47.6090504@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-03-09 3:49 AM, Arun Sharma wrote:
> On 3/8/12 7:31 AM, Frederic Weisbecker wrote:
>> On Thu, Mar 08, 2012 at 08:29:01AM +0100, Ingo Molnar wrote:
>>>
>>> * Arun Sharma<asharma@fb.com> wrote:
>>>
>>>> This patch series refactors existing code a bit and adds sort by
>>>> inclusive time (time spent in the function + callees).
>>>>
>>>> Sample command lines:
>>>>
>>>> # perf record -ag -- sleep 1
>>>> # perf report -g graph,0.5,callee -n -s inclusive
>>>
>>> So I tried this out with:
>>>
>>> $ taskset 1 perf record -g git gc
>>>
>>> and got entries above 100% (in the TUI):
>>>
>>> $ perf report -g graph,0.5,callee -n -s inclusive
>>>
>>> + 321.11% 5628 [.] 0x392b609269
>>> + 142.27% 3774 [.] create_delta
>>> + 78.86% 1248 [.] lookup_object
>>> + 40.54% 1348 [k] system_call_fastpath
>>> [...]
>>>
>>> Is that expected?
>
> Yes - this is the "known bug" I noted in the cover letter
>
> The second column (samples) is still accurate and could be used for the analysis.
>
>>
>> I think this happens because of this:
>>
>> - hists->stats.total_period += h->period;
>> + if (!h->inclusive)
>> + hists->stats.total_period += h->period;
>>
>> Which I'm not sure why it is needed btw.
>
> Suppose the perf.data file had 1000 samples each with a period of 1e6 events.
> total_period would be 1e9 without -s inclusive. Further, let's say the
> callchains had an average length of 10.
>
> Now, after adding extra entries to the histogram, total_period would be 1e10,
> which screws up the percentages. I'd like to differentiate between the hist
> entries that were in the event stream vs the ones added for inclusive time
> computation. Desired end result: the total_period remains unchanged at 1e9.
>
> This is done via:
>
> + if (i != 0)
> + he->inclusive = 1;
> + else
> + orig_he = he;
>
> Either (i != 0) is not a good enough test, or the inclusive bit is not getting
> propagated properly after histogram collapsing/resorting. This is the part I
> need to better understand and debug.
>
> I tried to explain this problem in my first RFC message as well:
>
> http://thread.gmane.org/gmane.linux.kernel/1262289
>
> The problem Ingo is running into (and I've reproduced it on my end as well) is
> that total_period is smaller than without -s inclusive i.e. h->inclusive is 1
> when it shouldn't be.
>

I think it's because of the shared hist_entry. If a callchain is a subset of 
another, it will be marked as inclusive so that it cannot be contributed to 
total period. Say, there're two chains - X (a -> b -> c) and Y (a -> b), once 
__hists__add_entry_inclusive() was called on X, we have:

  a -> b -> c	
  a -> b 	(inclusive)
  a		(inclusive)

And then, calling the function on Y should make:

  a -> b
  a		(inclusive)

However, since both callchains are in tree already they'll be shared and 
marked *inclusive*. Thus the total period will not increased at all for Y. 
Also I guess the reverse case - add Y first, and then X - will have the same 
result.

Thanks,
Namhyung
