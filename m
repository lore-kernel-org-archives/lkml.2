Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0JMQeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 12:34:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58509 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0JMQeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 12:34:23 -0400
Message-ID: <4CB5DF50.7070906@oracle.com>
Date: Wed, 13 Oct 2010 09:33:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add generic exponentially weighted moving average function
References: <20101006093225.8739.14012.stgit@tt-desk> <20101012173352.0a458c24.randy.dunlap@oracle.com> <201010131110.21341.br1@einfach.org>
In-Reply-To: <201010131110.21341.br1@einfach.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/10 19:10, Bruno Randolf wrote:
> Hello Randy!
> 
> Thank you for taking the time to look at this!
> 
> On Wed October 13 2010 09:33:52 Randy Dunlap wrote:
>> On Wed, 06 Oct 2010 18:32:25 +0900 Bruno Randolf wrote:
>>> This adds a generic exponentially weighted moving average function. This
>>> implementation makes use of a structure which keeps a scaled up internal
>>> representation to reduce rounding errors.
>>>
>>> The idea for this implementation comes from the rt2x00 driver
>>> (rt2x00link.c) and i would like to use it in several places in the
>>> mac80211 and ath5k code.
>>>
>>> Signed-off-by: Bruno Randolf <br1@einfach.org>
>>
>> I guess I don't understand "exponentially weighted" or why that would
>> be desirable.  Please try to explain (briefly).
> 
> It just means, that more recent values are given a higher priority. The 
> influence of older values decreases exponentially.

Got it, thanks.

> This is desirable if we want to have an average, but we are more interested in 
> the recent development. One example where that makes sense is the signal 
> strength of a station in a wireless LAN. As the signal strength can vary 
> significantly for every packet, just looking at one packet is misleading. 
> We are not so much interested in a long term average, as a station might move 
> - we are more interested in the average of the last X (say 8) packets, giving 
> most priority to the last value.
> 
> http://en.wikipedia.org/wiki/Exponentially_weighted_moving_average#Exponential_moving_average
> 
> This is one example, but I found several places in the kernel code where 
> something like this is used, usually open coded. That's why I tought a general 
> function for this can make sense.
> 
>> I'm attaching a test program that I did.  I don't especially like the
>> results of it.  Maybe it's due to the exponential weighting. (?)
>>
>> The test program tells me that the sum of 3 samples is 8 & average = 2:
>> i.e., not rounded up.
> 
> Oh, I see. I guess I should use DIV_ROUND_CLOSEST. I attach a new version of 
> the test program.
> 
>> And that the sum of 6 samples is 30 & average = 4. (!!)
>> And that the sum of 10 samples is 80 & average = 5. (!!)
>>
>> Am I just not understanding the function or am I misusing it?
> 
> You should keep 'samples' constant every time you call the function. It is the 
> factor which defines how fast the influence of older values decreases. Higher 
> values will take more older samples into account. E.g. use it like this:
> 
> moving_average(avg, val, 4);
> 
> I should have documented that better, I guess... And maybe rename it to 
> 'factor'.

OK, now I see how it's used.

> Also a moving average makes more sense when you use it more often, depending 
> on how high 'samples' is. E.g. here is the output of the test program with 
> 'sampes' of 4 and 20 iterations. I also print 'savg' (simple average) which is 
> sum/count:
> 
> count: 1, val: 1, sum: 1, savg: 1, avg: 1, internal: 1000
> count: 2, val: 3, sum: 4, savg: 2, avg: 2, internal: 1500
> count: 3, val: 4, sum: 8, savg: 2, avg: 2, internal: 2125
> count: 4, val: 6, sum: 14, savg: 3, avg: 3, internal: 3093
> count: 5, val: 7, sum: 21, savg: 4, avg: 4, internal: 4069
> count: 6, val: 9, sum: 30, savg: 5, avg: 5, internal: 5301
> count: 7, val: 10, sum: 40, savg: 5, avg: 6, internal: 6475
> count: 8, val: 12, sum: 52, savg: 6, avg: 8, internal: 7856
> count: 9, val: 13, sum: 65, savg: 7, avg: 9, internal: 9142
> count: 10, val: 15, sum: 80, savg: 8, avg: 11, internal: 10606
> count: 11, val: 16, sum: 96, savg: 8, avg: 12, internal: 11954
> count: 12, val: 18, sum: 114, savg: 9, avg: 13, internal: 13465
> count: 13, val: 19, sum: 133, savg: 10, avg: 15, internal: 14848
> count: 14, val: 21, sum: 154, savg: 11, avg: 16, internal: 16386
> count: 15, val: 22, sum: 176, savg: 11, avg: 18, internal: 17789
> count: 16, val: 24, sum: 200, savg: 12, avg: 19, internal: 19341
> count: 17, val: 25, sum: 225, savg: 13, avg: 21, internal: 20755
> count: 18, val: 27, sum: 252, savg: 14, avg: 22, internal: 22316
> count: 19, val: 28, sum: 280, savg: 14, avg: 24, internal: 23737
> count: 20, val: 30, sum: 310, savg: 15, avg: 25, internal: 25302
> 
> Especially towards the end you can see how a moving average gives preference 
> to the newer values.
> 
>>> Is this the right place to add it? Who to CC:?
>>
>> Try Andrew. (added)
> 
> I attach a new version of the test program. If you can generally agree that 
> this can be included in the kernel, I'll work on an improved version of my 
> patch.

Seems OK to me as long as there are multiple users of it.

> Thank you for your feedback!


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
