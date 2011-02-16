Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab1BPAX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:23:57 -0500
Received: from kroah.org ([198.145.64.141]:49500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab1BPAXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:45 2011
Message-Id: <20110216001445.253082060@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [201/272] watchdog: Fix sysctl consistency
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit 397357666de6b5b6adb5fa99f9758ec8cf30ac34 upstream.

If it was not possible to enable watchdog for any cpu, switch
watchdog_enabled back to 0, because it's visible via
kernel.watchdog sysctl.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1296230433-6261-2-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/watchdog.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -430,9 +430,6 @@ static int watchdog_enable(int cpu)
 		wake_up_process(p);
 	}
 
-	/* if any cpu succeeds, watchdog is considered enabled for the system */
-	watchdog_enabled = 1;
-
 	return 0;
 }
 
@@ -460,12 +457,16 @@ static void watchdog_disable(int cpu)
 static void watchdog_enable_all_cpus(void)
 {
 	int cpu;
-	int result = 0;
+
+	watchdog_enabled = 0;
 
 	for_each_online_cpu(cpu)
-		result += watchdog_enable(cpu);
+		if (!watchdog_enable(cpu))
+			/* if any cpu succeeds, watchdog is considered
+			   enabled for the system */
+			watchdog_enabled = 1;
 
-	if (result)
+	if (!watchdog_enabled)
 		printk(KERN_ERR "watchdog: failed to be enabled on some cpus\n");
 
 }


