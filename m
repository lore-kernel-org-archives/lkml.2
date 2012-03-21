Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226Ab2CUBBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:01:15 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34078 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab2CUBBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:01:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120320164757.GG17071@redhat.com>
References: <4F62EE5E.5070207@kernel.org>
	<20120320164757.GG17071@redhat.com>
Date: Wed, 21 Mar 2012 09:01:13 +0800
X-Google-Sender-Auth: JTrwvhWq2KlWePGpPxWLqURvWHI
Message-ID: <CANejiEW_W7873HYi7v682KDCM+vFhD3-_5t0Br6Zb89wcU5MXQ@mail.gmail.com>
Subject: Re: [RFC]blk: mark discard request sync
From: Shaohua Li <shli@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/21 Vivek Goyal <vgoyal@redhat.com>:
> On Fri, Mar 16, 2012 at 03:40:14PM +0800, Shaohua Li wrote:
>>
>> Subject: blk: mark discard request sync
>>
>> discard is called in jbd for example. If discard is slowed down, all
>> file operations could be impacted (eg, journal is full). And we always
>> wait for discard to finish. So looks we should mark discard as sync.
>>
>> Signed-off-by: Shaohua Li <shli@fusionio.com>
>
> This one is tricky and I am not sure what's the right thing to do.
>
> Generally the philosophy seems to be that request is sync is somebody
> is waiting on it. To me even on async writes somebody is waiting (either
> file system or a writer which has been throttled). So if we don't do
> async writes in reasonable amount of time, we start getting "task blocked
> for more than 120 seconds" message.
Not just waiting. If jbd is slow and full, things will get crazy.

> Do you have some test cases to show how bad the problem is if we don't
> issue discard as SYNC request.
I came this idea when debugging Holger's discard slow problem, though his
problem isn't related to the issue because he is using noop. I realized this
could be a problem if ioscheduler is cfq. I tested a workload which deletes
a lot of small files. With a fusionio card (changing ioscheduler to
cfq), marking
discard sync gives slightly better performance. For ssd with slow discard, this
might be more significant (I didn't try, no such ssd).

But any way, I haven't too strong reason we should do this, this's why it's RFC.

Thanks,
Shaohua
