Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1KQIbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:31:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58271 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab1KQIbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:31:08 -0500
Message-ID: <4EC4C603.8050704@cn.fujitsu.com>
Date: Thu, 17 Nov 2011 16:29:55 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.2-rc3] cpusets: stall when updating mems_allowed
 for mempolicy or disjoint nodemask
References: <alpine.DEB.2.00.1111161307020.23629@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1111161307020.23629@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-17 16:30:48,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-17 16:30:48,
	Serialize complete at 2011-11-17 16:30:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 13:08:33 -0800 (pst), David Rientjes wrote:
> c0ff7453bb5c ("cpuset,mm: fix no node to alloc memory when changing
> cpuset's mems") adds get_mems_allowed() to prevent the set of allowed
> nodes from changing for a thread.  This causes any update to a set of
> allowed nodes to stall until put_mems_allowed() is called.
> 
> This stall is unncessary, however, if at least one node remains unchanged
> in the update to the set of allowed nodes.  This was addressed by
> 89e8a244b97e ("cpusets: avoid looping when storing to mems_allowed if one
> node remains set"), but it's still possible that an empty nodemask may be
> read from a mempolicy because the old nodemask may be remapped to the new
> nodemask during rebind.  To prevent this, only avoid the stall if there
> is no mempolicy for the thread being changed.
> 
> This is a temporary solution until all reads from mempolicy nodemasks can
> be guaranteed to not be empty without the get_mems_allowed()
> synchronization.
> 
> Also moves the check for nodemask intersection inside task_lock() so that
> tsk->mems_allowed cannot change.
> 
> Reported-by: Miao Xie <miaox@cn.fujitsu.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

Oh~, David

I find these is another problem, please take account of the following case:

  2-3 -> 1-2 -> 0-1

the user change mems_allowed twice continuously, the task may see the empty
mems_allowed.

So, it is still dangerous.

Thanks
Miao

> ---
>  kernel/cpuset.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -949,7 +949,7 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
>  static void cpuset_change_task_nodemask(struct task_struct *tsk,
>  					nodemask_t *newmems)
>  {
> -	bool masks_disjoint = !nodes_intersects(*newmems, tsk->mems_allowed);
> +	bool need_loop;
>  
>  repeat:
>  	/*
> @@ -962,6 +962,14 @@ repeat:
>  		return;
>  
>  	task_lock(tsk);
> +	/*
> +	 * Determine if a loop is necessary if another thread is doing
> +	 * get_mems_allowed().  If at least one node remains unchanged and
> +	 * tsk does not have a mempolicy, then an empty nodemask will not be
> +	 * possible when mems_allowed is larger than a word.
> +	 */
> +	need_loop = tsk->mempolicy ||
> +			!nodes_intersects(*newmems, tsk->mems_allowed);
>  	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
>  	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP1);
>  
> @@ -981,12 +989,9 @@ repeat:
>  
>  	/*
>  	 * Allocation of memory is very fast, we needn't sleep when waiting
> -	 * for the read-side.  No wait is necessary, however, if at least one
> -	 * node remains unchanged and tsk has a mempolicy that could store an
> -	 * empty nodemask.
> +	 * for the read-side.
>  	 */
> -	while (masks_disjoint && tsk->mempolicy &&
> -			ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
> +	while (need_loop && ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
>  		task_unlock(tsk);
>  		if (!task_curr(tsk))
>  			yield();
> 

