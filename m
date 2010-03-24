Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab0CXRvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:51:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327Ab0CXRvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:51:10 -0400
Date: Wed, 24 Mar 2010 18:49:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] proc: task->signal can't be NULL
Message-ID: <20100324174907.GA20990@redhat.com>
References: <20100322184127.GA3952@redhat.com> <m1ocifvkzl.fsf@fess.ebiederm.org> <20100323183116.GA22516@redhat.com> <m1sk7qu5dl.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sk7qu5dl.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23, Eric W. Biederman wrote:
>
> We need a value that can be computed in constant time, and is not correct
> except when the number of threads is actively changing.

Sure. I was thinking of something like

	int get_nr_threads(struct task_struct *tsk)
	{
		int nr = atomic_read(&task->signal->live);
		int reasonable_min = 1;

		rcu_read_lock();
		if (!thread_group_leader(tsk) && pid_alive(tsk) &&
		    tsk->group_leader->exit_state)
			reasonable_min = 2;
		rcu_read_unlock();

		return max(nr, reasonable_min);
	}

but as I said this doesn't look nice at all.

> > OK. Let's keep this counter as "int nr_thread".
> >
> > Besides, when I tried to re-implement get_nr_threads() using signal->live
> > I got the really ugly result ;)
>
> Sounds good.

OK, please see the "final" patch I am going to send...

Oleg.

