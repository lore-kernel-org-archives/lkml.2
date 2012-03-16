Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946413Ab2CPXms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:42:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45118 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946473Ab2CPXlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:41:35 -0400
Message-Id: <20120316233814.097132945@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Martin Svec <martin.svec@zoner.cz>,
        Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 39/41] iscsi-target: Fix reservation conflict -EBUSY response handling bug
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 00fdc6bbef77844ce397a7de7acfaf25e8e2e4eb upstream.

This patch addresses a iscsi-target specific bug related to reservation conflict
handling in iscsit_handle_scsi_cmd() that has been causing reservation conflicts
to complete and not fail as expected due to incorrect errno checking.  The problem
occured with the change to return -EBUSY from transport_generic_cmd_sequencer() ->
transport_generic_allocate_tasks() failures, that broke iscsit_handle_scsi_cmd()
checking for -EINVAL in order to invoke a non GOOD status response.

This was manifesting itself as data corruption with legacy SPC-2 reservations,
but also effects iscsi-target LUNs with SPC-3 persistent reservations.

This bug was originally introduced in lio-core commit:

commit 03e98c9eb916f3f0868c1dc344dde2a60287ff72
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Fri Nov 4 02:36:16 2011 -0700

    target: Address legacy PYX_TRANSPORT_* return code breakage

Reported-by: Martin Svec <martin.svec@zoner.cz>
Cc: Martin Svec <martin.svec@zoner.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1029,7 +1029,7 @@ done:
 		return iscsit_add_reject_from_cmd(
 				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
 				1, 1, buf, cmd);
-	} else if (transport_ret == -EINVAL) {
+	} else if (transport_ret < 0) {
 		/*
 		 * Unsupported SAM Opcode.  CHECK_CONDITION will be sent
 		 * in iscsit_execute_cmd() during the CmdSN OOO Execution


