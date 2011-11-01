Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab1KARzC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 13:55:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab1KARzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 13:55:00 -0400
Date: Tue, 1 Nov 2011 18:50:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Layton <jlayton@redhat.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
	fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Message-ID: <20111101175035.GA5358@redhat.com>
References: <20111031221743.GA18855@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111031221743.GA18855@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31, Tejun Heo wrote:
>
> Commit 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake
> TASK_KILLABLE tasks too" made freezer wake up tasks in TASK_KILLABLE
> sleep too citing non-interruptible but killable sleeps in cifs and
> nfs.
>
> I don't think we can do this.  We should not send spurious unsolicited
> non-interruptible wakeups.  Most synchornization constructs are built
> to cope with spurious wakeups and any INTERRUPTIBLE sleep must be able
> to handle spurious wakeups but that's not true for KILLABLE sleeps -
> KILLABLE condition cannot be cancelled.

Agreed.

For example. sys_read() or page can sleep in TASK_KILLABLE assuming that
wait/down/whatever _killable can only fail if we can not return to the
usermode.

TASK_TRACED case is obviously wrong too.

> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -67,7 +67,7 @@ static void fake_signal_wake_up(struct task_struct *p)
>  	unsigned long flags;
>
>  	spin_lock_irqsave(&p->sighand->siglock, flags);
> -	signal_wake_up(p, 1);
> +	signal_wake_up(p, 0);
>  	spin_unlock_irqrestore(&p->sighand->siglock, flags);
>  }

Agreed, this looks like a bug fix to me.

Acked-by: Oleg Nesterov <oleg@redhat.com>

