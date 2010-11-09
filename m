Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0KIXk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:40:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36170 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab0KIXk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:40:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [GIT PULL] One more power management fix for 2.6.37
Date: Wed, 10 Nov 2010 00:39:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1011041045350.2522-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011041045350.2522-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011100039.17689.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 04, 2010, Alan Stern wrote:
> On Thu, 4 Nov 2010, Rafael J. Wysocki wrote:
...
> This won't work if the callback tries to unregister the device, but of
> course the old code wouldn't work in that case either.  We should
> document this requirement.

As per our discussion in Boston I think we may actually allow
devices to be unregistered during the late and early phases and
avoid the locking problem with PCMCIA at the same time.

So, what about the patch below?

Rafael

---
 drivers/base/power/main.c |   36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -475,20 +475,33 @@ End:
  */
 void dpm_resume_noirq(pm_message_t state)
 {
-	struct device *dev;
+	struct list_head list;
 	ktime_t starttime = ktime_get();
 
+	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
-	transition_started = false;
-	list_for_each_entry(dev, &dpm_list, power.entry)
+	while (!list_empty(&dpm_list)) {
+		struct device *dev = to_device(dpm_list.next);
+
+		get_device(dev);
 		if (dev->power.status > DPM_OFF) {
 			int error;
 
 			dev->power.status = DPM_OFF;
+			mutex_unlock(&dpm_list_mtx);
+
 			error = device_resume_noirq(dev, state);
+
+			mutex_lock(&dpm_list_mtx);
 			if (error)
 				pm_dev_err(dev, state, " early", error);
 		}
+		if (!list_empty(&dev->power.entry))
+			list_move_tail(&dev->power.entry, &list);
+		put_device(dev);
+	}
+	list_splice(&list, &dpm_list);
+	transition_started = false;
 	mutex_unlock(&dpm_list_mtx);
 	dpm_show_time(starttime, state, "early");
 	resume_device_irqs();
@@ -789,20 +802,33 @@ End:
  */
 int dpm_suspend_noirq(pm_message_t state)
 {
-	struct device *dev;
+	struct list_head list;
 	ktime_t starttime = ktime_get();
 	int error = 0;
 
+	INIT_LIST_HEAD(&list);
 	suspend_device_irqs();
 	mutex_lock(&dpm_list_mtx);
-	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
+	while (!list_empty(&dpm_list)) {
+		struct device *dev = to_device(dpm_list.prev);
+
+		get_device(dev);
+		mutex_unlock(&dpm_list_mtx);
+
 		error = device_suspend_noirq(dev, state);
+
+		mutex_lock(&dpm_list_mtx);
 		if (error) {
 			pm_dev_err(dev, state, " late", error);
+			put_device(dev);
 			break;
 		}
 		dev->power.status = DPM_OFF_IRQ;
+		if (!list_empty(&dev->power.entry))
+			list_move(&dev->power.entry, &list);
+		put_device(dev);
 	}
+	list_splice_tail(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
 	if (error)
 		dpm_resume_noirq(resume_event(state));
