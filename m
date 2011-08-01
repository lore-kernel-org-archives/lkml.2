Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1HALwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 07:52:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56308 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab1HALwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 07:52:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E369372.80105@jp.fujitsu.com>
Date: Mon, 01 Aug 2011 20:52:18 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: oleg@redhat.com
CC: rientjes@google.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, roland@hack.frob.com, tj@kernel.org,
        dvlasenk@redhat.com, matt.fleming@linux.intel.com,
        linux-kernel@vger.kernel.org, avagin@openvz.org, fhrbata@redhat.com,
        yinghan@google.com
Subject: Re: mm->oom_disable_count is broken
References: <20110727163159.GA23785@redhat.com> <20110727163610.GJ23793@redhat.com> <20110727175624.GA3950@redhat.com> <20110728154324.GA22864@redhat.com> <alpine.DEB.2.00.1107281341060.16093@chino.kir.corp.google.com> <20110729141431.GA3501@redhat.com> <20110730143426.GA6061@redhat.com> <20110730152238.GA17424@redhat.com>
In-Reply-To: <20110730152238.GA17424@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/31 0:22), Oleg Nesterov wrote:
> On 07/30, Oleg Nesterov wrote:
>>
>> So I'd suggest this hack^Wpatch as a quick fix. I still think this
>> code is not right, but the patch tries to keep the current logic.
> 
> And this reminds me. mm->oom_disable_count looks absolutely broken.
> IIRC, I already complained but nobody replied.
>
> What does this counter mean?
> 
> 	/* How many tasks sharing this mm are OOM_DISABLE */
> 	atomic_t oom_disable_count;
> 
> tasks? processes or threads?
> 
> Lets look at oom_adjust_write(),
> 
> 		if (task->signal->oom_adj == OOM_DISABLE)
> 			atomic_inc(&task->mm->oom_disable_count);
> 
> OK, so it is per-process. No matter how many threads this process
> has, mm->oom_disable_count becomes 1 (ignoring CLONE_VM).
> 
> 
> However, exit_mm() does:
> 
> 	if (tsk->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
> 		atomic_dec(&mm->oom_disable_count);
> 
> but this is per-thread! it becomes zero and then negative after
> pthread_exit().
> 
> 
> copy_process()->copy_mm() seems to think it is per-thread too. But,
> bad_fork_cleanup_mm:
> 
> 	if (p->mm) {
> 		task_lock(p);
> 		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
> 			atomic_dec(&p->mm->oom_disable_count);
> 		task_unlock(p);
> 		mmput(p->mm);
> 	}
> 
> Why do we take task_lock() ? OK, oom_score_adj_write() does task_lock()
> too, but this can't help in the multithreaded case? Why copy_mm() checks
> ->oom_score_adj lockless?

IIRC, I did pointed out this issue. But nobody replied.
I think ->oom_disable_count is currently broken. but now I have no time to
audit this stuff. So, I'd suggest to revert this code if nobody don't fix it.




