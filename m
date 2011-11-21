Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1KUSNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:13:07 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:45290 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1KUSNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:13:04 -0500
Message-ID: <4ECA94A6.90500@linux.vnet.ibm.com>
Date: Mon, 21 Nov 2011 23:42:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, lenb@kernel.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH v4] PM / Memory-hotplug: Avoid task freezing failures
References: <20111117083042.11419.19871.stgit@srivatsabhat.in.ibm.com> <201111192257.19763.rjw@sisk.pl> <4EC8984E.30005@linux.vnet.ibm.com> <201111201124.17528.rjw@sisk.pl> <4EC9D557.9090008@linux.vnet.ibm.com> <20111121164006.GB15314@google.com> <4ECA84A8.5030005@linux.vnet.ibm.com>
In-Reply-To: <4ECA84A8.5030005@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11112118-8878-0000-0000-0000004C7DBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lock_system_sleep() function is used in the memory hotplug code at
several places in order to implement mutual exclusion with hibernation.
However, this function tries to acquire the 'pm_mutex' lock using
mutex_lock() and hence blocks in TASK_UNINTERRUPTIBLE state if it doesn't
get the lock. This would lead to task freezing failures and hence
hibernation failure as a consequence, even though the hibernation call path
successfully acquired the lock.

But it is to be noted that, since this task tries to acquire pm_mutex, if it
blocks due to this, we are *100% sure* that this task is not going to run
as long as hibernation sequence is in progress, since hibernation releases
'pm_mutex' only at the very end, when everything is done.
And this means, this task is going to be anyway blocked for much more longer
than what the freezer intends to achieve; which means, freezing and thawing
doesn't really make any difference to this task!

So, to fix freezing failures, we just ask the freezer to skip freezing this
task, since it is already "frozen enough".

But instead of calling freezer_do_not_count() and freezer_count() as it is,
we use only the relevant parts of those functions, because restrictions
such as 'the task should be a userspace one' etc., might not be relevant in
this scenario.

v4: Redesigned the whole fix, to ask the freezer to skip freezing the task
    which is blocked trying to acquire 'pm_mutex' lock.

v3: Tejun suggested avoiding busy-looping by adding an msleep() since
    it is not guaranteed that we will get frozen immediately.

v2: Tejun pointed problems with using mutex_lock_interruptible() in a
    while loop, when signals not related to freezing are involved.
    So, replaced it with mutex_trylock().

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/suspend.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 57a6924..1f7fff4 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -380,12 +380,16 @@ static inline void unlock_system_sleep(void) {}
 
 static inline void lock_system_sleep(void)
 {
+	/* simplified freezer_do_not_count() */
+	current->flags |= PF_FREEZER_SKIP;
 	mutex_lock(&pm_mutex);
 }
 
 static inline void unlock_system_sleep(void)
 {
 	mutex_unlock(&pm_mutex);
+	/* simplified freezer_count() */
+	current->flags &= ~PF_FREEZER_SKIP;
 }
 #endif
 



