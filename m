Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2HMQy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:54:27 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:41788 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab2HMQyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:54:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120813163219.GA9180@google.com>
References: <1344874672-6257-1-git-send-email-js1304@gmail.com>
	<1344874672-6257-2-git-send-email-js1304@gmail.com>
	<20120813163219.GA9180@google.com>
Date: Tue, 14 Aug 2012 01:54:22 +0900
Message-ID: <CAAmzW4NfPAVQnmD0vG71Ahz_=gmV7CQBNABpnEHFU7YBsYJOyQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] workqueue: change value of lcpu in queue_delayed_work_on()
From: JoonSoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/14 Tejun Heo <tj@kernel.org>:
> Hello,
>
> On Tue, Aug 14, 2012 at 01:17:49AM +0900, Joonsoo Kim wrote:
>> We assign cpu id into work struct in queue_delayed_work_on().
>> In current implementation, when work is come in first time,
>> current running cpu id is assigned.
>> If we do queue_delayed_work_on() with CPU A on CPU B,
>> __queue_work() invoked in delayed_work_timer_fn() go into sub-optimal path
>> in case of WQ_NON_REENTRANT.
>> Change it to cpu argument is prevent to go into sub-optimal path.
>
> Which part is suboptimal?  Also, what if @cpu is WQ_UNBOUND?

Hi.
I think a following scenario.

wq = WQ_NON_REENTRANT.
queue_delayed_work_on(CPU B) is invoked in CPU A, so lcpu = CPU A, cpu = CPU B.

In this case, we call add_time_on(CPU B), then delayed_work_timer_fn()
is invoked on CPU B.
delayed_work_timer_fn() calls __queue_work(), then following
comparisons return true!

                gcwq = get_gcwq(cpu);
                if (wq->flags & WQ_NON_REENTRANT &&
                    (last_gcwq = get_work_gcwq(work)) && last_gcwq != gcwq) {

I thinks that if we assign cpu to lcpu, above comparisons return
false, so save some overheads.
Is there any missing part?

And, do u mean  @cpu is WORK_CPU_UNBOUND?

Thanks.
