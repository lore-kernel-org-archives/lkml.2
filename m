Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab2CHSuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:50:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47191 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757051Ab2CHSuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:50:09 -0500
Message-ID: <4F58FF47.6090504@fb.com>
Date: Thu, 8 Mar 2012 10:49:43 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        <linux-perf-users@vger.kernel.org>
Subject: Re: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
References: <1331160079-13821-1-git-send-email-asharma@fb.com> <20120308072901.GC20784@elte.hu> <20120308153130.GC7976@somewhere.redhat.com>
In-Reply-To: <20120308153130.GC7976@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-08_04:2012-03-08,2012-03-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/12 7:31 AM, Frederic Weisbecker wrote:
> On Thu, Mar 08, 2012 at 08:29:01AM +0100, Ingo Molnar wrote:
>>
>> * Arun Sharma<asharma@fb.com>  wrote:
>>
>>> This patch series refactors existing code a bit and adds sort by
>>> inclusive time (time spent in the function + callees).
>>>
>>> Sample command lines:
>>>
>>> # perf record -ag -- sleep 1
>>> # perf report -g graph,0.5,callee -n -s inclusive
>>
>> So I tried this out with:
>>
>>    $ taskset 1 perf record -g git gc
>>
>> and got entries above 100% (in the TUI):
>>
>>    $ perf report -g graph,0.5,callee -n -s inclusive
>>
>>   +  321.11%        5628  [.] 0x392b609269
>>   +  142.27%        3774  [.] create_delta
>>   +  78.86%        1248  [.] lookup_object
>>   +  40.54%        1348  [k] system_call_fastpath
>>   [...]
>>
>> Is that expected?

Yes - this is the "known bug" I noted in the cover letter

The second column (samples) is still accurate and could be used for the 
analysis.

>
> I think this happens because of this:
>
> -               hists->stats.total_period += h->period;
> +               if (!h->inclusive)
> +                       hists->stats.total_period += h->period;
>
> Which I'm not sure why it is needed btw.

Suppose the perf.data file had 1000 samples each with a period of 1e6 
events. total_period would be 1e9 without -s inclusive. Further, let's 
say the callchains had an average length of 10.

Now, after adding extra entries to the histogram, total_period would be 
1e10, which screws up the percentages. I'd like to differentiate between 
the hist entries that were in the event stream vs the ones added for 
inclusive time computation. Desired end result: the total_period remains 
unchanged at 1e9.

This is done via:

+		if (i != 0)
+			he->inclusive = 1;
+		else
+			orig_he = he;

Either (i != 0) is not a good enough test, or the inclusive bit is not 
getting propagated properly after histogram collapsing/resorting. This 
is the part I need to better understand and debug.

I tried to explain this problem in my first RFC message as well:

http://thread.gmane.org/gmane.linux.kernel/1262289

The problem Ingo is running into (and I've reproduced it on my end as 
well) is that total_period is smaller than without -s inclusive i.e. 
h->inclusive is 1 when it shouldn't be.

  -Arun
