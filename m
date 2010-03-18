Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab0CRWrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:47:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48362 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751893Ab0CRWrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:47:41 -0400
Date: Thu, 18 Mar 2010 22:51:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move tty_kref_put() outside of __cleanup_signal()
Message-ID: <20100318225102.6a5578d9@lxorguk.ukuu.org.uk>
In-Reply-To: <20100318223736.GA12944@redhat.com>
References: <20100318223736.GA12944@redhat.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -			tty_kref_put(p->signal->tty);
>  			p->signal->tty = tty_kref_get(current->signal->tty);

That bit needs commenting clearly or a WARN_ON() that p->signal->tty is
NULL before the get otherwise when the assumption is broken the flaw will
be subtle and hard to find.

>  			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
>  			attach_pid(p, PIDTYPE_SID, task_session(current));
> --- 34-rc1/kernel/exit.c~7_TTY_PUT	2010-03-17 20:05:38.000000000 +0100
> +++ 34-rc1/kernel/exit.c	2010-03-18 22:46:41.000000000 +0100
> @@ -150,6 +150,7 @@ static void __exit_signal(struct task_st
>  		 * see account_group_exec_runtime().
>  		 */
>  		task_rq_unlock_wait(tsk);
> +		tty_kref_put(sig->tty);

and a sig->tty = NULL assignment to trap races might not go amiss here
perhaps ?


