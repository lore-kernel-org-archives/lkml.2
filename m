Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab2KBRP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:15:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:33151 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762960Ab2KBRHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>,
        Andy Grover <agrover@redhat.com>
Subject: [ 07/11] target: Fix double-free of se_cmd in target_complete_tmr_failure
Date: Fri,  2 Nov 2012 10:06:42 -0700
Message-Id: <20121102170314.743885627@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170314.204845540@linuxfoundation.org>
References: <20121102170314.204845540@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit e13d5fef88c40b87c8430f8274c3a9ca32ef90bc upstream.

Fabric drivers currently expect to internally release se_cmd in the event
of a TMR failure during target_submit_tmr(), which means the immediate call
to transport_generic_free_cmd() after TFO->queue_tm_rsp() from within
target_complete_tmr_failure() workqueue context is wrong.

This is done as some fabrics expect TMR operations to be acknowledged
before releasing the descriptor, so the assumption that core is releasing
se_cmd associated TMR memory is incorrect.  This fixes a OOPs where
transport_generic_free_cmd() was being called more than once.

This bug was originally observed with tcm_qla2xxx fabric ports.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_transport.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1748,7 +1748,6 @@ static void target_complete_tmr_failure(
 
 	se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
 	se_cmd->se_tfo->queue_tm_rsp(se_cmd);
-	transport_generic_free_cmd(se_cmd, 0);
 }
 
 /**


