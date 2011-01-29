Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1A2W2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 17:28:44 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23755 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab1A2W2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 17:28:44 -0500
Date: Sat, 29 Jan 2011 23:29:56 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: "Nicholas A. Bellinger" <nab@kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] SCSI, target: Don't leak memory in error path in
 pscsi_alloc_task()
Message-ID: <alpine.LNX.2.00.1101292326510.19392@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll leak the memory allocated via kzalloc() to 'pt' if the allocation of 
memory for 'pt->pscsi_cdb' fails in pscsi_alloc_task().
This patch fixes the leak by kfree()'ing the previously allocated memory 
in the error path.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 target_core_pscsi.c |    1 +
 1 file changed, 1 insertion(+)

  Compile tested only since I lack the hardware.

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 742d246..84561a0 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -815,6 +815,7 @@ pscsi_alloc_task(struct se_cmd *cmd)
 
 		pt->pscsi_cdb = kzalloc(scsi_command_size(cdb), GFP_KERNEL);
 		if (!(pt->pscsi_cdb)) {
+			kfree(pt);
 			printk(KERN_ERR "pSCSI: Unable to allocate extended"
 					" pt->pscsi_cdb\n");
 			return NULL;


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

