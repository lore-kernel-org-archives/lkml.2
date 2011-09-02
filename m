Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1IBRem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:34:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab1IBRej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:34:39 -0400
Date: Fri, 2 Sep 2011 19:30:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 1/4] cgroup_freezer: fix freezer->state
	setting bug in freezer_change_state()
Message-ID: <20110902173039.GA9039@redhat.com>
References: <20110831102100.GA2828@mtj.dyndns.org> <20110902004231.GF1919@count0.beaverton.ibm.com> <20110902165839.GA7478@redhat.com> <20110902170844.GJ2752@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902170844.GJ2752@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Tejun Heo wrote:
>
> Can you please wait a bit?

Sure. But just in case, I mean the simple patch below.

Feel free to incorporate into 4/4, or I can resend it later.

Oleg.

------------------------------------------------------------------------------
[PATCH] freezer: remove the pointless/unsafe __thaw_task()->recalc_sigpending_and_wake()

Remove __thaw_task()->recalc_sigpending_and_wake(). It was copied from
cancel_freezing() recently, but it was always wrong.

It is pointless, contary to the comment it can't clear TIF_SIGPENDING.
Not to mention, we must never do this with !current task, this is wrong.

The usage of ->sighand is not safe if the caller is cgroup_freezer, we
can racw with exit.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/freezer.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- 3.1/kernel/freezer.c~kill_rspaw	2011-09-02 18:52:46.000000000 +0200
+++ 3.1/kernel/freezer.c	2011-09-02 19:03:30.000000000 +0200
@@ -150,18 +150,10 @@ void __thaw_task(struct task_struct *p)
 	 * be visible to @p as waking up implies wmb.  Waking up inside
 	 * freezer_lock also prevents wakeups from leaking outside
 	 * refrigerator.
-	 *
-	 * If !FROZEN, @p hasn't reached refrigerator, recalc sigpending to
-	 * avoid leaving dangling TIF_SIGPENDING behind.
 	 */
 	spin_lock_irqsave(&freezer_lock, flags);
-	if (frozen(p)) {
+	if (frozen(p))
 		wake_up_process(p);
-	} else {
-		spin_lock(&p->sighand->siglock);
-		recalc_sigpending_and_wake(p);
-		spin_unlock(&p->sighand->siglock);
-	}
 	spin_unlock_irqrestore(&freezer_lock, flags);
 }
 

