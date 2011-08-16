Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab1HPRuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:50:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab1HPRt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:49:59 -0400
Date: Tue, 16 Aug 2011 19:47:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 37/41] autofs4: Use set_current_blocked()
Message-ID: <20110816174707.GH29190@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-38-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313071035-12047-38-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Matt Fleming wrote:
>
> As described in e6fa16ab ("signal: sigprocmask() should do
> retarget_shared_pending()") the modification of current->blocked is
> incorrect as we need to check whether the signal we're about to block
> is pending in the shared queue.

ACK.


cough, can't resist...

> @@ -458,21 +458,16 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
>  	 */
>  	if (wq->name.name) {
>  		/* Block all but "shutdown" signals while waiting */
> -		sigset_t oldset;
> +		sigset_t oldset, blocked;
>  		unsigned long irqflags;
>  
> -		spin_lock_irqsave(&current->sighand->siglock, irqflags);
>  		oldset = current->blocked;
> -		siginitsetinv(&current->blocked, SHUTDOWN_SIGS & ~oldset.sig[0]);
> -		recalc_sigpending();
> -		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
> +		siginitsetinv(&blocked, SHUTDOWN_SIGS & ~oldset.sig[0]);
> +		set_current_blocked(&blocked);
>  
>  		wait_event_interruptible(wq->queue, wq->name.name == NULL);
> -
> -		spin_lock_irqsave(&current->sighand->siglock, irqflags);
> -		current->blocked = oldset;
> -		recalc_sigpending();
> -		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
> +		

this adds the trailing whitespaces ;)

Oleg.

