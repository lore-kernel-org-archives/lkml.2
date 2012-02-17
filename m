Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab2BQAjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:39:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab2BQAju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:39:50 -0500
Date: Thu, 16 Feb 2012 16:39:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] vfork: make it killable
Message-Id: <20120216163948.f2989a2b.akpm@linux-foundation.org>
In-Reply-To: <20120216172706.GC30393@redhat.com>
References: <20120214164709.GA21178@redhat.com>
	<20120214164914.GF21185@redhat.com>
	<20120215123049.6e938eed.akpm@linux-foundation.org>
	<20120216150429.GB11953@redhat.com>
	<20120216172626.GA30393@redhat.com>
	<20120216172706.GC30393@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 18:27:06 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -669,10 +669,34 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
>  
>  void complete_vfork_done(struct task_struct *tsk)
>  {
> -	struct completion *vfork_done = tsk->vfork_done;
> +	struct completion *vfork;
>  
> -	tsk->vfork_done = NULL;
> -	complete(vfork_done);
> +	task_lock(tsk);
> +	vfork = tsk->vfork_done;
> +	if (likely(vfork)) {
> +		tsk->vfork_done = NULL;
> +		complete(vfork);
> +	}
> +	task_unlock(tsk);
> +}

OK, so now we don't need to test tsk->vfork_done in callers.  But
mm_release() still does this, and it does it outside locks.  Mistake,
or micro-optimisation?  If the latter, why is the lockless peek
race-free?

