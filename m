Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0FLBzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 21:55:16 -0400
Received: from smtp-out.google.com ([74.125.121.35]:5321 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0FLBzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 21:55:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding;
	b=DbftpkRXLwooDP4hSh7gFWwarkgUYtoq6MobhMaTAtpF1JswJQAzSimVcHYRxIQzb
	0Jeqjefa9utGv5CEIR1ag==
MIME-Version: 1.0
In-Reply-To: <20100601075345.GP1660@kernel.dk>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins> 
	<20100601064120.GA3407@elte.hu> <20100601064726.GG1660@kernel.dk> 
	<20100601065500.GA7876@elte.hu> <20100601075345.GP1660@kernel.dk>
From: Divyesh Shah <dpshah@google.com>
Date: Fri, 11 Jun 2010 18:54:48 -0700
Message-ID: <AANLkTilDRP8WX62NwnjgBROf3hWsI5BHPJf__Aw77-la@mail.gmail.com>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code: 
	icedove-bin/5449
To: Jens Axboe <axboe@kernel.dk>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       piotr@hosowicz.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 12:53 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On Tue, Jun 01 2010, Ingo Molnar wrote:
>>
>> * Jens Axboe <axboe@kernel.dk> wrote:
>>
>> > On Tue, Jun 01 2010, Ingo Molnar wrote:
>> > >
>> > > * Peter Zijlstra <peterz@infradead.org> wrote:
>> > >
>> > > > On Mon, 2010-05-24 at 05:03 +0200, Piotr Hosowicz wrote:
>> > > > > [  720.313607] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
>> > > > > [  720.313612] caller is native_sched_clock+0x3c/0x68
>> > > > > [  720.313616] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
>> > > > > [  720.313618] Call Trace:
>> > > > > [  720.313624]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
>> > > > > [  720.313629]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
>> > > > > [  720.313634]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
>> > > > > [  720.313637]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
>> > > > > [  720.313641]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
>> > > > > [  720.313646]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
>> > > >
>> > > > This comes from wreckage in the blk tree..
>> > > >
>> > > > ---
>> > > > commit 9195291e5f05e01d67f9a09c756b8aca8f009089
>> > > > Author: Divyesh Shah <dpshah@google.com>
>> > > > Date:   Thu Apr 1 15:01:41 2010 -0700
>> > > >
>> > > >     blkio: Increment the blkio cgroup stats for real now
>> > >
>> > > Jens, this regression is still in .35-rc1 and triggers in about 25% of all
>> > > -tip boot tests.
>> > >
>> > > The above commit is using sched_clock() in an unsafe way - please fix it or
>> > > revert it.
>> > >
>> > > The local_clock() changes PeterZ is working on are still WIP, it's not sure
>> > > we'll have it before .36.
>> >
>> > OK, I guess we'll have to solve this differently for .35 - I'll cook up
>> > something simple, if need be revert the change.
>>
>> I suspect you can put get_cpu/put_cpu around it and use cpu_clock(). The
>> cross-CPU effects will still be there and there might be weird stats.
>
> It'll shut it up at least, which is the primary concern at this point.

Jens,
     Thanks for the temporary fix (adding preempt_enable/disable()
calls). I was able to repro the issue and and have a patch that
replaces use of sched_clock() in block layer w/
ktime_to_ns(ktime_get()). We will lose resolution when running w/o
highres timers but should be better than unbounded drift between cpus.
I'll send the patch next.

-Divyesh

>
> --
> Jens Axboe
>
>
