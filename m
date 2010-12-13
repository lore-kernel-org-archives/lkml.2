Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0LMW7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:59:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52429 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab0LMW73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:59:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/4] PM: Remove redundant checks from core device resume routines
Date: Mon, 13 Dec 2010 23:58:44 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201012130128.31243.rjw@sisk.pl> <201012130131.24970.rjw@sisk.pl> <AANLkTi=UVOQb15EdpfSeD+Qh8x779pJpsSCTyGvf-gxG@mail.gmail.com>
In-Reply-To: <AANLkTi=UVOQb15EdpfSeD+Qh8x779pJpsSCTyGvf-gxG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012132358.44354.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 13, 2010, Linus Torvalds wrote:
> So I really like this series not only because it implements what I
> suggested, but also because each patch seems to remove more lines than
> it adds. That's always nice, and much too unusual.
> 
> But in this one, I really think you should simplify/clarify things further:
> 
> On Sun, Dec 12, 2010 at 4:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > +++ linux-2.6/drivers/base/power/main.c
> > @@ -485,20 +485,17 @@ void dpm_resume_noirq(pm_message_t state
> >        transition_started = false;
> >        while (!list_empty(&dpm_noirq_list)) {
> >                struct device *dev = to_device(dpm_noirq_list.next);
> > +               int error;
> >
> >                get_device(dev);
> > -               if (dev->power.status > DPM_OFF) {
> > -                       int error;
> > -
> > -                       dev->power.status = DPM_OFF;
> > -                       mutex_unlock(&dpm_list_mtx);
> > +               dev->power.status = DPM_OFF;
> > +               mutex_unlock(&dpm_list_mtx);
> 
> I think you should move the device to the dpm_suspended list _here_,
> before dropping the mutex. That way the power.status thing matches the
> list.
> 
> So then you'd just remove the crazy conditional "if it's still on a
> list, move it to the right list" thing, and these two lines:
> 
> >                if (!list_empty(&dev->power.entry))
> >                        list_move_tail(&dev->power.entry, &dpm_suspended_list);
> 
> Would just be that plain
> 
>         list_move_tail(&dev->power.entry, &dpm_suspended_list);
> 
> before you even drop the lock. That look much simpler, and the list
> movement seems a lot more obvious, no?
> 
> If an unregister event (or whatever) happens while you had the mutex
> unlocked, it will just remove it from the new list (the one that
> matches the power state). So no need for that whole complexity with
> "what happens with the list if somebody removed the device while we
> were busy suspending/resuming it".
> 
> Or am I missing something?

No, you're right.  Somehow I didn't notice this possible simplification.

> (And same comment for that other identical case in dpm_complete())

Yeah.

In addition to that error messages need not be printed under the mutex.

Updated patch is appended.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Remove redundant checks from core device resume routines

Since a separate list of devices is used to link devices that have
completed each stage of suspend (or resume), it is not necessary to
check dev->power.status in the core device resume routines any more.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   44 +++++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -485,22 +485,18 @@ void dpm_resume_noirq(pm_message_t state
 	transition_started = false;
 	while (!list_empty(&dpm_noirq_list)) {
 		struct device *dev = to_device(dpm_noirq_list.next);
+		int error;
 
 		get_device(dev);
-		if (dev->power.status > DPM_OFF) {
-			int error;
-
-			dev->power.status = DPM_OFF;
-			mutex_unlock(&dpm_list_mtx);
+		dev->power.status = DPM_OFF;
+		list_move_tail(&dev->power.entry, &dpm_suspended_list);
+		mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume_noirq(dev, state);
+		error = device_resume_noirq(dev, state);
+		if (error)
+			pm_dev_err(dev, state, " early", error);
 
-			mutex_lock(&dpm_list_mtx);
-			if (error)
-				pm_dev_err(dev, state, " early", error);
-		}
-		if (!list_empty(&dev->power.entry))
-			list_move_tail(&dev->power.entry, &dpm_suspended_list);
+		mutex_lock(&dpm_list_mtx);
 		put_device(dev);
 	}
 	mutex_unlock(&dpm_list_mtx);
@@ -619,9 +615,6 @@ static void dpm_resume(pm_message_t stat
 	async_error = 0;
 
 	list_for_each_entry(dev, &dpm_suspended_list, power.entry) {
-		if (dev->power.status < DPM_OFF)
-			continue;
-
 		INIT_COMPLETION(dev->power.completion);
 		if (is_async(dev)) {
 			get_device(dev);
@@ -632,16 +625,16 @@ static void dpm_resume(pm_message_t stat
 	while (!list_empty(&dpm_suspended_list)) {
 		dev = to_device(dpm_suspended_list.next);
 		get_device(dev);
-		if (dev->power.status >= DPM_OFF && !is_async(dev)) {
+		if (!is_async(dev)) {
 			int error;
 
 			mutex_unlock(&dpm_list_mtx);
 
 			error = device_resume(dev, state, false);
-
-			mutex_lock(&dpm_list_mtx);
 			if (error)
 				pm_dev_err(dev, state, "", error);
+
+			mutex_lock(&dpm_list_mtx);
 		}
 		if (!list_empty(&dev->power.entry))
 			list_move_tail(&dev->power.entry, &dpm_prepared_list);
@@ -697,17 +690,14 @@ static void dpm_complete(pm_message_t st
 		struct device *dev = to_device(dpm_prepared_list.prev);
 
 		get_device(dev);
-		if (dev->power.status > DPM_ON) {
-			dev->power.status = DPM_ON;
-			mutex_unlock(&dpm_list_mtx);
+		dev->power.status = DPM_ON;
+		list_move(&dev->power.entry, &list);
+		mutex_unlock(&dpm_list_mtx);
 
-			device_complete(dev, state);
-			pm_runtime_put_sync(dev);
+		device_complete(dev, state);
+		pm_runtime_put_sync(dev);
 
-			mutex_lock(&dpm_list_mtx);
-		}
-		if (!list_empty(&dev->power.entry))
-			list_move(&dev->power.entry, &list);
+		mutex_lock(&dpm_list_mtx);
 		put_device(dev);
 	}
 	list_splice(&list, &dpm_list);
