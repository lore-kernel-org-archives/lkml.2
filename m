Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab0FRUmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 16:42:03 -0400
Received: from smtp-out.google.com ([74.125.121.35]:60768 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab0FRUmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 16:42:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:
	x-operating-system:user-agent:x-system-of-record;
	b=xYLeZuQlUoqfhg73R+YG/pRyO2CfBdIY/zPprfEW/nbCEMutUFjmCj7yZvmzRiQS1
	DfC4HpvgC8GNZHTjGh6sg==
Date: Fri, 18 Jun 2010 13:38:54 -0700
From: Mandeep Singh Baines <msb@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] fix the racy
	check_hung_uninterruptible_tasks()->rcu_lock_break() logic
Message-ID: <20100618203854.GW915@google.com>
References: <20100618190251.GA17297@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618190251.GA17297@redhat.com>
X-Operating-System: Linux/2.6.24-gg804007-generic (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov (oleg@redhat.com) wrote:
> check_hung_uninterruptible_tasks()->rcu_lock_break() introduced by
> "softlockup: check all tasks in hung_task" commit ce9dbe24 looks
> absolutely wrong.
> 
> 	- rcu_lock_break() does put_task_struct(). If the task has exited
> 	  it is not safe to even read its ->state, nothing protects this
> 	  task_struct.
> 
> 	- The TASK_DEAD checks are wrong too. Contrary to the comment, we
> 	  can't use it to check if the task was unhashed. It can be unhashed
> 	  without TASK_DEAD, or it can be valid with TASK_DEAD.
> 
> 	  For example, an autoreaping task can do release_task(current)
> 	  long before it sets TASK_DEAD in do_exit().
> 
> 	  Or, a zombie task can have ->state == TASK_DEAD but release_task()
> 	  was not called, and in this case we must not break the loop.
> 
> Change this code to check pid_alive() instead, and do this before we
> drop the reference to the task_struct.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---

Acked-by: Mandeep Singh Baines <msb@google.com>
