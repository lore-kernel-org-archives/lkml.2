Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138Ab1BITC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:02:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab1BITC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:02:57 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        pebolle@tiscali.nl, Don Zickus <dzickus@redhat.com>
Subject: [PATCH] watchdog, nmi: lower the severity of error messages
Date: Wed,  9 Feb 2011 14:02:33 -0500
Message-Id: <1297278153-21111-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During boot if the hardlockup detector fails to initialize, it
complains very loudly.  Some failures should be expected under
certain situations, ie no lapics, or resource in-use.  Tone those
error messages down a bit.  Keep the rest at a high level.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Tested-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index d7ebdf4..bb7887b 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -366,8 +366,17 @@ static int watchdog_nmi_enable(int cpu)
 		goto out_save;
 	}
 
-	printk(KERN_ERR "NMI watchdog disabled for cpu%i: unable to create perf event: %ld\n",
-	       cpu, PTR_ERR(event));
+
+	/* vary the KERN level based on the returned errno */
+	if (PTR_ERR(event) == -EOPNOTSUPP)
+		printk(KERN_INFO "NMI watchdog disabled (cpu%i): not supported"
+				 " (no LAPIC?)\n", cpu);
+	else if (PTR_ERR(event) == -ENOENT)
+		printk(KERN_WARNING "NMI watchdog disabled (cpu%i): hardware"
+				    " events not enabled\n", cpu);
+	else
+		printk(KERN_ERR "NMI watchdog disabled (cpu%i): unable to create"
+				" perf event: %ld\n", cpu, PTR_ERR(event));
 	return PTR_ERR(event);
 
 	/* success path */
-- 
1.7.3.5

