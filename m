Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2DSSK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:10:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40609 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2DSSK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:10:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6686"; a="183215700"
Message-ID: <4F905521.9020901@codeaurora.org>
Date: Thu, 19 Apr 2012 11:10:41 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 1/2] workqueue: Catch more locking problems with flush_work()
References: <1334805958-29119-1-git-send-email-sboyd@codeaurora.org> <20120419152841.GA10553@google.com>
In-Reply-To: <20120419152841.GA10553@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/12 08:28, Tejun Heo wrote:
> On Wed, Apr 18, 2012 at 08:25:57PM -0700, Stephen Boyd wrote:
>> @@ -2513,8 +2513,11 @@ bool flush_work(struct work_struct *work)
>>  		wait_for_completion(&barr.done);
>>  		destroy_work_on_stack(&barr.work);
>>  		return true;
>> -	} else
>> +	} else {
>> +		lock_map_acquire(&work->lockdep_map);
>> +		lock_map_release(&work->lockdep_map);
>>  		return false;
> We don't have this annotation when start_flush_work() succeeds either,
> right?  IOW, would lockdep trigger when an actual deadlock happens?

I believe it does although I haven't tested it.

> If not, why not add the acquire/release() before flush_work() does
> anything?
>

I was worried about causing false positive lockdep warnings in the case
that start_flush_work() succeeds and returns true. In that case, lockdep
is told about the cwq lockdep map:

static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
                             bool wait_executing)
{

        .....

        if (cwq->wq->saved_max_active == 1 || cwq->wq->flags & WQ_RESCUER)
                lock_map_acquire(&cwq->wq->lockdep_map);
        else
                lock_map_acquire_read(&cwq->wq->lockdep_map);


and so if we acquired the work->lockdep_map before the
cwq->wq->lockdep_map we would get a warning about ABBA between these two
lockdep maps. At least that is what I'm lead to believe when I look at
what process_one_work() is doing. Please correct me if I'm wrong.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

