Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab2EIGLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:11:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39048 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756518Ab2EIFxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:31 -0400
Message-Id: <20120509055045.843180985@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Felipe Balbi <balbi@ti.com>, Michal Nazarewicz <mina86@mina86.com>
Subject: [ 117/167] [PATCH] USB: gadget: storage gadgets send wrong error code for
 unknown commands
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit c85dcdac5852295cf6822f5c4331a6ddab72581f upstream.

This patch (as1539) fixes a minor bug in the mass-storage gadget
drivers.  When an unknown command is received, the error code sent
back is "Invalid Field in CDB" rather than "Invalid Command".  This is
because the bitmask of CDB bytes allowed to be nonzero is incorrect.

When handling an unknown command, we don't care which command bytes
are nonzero.  All the bits in the mask should be set, not just eight
of them.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/f_mass_storage.c |    2 +-
 drivers/usb/gadget/file_storage.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index a371e96..cb8c162 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2189,7 +2189,7 @@ unknown_cmnd:
 		common->data_size_from_cmnd = 0;
 		sprintf(unknown, "Unknown x%02x", common->cmnd[0]);
 		reply = check_command(common, common->cmnd_size,
-				      DATA_DIR_UNKNOWN, 0xff, 0, unknown);
+				      DATA_DIR_UNKNOWN, ~0, 0, unknown);
 		if (reply == 0) {
 			common->curlun->sense_data = SS_INVALID_COMMAND;
 			reply = -EINVAL;
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 4fac569..a896d73 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -2579,7 +2579,7 @@ static int do_scsi_command(struct fsg_dev *fsg)
 		fsg->data_size_from_cmnd = 0;
 		sprintf(unknown, "Unknown x%02x", fsg->cmnd[0]);
 		if ((reply = check_command(fsg, fsg->cmnd_size,
-				DATA_DIR_UNKNOWN, 0xff, 0, unknown)) == 0) {
+				DATA_DIR_UNKNOWN, ~0, 0, unknown)) == 0) {
 			fsg->curlun->sense_data = SS_INVALID_COMMAND;
 			reply = -EINVAL;
 		}
-- 
1.7.10



