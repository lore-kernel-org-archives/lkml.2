Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1G1DQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 23:16:13 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42819 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab1G1DQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 23:16:08 -0400
Date: Thu, 28 Jul 2011 11:16:00 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: migrate_disable() race with cpu hotplug?
Message-ID: <20110728031600.GA338@windriver.com>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <CAM2zO=AxRYEG=iJqrefOL34GW5ukoQKxYQdJ02mez=s5UZPoJg@mail.gmail.com>
 <alpine.LFD.2.02.1107272350560.2660@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1107272350560.2660@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 11:52:18PM +0200, Thomas Gleixner wrote:
> On Tue, 26 Jul 2011, Yong Zhang wrote:
> 
> > When reading the code, I'm afraid there is a race between migrate_disable()
> > and cpu hotplug. A scenario will like below:
> > 
> > 	CPU0			CPU1
> > _cpu_down();
> >   cpu_unplug_begin();
> >     wait_for_completion()
> >   			sync_unplug_thread();
> > 			  complete();
> > 			race_window? /*
> > 				      * migrate_disable() will
> > 				      * not take effect since
> > 				      * hotplug is in progress
> > 				      */
> 
> Rightfully so. The caller will just block on the cpu_hotplug.lock
> mutex until the unplug operation will be done.

Yup, just notice the mutex_lock/mutex_unlock in pin_current_cpu().

But if the caller block on mutex_lock() then waked up, it's possible
that it's been migrated to another cpu. So in the 'retry' loop, we
should reget hotplug_pcp.

Code like below?

Thanks,
Yong

---
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH] kernel/cpu.c: re-acquire hotplug_pcp when pin_current_cpu() retry

When 'retry' happen, it's possible that the task has been
migrated to other cpu, and 'hotplug_pcp' is still pointing to
the stale one.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/cpu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 53dd7ad..5f2382a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -75,9 +75,11 @@ static DEFINE_PER_CPU(struct hotplug_pcp, hotplug_pcp);
  */
 void pin_current_cpu(void)
 {
-	struct hotplug_pcp *hp = &__get_cpu_var(hotplug_pcp);
+	struct hotplug_pcp *hp;
 
 retry:
+	hp = &__get_cpu_var(hotplug_pcp);
+
 	if (!hp->unplug || hp->refcount || preempt_count() > 1 ||
 	    hp->unplug == current || (current->flags & PF_STOMPER)) {
 		hp->refcount++;
-- 
1.7.4.1

-- 
Only stand for myself
