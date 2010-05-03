Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377Ab0ECN1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:27:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:59046 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759345Ab0ECN1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:27:18 -0400
Subject: Re: [PATCH 1/4] cpu_stop: implement stop_cpu[s]()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       oleg@redhat.com, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org
In-Reply-To: <1271952554-22368-2-git-send-email-tj@kernel.org>
References: <1271952554-22368-1-git-send-email-tj@kernel.org>
	 <1271952554-22368-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 May 2010 15:26:31 +0200
Message-ID: <1272893191.5605.121.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 18:09 +0200, Tejun Heo wrote:

> +struct cpu_stop_done {
> +	atomic_t		nr_todo;	/* nr left to execute */
> +	bool			executed;	/* actually executed? */
> +	int			ret;		/* collected return value */
> +	struct completion	completion;	/* fired if nr_todo reaches 0 */
> +};
> +

> +/* signal completion unless @done is NULL */
> +static void cpu_stop_signal_done(struct cpu_stop_done *done, bool executed)
> +{
> +	if (done) {
> +		if (executed)
> +			done->executed = true;
> +		if (atomic_dec_and_test(&done->nr_todo))
> +			complete(&done->completion);
> +	}
> +}
> +
> +/* queue @work to @stopper.  if offline, @work is completed immediately */
> +static void cpu_stop_queue_work(struct cpu_stopper *stopper,
> +				struct cpu_stop_work *work)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&stopper->lock, flags);
> +
> +	if (stopper->enabled) {
> +		list_add_tail(&work->list, &stopper->works);
> +		wake_up_process(stopper->thread);
> +	} else
> +		cpu_stop_signal_done(work->done, false);
> +
> +	spin_unlock_irqrestore(&stopper->lock, flags);
> +}
> +

> +int stop_one_cpu(unsigned int cpu, cpu_stop_fn_t fn, void *arg)
> +{
> +	struct cpu_stop_done done;
> +	struct cpu_stop_work work = { .fn = fn, .arg = arg, .done = &done };
> +
> +	cpu_stop_init_done(&done, 1);
> +	cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu), &work);
> +	wait_for_completion(&done.completion);
> +	return done.executed ? done.ret : -ENOENT;
> +}

If you do:

 done = { .ret = -ENOENT, };

And remove that if()

> +		ret = work->fn(work->arg);
> +		if (ret)
> +			done->ret = ret;
> +

You can do away with all the ->executed bits.
