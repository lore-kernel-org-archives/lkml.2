Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab1KWAnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:43:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759531Ab1KWAnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:43:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:08 2011
Message-Id: <20111123002408.262876654@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: [39/53] usb-storage: Accept 8020i-protocol commands longer than 12 bytes
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 2f640bf4c94324aeaa1b6385c10aab8c5ad1e1cf upstream.

The 8020i protocol (also 8070i and QIC-157) uses 12-byte commands;
shorter commands must be padded.  Simon Detheridge reports that his
3-TB USB disk drive claims to use the 8020i protocol (which is
normally meant for ATAPI devices like CD drives), and because of its
large size, the disk drive requires the use of 16-byte commands.
However the usb_stor_pad12_command() routine in usb-storage always
sets the command length to 12, making the drive impossible to use.

Since the SFF-8020i specification allows for 16-byte commands in
future extensions, we may as well accept them.  This patch (as1490)
changes usb_stor_pad12_command() to leave commands larger than 12
bytes alone rather than truncating them.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Simon Detheridge <simon@widgit.com>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/protocol.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/usb/storage/protocol.c
+++ b/drivers/usb/storage/protocol.c
@@ -58,7 +58,9 @@
 
 void usb_stor_pad12_command(struct scsi_cmnd *srb, struct us_data *us)
 {
-	/* Pad the SCSI command with zeros out to 12 bytes
+	/*
+	 * Pad the SCSI command with zeros out to 12 bytes.  If the
+	 * command already is 12 bytes or longer, leave it alone.
 	 *
 	 * NOTE: This only works because a scsi_cmnd struct field contains
 	 * a unsigned char cmnd[16], so we know we have storage available
@@ -66,9 +68,6 @@ void usb_stor_pad12_command(struct scsi_
 	for (; srb->cmd_len<12; srb->cmd_len++)
 		srb->cmnd[srb->cmd_len] = 0;
 
-	/* set command length to 12 bytes */
-	srb->cmd_len = 12;
-
 	/* send the command to the transport layer */
 	usb_stor_invoke_transport(srb, us);
 }


