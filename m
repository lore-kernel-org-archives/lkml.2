Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab1LFWdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:33:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45834 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab1LFWdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:33:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] PM / Freezer: Remove the "userspace only" 
 =?iso-8859-1?q?=09constraint_from?= freezer[_do_not]_count()
Date: Tue, 6 Dec 2011 23:36:40 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, pavel@ucw.cz, len.brown@intel.com,
        tj@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <20111206160251.16729.62719.stgit@srivatsabhat.in.ibm.com> <20111206172020.GA709@redhat.com> <4EDE5AE1.2080607@linux.vnet.ibm.com>
In-Reply-To: <4EDE5AE1.2080607@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112062336.40846.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 06, 2011, Srivatsa S. Bhat wrote:
> On 12/06/2011 10:50 PM, Oleg Nesterov wrote:
> 
> > On 12/06, Srivatsa S. Bhat wrote:
> >>
> >> And moreover, even the vfork issue does not need
> >> the above restriction in these functions, since they are anyway called by
> >> userspace processes.
> > 
> > This looks a bit confusing, as if CLONE_VFORK is not used by kthreads.
> > It is actually used, but only by the non-freezeable workqueue threads,
> > so the patch is fine.
> > 
> > Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> > 
> 
> 
> Thank you! I have updated the commit message by omitting the confusing part:
> 
> ---
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> [PATCH 1/2] PM / Freezer: Remove the "userspace only" constraint from freezer[_do_not]_count()
> 
> At present, the functions freezer_count() and freezer_do_not_count()
> impose the restriction that they are effective only for userspace processes.
> However, now, these functions have found more utility than originally
> intended by the commit which introduced it: ba96a0c8 (freezer:
> fix vfork problem). And moreover, even the vfork issue actually does not
> need the above restriction in these functions.
> 
> So, modify these functions to make them work even for kernel threads, so
> that they can be used at other places in the kernel, where the userspace
> restriction doesn't apply.
> 
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Suggested-by: Tejun Heo <tj@kernel.org>
> Acked-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied to linux-pm/linux-next ([2/2] too).

Thanks,
Rafael


> ---
> 
>  include/linux/freezer.h |   28 +++++++++++-----------------
>  1 files changed, 11 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index 30f06c2..7bcfe73 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -67,33 +67,27 @@ static inline bool cgroup_freezing(struct task_struct *task)
>   * appropriately in case the child has exited before the freezing of tasks is
>   * complete.  However, we don't want kernel threads to be frozen in unexpected
>   * places, so we allow them to block freeze_processes() instead or to set
> - * PF_NOFREEZE if needed and PF_FREEZER_SKIP is only set for userland vfork
> - * parents.  Fortunately, in the ____call_usermodehelper() case the parent won't
> - * really block freeze_processes(), since ____call_usermodehelper() (the child)
> - * does a little before exec/exit and it can't be frozen before waking up the
> - * parent.
> + * PF_NOFREEZE if needed. Fortunately, in the ____call_usermodehelper() case the
> + * parent won't really block freeze_processes(), since ____call_usermodehelper()
> + * (the child) does a little before exec/exit and it can't be frozen before
> + * waking up the parent.
>   */
>  
> -/*
> - * If the current task is a user space one, tell the freezer not to count it as
> - * freezable.
> - */
> +
> +/* Tell the freezer not to count the current task as freezable. */
>  static inline void freezer_do_not_count(void)
>  {
> -	if (current->mm)
> -		current->flags |= PF_FREEZER_SKIP;
> +	current->flags |= PF_FREEZER_SKIP;
>  }
>  
>  /*
> - * If the current task is a user space one, tell the freezer to count it as
> - * freezable again and try to freeze it.
> + * Tell the freezer to count the current task as freezable again and try to
> + * freeze it.
>   */
>  static inline void freezer_count(void)
>  {
> -	if (current->mm) {
> -		current->flags &= ~PF_FREEZER_SKIP;
> -		try_to_freeze();
> -	}
> +	current->flags &= ~PF_FREEZER_SKIP;
> +	try_to_freeze();
>  }
>  
>  /*
> 
> 
> 
> 

