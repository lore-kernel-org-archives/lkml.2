Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab2GaE5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:57:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48789 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755640Ab2GaEu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:56 -0400
Message-Id: <20120731044318.065577604@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 42/73] target: Add generation of LOGICAL BLOCK ADDRESS OUT OF RANGE
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit e2397c704429025bc6b331a970f699e52f34283e upstream.

Many SCSI commands are defined to return a CHECK CONDITION / ILLEGAL
REQUEST with ASC set to LOGICAL BLOCK ADDRESS OUT OF RANGE if the
initiator sends a command that accesses a too-big LBA.  Add an enum
value and case entries so that target code can return this status.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_transport.c |   10 ++++++++++
 include/target/target_core_base.h      |    1 +
 2 files changed, 11 insertions(+)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1820,6 +1820,7 @@ static void transport_generic_request_fa
 	case TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE:
 	case TCM_UNKNOWN_MODE_PAGE:
 	case TCM_WRITE_PROTECTED:
+	case TCM_ADDRESS_OUT_OF_RANGE:
 	case TCM_CHECK_CONDITION_ABORT_CMD:
 	case TCM_CHECK_CONDITION_UNIT_ATTENTION:
 	case TCM_CHECK_CONDITION_NOT_READY:
@@ -4496,6 +4497,15 @@ int transport_send_check_condition_and_s
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
@@ -157,6 +157,7 @@ enum tcm_sense_reason_table {
 	TCM_CHECK_CONDITION_UNIT_ATTENTION	= 0x0e,
 	TCM_CHECK_CONDITION_NOT_READY		= 0x0f,
 	TCM_RESERVATION_CONFLICT		= 0x10,
+	TCM_ADDRESS_OUT_OF_RANGE		= 0x11,
 };
 
 struct se_obj {


