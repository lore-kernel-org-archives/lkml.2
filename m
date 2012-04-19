Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab2DSTiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:38:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50779 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab2DSTiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:38:05 -0400
Date: Thu, 19 Apr 2012 12:37:49 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-b9a6a23566960d0dd3f51e2e68b472cd61911078@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, santosh.shilimkar@ti.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.02.1204181723350.2542@ionos>
References: <alpine.LFD.2.02.1204181723350.2542@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick:
  Ensure that the broadcast device is initialized
Git-Commit-ID: b9a6a23566960d0dd3f51e2e68b472cd61911078
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 19 Apr 2012 12:37:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9a6a23566960d0dd3f51e2e68b472cd61911078
Gitweb:     http://git.kernel.org/tip/b9a6a23566960d0dd3f51e2e68b472cd61911078
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 18 Apr 2012 17:31:58 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 19 Apr 2012 21:27:35 +0200

tick: Ensure that the broadcast device is initialized

Santosh found another trap when we avoid to initialize the broadcast
device in the switch_to_oneshot code. The broadcast device might be
still in SHUTDOWN state when we actually need to use it. That
obviously breaks, as set_next_event() is called on a shutdown
device. This did not break on x86, but Suresh analyzed it:

>From the review, most likely on Sven's system we are force enabling
the hpet using the pci quirk's method very late. And in this case,
hpet_clockevent (which will be global_clock_event) handler can be
null, specifically as this platform might not be using deeper c-states
and using the reliable APIC timer.

Prior to commit 'fa4da365bc7772c', that handler will be set to
'tick_handle_oneshot_broadcast' when we switch the broadcast timer to
oneshot mode, even though we don't use it. Post commit
'fa4da365bc7772c', we stopped switching the broadcast mode to oneshot
as this is not really needed and his platform's global_clock_event's
handler will remain null. While on my SNB laptop, same is set to
'clockevents_handle_noop' because hpet gets enabled very early. (noop
handler on my platform set when the early enabled hpet timer gets
replaced by the lapic timer).

But the commit 'fa4da365bc7772c' tracked the broadcast timer mode in
the SW as oneshot, even though it didn't touch the HW timer. During
resume however, tick_resume_broadcast() saw the SW broadcast mode as
oneshot and actually programmed the broadcast device also into oneshot
mode. So this triggered the null pointer de-reference after the hpet
wraps around and depending on what the hpet counter is set to. On the
normal platforms where hpet gets enabled early we should be seeing a
spurious interrupt (in my SNB laptop I see one spurious interrupt
after around 5 minutes ;) which is 32-bit hpet counter wraparound
time), but that's a separate issue.

Enforce the mode setting when trying to set an event.

Reported-and-tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: torvalds@linux-foundation.org
Cc: svenjoac@gmx.de
Cc: rjw@sisk.pl
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1204181723350.2542@ionos

---
 kernel/time/tick-broadcast.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 119aca5..029531f 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -373,6 +373,9 @@ static int tick_broadcast_set_event(ktime_t expires, int force)
 {
 	struct clock_event_device *bc = tick_broadcast_device.evtdev;
 
+	if (bc->mode != CLOCK_EVT_MODE_ONESHOT)
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+
 	return clockevents_program_event(bc, expires, force);
 }
 
