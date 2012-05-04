Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2EDUpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:45:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab2EDUpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:45:34 -0400
Message-Id: <20120504204227.041351032@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 31/75] USB: gadget: storage gadgets send wrong error code for unknown commands
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
CC: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/f_mass_storage.c |    2 +-
 drivers/usb/gadget/file_storage.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2190,7 +2190,7 @@ unknown_cmnd:
 		common->data_size_from_cmnd = 0;
 		sprintf(unknown, "Unknown x%02x", common->cmnd[0]);
 		reply = check_command(common, common->cmnd_size,
-				      DATA_DIR_UNKNOWN, 0xff, 0, unknown);
+				      DATA_DIR_UNKNOWN, ~0, 0, unknown);
 		if (reply == 0) {
 			common->curlun->sense_data = SS_INVALID_COMMAND;
 			reply = -EINVAL;
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -2579,7 +2579,7 @@ static int do_scsi_command(struct fsg_de
 		fsg->data_size_from_cmnd = 0;
 		sprintf(unknown, "Unknown x%02x", fsg->cmnd[0]);
 		if ((reply = check_command(fsg, fsg->cmnd_size,
-				DATA_DIR_UNKNOWN, 0xff, 0, unknown)) == 0) {
+				DATA_DIR_UNKNOWN, ~0, 0, unknown)) == 0) {
 			fsg->curlun->sense_data = SS_INVALID_COMMAND;
 			reply = -EINVAL;
 		}


