Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab1BPAYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:24:37 -0500
Received: from kroah.org ([198.145.64.141]:49658 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257Ab1BPAYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:47 2011
Message-Id: <20110216001447.238238082@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [221/272] PM / Runtime: Dont enable interrupts while running in_interrupt
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit c3810c88788d505d4ffd786addd111b745e42161 upstream.

This patch (as1445) fixes a bug in the runtime PM core left over from
the addition of the no_callbacks flag.  If this flag is set then it is
possible for rpm_suspend() to be called in_interrupt, so when
releasing spinlocks it's important not to re-enable interrupts.

To avoid an unnecessary save-and-restore of the interrupt flag, the
patch also inlines a pm_request_idle() call.

This fixes Bugzilla #27482.

(The offending code was added in 2.6.37, so it's not necessary to apply
this to any earlier stable kernels.)

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: tim blechmann <tim@klingt.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/power/runtime.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -404,12 +404,15 @@ static int rpm_suspend(struct device *de
 		goto out;
 	}
 
+	/* Maybe the parent is now able to suspend. */
 	if (parent && !parent->power.ignore_children) {
-		spin_unlock_irq(&dev->power.lock);
+		spin_unlock(&dev->power.lock);
 
-		pm_request_idle(parent);
+		spin_lock(&parent->power.lock);
+		rpm_idle(parent, RPM_ASYNC);
+		spin_unlock(&parent->power.lock);
 
-		spin_lock_irq(&dev->power.lock);
+		spin_lock(&dev->power.lock);
 	}
 
  out:


