Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2ARQyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 11:54:55 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:45745 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2ARQyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 11:54:54 -0500
Message-ID: <4F16F94C.4020000@linux.vnet.ibm.com>
Date: Wed, 18 Jan 2012 22:24:36 +0530
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
References: <201201172345.15010.rjw@sisk.pl>	<201201180015.56510.rjw@sisk.pl> <4F16C24A.4050007@linux.vnet.ibm.com> <CAOS58YMBWrD2cMyPJG0Xf16i1vnkB8xerdeqWJ=fk7HVNpoPAw@mail.gmail.com>
In-Reply-To: <CAOS58YMBWrD2cMyPJG0Xf16i1vnkB8xerdeqWJ=fk7HVNpoPAw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011806-1396-0000-0000-0000008D1B26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

On 01/18/2012 09:12 PM, Tejun Heo wrote:

> Hello,
> 
> On Wed, Jan 18, 2012 at 4:59 AM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> +       /*
>> +        * Don't use freezer_count() because we don't want the
>> +        * call to try_to_freeze() here.
>> +        */
> 
> Please explain "why" here.
>


Ok, how about the following patch?
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

 include/linux/suspend.h |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 95040cc..6e76380 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -364,7 +364,18 @@ static inline void lock_system_sleep(void)
 static inline void unlock_system_sleep(void)
 {
 	mutex_unlock(&pm_mutex);
-	freezer_count();
+
+	/*
+	 * Don't use freezer_count() because we don't want the call to
+	 * try_to_freeze() here.
+	 *
+	 * Reason:
+	 * unlock_system_sleep() gets called in snapshot_read() and
+	 * snapshot_write() when the freezing condition is still in effect.
+	 * Which means, if we use try_to_freeze() here, it would make them
+	 * enter the refrigerator, thus causing suspend-to-disk to lockup.
+	 */
+	current->flags &= ~PF_FREEZER_SKIP;
 }
 
 #else /* !CONFIG_PM_SLEEP */


