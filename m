Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab2ARU3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 15:29:15 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:47173 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab2ARU3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 15:29:14 -0500
Message-ID: <4F172B8D.8050408@linux.vnet.ibm.com>
Date: Thu, 19 Jan 2012 01:59:01 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, horms@verge.net.au,
        "pavel@ucw.cz" <pavel@ucw.cz>, Len Brown <lenb@kernel.org>
Subject: Re: [Update][PATCH] PM / Hibernate: Fix s2disk regression related
 to unlock_system_sleep()
References: <201201172345.15010.rjw@sisk.pl> <201201180015.56510.rjw@sisk.pl> <4F16C24A.4050007@linux.vnet.ibm.com> <CAOS58YMBWrD2cMyPJG0Xf16i1vnkB8xerdeqWJ=fk7HVNpoPAw@mail.gmail.com> <4F16F94C.4020000@linux.vnet.ibm.com> <CAOS58YPW3hB3ibaYPLBqhu=2jZTAjjF7DZaXO=hK5tookAX7YA@mail.gmail.com> <4F16FF0D.1030606@linux.vnet.ibm.com> <20120118173037.GE30664@google.com> <4F171BF8.50803@linux.vnet.ibm.com> <20120118193040.GA28538@google.com> <4F17217E.5040805@linux.vnet.ibm.com>
In-Reply-To: <4F17217E.5040805@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011820-8256-0000-0000-000000EF2FD0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 01:16 AM, Srivatsa S. Bhat wrote:

> On 01/19/2012 01:00 AM, Tejun Heo wrote:
> 
>> Hello,
>>
>> On Thu, Jan 19, 2012 at 12:52:32AM +0530, Srivatsa S. Bhat wrote:
>>> Somehow I don't think its a hack, based on my perception as described
>>> above. But feel free to prove me wrong :-)
>>
>> Thanks for the explanation.  Yeah, I agree and it's much simpler this
>> way, which is nice.  So, in short, because freezing state can't change
>> across lock_system_sleep(), there's no reason to check for freezing
>> state on unlock and this nicely resolves the freezer problem together.
>>
> 
> 
> Absolutely!
> 
>> The only thing to be careful is, then, we need to set and clear SKIP
>> inside pm_mutex.
>>
> 
> 
> Not exactly. We need to set SKIP before grabbing pm_mutex and clear it
> inside pm_mutex. The reason is that we decided to set SKIP in the first
> place just to avoid the freezer from declaring failure when we are
> blocked on pm_mutex. If we move it to *after* mutex_lock(&pm_mutex), that
> original intention itself is not satisfied, and we will hit freezing
> failures - IOW making the set and clear exercise useless!
> 
> So, something like this should work perfectly:
> 
> lock_system_sleep()
> {
> 	freezer_do_not_count();
> 	mutex_lock(&pm_mutex);
> 	current->flags &= ~PF_FREEZER_SKIP;
> }
> 
> But in the interest of making the code look a bit symmetric, we can do:
> 
> lock_system_sleep()
> {
> 	freezer_do_not_count();
> 	mutex_lock(&pm_mutex);
> }
> 
> unlock_system_sleep()
> {
> 	current->flags &= ~PF_FREEZER_SKIP;
> 	mutex_unlock(&pm_mutex);
> }
>  


So how about this patch, with the comment updated?
(and the changelog updated as well to reflect the movement of code)

---
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

While at it, make the code more correct and robust by ensuring that the
PF_FREEZER_SKIP flag gets cleared with pm_mutex held, to avoid a race with
the freezer.

Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/suspend.h |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 95040cc..cb9d3f4 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -363,8 +363,23 @@ static inline void lock_system_sleep(void)
 
 static inline void unlock_system_sleep(void)
 {
+	/*
+	 * Don't use freezer_count() because we don't want the call to
+	 * try_to_freeze() here.
+	 *
+	 * Reason:
+	 * Fundamentally, we just don't need it, because freezing condition
+	 * doesn't come into effect until we release the pm_mutex lock,
+	 * since the freezer always works with pm_mutex held.
+	 *
+	 * More importantly, in the case of hibernation,
+	 * unlock_system_sleep() gets called in snapshot_read() and
+	 * snapshot_write() when the freezing condition is still in effect.
+	 * Which means, if we use try_to_freeze() here, it would make them
+	 * enter the refrigerator, thus causing hibernation to lockup.
+	 */
+	current->flags &= ~PF_FREEZER_SKIP;
 	mutex_unlock(&pm_mutex);
-	freezer_count();
 }
 
 #else /* !CONFIG_PM_SLEEP */


