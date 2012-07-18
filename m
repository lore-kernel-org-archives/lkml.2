Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2GRSBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 14:01:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab2GRSBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 14:01:34 -0400
Date: Wed, 18 Jul 2012 14:01:19 -0400
From: Dave Jones <davej@redhat.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: potential NULL dereference in futex_wait_requeue_pi()
Message-ID: <20120718180119.GA1458@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Darren Hart <dvhart@linux.intel.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20120718142514.GA18850@elgon.mountain>
 <5006DE4A.4020905@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5006DE4A.4020905@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 09:03:22AM -0700, Darren Hart wrote:
 
 > > This will oops if pi_mutex is NULL.
 > > 
 > >   2374                          rt_mutex_unlock(pi_mutex);
 > >   2375          } else if (ret == -EINTR) {
 > 
 > Nice Dan, thanks for taking a closer look. This appears to be a simple fix, can
 > you try the following:
 > 
 > 
 > futex: Test for pi_mutex on fault in futex_wait_requeue_pi
 > 
 > If fixup_pi_state_owner() faults, pi_mutex may be NULL. Test
 > for pi_mutex != NULL before testing the owner against current
 > and possibly unlocking it.
 > 
 > Signed-off-by: Darren Hart <dvhart@linux.intel.com>
 > CC: Dave Jones <davej@redhat.com>
 > CC: Dan Carpenter <dan.carpenter@oracle.com>
 > CC: Thomas Gleixner <tglx@linutronix.de>
 > 
 > diff --git a/kernel/futex.c b/kernel/futex.c
 > index e2b0fb9..05018bf 100644
 > --- a/kernel/futex.c
 > +++ b/kernel/futex.c
 > @@ -2370,7 +2370,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
 >  	 * fault, unlock the rt_mutex and return the fault to userspace.
 >  	 */
 >  	if (ret == -EFAULT) {
 > -		if (rt_mutex_owner(pi_mutex) == current)
 > +		if (pi_mutex && rt_mutex_owner(pi_mutex) == current)
 >  			rt_mutex_unlock(pi_mutex);
 >  	} else if (ret == -EINTR) {
 >  		/*

Doesn't fix the oops for me unfortunatly.  It looks like it happens further up,
so this might be a spearate bug after all.

I added this..

@@ -2344,7 +2351,13 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
                 * the pi_state.
                 */
                WARN_ON(!&q.pi_state);
+
                pi_mutex = &q.pi_state->pi_mutex;
+               if (pi_mutex == NULL) {
+                       ret = -EINVAL;
+                       goto out;
+               }
+
                ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);


But that didn't seem to fix it either.  Somehow we still do this ..


BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
IP: [<ffffffff810d68be>] __lock_acquire+0x5e/0x1ae0

	lock_acquire+0xad/0x220
	_raw_spin_lock+0x46/0x80
	rt_mutex_finish_proxy_lock+0x34/0xe0
	futex_wait_requeue_pi.constprop.20+0x2e5/0x400
	do_futex+0xea/0xa20
	sys_futex+0x107/0x1a0
	system_call_fastpath+0x1a/0x1f

Ah, could it somehow be that we have a pi_mutex here, but it hasn't been initialised ?

The code: line fingers this as the failure in kernel/lockdep.c

        if (lock->key == &__lockdep_no_validate__)
    3f9e:       49 8b 07                mov    (%r15),%rax

r15 (lock) is somehow '0x28' here, which is why the NULL check I added didn't trigger.

This isn't helped by the fact that there seems to be another unrelated bug in futexes
that trinity triggers.  If you want to try this, running it with "-c futex" will reproduce
it very quickly.

	Dave

