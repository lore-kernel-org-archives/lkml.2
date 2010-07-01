Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab0GAVSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:18:10 -0400
Received: from kroah.org ([198.145.64.141]:33091 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741Ab0GAVO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:58 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:59 2010
Message-Id: <20100701174259.867041442@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [158/200] USB: unbind all interfaces before rebinding them
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit c043f1245654a726925529007210e9f786426448 upstream.

This patch (as1387) fixes a bug introduced during the changeover to
the runtime PM framework.  When a driver doesn't support resume or
reset-resume, and consequently its interfaces need to be unbound and
rebound, we have to unbind all the interfaces before trying to rebind
any of them.  Otherwise the driver's probe method for one interface
could try to claim a different interface and fail, because that other
interface hasn't been unbound yet.

This fixes Bugzilla #15788.  The symptom is that some USB sound cards
don't work after hibernation.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: François Valenduc <francois.valenduc@tvcablenet.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/driver.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1322,6 +1322,7 @@ int usb_resume(struct device *dev, pm_me
 
 	/* For all other calls, take the device back to full power and
 	 * tell the PM core in case it was autosuspended previously.
+	 * Unbind the interfaces that will need rebinding later.
 	 */
 	} else {
 		status = usb_resume_both(udev, msg);
@@ -1330,6 +1331,7 @@ int usb_resume(struct device *dev, pm_me
 			pm_runtime_set_active(dev);
 			pm_runtime_enable(dev);
 			udev->last_busy = jiffies;
+			do_unbind_rebind(udev, DO_REBIND);
 		}
 	}
 


