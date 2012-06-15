Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab2FOO1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 10:27:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46421 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab2FOO1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:27:20 -0400
Message-ID: <4FDB4642.5070509@gmail.com>
Date: Fri, 15 Jun 2012 22:27:14 +0800
From: Charles Wang <muming.wq@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Charles Wang <muming.wq@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Tao Ma <tm@tao.ma>,
        =?UTF-8?B?5ZCr6bub?= <handai.szj@taobao.com>,
        Doug Smythies <dsmythies@telus.net>
Subject: Re: [PATCH] sched: Folding nohz load accounting more accurate
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>  <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com> <1339494970.31548.66.camel@twins>
In-Reply-To: <1339494970.31548.66.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 12, 2012 05:56 PM, Peter Zijlstra wrote:

> Also added Doug to CC, hopefully we now have everybody who pokes at this
> stuff.
> 
> On Tue, 2012-06-12 at 17:34 +0800, Charles Wang wrote:
>> consider following case:
>>
>> 5HZ+1
>> | cpu0_load     cpu1    cpu2    cpu3    calc_load_tasks
>> |    1           1       1       1      
>> |  -->calc_load                             1
>> |    1           1       1       1      
>> |              -->calc_load                 2
>> |    0           0       1       0
>> |                      -->calc_load         2+1-3=1
> 
> Not sure but last time I did the math 2+1-3 ended up being 0.
> 
>> |    1           1       0       1      
>> |                            -->calc_load   1-1=0
>> V
>> 5HZ+11     -->calc_global_load              0
>>
>> actually the load should be around 3, but shows nearly 0.
>>
>> 1 tick is much long for some workloads. 
> 
> Yes, one tick is long for some stuff, but seeing we sample once every 5
> seconds a little fuzz around sampling the nr_running+nr_uninterruptible
> thing shouldn't be too bad.
> 
> But I think I see what you're getting at.. lemme get more tea and ponder
> this a bit.
> .
> 


In our mind per-cpu sampling for cpu idle and non-idle is equal. But
actually may not. For non-idle cpu sampling, it's right the load when
sampling. But for idle, cause of nohz, the sampling will be delayed to
nohz exit(less than 1 tick after nohz exit). Nohz exit is always caused
by processes woken up--non-idle model. It's not fair here, idle
calculated to non-idle.

     time-expect-sampling
                   |    time-do-sampling
                   |         |
                   V         V
-|-------------------------|--
start_nohz              stop_nohz


This may explain why using my patch the load shows higher, also may
explain some reports about high load for current.

I tried a experiments, results showed better. Now i need more experiments.

Peter, is this right as i thought?
