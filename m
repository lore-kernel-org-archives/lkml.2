Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299Ab0FKTLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 15:11:52 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33772 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469Ab0FKTLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 15:11:50 -0400
Message-ID: <4C128A75.3030501@fusionio.com>
Date: Fri, 11 Jun 2010 21:11:49 +0200
From: Jens Axboe <jaxboe@fusionio.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Carl Worth <cworth@cworth.org>,
       Eric Anholt <eric@anholt.net>, Divyesh Shah <dpshah@google.com>,
       "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.35-rc2-git2: Reported regressions from 2.6.34
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera> <alpine.LFD.2.00.1006081814240.4506@i5.linux-foundation.org> <4C0F4872.7090909@fusionio.com> <20100611083249.GA11143@elte.hu> <4C11F661.3070604@fusionio.com> <20100611085520.GA20218@elte.hu> <4C11FF77.1000101@fusionio.com> <20100611190714.GA20837@redhat.com>
In-Reply-To: <20100611190714.GA20837@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/10 21.07, Vivek Goyal wrote:
> On Fri, Jun 11, 2010 at 11:18:47AM +0200, Jens Axboe wrote:
>> On 2010-06-11 10:55, Ingo Molnar wrote:
>>>>> Caused by the same blkiocg_update_io_add_stats() function. Bootlog and config 
>>>>> attached. Reproducible on that sha1 and with that config.
>>>>
>>>> I think I see it, the internal CFQ blkg groups are not properly
>>>> initialized... Will send a patch shortly.
>>>
>>> Cool - can test it with a short turnaround, the bug is easy to reproduce.
>>
>> Here's a nasty patch that should fix it. Not optimal, since we really
>> just want empty functions for these when cfq group scheduling is not
>> defined.
>>
>> CC'ing the guilty parties to come up with a better patch that does NOT
>> involve ifdefs in cfq-iosched.c. We want blk-cgroup.[ch] fixed up.
>> And trimming the CC list a bit.
> 
> Jens, Ingo, I am sorry for this mess.
> 
> Jens,
> 
> How about introducing "block/cfq.h" and declaring additional set of wrapper
> functions to update blkiocg stats and make these do nothing if
> CFQ_GROUP_IOSCHED=n.
> 
> For example, in linux-2.6/block/cfq.h, we can define functions as follows.
> 
> #ifdef CONFIG_CFQ_GROUP_IOSCHED
> cfq_blkiocg_update_dequeue_stats () {
> 	blkiocg_update_dequeue_stats()
> }
> #else
> cfq_blkiocg_update_dequeue_stats () {}
> #endif
> 
> Fixing it blk-cgroup.[ch] might not be best as BLK_CGROUP is set.
> Secondly, if there are other IO control policies later, they might
> want to make use of BLK_CGROUP while cfq has disabled the group io 
> scheduling.

I already tried such a patch, but it's not exactly pretty. How about
splitting blk-cgroup.c into two parts, one that is built for
BLK_CGROUP and an additional one that is also built for
CFQ_GROUP_SCHED? Lets try and improve on the ifdef mess, not extend
it.

-- 
Jens Axboe

