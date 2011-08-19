Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab1HSPzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:55:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab1HSPzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:55:21 -0400
Date: Fri, 19 Aug 2011 17:52:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 01/16] freezer: fix current->state restoration race in
	refrigerator()
Message-ID: <20110819155222.GA17879@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763382-12341-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll try to read this series later.

Probably this doesn't matter since I didn't read the next patches, but

On 08/19, Tejun Heo wrote:
>
> refrigerator() saves current->state before entering frozen state and
> restores it before returning using __set_current_state(); however,
> this is racy,

Oh, yes. I even tried to ask for the explanation.

> 	set_current_state(TASK_INTERRUPTIBLE);
> 	try_to_sleep();
> 	if (kthread_should_stop())
> 		break;
> 	schedule();

Indeed, we can miss kthread->should_stop, and the patch fixes this
case.

But please look at, say, kauditd_thread(), it does

		DECLARE_WAITQUEUE(wait, current);
		set_current_state(TASK_INTERRUPTIBLE);
		add_wait_queue(&kauditd_wait, &wait);

		if (!skb_queue_len(&audit_skb_queue)) {
			try_to_freeze();
			schedule();
		}

Now suppose that wake_up_interruptible(&kauditd_wait) happens, and
after that refrigerator() restores TASK_INTERRUPTIBLE.

Any reason refrigerator() should try to restore? Shouldn't we simply
change the rules? Yes, probably we will have to fix some users.

But it seems to me it is simply not possible to make this ->state
restoration correct.

Oleg.

