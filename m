Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab2HGBTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 21:19:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36039 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757160Ab2HGBTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 21:19:12 -0400
Message-ID: <1344302351.2026.24.camel@joe2Laptop>
Subject: Re: [RFC v3 4/7] workqueue: use new hashtable implementation
From: Joe Perches <joe@perches.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org, josh@joshtriplett.org,
        eric.dumazet@gmail.com, mathieu.desnoyers@efficios.com,
        Sasha Levin <sasha.levin@oracle.com>
Date: Mon, 06 Aug 2012 18:19:11 -0700
In-Reply-To: <1344300317-23189-6-git-send-email-levinsasha928@gmail.com>
References: <1344300317-23189-1-git-send-email-levinsasha928@gmail.com>
	 <1344300317-23189-6-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 02:45 +0200, Sasha Levin wrote:
> From: Sasha Levin <sasha.levin@oracle.com>
> 
> Switch workqueues to use the new hashtable implementation. This reduces the amount of
> generic unrelated code in the workqueues.

Just style trivia:

> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
[]
> @@ -897,8 +839,15 @@ static struct worker *__find_worker_executing_work(struct global_cwq *gcwq,
>  static struct worker *find_worker_executing_work(struct global_cwq *gcwq,
>  						 struct work_struct *work)
>  {
> -	return __find_worker_executing_work(gcwq, busy_worker_head(gcwq, work),
> -					    work);
> +	struct worker *worker;
> +	struct hlist_node *tmp;
> +
> +	hash_for_each_possible(gcwq->busy_hash, worker, BUSY_WORKER_HASH_ORDER,
> +								tmp, hentry, work)
> +		if (worker->current_work == work)
> +			return worker;

braces please:

	hash_for_each_possible(gcwq->busy_hash, worker, BUSY_WORKER_HASH_ORDER,
			       tmp, hentry, work) {
		if (worker->current_work == work)
			return worker;
	}

[]

@@ -1916,7 +1865,7 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color,
>   * @worker: self
>   * @work: work to process
>   *
> - * Process @work.  This function contains all the logics necessary to
> + * Process @work.  This? function contains all the logics necessary to

Odd ? and the grammar also seems odd.

>   * process a single work including synchronization against and
>   * interaction with other workers on the same cpu, queueing and
>   * flushing.  As long as context requirement is met, any worker can


