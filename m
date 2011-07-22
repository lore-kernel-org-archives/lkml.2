Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab1GVG6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 02:58:03 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:43830 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1GVG6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 02:58:01 -0400
Message-ID: <4E291F28.2040609@ct.jp.nec.com>
Date: Fri, 22 Jul 2011 15:56:40 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: agk@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: request baset device mapper in Linux
References: <20110720082640.GZ7561@ics.muni.cz> <4E280964.6070000@ct.jp.nec.com> <20110721132627.GY7561@ics.muni.cz>
In-Reply-To: <20110721132627.GY7561@ics.muni.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukas,

Lukas Hejtmanek wrote:
> On Thu, Jul 21, 2011 at 08:11:32PM +0900, Kiyoshi Ueda wrote:
>> I don't understand why you are saying request-based device-mapper makes
>> serious troubles.
>> BIO merging is done in the block layer.  Don't you see the same thing
>> if you use sd devices (/dev/sdX)?
> 
> no, if I use sd devices directly, it does not overload ksoftirqd and this is
> obvious. The problem with overloading ksoftirqd has roots in request based
> stuff in dm layer, in particular in dm_softirq_done() call. 
> 
>> If you see your problem only with request-based device-mapper, please
>> elaborate about below:
>>     - end_clone_bio() has someting like quadratic complexity.
>>         * What do you mean the "quadratic complexity"?
> 
> end_clone_bio calls blk_update_request which calls __blk_recalc_rq_segments
> which has code:
> for_each_bio(bio) {
>         bio_for_each_segment(bv, bio, i) {
> 
> in total, it seems that *whole* bio list is traversed again and again as some parts
> are done and some not which leads to comlexity O(n^2) with respect to number
> of bio and segments. But this is just wild guess. The real problem could be
> elsewhere.
> 
> However, oprofile or sysprof show that ksoftirq spends most time in
> __blk_recalc_rq_segments().

Thank you very much for the detailed explanation.
Now, I understand what you mentioned except below:

> ksoftirqd eats 100% CPU as soon as all available memory is used for buffers.

If the slow down is caused only by lack of CPU power, memory usage
should not matter here.
Don't you see 100% CPU of ksoftirqd (nor the slow down) if you use
a fewer size than memory size? (e.g. 500[MB] for each dd)

> The problem with overloading ksoftirqd has roots in request based
> stuff in dm layer, in particular in dm_softirq_done() call. 

Is that your actual trace result?
end_clone_bio(), which seems taking much time, is called
in the context of SCSI's softirq.
So if you really see that dm_softirq_done() is taking a time,
there may be other problems, too.


>>     - each request contains more then 100 bios which makes serious
>>       troubles for ksoftirqd call backs.
>>         * What do you mean the "serious troubles for ksoftirqd call backs"?
> 
> serious troubles means that ksoftirqd eats 100% CPU and slows down I/O
> significantly (from 2.8GB/s to 500MB/s).

OK, at least, request-based device-mapper eats more CPU/memory resources
than bio-based device-mapper due to the design which clones bio, too,
not only request.
So I think you need more CPUs on such environments which have lots of devices,
or you may be able to work around by splitting each request to shorter size
as you mentioned.
(How many CPUs do you have and how fast are those CPUs?
 I just tried, but no such phenomenon can be seen on the environment
 of 10 (FC) devices and 1 CPU (Xeon(R) E5205 1.86[GHz]).)

# I will be on a vacation whole next week, so I won't be able to respond
# until 8/1.  Sorry about that.

Thanks,
Kiyoshi Ueda
