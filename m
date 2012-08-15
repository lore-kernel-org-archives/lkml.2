Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab2HOUDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:03:21 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63120 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2HOTwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 138/165] usb-storage: Accept 8020i-protocol commands longer than 12 bytes
Date: Wed, 15 Aug 2012 15:48:02 -0400
Message-ID: <1345060109-9187-139-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/storage/protocol.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
index fc310f7..0fded39 100644
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
@@ -66,9 +68,6 @@ void usb_stor_pad12_command(struct scsi_cmnd *srb, struct us_data *us)
 	for (; srb->cmd_len<12; srb->cmd_len++)
 		srb->cmnd[srb->cmd_len] = 0;
 
-	/* set command length to 12 bytes */
-	srb->cmd_len = 12;
-
 	/* send the command to the transport layer */
 	usb_stor_invoke_transport(srb, us);
 }
-- 
1.7.12.rc2

