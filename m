Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964918Ab2HGDjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:39:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59929 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964864Ab2HGDjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:39:04 -0400
Message-Id: <20120807032759.521009923@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Darren Hart <dvhart@linux.intel.com>,
        Dave Jones <davej@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 24/70] futex: Test for pi_mutex on fault in futex_wait_requeue_pi()
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darren Hart <dvhart@linux.intel.com>

commit b6070a8d9853eda010a549fa9a09eb8d7269b929 upstream.

If fixup_pi_state_owner() faults, pi_mutex may be NULL. Test
for pi_mutex != NULL before testing the owner against current
and possibly unlocking it.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Link: http://lkml.kernel.org/r/dc59890338fc413606f04e5c5b131530734dae3d.1342809673.git.dvhart@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e2b0fb9..05018bf 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2370,7 +2370,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 	 * fault, unlock the rt_mutex and return the fault to userspace.
 	 */
 	if (ret == -EFAULT) {
-		if (rt_mutex_owner(pi_mutex) == current)
+		if (pi_mutex && rt_mutex_owner(pi_mutex) == current)
 			rt_mutex_unlock(pi_mutex);
 	} else if (ret == -EINTR) {
 		/*


