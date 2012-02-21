Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2BUXfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 18:35:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35757 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab2BUXfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 18:35:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 1/7] PM / Sleep: Look for wakeup events in later stages of device suspend
Date: Wed, 22 Feb 2012 00:32:44 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <201202070200.55505.rjw@sisk.pl> <201202220031.46219.rjw@sisk.pl>
In-Reply-To: <201202220031.46219.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202220032.45102.rjw@sisk.pl>
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

