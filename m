Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1H1SMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 14:12:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab1H1SM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 14:12:27 -0400
Date: Sun, 28 Aug 2011 20:09:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 12/16] freezer: clean up freeze_processes() failure path
Message-ID: <20110828180901.GD27032@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-13-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763382-12341-13-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Tejun Heo wrote:
>
>  void __thaw_task(struct task_struct *p)
>  {
>  	unsigned long flags;
> @@ -150,11 +135,19 @@ void __thaw_task(struct task_struct *p)
>  	 * be visible to @p as waking up implies wmb.  Waking up inside
>  	 * freezer_lock also prevents wakeups from leaking outside
>  	 * refrigerator.
> +	 *
> +	 * If !FROZEN, @p hasn't reached refrigerator, recalc sigpending to
> +	 * avoid leaving dangling TIF_SIGPENDING behind.
>  	 */
>  	spin_lock_irqsave(&freezer_lock, flags);
>  	clear_freeze_flag(p);
> -	if (frozen(p))
> +	if (frozen(p)) {
>  		wake_up_process(p);
> +	} else {
> +		spin_lock(&p->sighand->siglock);
> +		recalc_sigpending_and_wake(p);

This was copied from cancel_, yes. but what this
recalc_sigpending_and_wake() can or should do?

It looks simply pointless. It can't clear TIF_SIGPENDING,
it can only do the unneeded/spurious wake_up(INTERRUPTIBLE).

Oleg.

