Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3AJNLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:11:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab3AJNLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:11:08 -0500
Message-ID: <50EEBC7C.70508@redhat.com>
Date: Thu, 10 Jan 2013 08:05:00 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Subject: Re: [PATCH 4/5] x86,smp: keep spinlock delay values per hashed spinlock
 address
References: <20130108172632.1126898a@annuminas.surriel.com> <20130108173119.5e59fac2@annuminas.surriel.com> <CANN689H1eb_h-eX3wiEMczrA9hrX7C9zgwWzg0N7w_UcHHA2MA@mail.gmail.com>
In-Reply-To: <CANN689H1eb_h-eX3wiEMczrA9hrX7C9zgwWzg0N7w_UcHHA2MA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 08:01 AM, Michel Lespinasse wrote:
> On Tue, Jan 8, 2013 at 2:31 PM, Rik van Riel <riel@redhat.com> wrote:
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>>
>> Eric Dumazet found a regression with the first version of the spinlock
>> backoff code, in a workload where multiple spinlocks were contended,
>> each having a different wait time.
>>
>> This patch has multiple delay values per cpu, indexed on a hash
>> of the lock address, to avoid that problem.
>>
>> Eric Dumazet wrote:
>>
>> I did some tests with your patches with following configuration :
>>
>> tc qdisc add dev eth0 root htb r2q 1000 default 3
>> (to force a contention on qdisc lock, even with a multi queue net
>> device)
>>
>> and 24 concurrent "netperf -t UDP_STREAM -H other_machine -- -m 128"
>>
>> Machine : 2 Intel(R) Xeon(R) CPU X5660  @ 2.80GHz
>> (24 threads), and a fast NIC (10Gbps)
>>
>> Resulting in a 13 % regression (676 Mbits -> 595 Mbits)
>>
>> In this workload we have at least two contended spinlocks, with
>> different delays. (spinlocks are not held for the same duration)
>>
>> It clearly defeats your assumption of a single per cpu delay being OK :
>> Some cpus are spinning too long while the lock was released.
>>
>> We might try to use a hash on lock address, and an array of 16 different
>> delays so that different spinlocks have a chance of not sharing the same
>> delay.
>>
>> With following patch, I get 982 Mbits/s with same bench, so an increase
>> of 45 % instead of a 13 % regression.
>
> Note that these results were with your v1 proposal. With v3 proposal,
> on a slightly different machine (2 socket sandybridge) with a similar
> NIC, I am not seeing the regression when not using the hash table. I
> think this is because v3 got more conservative about mixed spinlock
> hold times, and converges towards the shortest of the hold times in
> that case.

Eric,

with just patches 1-3, can you still reproduce the
regression on your system?

In other words, could we get away with dropping the
complexity of patch 4, or do we still need it?


-- 
All rights reversed
