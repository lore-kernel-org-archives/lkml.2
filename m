Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241Ab2DKUli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:41:38 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16761 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab2DKUlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:41:37 -0400
Date: Wed, 11 Apr 2012 22:41:36 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-wireless@vger.kernel.org
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Love <rlove@google.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH] ath6kl: fix memory leak in ath6kl_fwlog_block_read()
Message-ID: <alpine.LNX.2.00.1204112239070.2137@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If, in
drivers/net/wireless/ath/ath6kl/debug.c::ath6kl_fwlog_block_read(),
the call to wait_for_completion_interruptible() returns -ERESTARTSYS
then we'll return without freeing the (as yet unused) memory we
allocated for 'buf' - thus leaking it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/wireless/ath/ath6kl/debug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index d01403a..34eb927 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -401,8 +401,10 @@ static ssize_t ath6kl_fwlog_block_read(struct file *file,
 
 		ret = wait_for_completion_interruptible(
 			&ar->debug.fwlog_completion);
-		if (ret == -ERESTARTSYS)
+		if (ret == -ERESTARTSYS) {
+			vfree(buf);
 			return ret;
+		}
 
 		spin_lock(&ar->debug.fwlog_queue.lock);
 	}
-- 
1.7.10


PS. Please CC me on replies.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

