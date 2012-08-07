Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030910Ab2HGWly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:41:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030897Ab2HGWlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:41:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Darren Hart <dvhart@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 109/109] futex: Forbid uaddr == uaddr2 in futex_wait_requeue_pi()
Date: Tue,  7 Aug 2012 15:36:08 -0700
Message-Id: <20120807222052.636170866@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darren Hart <dvhart@linux.intel.com>

commit 6f7b0a2a5c0fb03be7c25bd1745baa50582348ef upstream.

If uaddr == uaddr2, then we have broken the rule of only requeueing
from a non-pi futex to a pi futex with this call. If we attempt this,
as the trinity test suite manages to do, we miss early wakeups as
q.key is equal to key2 (because they are the same uaddr). We will then
attempt to dereference the pi_mutex (which would exist had the futex_q
been properly requeued to a pi futex) and trigger a NULL pointer
dereference.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Link: http://lkml.kernel.org/r/ad82bfe7f7d130247fbe2b5b4275654807774227.1342809673.git.dvhart@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/futex.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2231,11 +2231,11 @@ int handle_early_requeue_pi_wakeup(struc
  * @uaddr2:	the pi futex we will take prior to returning to user-space
  *
  * The caller will wait on uaddr and will be requeued by futex_requeue() to
- * uaddr2 which must be PI aware.  Normal wakeup will wake on uaddr2 and
- * complete the acquisition of the rt_mutex prior to returning to userspace.
- * This ensures the rt_mutex maintains an owner when it has waiters; without
- * one, the pi logic wouldn't know which task to boost/deboost, if there was a
- * need to.
+ * uaddr2 which must be PI aware and unique from uaddr.  Normal wakeup will wake
+ * on uaddr2 and complete the acquisition of the rt_mutex prior to returning to
+ * userspace.  This ensures the rt_mutex maintains an owner when it has waiters;
+ * without one, the pi logic would not know which task to boost/deboost, if
+ * there was a need to.
  *
  * We call schedule in futex_wait_queue_me() when we enqueue and return there
  * via the following:
@@ -2272,6 +2272,9 @@ static int futex_wait_requeue_pi(u32 __u
 	struct futex_q q = futex_q_init;
 	int res, ret;
 
+	if (uaddr == uaddr2)
+		return -EINVAL;
+
 	if (!bitset)
 		return -EINVAL;
 


