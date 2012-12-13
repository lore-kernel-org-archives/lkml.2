Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab2LMOUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:20:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45098 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933279Ab2LMOOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:14:31 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Szymon Janc <szymon.janc@tieto.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 222/241] NFC: pn533: Fix use after free
Date: Thu, 13 Dec 2012 11:59:47 -0200
Message-Id: <1355407206-17100-223-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Szymon Janc <szymon.janc@tieto.com>

commit 770f750bc2b8312489c8e45306f551d08a319d3c upstream.

cmd was freed in pn533_dep_link_up regardless of
pn533_send_cmd_frame_async return code. Cmd is passed as argument to
pn533_in_dep_link_up_complete callback and should be freed there.

Signed-off-by: Szymon Janc <szymon.janc@tieto.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/nfc/pn533.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 19110f0..3811d60 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1395,12 +1395,8 @@ static int pn533_dep_link_up(struct nfc_dev *nfc_dev, struct nfc_target *target,
 	rc = pn533_send_cmd_frame_async(dev, dev->out_frame, dev->in_frame,
 				dev->in_maxlen,	pn533_in_dep_link_up_complete,
 				cmd, GFP_KERNEL);
-	if (rc)
-		goto out;
-
-
-out:
-	kfree(cmd);
+	if (rc < 0)
+		kfree(cmd);
 
 	return rc;
 }
-- 
1.7.9.5

