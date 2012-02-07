Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab2BGBH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 20:07:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40156 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab2BGBF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 20:05:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/8] PM / Sleep: Do not check wakeup too often in try_to_freeze_tasks()
Date: Tue, 7 Feb 2012 02:03:00 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>,
        Greg KH <greg@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201202070200.55505.rjw@sisk.pl>
In-Reply-To: <201202070200.55505.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202070203.00568.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use the observation that it is more efficient to check the wakeup
variable once before the loop reporting tasks that were not
frozen in try_to_freeze_tasks() than to do that in every step of that
loop.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/process.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux/kernel/power/process.c
===================================================================
--- linux.orig/kernel/power/process.c
+++ linux/kernel/power/process.c
@@ -98,13 +98,15 @@ static int try_to_freeze_tasks(bool user
 		       elapsed_csecs / 100, elapsed_csecs % 100,
 		       todo - wq_busy, wq_busy);
 
-		read_lock(&tasklist_lock);
-		do_each_thread(g, p) {
-			if (!wakeup && !freezer_should_skip(p) &&
-			    p != current && freezing(p) && !frozen(p))
-				sched_show_task(p);
-		} while_each_thread(g, p);
-		read_unlock(&tasklist_lock);
+		if (!wakeup) {
+			read_lock(&tasklist_lock);
+			do_each_thread(g, p) {
+				if (p != current && !freezer_should_skip(p)
+				    && freezing(p) && !frozen(p))
+					sched_show_task(p);
+			} while_each_thread(g, p);
+			read_unlock(&tasklist_lock);
+		}
 	} else {
 		printk("(elapsed %d.%02d seconds) ", elapsed_csecs / 100,
 			elapsed_csecs % 100);

