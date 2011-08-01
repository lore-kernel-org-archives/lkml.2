Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab1HAXcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:32:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab1HAX07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:26:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:56 2011
Message-Id: <20110801232056.244470337@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Dave Howorth <dhoworth@mrc-lmb.cam.ac.uk>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: [56/70] libata: fix unexpectedly frozen port after ata_eh_reset()
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 8c56cacc724c7650b893d43068fa66044aa29a61 upstream.

To work around controllers which can't properly plug events while
reset, ata_eh_reset() clears error states and ATA_PFLAG_EH_PENDING
after reset but before RESET is marked done.  As reset is the final
recovery action and full verification of devices including onlineness
and classfication match is done afterwards, this shouldn't lead to
lost devices or missed hotplug events.

Unfortunately, it forgot to thaw the port when clearing EH_PENDING, so
if the condition happens after resetting an empty port, the port could
be left frozen and EH will end without thawing it, making the port
unresponsive to further hotplug events.

Thaw if the port is frozen after clearing EH_PENDING.  This problem is
reported by Bruce Stenning in the following thread.

 http://thread.gmane.org/gmane.linux.kernel/1123265

stable: I think we should weather this patch a bit longer in -rcX
	before sending it to -stable.  Please wait at least a month
	after this patch makes upstream.  Thanks.

-v2: Fixed spelling in the comment per Dave Howorth.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Bruce Stenning <b.stenning@indigovision.com>
Cc: Dave Howorth <dhoworth@mrc-lmb.cam.ac.uk>
Signed-off-by: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2802,10 +2802,11 @@ int ata_eh_reset(struct ata_link *link,
 	}
 
 	/*
-	 * Some controllers can't be frozen very well and may set
-	 * spuruious error conditions during reset.  Clear accumulated
-	 * error information.  As reset is the final recovery action,
-	 * nothing is lost by doing this.
+	 * Some controllers can't be frozen very well and may set spurious
+	 * error conditions during reset.  Clear accumulated error
+	 * information and re-thaw the port if frozen.  As reset is the
+	 * final recovery action and we cross check link onlineness against
+	 * device classification later, no hotplug event is lost by this.
 	 */
 	spin_lock_irqsave(link->ap->lock, flags);
 	memset(&link->eh_info, 0, sizeof(link->eh_info));
@@ -2814,6 +2815,9 @@ int ata_eh_reset(struct ata_link *link,
 	ap->pflags &= ~ATA_PFLAG_EH_PENDING;
 	spin_unlock_irqrestore(link->ap->lock, flags);
 
+	if (ap->pflags & ATA_PFLAG_FROZEN)
+		ata_eh_thaw_port(ap);
+
 	/*
 	 * Make sure onlineness and classification result correspond.
 	 * Hotplug could have happened during reset and some


