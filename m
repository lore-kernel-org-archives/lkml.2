Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab0C2N7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:59:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab0C2N7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:59:46 -0400
Date: Mon, 29 Mar 2010 15:57:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       dipankar@in.ibm.com, josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, peterz@infradead.org, arjan@infradead.org
Subject: Re: [PATCH 3/4] scheduler: replace migration_thread with cpuhog
Message-ID: <20100329135700.GA25423@redhat.com>
References: <1268815251-31407-1-git-send-email-tj@kernel.org> <1268815251-31407-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268815251-31407-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I said, personally I like these changes very much. Even if I can't ack them
I'd like to add my vote.

On 03/17, Tejun Heo wrote:
>
>  int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
>  {
> ...
> +	if (migrate_task(p, dest_cpu)) {
> +		struct migration_arg arg = { p, dest_cpu };
>  		/* Need help from migration thread: drop lock and wait. */
> -		struct task_struct *mt = rq->migration_thread;
> -
> -		get_task_struct(mt);
>  		task_rq_unlock(rq, &flags);
> -		wake_up_process(rq->migration_thread);
> -		put_task_struct(mt);
> -		wait_for_completion(&req.done);
> +		hog_one_cpu(cpu_of(rq), migration_hog, &arg);

Afaics, this is the only change which can make a difference. If we race with
cpu_down(), set_cpus_allowed_ptr() can return before the task was actually
moved to another CPU. But this seems harmless to me.

Oleg.

