Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab0LCV4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 16:56:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52791 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab0LCVz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:55:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 3/3] PM: Use pm_wakeup_pending() in device_suspend()
Date: Fri, 3 Dec 2010 22:54:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1012031024020.1682-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1012031024020.1682-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012032254.55542.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 03, 2010, Alan Stern wrote:
> On Fri, 3 Dec 2010, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Before starting to suspend a device in device_suspend() check if
> > there's a request to abort the power transition and return -EBUSY
> > in that case.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/base/power/main.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > Index: linux-2.6/drivers/base/power/main.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/base/power/main.c
> > +++ linux-2.6/drivers/base/power/main.c
> > @@ -935,6 +935,11 @@ static void async_suspend(void *data, as
> >  
> >  static int device_suspend(struct device *dev)
> >  {
> > +	if (pm_wakeup_pending()) {
> > +		async_error = -EBUSY;
> > +		return async_error;
> > +	}
> > +
> >  	INIT_COMPLETION(dev->power.completion);
> >  
> >  	if (pm_async_enabled && dev->power.async_suspend) {
> 
> Is a similar test needed in async_suspend()?  What happens if 
> dpm_suspend() runs through the entire device list okay, but a wakeup 
> event occurs in the middle of the async_synchronize_full() delay?

The devices will be suspended and the suspend will progress until it's
finally aborted before putting the system into the sleep state.  But I agree
it's better to check pm_wakeup_pending() in async_suspend() too,
so I think we can simply put it into __device_suspend() instead, like in the
patch below.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Use pm_wakeup_pending() in __device_suspend()

Before starting to suspend a device in __device_suspend() check if
there's a request to abort the power transition and return -EBUSY
in that case.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -877,6 +877,11 @@ static int __device_suspend(struct devic
 	if (async_error)
 		goto End;
 
+	if (pm_wakeup_pending()) {
+		async_error = -EBUSY;
+		goto End;
+	}
+
 	if (dev->class) {
 		if (dev->class->pm) {
 			pm_dev_dbg(dev, state, "class ");
