Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851Ab1KJDVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:21:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933816Ab1KJDVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:21:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:01 2011
Message-Id: <20111109212701.000278617@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:25:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, James Wylder <james.wylder@motorola.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [007/262] USB: for usb_autopm_get_interface_async -EINPROGRESS is not an error
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Wylder <jwylder1@motorola.com>

commit c5a48592d874ddef8c7880311581eccf0eb30c3b upstream.

A return value of -EINPROGRESS from pm_runtime_get indicates that
the device is already resuming due to a previous call.  Internally,
usb_autopm_get_interface_async doesn't treat this as an error and
increments the usage count, but passes the error status along
to the caller.  The logical assumption of the caller is that
any negative return value reflects the device not resuming
and the pm_usage_cnt not being incremented.  Since the usage count
is being incremented and the device is resuming, return success (0)
instead.

Signed-off-by: James Wylder <james.wylder@motorola.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1583,7 +1583,7 @@ int usb_autopm_get_interface_async(struc
 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
 			__func__, atomic_read(&intf->dev.power.usage_count),
 			status);
-	if (status > 0)
+	if (status > 0 || status == -EINPROGRESS)
 		status = 0;
 	return status;
 }


