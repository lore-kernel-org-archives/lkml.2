Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab2ARNAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:00:07 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39968 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab2ARNAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:00:04 -0500
Message-ID: <4F16C24A.4050007@linux.vnet.ibm.com>
Date: Wed, 18 Jan 2012 18:29:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        horms@verge.net.au, "pavel@ucw.cz" <pavel@ucw.cz>,
        Len Brown <lenb@kernel.org>
Subject: Re: [Update][PATCH] PM / Hibernate: Fix s2disk regression related
 to unlock_system_sleep()
References: <201201172345.15010.rjw@sisk.pl> <201201180015.56510.rjw@sisk.pl>
In-Reply-To: <201201180015.56510.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011812-2674-0000-0000-0000030A5011
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 04:45 AM, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Hibernate: Fix s2disk regression related to unlock_system_sleep()
> 
> Commit bcda53faf5814c0c6025a0bd47108adfcbe9f199, "PM / Sleep: Replace
> mutex_[un]lock(&pm_mutex) with [un]lock_system_sleep()", modified
> snapshot_read() and snapshot_write() in kernel/power/user.c, among
> other things, by making them use lock_system_sleep() and
> unlock_system_sleep() instead of just locking and unlocking pm_mutex.
> Unfortunately, however, this was a mistake, because these routines
> are supposed to be executed after processes have been frozen
> (i.e. when system_freezing_cnt is nonzero), so when
> unlock_system_sleep() is executed by one of them, this causes the
> caller to execute try_to_freeze() and go into the refrigerator as
> a result.  This, in turn, deadlocks the suspend process and locks up
> the system.
> 
> Fix the problem by reverting the part of commit bcda53faf5814c0c6025a
> that changed snapshot_read() and snapshot_write().
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---


This quick fix is good to fix the regression, but I am wondering if going
further, it would be better to rewrite unlock_system_sleep() by open-coding
a part of freezer_count() and excluding try_to_freeze() in that. 

When freezer_count() is used as it is (in other parts of the kernel), it
makes sense (that is, the try_to_freeze() embedded within it is justified).

However, in the case of unlock_system_sleep(), I don't quite see why
try_to_freeze() would be useful in any case at all... And moreover, it is
also semantically misleading because, unlock_system_sleep() tries to freeze
us behind our back, when we only intended to grab and release the pm_mutex
safely (as advertised by these APIs). IOW, commit bcda53f, while promising
to make stuff freezer-safe and nothing else, introduced a fundamental,
unneeded functionality change in all call paths that these APIs are invoked
in, by having that try_to_freeze() hidden inside. And now we just realized
that this change is not just unneeded, but it is harmful too!

So how about something like the following patch?
(This is not on top of your patch. Rather, this patch is an alternative to
your fix. Please let me know your thoughts.)

----
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM / Hibernate: Rewrite unlock_system_sleep() to fix s2disk regression

Commit 33e638b, "PM / Sleep: Use the freezer_count() functions in
[un]lock_system_sleep() APIs" introduced an undesirable change in the
behaviour of unlock_system_sleep() since freezer_count() internally calls
try_to_freeze() - which we don't need in unlock_system_sleep().

And commit bcda53f, "PM / Sleep: Replace mutex_[un]lock(&pm_mutex) with
[un]lock_system_sleep()" made these APIs wide-spread. This caused a
regression in suspend-to-disk where snapshot_read() and snapshot_write()
were getting frozen due to the try_to_freeze embedded in
unlock_system_sleep(), since these functions were invoked when the freezing
condition was still in effect.

Fix this by rewriting unlock_system_sleep() by open-coding freezer_count()
and dropping the try_to_freeze() part. Not only will this fix the
regression but this will also ensure that the API only does what it is
intended to do, and nothing more, under the hood.

Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/suspend.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 95040cc..a1db01f 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -364,7 +364,11 @@ static inline void lock_system_sleep(void)
 static inline void unlock_system_sleep(void)
 {
 	mutex_unlock(&pm_mutex);
-	freezer_count();
+	/*
+	 * Don't use freezer_count() because we don't want the
+	 * call to try_to_freeze() here.
+	 */
+	current->flags &= ~PF_FREEZER_SKIP;
 }
 
 #else /* !CONFIG_PM_SLEEP */


