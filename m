Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab0HKX7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:31 -0400
Received: from kroah.org ([198.145.64.141]:43620 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759251Ab0HKX7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:09 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:03 2010
Message-Id: <20100811235503.574374391@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [087/111] mutex: Dont spin when the owner CPU is offline or other weird cases
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 4b402210486c6414fe5fbfd85934a0a22da56b04 upstream.

Due to recent load-balancer changes that delay the task migration to
the next wakeup, the adaptive mutex spinning ends up in a live lock
when the owner's CPU gets offlined because the cpu_online() check
lives before the owner running check.

This patch changes mutex_spin_on_owner() to return 0 (don't spin) in
any case where we aren't sure about the owner struct validity or CPU
number, and if the said CPU is offline. There is no point going back &
re-evaluate spinning in corner cases like that, let's just go to
sleep.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1271212509.13059.135.camel@pasglop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5590,7 +5590,7 @@ int mutex_spin_on_owner(struct mutex *lo
 	 * the mutex owner just released it and exited.
 	 */
 	if (probe_kernel_address(&owner->cpu, cpu))
-		goto out;
+		return 0;
 #else
 	cpu = owner->cpu;
 #endif
@@ -5600,14 +5600,14 @@ int mutex_spin_on_owner(struct mutex *lo
 	 * the cpu field may no longer be valid.
 	 */
 	if (cpu >= nr_cpumask_bits)
-		goto out;
+		return 0;
 
 	/*
 	 * We need to validate that we can do a
 	 * get_cpu() and that we have the percpu area.
 	 */
 	if (!cpu_online(cpu))
-		goto out;
+		return 0;
 
 	rq = cpu_rq(cpu);
 
@@ -5626,7 +5626,7 @@ int mutex_spin_on_owner(struct mutex *lo
 
 		cpu_relax();
 	}
-out:
+
 	return 1;
 }
 #endif


