Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760326Ab0I0WlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:41:13 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:33243 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760279Ab0I0WlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:41:12 -0400
X-ASG-Debug-ID: 1285627270-08b783ee0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CA11D83.6010500@fusionio.com>
Date: Tue, 28 Sep 2010 07:41:07 +0900
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Vivek Goyal <vgoyal@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: Request starvation with CFQ
References: <20100927190024.GF3610@quack.suse.cz> <20100927200232.GA2377@redhat.com> <4CA114F8.8000102@fusionio.com> <20100927223515.GH3610@quack.suse.cz>
X-ASG-Orig-Subj: Re: Request starvation with CFQ
In-Reply-To: <20100927223515.GH3610@quack.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1285627270
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.42080
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-28 07:35, Jan Kara wrote:
> On Tue 28-09-10 07:04:40, Jens Axboe wrote:
>> On 2010-09-28 05:02, Vivek Goyal wrote:
>>> On Mon, Sep 27, 2010 at 09:00:24PM +0200, Jan Kara wrote:
>>>>   Hi,
>>>>
>>>>   when helping Lennart with answering some questions, I've spotted the
>>>> following problem (at least I think it's a problem ;): The thing is that
>>>> CFQ schedules how requests should be dispatched but does not in any
>>>> significant way limit to whom requests get allocated. Given we have a
>>>> quite limited pool of available requests it can happen that processes
>>>> will be actually starved not waiting for disk but waiting for requests
>>>> getting allocated and any IO scheduling priorities or classes will not
>>>> have serious effect.
>>>>   A pathological example I've tried below:
>>>> #include <fcntl.h>
>>>> #include <stdio.h>
>>>> #include <stdlib.h>
>>>> #include <sys/stat.h>
>>>>
>>>> int main(void)
>>>> {
>>>>   int fd = open("/dev/vdb", O_RDONLY);
>>>>   int loop = 0;
>>>>
>>>>   if (fd < 0) {
>>>>     perror("open");
>>>>     exit(1);
>>>>   }
>>>>   while (1) {
>>>>     if (loop % 100 == 0)
>>>>       printf("Loop %d\n", loop);
>>>>     posix_fadvise(fd, (random() * 4096) % 1000204886016ULL, 4096, POSIX_FADV_WILLNEED);
>>>>     loop++;
>>>>   }
>>>> }
>>>>
>>>>   This program will just push as many requests as possible to the block
>>>> layer and does not wait for any IO. Thus it will basically ignore any
>>>> decisions about when requests get dispatched. BTW, don't get distracted
>>>> by the fact that the program operates directly on the device, that is just
>>>> for simplicity. Large enough file would work the same way.
>>>>   Even though I run this program with ionice -c 3, I still see that any
>>>> other IO to the device is basically stalled. When I look at the block
>>>> traces, I indeed see that what happens is that the above program submits
>>>> requests until there are no more available:
> <snip>
>>>>   I can provide the full traces for download if someone is interested
>>>> in some part I didn't include here. The kernel is 2.6.36-rc4.
>>>>   Now I agree that the above program is about as bad as it can get but
>>>> Lennart would like to implement readahead during boot on background and
>>>> I believe that could starve other IO in a similar way. So any idea how
>>>> to solve this? To me it seems as if we also needed to somehow limit the
>>>> number of allocated requests per cfqq but OTOH we have to be really careful
>>>> to not harm common workloads where we benefit from having lots of requests
>>>> queued...
>>>
>>> Hi Jan,
>>>
>>> True that during request allocation, there is no consideration for ioprio.
>>> I think the whole logic is round robin, where after getting a bunch of
>>> request each process is put to sleep in the queue and then we do round
>>> robin on all waiters. This should in general be an issue with request
>>> queue and not just CFQ.
>>>
>>> So if there are bunch of threads which are very bullish on doing IO, and 
>>> there is a dependent reader, read latencies will shoot up.
>>>
>>> In fact current implementation of blkio controller also suffers with this
>>> limitation because we don't yet have per group request descriptors and
>>> once request queue is congested, requests from one group can get stuck
>>> behind the requests from other group.
>>>
>>> One way forward could be to implement per cgroup request descriptors and
>>> put this readahead thread into a separate cgroup of low weight.
>>>
>>> Other could be to implemnet some kind of request quota per priority level.
>>> This is similar to per cgroup quota I talked above, just one level below.
>>>
>>> Third could be ad-hoc way of putting some limit on per cfqq. But I think a
>>> process can easily circumvent that by forking off child which are not
>>> sharing cfq context and then we are back to same situaiton.
>>>
>>> A very hackish solution could be to try to increase nr_requests on the 
>>> queue to say 1024. This will work only if you know that read-ahead process
>>> does some limited amount of read-ahead and does not overwhelm the queue
>>> with more than 1024 requets.  And then use ioprio with low prio for
>>> read-ahead process.
>>
>> I don't think that is necessarily hackish. The current rq allocation
>> batching and accounting is pretty horrible imho, in fact in recent
>> patches I ripped that out. The vm copes a lot better with larger depths
>> these days, so what I want to add is just a per-ioc queue limit instead.
>   So no per-queue request limit? Since ioc is per-process if I'm right,
> that would solve the problem quite nicely. Thanks for info.

Exactly, no more per-queue upper limit, or at least a very relaxed one
if that. I want to get rid of some of that shared state.

-- 
Jens Axboe

