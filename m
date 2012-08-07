Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab2HGXpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:45:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab2HGW1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:27:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 001/122] target: Add generation of LOGICAL BLOCK ADDRESS OUT OF RANGE
Date: Tue,  7 Aug 2012 15:24:49 -0700
Message-Id: <20120807221948.359768857@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit e2397c704429025bc6b331a970f699e52f34283e upstream.

Many SCSI commands are defined to return a CHECK CONDITION / ILLEGAL
REQUEST with ASC set to LOGICAL BLOCK ADDRESS OUT OF RANGE if the
initiator sends a command that accesses a too-big LBA.  Add an enum
value and case entries so that target code can return this status.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |   10 ++++++++++
 include/target/target_core_base.h      |    1 +
 2 files changed, 11 insertions(+)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1797,6 +1797,7 @@ void transport_generic_request_failure(s
 	case TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE:
 	case TCM_UNKNOWN_MODE_PAGE:
 	case TCM_WRITE_PROTECTED:
+	case TCM_ADDRESS_OUT_OF_RANGE:
 	case TCM_CHECK_CONDITION_ABORT_CMD:
 	case TCM_CHECK_CONDITION_UNIT_ATTENTION:
 	case TCM_CHECK_CONDITION_NOT_READY:
@@ -4212,6 +4213,15 @@ int transport_send_check_condition_and_s
 		/* WRITE PROTECTED */
 		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x27;
 		break;
+	case TCM_ADDRESS_OUT_OF_RANGE:
+		/* CURRENT ERROR */
+		buffer[offset] = 0x70;
+		buffer[offset+SPC_ADD_SENSE_LEN_OFFSET] = 10;
+		/* ILLEGAL REQUEST */
+		buffer[offset+SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
+		/* LOGICAL BLOCK ADDRESS OUT OF RANGE */
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x21;
+		break;
 	case TCM_CHECK_CONDITION_UNIT_ATTENTION:
 		/* CURRENT ERROR */
 		buffer[offset] = 0x70;
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -220,6 +220,7 @@ enum tcm_sense_reason_table {
 	TCM_CHECK_CONDITION_UNIT_ATTENTION	= 0x0e,
 	TCM_CHECK_CONDITION_NOT_READY		= 0x0f,
 	TCM_RESERVATION_CONFLICT		= 0x10,
+	TCM_ADDRESS_OUT_OF_RANGE		= 0x11,
 };
 
 enum target_sc_flags_table {


