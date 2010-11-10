Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab0KJWmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:42:44 -0500
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:53884 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757198Ab0KJWmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:42:43 -0500
X-AuditID: 1209190c-b7ba9ae0000009f8-68-4cdb1fe2cc34
From: Andy Lutomirski <luto@MIT.EDU>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2] Improve clocksource unstable warning
Date: Wed, 10 Nov 2010 17:42:26 -0500
Message-Id: <b498b4d7b3a0c50a08e1547ff93d7ad1d4d49c35.1289428887.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <alpine.LFD.2.00.1011102327050.2900@localhost6.localdomain6>
References: <alpine.LFD.2.00.1011102327050.2900@localhost6.localdomain6>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system goes out to lunch for a long time, the clocksource
watchdog might get false positives.  Clarify the warning so that
people stop blaming their system freezes on the timing code.

This change was Thomas Gleixner's suggestion.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---

This version compares directly (and tediously to avoid overflow) with
max_idle_ns.

 kernel/time/clocksource.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c18d7ef..f8cef8b 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -215,8 +215,10 @@ static void __clocksource_unstable(struct clocksource *cs)
 
 static void clocksource_unstable(struct clocksource *cs, int64_t delta)
 {
-	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
-	       cs->name, delta);
+	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)%s\n",
+	       cs->name, delta,
+	       (delta < 0 && (u64)-delta > watchdog->max_idle_ns) ?
+		 " or your system lagged for other reasons" : "");
 	__clocksource_unstable(cs);
 }
 
-- 
1.7.3.2

