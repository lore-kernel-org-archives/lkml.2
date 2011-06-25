Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1FYVZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 17:25:21 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18383 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab1FYVZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 17:25:19 -0400
Date: Sat, 25 Jun 2011 23:16:19 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-scsi@vger.kernel.org
cc: linux-kernel@vger.kernel.org, aacraid@adaptec.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH][RESEND 3rd time] SCSI, aacraid: Remove mem leak in
 aac_send_raw_srb()
Message-ID: <alpine.LNX.2.00.1106252312000.23991@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We leak in drivers/scsi/aacraid/commctrl.c::aac_send_raw_srb() :

We allocate memory:
        ...
                        struct user_sgmap* usg;
                        usg = kmalloc(actual_fibsize - sizeof(struct aac_srb)
                          + sizeof(struct sgmap), GFP_KERNEL);
and then neglect to free it:
        ...
                        for (i = 0; i < usg->count; i++) {
                                u64 addr;
                                void* p;
                                if (usg->sg[i].count >
                                    ((dev->adapter_info.options &
                                     AAC_OPT_NEW_COMM) ?
                                      (dev->scsi_host_ptr->max_sectors << 9) :
                                      65536)) {
                                        rcode = -EINVAL;
                                        goto cleanup;
        ... this 'goto' makes 'usg' go out of scope and leak the memory we
            allocated.
            Other exits properly kfree(usg), it's just here it is neglected.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/aacraid/commctrl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 8a0b330..0bd38da 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -650,6 +650,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
 				      65536)) {
+					kfree(usg);
 					rcode = -EINVAL;
 					goto cleanup;
 				}
-- 
1.7.5.2

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

