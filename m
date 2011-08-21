Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab1HUTRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 15:17:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab1HUTRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 15:17:35 -0400
Date: Sun, 21 Aug 2011 21:14:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, Jens Axboe <axboe@kernel.dk>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Subject: Re: [PATCH 04/16] freezer: implement and use
	kthread_freezable_should_stop()
Message-ID: <20110821191421.GA9793@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763382-12341-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Tejun Heo wrote:
>
> +bool kthread_freezable_should_stop(bool *was_frozen)
> +{
> +	bool frozen = false;
> +
> +	might_sleep();
> +
> +	if (unlikely(freezing(current)))
> +		frozen = __refrigerator(true);
> +
> +	if (was_frozen)
> +		*was_frozen = frozen;
> +
> +	return kthread_should_stop();
> +}

Imho, nice interface...

So, the caller can not miss the kthread_stop() request and freeze.
And the change in __refrigerator() means that kthread_should_stop()
acts as thaw_process() (in some sense).

But. can't __refrigerator() race with thaw_process() in this case?

> +bool __refrigerator(bool check_kthr_stop)
>  {
>  	/* Hmm, should we be allowed to suspend when there are realtime
>  	   processes around? */
> @@ -50,7 +51,8 @@ bool __refrigerator(void)
>
>  	for (;;) {
>  		set_current_state(TASK_UNINTERRUPTIBLE);
> -		if (!frozen(current))
> +		if (!frozen(current) ||
> +		    (check_kthr_stop && kthread_should_stop()))
>  			break;

OK, but then we do

	current->flags &= ~PF_FREEZING;

since PF_FROZEN wasn't cleared this can race with

	p->flags &= ~PF_FROZEN;

No?

Oleg.

