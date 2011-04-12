Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab1DLOyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:54:46 -0400
Received: from kroah.org ([198.145.64.141]:57499 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163Ab1DLOhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:51 2011
Message-Id: <20110412143551.251652319@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [031/105] powerpc: Fix accounting of softirq time when idle
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit ad5d1c888e556bc00c4e86f452cad4a3a87d22c1 upstream.

commit cf9efce0ce31 (powerpc: Account time using timebase rather
than PURR) used in_irq() to detect if the time was spent in
interrupt processing. This only catches hardirq context so if we
are in softirq context and in the idle loop we end up accounting it
as idle time. If we instead use in_interrupt() we catch both softirq
and hardirq time.

The issue was found when running a network intensive workload. top
showed the following:

0.0%us,  1.1%sy,  0.0%ni, 85.7%id,  0.0%wa,  9.9%hi,  3.3%si,  0.0%st

85.7% idle. But this was wildly different to the perf events data.
To confirm the suspicion I ran something to keep the core busy:

# yes > /dev/null &

8.2%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa, 10.3%hi, 81.4%si,  0.0%st

We only got 8.2% of the CPU for the userspace task and softirq has
shot up to 81.4%.

With the patch below top shows the correct stats:

0.0%us,  0.0%sy,  0.0%ni,  5.3%id,  0.0%wa, 13.3%hi, 81.3%si,  0.0%st

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -356,7 +356,7 @@ void account_system_vtime(struct task_st
 	}
 	get_paca()->user_time_scaled += user_scaled;
 
-	if (in_irq() || idle_task(smp_processor_id()) != tsk) {
+	if (in_interrupt() || idle_task(smp_processor_id()) != tsk) {
 		account_system_time(tsk, 0, delta, sys_scaled);
 		if (stolen)
 			account_steal_time(stolen);


