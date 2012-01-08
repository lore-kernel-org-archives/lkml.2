Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab2AHVo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 16:44:26 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:53812 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab2AHVoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 16:44:25 -0500
Date: Sun, 8 Jan 2012 22:44:19 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: [PATCH] drivers/scsi/aacraid/commctrl.c: fix mem leak in
 aac_send_raw_srb()
In-Reply-To: <alpine.LNX.2.00.1201082228280.24030@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1201082239480.24030@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201082028140.24030@swampdragon.chaosbits.net> <CA+55aFwO9Wtq=NEpMskW-2wrWZAGh-C6VBXENA3LtFOk=tUwgQ@mail.gmail.com> <alpine.LNX.2.00.1201082228280.24030@swampdragon.chaosbits.net>
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
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
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
1.7.8.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

