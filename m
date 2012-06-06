Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab2FFCNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 22:13:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab2FFCNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 22:13:30 -0400
Message-ID: <4FCEBD12.4030706@redhat.com>
Date: Wed, 06 Jun 2012 10:14:42 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] block: Avoid missed wakeup in request waitqueue
References: <20120528102614.GC15202@dhcp-172-17-108-109.mtv.corp.google.com> <1338254100-13336-1-git-send-email-asias@redhat.com> <20120529012115.GE20954@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120529012115.GE20954@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens

On 05/29/2012 09:21 AM, Tejun Heo wrote:
> On Tue, May 29, 2012 at 09:15:00AM +0800, Asias He wrote:
>> After hot-unplug a stressed disk, I found that rl->wait[] is not empty
>> while rl->count[] is empty and there are theads still sleeping on
>> get_request after the queue cleanup. With simple debug code, I found
>> there are exactly nr_sleep - nr_wakeup of theads in D state. So there
>> are missed wakeup.
>>
>>    $ dmesg | grep nr_sleep
>>    [   52.917115] --->  nr_sleep=1046, nr_wakeup=873, delta=173
>>    $ vmstat 1
>>    1 173  0 712640  24292  96172 0 0  0  0  419  757  0  0  0 100  0
>>
>> To quote Tejun:
>>
>>    Ah, okay, freed_request() wakes up single waiter with the assumption
>>    that after the wakeup there will at least be one successful allocation
>>    which in turn will continue the wakeup chain until the wait list is
>>    empty - ie. waiter wakeup is dependent on successful request
>>    allocation happening after each wakeup.  With queue marked dead, any
>>    woken up waiter fails the allocation path, so the wakeup chaining is
>>    lost and we're left with hung waiters. What we need is wake_up_all()
>>    after drain completion.
>>
>> This patch fixes the missed wakeup by waking up all the theads which
>> are sleeping on wait queue after queue drain.
>>
>> Changes in v2: Drop waitqueue_active() optimization
>>
>> Signed-off-by: Asias He<asias@redhat.com>
>
> Acked-by: Tejun Heo<tj@kernel.org>
>
> Jens, this one wants Cc: stable.

Ping.

-- 
Asias
