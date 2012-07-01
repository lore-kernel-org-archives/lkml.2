Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2GAPeK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 11:34:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab2GAPeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 11:34:08 -0400
Message-ID: <4FF06DBD.6020901@redhat.com>
Date: Sun, 01 Jul 2012 11:33:17 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 20/40] autonuma: alloc/free/init mm_autonuma
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-21-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-21-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 08:56 AM, Andrea Arcangeli wrote:

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 0adbe09..3e5a0d9 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -527,6 +527,8 @@ static void mm_init_aio(struct mm_struct *mm)
>
>   static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
>   {
> +	if (unlikely(alloc_mm_autonuma(mm)))
> +		goto out_free_mm;
>   	atomic_set(&mm->mm_users, 1);
>   	atomic_set(&mm->mm_count, 1);
>   	init_rwsem(&mm->mmap_sem);

I wonder if it would be possible to defer the allocation
of the mm_autonuma struct to knuma_scand, so short lived
processes never have to allocate and free the mm_autonuma
structure.

That way we only have a function call at exit time, and
the branch inside kfree that checks for a null pointer.

-- 
All rights reversed
