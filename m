Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab1F0WFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:05:14 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26646 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1F0WDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:03:54 -0400
Date: Mon, 27 Jun 2011 23:54:48 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
cc: James Bottomley <jbottomley@parallels.com>,
        Dan Carpenter <error27@gmail.com>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][Resend] SCSI, target, loopback: Fix memory leak in
 tcm_loop_make_scsi_hba()
Message-ID: <alpine.LNX.2.00.1106272351520.30245@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a memory leak in tcm_loop_make_scsi_hba().

If all the strstr() calls return NULL and we end up at
 return ERR_PTR(-EINVAL);
then we'll be leaking the memory previously allocated to tl_hba as
that variable goes out of scope.

This patch should fix the leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/target/loopback/tcm_loop.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

  Compile tested only.
  Last submitted April 07, 2011

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 70c2e7f..aa3bb70 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1321,7 +1321,8 @@ struct se_wwn *tcm_loop_make_scsi_hba(
 
 	printk(KERN_ERR "Unable to locate prefix for emulated Target Port:"
 			" %s\n", name);
-	return ERR_PTR(-EINVAL);
+	ret = -EINVAL;
+	goto out;
 
 check_len:
 	if (strlen(name) >= TL_WWN_ADDR_LEN) {
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

