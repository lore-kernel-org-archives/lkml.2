Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211Ab1ETHxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:53:42 -0400
Received: from mail4.comsite.net ([205.238.176.238]:64054 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420Ab1ETHxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:53:40 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: Re: [22/44] driver core: let dev_set_drvdata return int instead of void
 as it can fail
From: Milton Miller <miltonm@bga.com>
Message-Id: <please-do-not-merge-driver-set-data-fail@mdm.bga.com>
Cc: linux-kernel@vger.kernel.org
To: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <1305850262-9575-22-git-send-email-gregkh@suse.de>
References: <1305850262-9575-22-git-send-email-gregkh@suse.de>
Date: Fri, 20 May 2011 02:53:30 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 about 00:10:40 -0000, Greg Kroah-Hartman wrote:
> 
> From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> Before commit
> 
> 	b402843 (Driver core: move dev_get/set_drvdata to drivers/base/dd.c)
> 
> calling dev_set_drvdata with dev=NULL was an unchecked error. After some
> discussion about what to return in this case removing the check (and so
> producing a null pointer exception) seems fine.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 

I obviously didn't follow the discussions close enough and got
confused[1], but I don't like the anticipated fallout of pushing this
change though all the drivers.  Let alone see the arguments that not
being able to free the device when it fails is no reason to fail.

So, my first question is:  When is it legal for a driver to set driver
data before a device is registered?

I understand we can call device_initialize and then set driver and
then add it to the bus, but is there ever a reason to add driver data
before we call device_initialize?


And if for some obscure reason we need it early, could we instead
move it to the public portion of struct device?  Its not like its
core data list that needs special locking.

Or ... I was going to say move the private allocation to
device_initialize instead, but I see that too is void.  On the other
hand there are only 116 lines found by git grep device_initialize,
as oposed to 3543 with set_drvdata.






AHH!

I just found this quote:

https://lkml.org/lkml/2011/4/29/57

Uwe:
> Russell:
> > If the answer is no one, its pointless returning an error value in the
> > first place (which I think is what the original author already thought
> > about.)
> In the meantime I learned that dev->p is valid when the device is
> registered. As calling dev_set_drvdata on an unregisted device is not
> allowed maybe issuing a warning instead would be OK for me, too.


So why is this in the queue to be merged?

milton


[1] I scanned the commit message and saw "just dereference NULL"
and didn't notice we are still changing the return type.

So we loose the check on no-mmu or archs that allow map of
page 0.  Where is Russell's BUG_ON_MAPPABLE_NULL?


Actually I probably read https://lkml.org/lkml/2011/4/29/57 and
expected the patch in its current form to be dead.


Anyways, here is a patch for next:

Prove no driver calls dev_set_drvdata before device_add, so we
can make it a full BUG_ON(!dev || !dev->p);

Index: work.git/drivers/base/dd.c
===================================================================
--- work.git.orig/drivers/base/dd.c	2011-05-20 01:57:32.390257692 -0500
+++ work.git/drivers/base/dd.c	2011-05-20 02:16:56.654275127 -0500
@@ -413,6 +413,7 @@ int dev_set_drvdata(struct device *dev, 
 	int error;
 
 	if (!dev->p) {
+		WARN(1, "dev_set_drvdata called before device_add");
 		error = device_private_init(dev);
 		if (error)
 			return error;
