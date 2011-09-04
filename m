Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1IDStt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 14:49:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab1IDSto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 14:49:44 -0400
Date: Sun, 4 Sep 2011 20:46:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] freezer: kill unused set_freezable_with_signal()
Message-ID: <20110904184626.GA30101@redhat.com>
References: <1314988070-12244-1-git-send-email-tj@kernel.org> <1314988070-12244-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314988070-12244-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Tejun Heo wrote:
>
> This patch removes set_freezable_with_signal() along with
> PF_FREEZER_NOSIG

Great. I never understood PF_FREEZER_NOSIG logic ;)

One question,

> @@ -72,10 +72,6 @@ bool __refrigerator(bool check_kthr_stop)
>  		schedule();
>  	}
>
> -	spin_lock_irq(&current->sighand->siglock);
> -	recalc_sigpending(); /* We sent fake signal, clean it up */
> -	spin_unlock_irq(&current->sighand->siglock);
> -

Why? This recalc_sigpending() makes sense imho. Otherwise the user-space
tasks (almost) always return with TIF_SIGPENDING. May be we can do this
under "if (PF_KTRHREAD)".

For example. Suppose the user-space task does wait_event_freezable()...

Hmm. OTOH, wait_event_freezable() looks wrong anyway... So probably
this doesn't matter. ptrace_stop/get_signal_to_deliver doesn't need
this, probably we do not care about the other callers.

It seems, a lot of get_signal_to_deliver() calles also call
try_to_freeze() for no reason.


So, yes, I am starting to think this change is fine too ;)

Oleg.

