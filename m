Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab1CCPIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 10:08:16 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:33635 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751837Ab1CCPIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 10:08:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bpR4d14EQp4h41xzLTky7KSeE9IQAyXn0tCW21CPm8LH6Iketo0kL2f8L8H6O+WcfHDL5UwO9BlI/+3mRK5Zi21YvceAq1MFFyHiH4iBcKxnZEj/UNuhJ02OvR8Td/qn;
Message-ID: <4D6FAED0.5010000@tao.ma>
Date: Thu, 03 Mar 2011 23:08:00 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Liu Yuan <namei.unix@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jaxboe@fusionio.com, akpm@linux-foundation.org,
        fengguang.wu@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [RFC PATCH 4/5] mm: Add hit/miss accounting for Page Cache
References: <no> <1299055090-23976-4-git-send-email-namei.unix@gmail.com> <20110302084542.GA20795@elte.hu> <4D6F077B.3060400@tao.ma> <20110303093422.GC18252@elte.hu>
In-Reply-To: <20110303093422.GC18252@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.217.57.222 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 05:34 PM, Ingo Molnar wrote:
> * Tao Ma<tm@tao.ma>  wrote:
>
>> On 03/02/2011 04:45 PM, Ingo Molnar wrote:
>>> * Liu Yuan<namei.unix@gmail.com>   wrote:
>>>
>>>> +		if (likely(!retry_find)&&   page&&   PageUptodate(page))
>>>> +			page_cache_acct_hit(inode->i_sb, READ);
>>>> +		else
>>>> +			page_cache_acct_missed(inode->i_sb, READ);
>>> Sigh.
>>>
>>> This would make such a nice tracepoint or sw perf event. It could be collected in a
>>> 'count' form, equivalent to the stats you are aiming for here, or it could even be
>>> traced, if someone is interested in such details.
>>>
>>> It could be mixed with other events, enriching multiple apps at once.
>>>
>>> But, instead of trying to improve those aspects of our existing instrumentation
>>> frameworks, mm/* is gradually growing its own special instrumentation hacks, missing
>>> the big picture and fragmenting the instrumentation space some more.
>> Thanks for the quick response. Actually our team(including Liu) here are planing
>> to add some debug info to the mm parts for analyzing the application behavior and
>> hope to find some way to improve our application's performance. We have searched
>> the trace points in mm, but it seems to us that the trace points isn't quite
>> welcomed there. Only vmscan and writeback have some limited trace points added.
>> That's the reason we first tried to add some debug info like this patch. You does
>> shed some light on our direction. Thanks.
> Yes, it's very much a 'critical mass' phenomenon: the moment there's enough
> tracepoints, above some magic limit, things happen quickly and everyone finds the
> stuff obviously useful.
>
> Before that limit it's all pretty painful.
yeah.
>> btw, what part do you think is needed to add some trace point?  We
>> volunteer to add more if you like.
> Whatever part you find useful in your daily development work!
>
> Tracepoints are pretty flexible. The bit that is missing and which is very important
> for the MM is the collapse into 'summaries' and the avoidance of tracing overhead
> when only a summary is wanted. Please see Wu Fengguang's reply in this thread about
> the 'dump state' facility he and Steve added to recover large statistics.
We are looking into it now. Thanks for the hint.
> I suspect the hit/miss histogram you are building in this patch could be recovered
> via that facility initially?
>
> The next step would generalize that approach - it is non-trivial but powerful :-)
>
> The idea is to allow non-trivial histograms and summaries to be built out of simple
> events, via the filter engine.
>
> It would require an extension of tracing to really allow a filter expression to be
> defined over existing events, which would allow the maintenance of a persistent
> 'sum' variable - probably within the perf ring-buffer. We already have filter
> support, that would have to be extended with a notion of 'persistent variables'.
>
> So right now, if you define a tracepoint in that spot, we already support such
> filter expressions:
>
>       'bdev == sda1&&  page_state == PageUptodate'
>
> You can inject such filter expressions into /debug/tracing/events/*/*/filter today,
> and you can use filters in perf record --filter '...' as well.
>
> To implement 'fast statistics', the filter engine would have to be extended to
> support (simple) statements like:
>
> 	if (bdev == sda1&&  page_state == PageUptodate)'
> 		var0++;
>
> And:
>
> 	if (bdev == sda1&&  page_state != PageUptodate)'
> 		var1++;
>
> Only a very minimal type of C syntax would be supported - not a full C parser.
>
> That way the 'var0' portion of the perf ring-buffer (which would not be part of the
> regular, overwritten ring-buffer) would act as a 'hits' variable that you could
> recover. The 'var1' portion would be the 'misses' counter.
>
> Individual trace events would only twiddle var0 and var1 - they would not inject a
> full-blown event into the ring-buffer, so statistics would be very fast.
>
> This method is very extensible and could be used for far more things than just MM
> statistics. In theory all of /proc statistics collection could be replaced and made
> optional that way, just by adding the right events to the right spots in the kernel.
> That is obviously a very long-term project.
It looks really fantastic for us. OK, we will try to figure out when and 
how we can work on this issue. Great thanks.

Regards,
Tao
