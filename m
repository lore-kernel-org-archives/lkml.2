Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab1I3UAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:00:35 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:45241 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124Ab1I3UAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:00:34 -0400
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
In-Reply-To: <20110930165206.GA22048@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
	 <20110930165206.GA22048@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 21:00:23 +0100
Message-ID: <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 18:52 +0200, Oleg Nesterov wrote:
> And, this patch adds 4 new locks:
> 
> 	sighand_struct->action_lock
> 
> 	signal_struct->ctrl_lock
> 	signal_struct->shared_siglock
> 
> 	task_struct->siglock
> 
> Nice ;) For what? This should be justified, imho.

Well, sighand->siglock is seriously overused. It protects so much and I
think it's pretty confusing. It took me long enough to figure out how
many locks were really needed. But that's beside the point, having a
single lock doesn't scale at all, and that's what this series is about.

> Hmm. Just out of curiosity, I blindly applied the whole series and poke
> the _random_ function to look at, dequeue_signal(). And it looks wrong.
> 
> 	spin_lock_irqsave(&current->signal->ctrl_lock, flags);
> 	current->jobctl |= JOBCTL_STOP_DEQUEUED;
> 
> This signal->ctrl_lock can't help. A sig_kernel_stop() should be
> dequeued under the same lock, and we shouldn't release it unless we
> set JOBCTL_STOP_DEQUEUED. Otherwise we race with SIGCONT.

Hmm.. is that really a problem? Does the dequeue and setting
JOBCTL_STOP_DEQUEUED actually need to be atomic? Does it matter if we
have SIGCONT on the signal queue when we set JOBCTL_STOP_DEQUEUED?

> May be do_signal_stop() does something special? At first flance it doesn't.
> But wait, it does while_each_thread() under ->ctrl_lock, why this is safe?

Why is it not safe? What scenario are you thinking of where that isn't
safe?

> May be I was just lucky ;)

I doubt luck has anything to do with it ;-)

Thanks for the review!

-- 
Matt Fleming, Intel Open Source Technology Center

