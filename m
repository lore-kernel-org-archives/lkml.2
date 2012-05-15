Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965772Ab2EOCo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:44:29 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53462 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965238Ab2EOCRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 117/179] libata: fix unexpectedly frozen port after ata_eh_reset()
Date: Mon, 14 May 2012 22:13:33 -0400
Message-ID: <1337048075-6132-118-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/ata/libata-eh.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 1cf0bff..3704b2d 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2716,10 +2716,11 @@ int ata_eh_reset(struct ata_link *link, int classify,
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
@@ -2728,6 +2729,9 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	ap->pflags &= ~ATA_PFLAG_EH_PENDING;
 	spin_unlock_irqrestore(link->ap->lock, flags);
 
+	if (ap->pflags & ATA_PFLAG_FROZEN)
+		ata_eh_thaw_port(ap);
+
 	/*
 	 * Make sure onlineness and classification result correspond.
 	 * Hotplug could have happened during reset and some
-- 
1.7.9.6

