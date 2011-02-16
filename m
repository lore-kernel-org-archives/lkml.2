Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab1BPBZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:25:56 -0500
Received: from kroah.org ([198.145.64.141]:49151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421Ab1BPAWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:40 2011
Message-Id: <20110216001440.141762760@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shaohua Li <shaohua.li@intel.com>
Subject: [151/272] fix a shutdown regression in intel_idle
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit ec30f343d61391ab23705e50a525da1d55395780 upstream.

Fix a shutdown regression caused by 2a2d31c8dc6f ("intel_idle: open
broadcast clock event").  The clockevent framework can automatically
shutdown broadcast timers for hotremove CPUs.  And we get a shutdown
regression when we shutdown broadcast timer for hot remove CPU, so just
delete some code.

Also fix some section mismatch.

Reported-by: Ari Savolainen <ari.m.savolainen@gmail.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Tested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/idle/intel_idle.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -258,7 +258,7 @@ static void __setup_broadcast_timer(void
 	clockevents_notify(reason, &cpu);
 }
 
-static int __cpuinit setup_broadcast_cpuhp_notify(struct notifier_block *n,
+static int setup_broadcast_cpuhp_notify(struct notifier_block *n,
 		unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
@@ -268,15 +268,11 @@ static int __cpuinit setup_broadcast_cpu
 		smp_call_function_single(hotcpu, __setup_broadcast_timer,
 			(void *)true, 1);
 		break;
-	case CPU_DOWN_PREPARE:
-		smp_call_function_single(hotcpu, __setup_broadcast_timer,
-			(void *)false, 1);
-		break;
 	}
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata setup_broadcast_notifier = {
+static struct notifier_block setup_broadcast_notifier = {
 	.notifier_call = setup_broadcast_cpuhp_notify,
 };
 


