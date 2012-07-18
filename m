Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2GROZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:25:29 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32418 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab2GROZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:25:27 -0400
Date: Wed, 18 Jul 2012 17:25:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: potential NULL dereference in futex_wait_requeue_pi()
Message-ID: <20120718142514.GA18850@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

The patch 52400ba94675: "futex: add requeue_pi functionality" from
Apr 3, 2009, leads to the following warning:
kernel/futex.c:2373 futex_wait_requeue_pi()
	 error: potential NULL dereference 'pi_mutex'.

  2330          if (!q.rt_waiter) {
  2331                  /*
  2332                   * Got the lock. We might not be the anticipated owner if we
  2333                   * did a lock-steal - fix up the PI-state in that case.
  2334                   */
  2335                  if (q.pi_state && (q.pi_state->owner != current)) {
  2336                          spin_lock(q.lock_ptr);
  2337                          ret = fixup_pi_state_owner(uaddr2, &q, current);

pi_mutex is NULL here and it looks like fixup_pi_state_owner() can
return -EFAULT.

  2338                          spin_unlock(q.lock_ptr);
  2339                  }
  2340          } else {

	[snipped]

  2366          }
  2367  
  2368          /*
  2369           * If fixup_pi_state_owner() faulted and was unable to handle the
  2370           * fault, unlock the rt_mutex and return the fault to userspace.
  2371           */
  2372          if (ret == -EFAULT) {
  2373                  if (rt_mutex_owner(pi_mutex) == current)
                                           ^^^^^^^^
This will oops if pi_mutex is NULL.

  2374                          rt_mutex_unlock(pi_mutex);
  2375          } else if (ret == -EINTR) {

regards,
dan carpenter

