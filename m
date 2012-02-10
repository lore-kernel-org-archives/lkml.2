Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730Ab2BJW4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:56:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963Ab2BJWpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:45:12 -0500
MIME-Version: 1.0
Message-Id: <20120210223444.130985164@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [patch 44/55] target: Correct sense key for INVALID FIELD IN {PARAMETER LIST,CDB}
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 9fbc8909876a2160044e71d376848973b9bfdc3f upstream.

According to SPC-4, the sense key for commands that are failed with
INVALID FIELD IN PARAMETER LIST and INVALID FIELD IN CDB should be
ILLEGAL REQUEST (5h) rather than ABORTED COMMAND (Bh).  Without this
patch, a tcm_loop LUN incorrectly gives:

    # sg_raw -r 1 -v /dev/sda 3 1 0 0 ff 0
    Sense Information:
     Fixed format, current;  Sense key: Aborted Command
     Additional sense: Invalid field in cdb
     Raw sense data (in hex):
            70 00 0b 00 00 00 00 0a  00 00 00 00 24 00 00 00
            00 00

While a real SCSI disk gives:

    Sense Information:
     Fixed format, current;  Sense key: Illegal Request
     Additional sense: Invalid field in cdb
     Raw sense data (in hex):
            70 00 05 00 00 00 00 18  00 00 00 00 24 00 00 00
            00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

with the main point being that the real disk gives a sense key of
ILLEGAL REQUEST (5h).

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5709,8 +5709,8 @@ int transport_send_check_condition_and_s
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
 		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ABORTED COMMAND */
-		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
+		/* ILLEGAL REQUEST */
+		buffer[offset+SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* INVALID FIELD IN CDB */
 		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x24;
 		break;
@@ -5718,8 +5718,8 @@ int transport_send_check_condition_and_s
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
 		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
-		/* ABORTED COMMAND */
-		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
+		/* ILLEGAL REQUEST */
+		buffer[offset+SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* INVALID FIELD IN PARAMETER LIST */
 		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x26;
 		break;


