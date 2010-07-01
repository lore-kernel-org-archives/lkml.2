Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab0GAVAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:00:39 -0400
Received: from kroah.org ([198.145.64.141]:47956 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932882Ab0GAUva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:30 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:39 2010
Message-Id: <20100701173439.370783301@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Glauber Costa <glommer@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 149/164] x86, paravirt: Add a global synchronization point for pvclock
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Glauber Costa <glommer@redhat.com>

In recent stress tests, it was found that pvclock-based systems
could seriously warp in smp systems. Using ingo's time-warp-test.c,
I could trigger a scenario as bad as 1.5mi warps a minute in some systems.
(to be fair, it wasn't that bad in most of them). Investigating further, I
found out that such warps were caused by the very offset-based calculation
pvclock is based on.

This happens even on some machines that report constant_tsc in its tsc flags,
specially on multi-socket ones.

Two reads of the same kernel timestamp at approx the same time, will likely
have tsc timestamped in different occasions too. This means the delta we
calculate is unpredictable at best, and can probably be smaller in a cpu
that is legitimately reading clock in a forward ocasion.

Some adjustments on the host could make this window less likely to happen,
but still, it pretty much poses as an intrinsic problem of the mechanism.

A while ago, I though about using a shared variable anyway, to hold clock
last state, but gave up due to the high contention locking was likely
to introduce, possibly rendering the thing useless on big machines. I argue,
however, that locking is not necessary.

We do a read-and-return sequence in pvclock, and between read and return,
the global value can have changed. However, it can only have changed
by means of an addition of a positive value. So if we detected that our
clock timestamp is less than the current global, we know that we need to
return a higher one, even though it is not exactly the one we compared to.

OTOH, if we detect we're greater than the current time source, we atomically
replace the value with our new readings. This do causes contention on big
boxes (but big here means *BIG*), but it seems like a good trade off, since
it provide us with a time source guaranteed to be stable wrt time warps.

After this patch is applied, I don't see a single warp in time during 5 days
of execution, in any of the machines I saw them before.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Acked-by: Zachary Amsden <zamsden@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>
CC: Zachary Amsden <zamsden@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
(cherry picked from commit 489fb490dbf8dab0249ad82b56688ae3842a79e8)
---
 arch/x86/kernel/pvclock.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -109,11 +109,14 @@ unsigned long pvclock_tsc_khz(struct pvc
 	return pv_tsc_khz;
 }
 
+static atomic64_t last_value = ATOMIC64_INIT(0);
+
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 {
 	struct pvclock_shadow_time shadow;
 	unsigned version;
 	cycle_t ret, offset;
+	u64 last;
 
 	do {
 		version = pvclock_get_time_values(&shadow, src);
@@ -123,6 +126,27 @@ cycle_t pvclock_clocksource_read(struct
 		barrier();
 	} while (version != src->version);
 
+	/*
+	 * Assumption here is that last_value, a global accumulator, always goes
+	 * forward. If we are less than that, we should not be much smaller.
+	 * We assume there is an error marging we're inside, and then the correction
+	 * does not sacrifice accuracy.
+	 *
+	 * For reads: global may have changed between test and return,
+	 * but this means someone else updated poked the clock at a later time.
+	 * We just need to make sure we are not seeing a backwards event.
+	 *
+	 * For updates: last_value = ret is not enough, since two vcpus could be
+	 * updating at the same time, and one of them could be slightly behind,
+	 * making the assumption that last_value always go forward fail to hold.
+	 */
+	last = atomic64_read(&last_value);
+	do {
+		if (ret < last)
+			return last;
+		last = atomic64_cmpxchg(&last_value, last, ret);
+	} while (unlikely(last != ret));
+
 	return ret;
 }
 


