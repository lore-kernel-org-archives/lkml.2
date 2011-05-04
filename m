Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1EDBNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 21:13:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:22345 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab1EDBNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 21:13:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xoFOEcJ3m3SLvH/4zSgP5TVRmZemzMwWIzLZasHVFOHHUju8YWSnLiG+0CeJmENF96
         5lMFLAm2c6DSfEuCqAog==
MIME-Version: 1.0
In-Reply-To: <BANLkTiktch2mHDLXZCdCED3XoqmkVRfghA@mail.gmail.com>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
 <20110502061411.GA16682@elte.hu> <BANLkTiktch2mHDLXZCdCED3XoqmkVRfghA@mail.gmail.com>
From: Nikhil Rao <ncrao@google.com>
Date: Tue, 3 May 2011 18:07:12 -0700
Message-ID: <BANLkTimcqA2uaLqA9EDSXtd7OmSsKQdJ0Q@mail.gmail.com>
Subject: Re: [PATCH v1 00/19] Increase resolution of load weights
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 5:58 PM, Nikhil Rao <ncrao@google.com> wrote:
> On Sun, May 1, 2011 at 11:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Nikhil Rao <ncrao@google.com> wrote:
>>
>>> 1. Performance costs
>>>
>>> Ran 50 iterations of Ingo's pipe-test-100k program (100k pipe ping-pongs).
>>> See http://thread.gmane.org/gmane.linux.kernel/1129232/focus=1129389 for more
>>> info.
>>>
>>> 64-bit build.
>>>
>>>   2.6.39-rc5 (baseline):
>>>
>>>     Performance counter stats for './pipe-test-100k' (50 runs):
>>>
>>>        905,034,914 instructions             #      0.345 IPC     ( +-   0.016% )
>>>      2,623,924,516 cycles                     ( +-   0.759% )
>>>
>>>         1.518543478  seconds time elapsed   ( +-   0.513% )
>>>
>>>   2.6.39-rc5 + patchset:
>>>
>>>     Performance counter stats for './pipe-test-100k' (50 runs):
>>>
>>>        905,351,545 instructions             #      0.343 IPC     ( +-   0.018% )
>>>      2,638,939,777 cycles                     ( +-   0.761% )
>>>
>>>         1.509101452  seconds time elapsed   ( +-   0.537% )
>>>
>>> There is a marginal increase in instruction retired, about 0.034%; and marginal
>>> increase in cycles counted, about 0.57%.
>>
>> Not sure this increase is statistically significant: both effects are within
>> noise and look at elapsed time, it actually went down.
>>
>> Btw., to best measure context-switching costs you should do something like:
>>
>>  taskset 1 perf stat --repeat 50 ./pipe-test-100k
>>
>> to pin both tasks to the same CPU. This reduces noise and makes the numbers
>> more relevant: SMP costs do not increase due to your patchset.
>>
>> So it would be nice to re-run the 64-bit tests with the pipe test bound to a
>> single CPU.
>
> I re-ran the 64-bit tests with the pipe test bound to a single CPU.
> Data attached below.
>
> 2.6.39-rc5:
>
>  Performance counter stats for './pipe-test-100k' (100 runs):
>
>       855,571,900 instructions             #      0.869 IPC     ( +-   0.637% )
>       984,213,635 cycles                     ( +-   0.254% )
>
>        0.796129773  seconds time elapsed   ( +-   0.152% )
>
> 2.6.39-rc5  + patchset:
>
>  Performance counter stats for './pipe-test-100k' (100 runs):
>
>       905,553,828 instructions             #      0.934 IPC     ( +-   0.059% )
>       969,792,787 cycles                     ( +-   0.168% )
>
>        0.788676004  seconds time elapsed   ( +-   0.122% )
>
>
> There is a 5.8% increase in instructions which is statistically
> significant and well over the error margins. Cycles dropped by about
> 1.17% and elapsed time also dropped about ~1%. I'm looking into
> profiles for this test to understand why instr has increased.
>
>>
>>> 32-bit build.
>>>
>>>   2.6.39-rc5 (baseline):
>>>
>>>     Performance counter stats for './pipe-test-100k' (50 runs):
>>>
>>>      1,025,151,722 instructions             #      0.238 IPC     ( +-   0.018% )
>>>      4,303,226,625 cycles                     ( +-   0.524% )
>>>
>>>         2.133056844  seconds time elapsed   ( +-   0.619% )
>>>
>>>   2.6.39-rc5 + patchset:
>>>
>>>     Performance counter stats for './pipe-test-100k' (50 runs):
>>>
>>>      1,070,610,068 instructions             #      0.239 IPC     ( +-   1.369% )
>>>      4,478,912,974 cycles                     ( +-   1.011% )
>>>
>>>         2.293382242  seconds time elapsed   ( +-   0.144% )
>>>
>>> On 32-bit kernels, instructions retired increases by about 4.4% with this
>>> patchset. CPU cycles also increases by about 4%.
>>>
>>> There is a marginal increase in instruction retired, about 0.034%; and
>>> marginal increase in cycles counted, about 0.57%.
>>
>> These results look more bothersome, a clear increase in both cycles, elapsed
>> time, and instructions retired, well beyond measurement noise.
>>
>> Given that scheduling costs are roughly 30% of that pipe test-case, the cost
>> increase to the scheduler is probably around:
>>
>>        instructions:   +14.5%
>>        cycles:         +13.3%
>>
>> That is rather significant.
>>
>
> I'll take a closer look at the performance of this patchset this week.
> I'm a little confused about how you calculated the cost to the
> scheduler. How did you come up with 14.5 % and 13.3%?

Ah, never mind that. After reading your mail again, I see how this is
calculated now.

Also, out of
> curiosity, what's an acceptable tolerance level for a performance hit
> on 32-bit?
>
> -Thanks
> Nikhil
>
>> Thanks,
>>
>>        Ingo
>>
>
