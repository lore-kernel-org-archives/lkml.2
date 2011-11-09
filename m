Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964977Ab1KJEgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:36:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964913Ab1KJDgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:36:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:46 2011
Message-Id: <20111109213146.245219838@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@risingtidesystems.com>
Subject: [041/264] target: Prevent TRANSPORT_FREE_CMD_INTR processing in core_tmr_drain_cmd_list
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit b0e062aec578c756d1aea4b5809294488366a6e8 upstream.

This patch contains a bugfix for TMR LUN_RESET related to TRANSPORT_FREE_CMD_INTR
operation, where core_tmr_drain_cmd_list() will now skip processing for this
case to prevent an ABORT_TASK status from being returned for descriptors that
are already queued up to be released by processing thread context.

Cc: Roland Dreier <roland@purestorage.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@risingtidesystems.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_tmr.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -337,6 +337,16 @@ int core_tmr_lun_reset(
 		 */
 		if (prout_cmd == cmd)
 			continue;
+		/*
+		 * Skip direct processing of TRANSPORT_FREE_CMD_INTR for
+		 * HW target mode fabrics.
+		 */
+		spin_lock(&cmd->t_state_lock);
+		if (cmd->t_state == TRANSPORT_FREE_CMD_INTR) {
+			spin_unlock(&cmd->t_state_lock);
+			continue;
+		}
+		spin_unlock(&cmd->t_state_lock);
 
 		atomic_dec(&cmd->t_transport_queue_active);
 		atomic_dec(&qobj->queue_cnt);


