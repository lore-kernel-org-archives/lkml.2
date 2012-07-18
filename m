Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2GRQFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:05:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:42615 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab2GRQFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:05:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="173763466"
Message-ID: <5006DE4A.4020905@linux.intel.com>
Date: Wed, 18 Jul 2012 09:03:22 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: potential NULL dereference in futex_wait_requeue_pi()
References: <20120718142514.GA18850@elgon.mountain>
In-Reply-To: <20120718142514.GA18850@elgon.mountain>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 07:25 AM, Dan Carpenter wrote:
> Hi Darren,
> 
> The patch 52400ba94675: "futex: add requeue_pi functionality" from
> Apr 3, 2009, leads to the following warning:
> kernel/futex.c:2373 futex_wait_requeue_pi()
> 	 error: potential NULL dereference 'pi_mutex'.
> 
>   2330          if (!q.rt_waiter) {
>   2331                  /*
>   2332                   * Got the lock. We might not be the anticipated owner if we
>   2333                   * did a lock-steal - fix up the PI-state in that case.
>   2334                   */
>   2335                  if (q.pi_state && (q.pi_state->owner != current)) {
>   2336                          spin_lock(q.lock_ptr);
>   2337                          ret = fixup_pi_state_owner(uaddr2, &q, current);
> 
> pi_mutex is NULL here and it looks like fixup_pi_state_owner() can
> return -EFAULT.
>
> 
>   2338                          spin_unlock(q.lock_ptr);
>   2339                  }
>   2340          } else {
> 
> 	[snipped]
> 
>   2366          }
>   2367  
>   2368          /*
>   2369           * If fixup_pi_state_owner() faulted and was unable to handle the
>   2370           * fault, unlock the rt_mutex and return the fault to userspace.
>   2371           */
>   2372          if (ret == -EFAULT) {
>   2373                  if (rt_mutex_owner(pi_mutex) == current)
>                                            ^^^^^^^^
> This will oops if pi_mutex is NULL.
> 
>   2374                          rt_mutex_unlock(pi_mutex);
>   2375          } else if (ret == -EINTR) {

Nice Dan, thanks for taking a closer look. This appears to be a simple fix, can
you try the following:


futex: Test for pi_mutex on fault in futex_wait_requeue_pi

If fixup_pi_state_owner() faults, pi_mutex may be NULL. Test
for pi_mutex != NULL before testing the owner against current
and possibly unlocking it.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Dave Jones <davej@redhat.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>

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


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


