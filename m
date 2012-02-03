Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab2BCQhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:37:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab2BCQhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:37:45 -0500
Date: Fri, 3 Feb 2012 17:30:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg KH <gregkh@suse.de>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] staging: android/lowmemorykiller: Don't grab
	tasklist_lock
Message-ID: <20120203163056.GA4190@redhat.com>
References: <20120201043330.GA25511@oksana.dev.rtsoft.ru> <20120202125441.GA32229@redhat.com> <20120202171659.GA29378@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202171659.GA29378@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02, Anton Vorontsov wrote:
>
> On Thu, Feb 02, 2012 at 01:54:41PM +0100, Oleg Nesterov wrote:
> >
> > This has the same problem, force_sig() becomes unsafe.
>
> Ouch, I think I finally got it. So, lock_task_sighand() is trying to
> gracefully grab the lock, checking if the sighand is not NULL (which means,
> per __exit_signal(), that the task is halfway into the grave).

Yes.

> Would the following fix work for the sysrq?
>
> - - - -
> From: Anton Vorontsov <anton.vorontsov@linaro.org>
> Subject: [PATCH] sysrq: Fix unsafe operations on tasks
>
> sysrq should grab the tasklist lock, otherwise calling force_sig() is
> not safe, as it might race with exiting task, which ->sighand might be
> set to NULL already.

And there are other reasons for tasklist. It is not clear why
for_each_process() itself is safe. OK, currently (afaics) the
caller disables irqs, but in theory this doesn't imply rcu_lock.

And it can race with fork() and miss the task, although mostly
in theory.

> --- a/drivers/tty/sysrq.c
> +++ b/drivers/tty/sysrq.c
> @@ -322,11 +322,13 @@ static void send_sig_all(int sig)
>  {
>  	struct task_struct *p;
>
> +	read_lock(&tasklist_lock);
>  	for_each_process(p) {
>  		if (p->mm && !is_global_init(p))
>  			/* Not swapper, init nor kernel thread */
>  			force_sig(sig, p);
>  	}
> +	read_unlock(&tasklist_lock);

Agreed, but force_sig() should not be used anyway. It sends the
signal to the thread, we need to kill the process. The main thread
can exit.

> > With or without this patch, sig == NULL is not possible but !mm is not right,
> > there could be other other threads with mm != NULL.
>
> I'm not sure I completely follow. In the current LMK code, we check for !mm
> because otherwise the potential victim is useless for us (i.e. killing it
> will not free much memory anyway).

This is the common mistake. Consider this program:

	void *thread_func(...)
	{
		use_a_lot_of_memory();
	}

	int main(void)
	{
		pthread_create(..., thread_func, ...);
		pthread_exit();
	}

lowmem_shrink() will skip this task because p->mm == NULL.

Oleg.

