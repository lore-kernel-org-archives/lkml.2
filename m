Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab0KDN0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:26:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51199 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab0KDN0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:26:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [GIT PULL] One more power management fix for 2.6.37
Date: Thu, 4 Nov 2010 14:24:44 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201010292358.27975.rjw@sisk.pl> <201011040604.05183.rjw@sisk.pl> <20101104062709.GA3118@isilmar-3.linta.de>
In-Reply-To: <20101104062709.GA3118@isilmar-3.linta.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011041424.44215.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 04, 2010, Dominik Brodowski wrote:
> On Thu, Nov 04, 2010 at 06:04:05AM +0100, Rafael J. Wysocki wrote:
> > On Wednesday, November 03, 2010, Dominik Brodowski wrote:
> > > > There's apparently an ordering problem with dpm_list_mtx and
> > > > socket->skt_mutex. Lockdep details appended.
> > > > 
> > > > Dominik, Rafael? What's the proper locking order here, and
> > > > how do we fix this?
> > > 
> > > Thanks for noting this; let's see:
> > > 
> > > - We add a PCMCIA device holding skt_mutex, therefore we have the ordering
> > >   (1) skt_mutex -> (2) dpm_list_mtx
> > > 
> > > - If we're suspending, dpm_list_mtx is held, but we need to acquire
> > >   skt_mutex as we modify some data being protected by skt_mutex
> > >   (1) dpm_list_mtx -> (2) skt_mutex
> > > 
> > > Rafael, any idea on how to solve this? How do other subsystems handle such
> > > an issue? Do they call device_add() with no locks held at all?
> > 
> > They usually do from what I can tell.
> > 
> > Also only a few of them implement the ->suspend_noirq() callback, which is the
> > one executed under dpm_list_mtx.
> > 
> > What exactly is protected by skt_mutex ?
> 
> e.g.
> struct pcmcia_socket {
> 	...
>         u_int                   suspended_state;
>         int                     resume_status;
> 	...
> }
> 
> Furthermore, one has to acquire skt_mutex first before obtaining ops_mutex,
> which protects many more fields (and asserts exclusion for some code paths),
> see Documentation/pcmcia/locking.txt for details.

OK, so I think we can relax the locking in dpm_[suspend/resume]_noirq() to
avoid executing callbacks under dpm_list_mtx, like in the (untested) patch
below.

Alan, do you see any immediate problem with that?

Rafael

---
 drivers/base/power/main.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -480,15 +480,23 @@ void dpm_resume_noirq(pm_message_t state
 
 	mutex_lock(&dpm_list_mtx);
 	transition_started = false;
-	list_for_each_entry(dev, &dpm_list, power.entry)
+	list_for_each_entry(dev, &dpm_list, power.entry) {
+		get_device(dev);
 		if (dev->power.status > DPM_OFF) {
 			int error;
 
 			dev->power.status = DPM_OFF;
+
+			mutex_unlock(&dpm_list_mtx);
+
 			error = device_resume_noirq(dev, state);
+
+			mutex_lock(&dpm_list_mtx);
 			if (error)
 				pm_dev_err(dev, state, " early", error);
 		}
+		put_device(dev);
+	}
 	mutex_unlock(&dpm_list_mtx);
 	dpm_show_time(starttime, state, "early");
 	resume_device_irqs();
@@ -796,12 +804,19 @@ int dpm_suspend_noirq(pm_message_t state
 	suspend_device_irqs();
 	mutex_lock(&dpm_list_mtx);
 	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
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
+		put_device(dev);
 	}
 	mutex_unlock(&dpm_list_mtx);
 	if (error)
