Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab1D1RL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 13:11:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6223 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867Ab1D1RL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 13:11:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HMNZ30iStSAPHH3P2SOhdQV4UtIOX7AUAFBBXj7p5IVePJOEvwu94j+ForEs6HZQm+
         gCU3IuTnmnj4XxfqpN7Q==
MIME-Version: 1.0
In-Reply-To: <m38vuu3dms.fsf@IBM-009124035060.in.ibm.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
 <1303332697-16426-3-git-send-email-ncrao@google.com> <m38vuu3dms.fsf@IBM-009124035060.in.ibm.com>
From: Nikhil Rao <ncrao@google.com>
Date: Thu, 28 Apr 2011 10:11:33 -0700
Message-ID: <BANLkTi=6mXoZgDssXi8U-K=+iRXFzF_zJQ@mail.gmail.com>
Subject: Re: [RFC][Patch 02/18] sched: increase SCHED_LOAD_SCALE resolution
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 2:54 AM, Nikunj A. Dadhania
<nikunj@linux.vnet.ibm.com> wrote:
> On Wed, 20 Apr 2011 13:51:21 -0700, Nikhil Rao <ncrao@google.com> wrote:
>> Introduce SCHED_LOAD_RESOLUTION, which scales is added to SCHED_LOAD_SHIFT and
>> increases the resolution of SCHED_LOAD_SCALE. This patch sets the value of
>> SCHED_LOAD_RESOLUTION to 10, scaling up the weights for all sched entities by
>> a factor of 1024. With this extra resolution, we can handle deeper cgroup
>> hiearchies and the scheduler can do better shares distribution and load
>> load balancing on larger systems (especially for low weight task groups).
>>
>> This does not change the existing user interface, the scaled weights are only
>> used internally. We do not modify prio_to_weight values or inverses, but use
>> the original weights when calculating the inverse which is used to scale
>> execution time delta in calc_delta_mine(). This ensures we do not lose accuracy
>> when accounting time to the sched entities.
>>
>> Signed-off-by: Nikhil Rao <ncrao@google.com>
>> ---
>>  include/linux/sched.h |    3 ++-
>>  kernel/sched.c        |   18 ++++++++++--------
>>  2 files changed, 12 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 8d1ff2b..d2c3bab 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -794,7 +794,8 @@ enum cpu_idle_type {
>>  /*
>>   * Increase resolution of nice-level calculations:
>>   */
>> -#define SCHED_LOAD_SHIFT     10
>> +#define SCHED_LOAD_RESOLUTION        10
>> +#define SCHED_LOAD_SHIFT     (10 + SCHED_LOAD_RESOLUTION)
>>  #define SCHED_LOAD_SCALE     (1L << SCHED_LOAD_SHIFT)
>>
>>  /*
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 50f97cc..bfee8ff 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -293,7 +293,7 @@ static DEFINE_SPINLOCK(task_group_lock);
>>   *  limitation from this.)
>>   */
>>  #define MIN_SHARES   2
>> -#define MAX_SHARES   (1UL << 18)
>> +#define MAX_SHARES   (1UL << 28)
> Shouldn't this change depend on SCHED_LOAD_RESOLUTION?
>
> #define MAX_SHARES      (1UL << (18 + SCHED_LOAD_RESOLUTION))
>

Right, and the other 18 bits come from SCHED_LOAD_SCALE + some slack,
which is also implicitly defined. I can make this more explicit in the
next rev as you suggest. I don't expect SCHED_LOAD_RESOLUTION to
change often though.

> Nikunj
>
