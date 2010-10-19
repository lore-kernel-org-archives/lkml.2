Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966Ab0JSLzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:55:13 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34844 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932693Ab0JSLzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:55:12 -0400
Message-ID: <4CBD871C.2080900@kernel.dk>
Date: Tue, 19 Oct 2010 13:55:08 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Fix array overflow in CFQ
References: <1287479450-11447-1-git-send-email-andi@firstfloor.org> <4CBD6C84.3020309@kernel.dk> <20101019114933.GA857@redhat.com>
In-Reply-To: <20101019114933.GA857@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-19 13:49, Vivek Goyal wrote:
> On Tue, Oct 19, 2010 at 12:01:40PM +0200, Jens Axboe wrote:
>> On 2010-10-19 11:10, Andi Kleen wrote:
>>> From: Andi Kleen <ak@linux.intel.com>
>>>
>>> gcc 4.5 complains when compiling a recent rc with
>>>
>>> linux/block/cfq-iosched.c: In function ‘cfq_dispatch_requests’:
>>> linux/block/cfq-iosched.c:2156:3: warning: array subscript is above array bounds
>>>
>>> and it is right:
>>>
>>>  slice = group_slice * count /
>>>                 max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
>>>                       cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));
>>>
>>> busy_queues_avg can be indexed by this enum
>>>
>>> enum wl_prio_t {
>>>         BE_WORKLOAD = 0,
>>>         RT_WORKLOAD = 1,
>>>         IDLE_WORKLOAD = 2,
>>> };
>>>
>>> in cfqd->serving_prio, but is only declared as
>>>
>>> unsigned int busy_queues_avg[2];
>>>
>>> which is clearly off by one. Fix this here.
>>
>> Indeed, that is definitely buggy. ->service_trees[][] looks buggy, too.
>> WTF?!
> 
> Hi Jens,
> 
> busy_queues_avg[] definitely looks buggy. Looks like I introduced this bug
> while converting corrado's logic to group logic. I will fix it in a while.
> Sorry for the goof up here.
> 
> ->service_trees[][] is not buggy. We maintain workload subclassification
> only for RT and BE class. For IDLE class, there are no ASYNC_WORKLOAD,
> SYNC_NOIDLE_WORKLOAD or SYNC_WORKLOAD. All the type of idle queues
> go onto a separate service tree, service_tree_idle.

Right, that one looks convoluted (but correct). Ugh:

#define for_each_cfqg_st(cfqg, i, j, st) \
        for (i = 0; i <= IDLE_WORKLOAD; i++) \
                for (j = 0, st = i < IDLE_WORKLOAD ?  &cfqg->service_trees[i][j]\
                        : &cfqg->service_tree_idle; \
                        (i < IDLE_WORKLOAD && j <= SYNC_WORKLOAD) || \
                        (i == IDLE_WORKLOAD && j == 0); \
                        j++, st = i < IDLE_WORKLOAD ? \
                        &cfqg->service_trees[i][j]: NULL) \

-- 
Jens Axboe

