Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab2AXCtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:49:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932960Ab2AXCtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:49:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:33 2012
Message-Id: <20120124023933.465611947@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [107/129] target: Set additional sense length field in sense data
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 6135
Lines: 168

From: Roland Dreier <roland@purestorage.com>

commit 895f3022523361e9b383cf48f51feb1f7d5e7e53 upstream.

The target code was not setting the additional sense length field in the
sense data it returned, which meant that at least the Linux stack
ignored the ASC/ASCQ fields.  For example, without this patch, on a
tcm_loop device:

    # sg_raw -v /dev/sda 2 0 0 0 0 0

gives

        cdb to send: 02 00 00 00 00 00
    SCSI Status: Check Condition

    Sense Information:
     Fixed format, current;  Sense key: Illegal Request
      Raw sense data (in hex):
            70 00 05 00 00 00 00 00

while after the patch we correctly get the following (which matches what
a regular disk returns):

        cdb to send: 02 00 00 00 00 00
    SCSI Status: Check Condition

    Sense Information:
     Fixed format, current;  Sense key: Illegal Request
     Additional sense: Invalid command operation code
     Raw sense data (in hex):
            70 00 05 00 00 00 00 0a  00 00 00 00 20 00 00 00
            00 00

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_transport.c |   14 ++++++++++++++
 include/target/target_core_base.h      |    1 +
 2 files changed, 15 insertions(+)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4353,6 +4353,7 @@ int transport_send_check_condition_and_s
 	case TCM_NON_EXISTENT_LUN:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* ILLEGAL REQUEST */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* LOGICAL UNIT NOT SUPPORTED */
@@ -4362,6 +4363,7 @@ int transport_send_check_condition_and_s
 	case TCM_SECTOR_COUNT_TOO_MANY:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* ILLEGAL REQUEST */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* INVALID COMMAND OPERATION CODE */
@@ -4370,6 +4372,7 @@ int transport_send_check_condition_and_s
 	case TCM_UNKNOWN_MODE_PAGE:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* ILLEGAL REQUEST */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* INVALID FIELD IN CDB */
@@ -4378,6 +4381,7 @@ int transport_send_check_condition_and_s
 	case TCM_CHECK_CONDITION_ABORT_CMD:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* ABORTED COMMAND */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
 		/* BUS DEVICE RESET FUNCTION OCCURRED */
@@ -4387,6 +4391,7 @@ int transport_send_check_condition_and_s
 	case TCM_INCORRECT_AMOUNT_OF_DATA:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* ABORTED COMMAND */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
 		/* WRITE ERROR */
@@ -4397,6 +4402,7 @@ int transport_send_check_condition_and_s
 	case TCM_INVALID_CDB_FIELD:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* ABORTED COMMAND */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
 		/* INVALID FIELD IN CDB */
@@ -4405,6 +4411,7 @@ int transport_send_check_condition_and_s
 	case TCM_INVALID_PARAMETER_LIST:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* ABORTED COMMAND */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
 		/* INVALID FIELD IN PARAMETER LIST */
@@ -4413,6 +4420,7 @@ int transport_send_check_condition_and_s
 	case TCM_UNEXPECTED_UNSOLICITED_DATA:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* ABORTED COMMAND */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
 		/* WRITE ERROR */
@@ -4423,6 +4431,7 @@ int transport_send_check_condition_and_s
 	case TCM_SERVICE_CRC_ERROR:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* ABORTED COMMAND */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
 		/* PROTOCOL SERVICE CRC ERROR */
@@ -4433,6 +4442,7 @@ int transport_send_check_condition_and_s
 	case TCM_SNACK_REJECTED:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* ABORTED COMMAND */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ABORTED_COMMAND;
 		/* READ ERROR */
@@ -4443,6 +4453,7 @@ int transport_send_check_condition_and_s
 	case TCM_WRITE_PROTECTED:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* DATA PROTECT */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = DATA_PROTECT;
 		/* WRITE PROTECTED */
@@ -4451,6 +4462,7 @@ int transport_send_check_condition_and_s
 	case TCM_CHECK_CONDITION_UNIT_ATTENTION:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* UNIT ATTENTION */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = UNIT_ATTENTION;
 		core_scsi3_ua_for_check_condition(cmd, &asc, &ascq);
@@ -4460,6 +4472,7 @@ int transport_send_check_condition_and_s
 	case TCM_CHECK_CONDITION_NOT_READY:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* Not Ready */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = NOT_READY;
 		transport_get_sense_codes(cmd, &asc, &ascq);
@@ -4470,6 +4483,7 @@ int transport_send_check_condition_and_s
 	default:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
 		/* ILLEGAL REQUEST */
 		buffer[offset+SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
 		/* LOGICAL UNIT COMMUNICATION FAILURE */
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -34,6 +34,7 @@
 #define TRANSPORT_SENSE_BUFFER			SCSI_SENSE_BUFFERSIZE
 /* Used by transport_send_check_condition_and_sense() */
 #define SPC_SENSE_KEY_OFFSET			2
+#define SPC_ADD_SENSE_LEN_OFFSET		7
 #define SPC_ASC_KEY_OFFSET			12
 #define SPC_ASCQ_KEY_OFFSET			13
 #define TRANSPORT_IQN_LEN			224


