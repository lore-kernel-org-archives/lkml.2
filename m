Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab1CGTjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:39:55 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48458 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329Ab1CGTjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:39:54 -0500
Message-ID: <4D753488.6090808@kernel.dk>
Date: Mon, 07 Mar 2011 20:39:52 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: RFC: default group_isolation to 1, remove option
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com> <20110301142002.GB25699@redhat.com> <4D6F0ED0.80804@kernel.dk> <AANLkTin+TycqQxWGyxWOsuT+WOaEA0XhqFkJBMKe7-uY@mail.gmail.com>
In-Reply-To: <AANLkTin+TycqQxWGyxWOsuT+WOaEA0XhqFkJBMKe7-uY@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-07 19:20, Justin TerAvest wrote:
> On Wed, Mar 2, 2011 at 7:45 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2011-03-01 09:20, Vivek Goyal wrote:
>>> I think creating per group request pool will complicate the
>>> implementation further. (we have done that once in the past). Jens
>>> once mentioned that he liked number of requests per iocontext limit
>>> better than overall queue limit. So if we implement per iocontext
>>> limit, it will get rid of need of doing anything extra for group
>>> infrastructure.
>>>
>>> Jens, do you think per iocontext per queue limit on request
>>> descriptors make sense and we can get rid of per queue overall limit?
>>
>> Since we practically don't need a limit anymore to begin with (or so is
>> the theory), then yes we can move to per-ioc limits instead and get rid
>> of that queue state. We'd have to hold on to the ioc for the duration of
>> the IO explicitly from the request then.
>>
>> I primarily like that implementation since it means we can make the IO
>> completion lockless, at least on the block layer side. We still have
>> state to complete in the schedulers that require that, but it's a good
>> step at least.
> 
> So, the primary advantage of using per-ioc limits that we can make IO
> completions lockless?

Primarily, yes. The rq pool and accounting is the only state left we
have to touch from both queuing IO and completing it.

> I'm concerned that looking up the correct iocontext for a page will be
> more complicated, and require more storage (than a css_id, anyway). I
> think Vivek mentioned this too.

A contained cgroup, is that sharing an IO context across the processes?

> I don't understand what the advantage is of offering isolation between
> iocontexts within a cgroup; if the user wanted isolation, shouldn't
> they just create multiple cgroups? It seems like per-cgroup limits
> would work as well.

It's at least not my goal, it has nothing to do with isolation. Since we
have ->make_request_fn() drivers operating completely without queuing
limits, it may just be that we can drop the tracking completely on the
request side. Either one is currently broken, or both will work that
way. And if that is the case, then we don't have to do this ioc tracking
at all. With the additional complication of now needing
per-disk-per-process io contexts, that approach is looking a lot more
tasty right now.

Or not get rid of limits completely, but do a lot more relaxed
accounting at the queue level still. That will not require any
additional tracking of io contexts etc, but still impose some limit on
the number of queued IOs.

-- 
Jens Axboe

