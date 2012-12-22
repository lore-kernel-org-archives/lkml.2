Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab2LVTj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 14:39:28 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:64874 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2LVTjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 14:39:25 -0500
Date: Sat, 22 Dec 2012 13:39:20 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH review 1/3] pidns: Outlaw thread creation after
 unshare(CLONE_NEWPID)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <877goaela9.fsf@xmission.com> (from ebiederm@xmission.com on
	Fri Dec 21 22:57:34 2012)
X-Mailer: Balsa 2.4.11
Message-Id: <1356205160.5255.0@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 10:57:34 PM, Eric W. Biederman wrote:
> 
> The sequence:
> unshare(CLONE_NEWPID)
> clone(CLONE_THREAD|CLONE_SIGHAND|CLONE_VM)
> 
> Creates a new process in the new pid namespace without setting
> pid_ns->child_reaper.  After forking this results in a NULL
> pointer dereference.
> 
> Avoid this and other nonsense scenarios that can show up after
> creating a new pid namespace with unshare by adding a new
> check in copy_prodcess.
> 
> Pointed-out-by:  Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/fork.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index a31b823..65ca6d2 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1166,6 +1166,14 @@ static struct task_struct  
> *copy_process(unsigned long clone_flags,
>  				current->signal->flags &  
> SIGNAL_UNKILLABLE)
>  		return ERR_PTR(-EINVAL);
> 
> +	/*
> +	 * If the new process will be in a different pid namespace
> +	 * don't allow the creation of threads.
> +	 */
> +	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
> +	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
> +		return ERR_PTR(-EINVAL);
> +

Since the first bit will trigger if clone_flags has just CLONE_VM  
without CLONE_NEWPID, or vice versa, I'm guessing this is a fast path  
optimization? (Otherwise you meant (clone_flags &  
(CLONE_VM|CLONE_NEWPID)) == CLONE_VM|CLONE_NEWPID ?)

(Just trying to wrap my head around it...)

Rob