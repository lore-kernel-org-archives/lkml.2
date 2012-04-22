Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab2DVVUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 17:20:30 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:58156 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab2DVVU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 17:20:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/8] PM / Sleep: Look for wakeup events in later stages of device suspend
Date: Sun, 22 Apr 2012 23:19:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <201202070200.55505.rjw@sisk.pl> <201202220031.46219.rjw@sisk.pl> <201204222319.02228.rjw@sisk.pl>
In-Reply-To: <201204222319.02228.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204222319.59351.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently, the device suspend code in drivers/base/power/main.c
only checks if there have been any wakeup events, and therefore the
ongoing system transition to a sleep state should be aborted, during
the first (i.e. "suspend") device suspend phase.  However, wakeup
events may be reported later as well, so it's reasonable to look for
them in the in the subsequent (i.e. "late suspend" and "suspend
noirq") phases.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux/drivers/base/power/main.c
===================================================================
--- linux.orig/drivers/base/power/main.c
+++ linux/drivers/base/power/main.c
@@ -889,6 +889,11 @@ static int dpm_suspend_noirq(pm_message_
 		if (!list_empty(&dev->power.entry))
 			list_move(&dev->power.entry, &dpm_noirq_list);
 		put_device(dev);
+
+		if (pm_wakeup_pending()) {
+			error = -EBUSY;
+			break;
+		}
 	}
 	mutex_unlock(&dpm_list_mtx);
 	if (error)
@@ -962,6 +967,11 @@ static int dpm_suspend_late(pm_message_t
 		if (!list_empty(&dev->power.entry))
 			list_move(&dev->power.entry, &dpm_late_early_list);
 		put_device(dev);
+
+		if (pm_wakeup_pending()) {
+			error = -EBUSY;
+			break;
+		}
 	}
 	mutex_unlock(&dpm_list_mtx);
 	if (error)

