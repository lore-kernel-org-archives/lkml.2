Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab0F3Qnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:43:46 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34669 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530Ab0F3Qno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:43:44 -0400
Message-ID: <4C2B742F.6050403@us.ibm.com>
Date: Wed, 30 Jun 2010 09:43:27 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] futex: futex_find_get_task remove credentails check
References: <4C24ED34.9040808@us.ibm.com> <4C253D32.6040304@us.ibm.com> <20100628144246.GA14201@tiehlicka.suse.cz> <20100628153214.GA24127@tiehlicka.suse.cz> <20100628155845.GC24127@tiehlicka.suse.cz> <20100628163952.GD24127@tiehlicka.suse.cz> <1277743748.3561.139.camel@laptop> <20100629084230.GE6215@tiehlicka.suse.cz> <AANLkTinyoyZVg8iYOuUx6aA4XlUlLywl4q6GLXmeYP-x@mail.gmail.com> <20100630070115.GB3890@tiehlicka.suse.cz> <20100630095525.GA5840@tiehlicka.suse.cz>
In-Reply-To: <20100630095525.GA5840@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 02:55 AM, Michal Hocko wrote:
> On Wed 30-06-10 09:01:15, Michal Hocko wrote:
>> On Tue 29-06-10 09:41:02, Linus Torvalds wrote:
>>> On Tue, Jun 29, 2010 at 1:42 AM, Michal Hocko<mhocko@suse.cz>  wrote:
>>>>
>>>> futex_find_get_task is currently used (through lookup_pi_state) from two
>>>> contexts, futex_requeue and futex_lock_pi_atomic. While credentials check
>>>> makes sense in the first code path, the second one is more problematic
>>>> because this check requires that the PI lock holder (pid parameter) has
>>>> the same uid and euid as the process's euid which is trying to lock the
>>>> same futex (current).
>>>
>>> So exactly why does it make sense to check the credentials in the
>>> first code path then?
>>
>> I though that requeue needs this for security reasons (don't let requeue
>> process for other user), but when I thought about that again you are
>> right and the only what matters should be accessibility of the shared
>> memory.
>
> And here is the patch which does the thing.
>
> --
>
>  From 082c5ad2c482a8e78b61b17e213e750b006176aa Mon Sep 17 00:00:00 2001
> From: Michal Hocko<mhocko@suse.cz>
> Date: Wed, 30 Jun 2010 09:51:19 +0200
> Subject: [PATCH] futex: futex_find_get_task remove credentails check
>
> futex_find_get_task is currently used (through lookup_pi_state) from two
> contexts, futex_requeue and futex_lock_pi_atomic. None of the paths
> looks it needs the credentials check, though. Different (e)uids
> shouldn't matter at all because the only thing that is important for
> shared futex is the accessibility of the shared memory.
>
> The credentail check results in glibc assert failure or process hang (if
> glibc is compiled without assert support) for shared robust pthread
> mutex with priority inheritance if a process tries to lock already held
> lock owned by a process with a different euid:
>
> pthread_mutex_lock.c:312: __pthread_mutex_lock_full: Assertion `(-(e)) != 3 || !robust' failed.
>
> The problem is that futex_lock_pi_atomic which is called when we try to
> lock already held lock checks the current holder (tid is stored in the
> futex value) to get the PI state. It uses lookup_pi_state which in turn
> gets task struct from futex_find_get_task. ESRCH is returned either when
> the task is not found or if credentials check fails.
> futex_lock_pi_atomic simply returns if it gets ESRCH. glibc code,
> however,  doesn't expect that robust lock returns with ESRCH because it
> should get either success or owner died.
>
> Signed-off-by: Michal Hocko<mhocko@suse.cz>

Without hearing back from Ingo on the original intent of the credentials 
check, this looks right to me.

Acked-by: Darren Hart <dvhltc@us.ibm.com>


> ---
>   kernel/futex.c |   17 ++++-------------
>   1 files changed, 4 insertions(+), 13 deletions(-)
>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index e7a35f1..6a3a5fa 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -429,20 +429,11 @@ static void free_pi_state(struct futex_pi_state *pi_state)
>   static struct task_struct * futex_find_get_task(pid_t pid)
>   {
>   	struct task_struct *p;
> -	const struct cred *cred = current_cred(), *pcred;
>
>   	rcu_read_lock();
>   	p = find_task_by_vpid(pid);
> -	if (!p) {
> -		p = ERR_PTR(-ESRCH);
> -	} else {
> -		pcred = __task_cred(p);
> -		if (cred->euid != pcred->euid&&
> -		    cred->euid != pcred->uid)
> -			p = ERR_PTR(-ESRCH);
> -		else
> -			get_task_struct(p);
> -	}
> +	if (p)
> +		get_task_struct(p);
>
>   	rcu_read_unlock();
>
> @@ -564,8 +555,8 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
>   	if (!pid)
>   		return -ESRCH;
>   	p = futex_find_get_task(pid);
> -	if (IS_ERR(p))
> -		return PTR_ERR(p);
> +	if (!p)
> +		return -ESRCH;
>
>   	/*
>   	 * We need to look at the task state flags to figure out,


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
