Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab1H1SEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 14:04:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab1H1SEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 14:04:41 -0400
Date: Sun, 28 Aug 2011 20:01:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 10/16] freezer: fix set_freezable[_with_signal]() race
Message-ID: <20110828180106.GC27032@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-11-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763382-12341-11-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Tejun Heo wrote:
>
> A kthread doing set_freezable*() may race with on-going PM freeze and
> the freezer might think all tasks are frozen while the new freezable
> kthread is marrily proceeding to execute code paths which aren't
> supposed to be executing during PM freeze.

Yes,

> +bool __set_freezable(bool with_signal)
> +{
> +	might_sleep();
> +
> +	/*
> +	 * Modify flags while holding freezer_lock.  This ensures the
> +	 * freezer notices that we aren't frozen yet or the freezing
> +	 * condition is visible to try_to_freeze() below.
> +	 */
> +	spin_lock_irq(&freezer_lock);
> +	current->flags &= ~PF_NOFREEZE;
> +	if (with_signal)
> +		current->flags &= ~PF_FREEZER_NOSIG;
> +	spin_unlock_irq(&freezer_lock);
> +
> +	return try_to_freeze();
> +}

You know, I was really, really puzzled by this change. Because it
"obviously can fix nothing", and try_to_freeze() makes no sense
(ignoring the very unlikely case when TIF_FREEZING was set right
after we drop freezer_lock).

But I guess this works along with 14/16 which removes TIF_FREEZING.

Oleg.

