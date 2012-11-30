Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421Ab2K3S7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:59:34 -0500
Received: from mail.kernel.org ([198.145.19.201]:58754 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758848Ab2K3S5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:57:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Szymon Janc <szymon.janc@tieto.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>
Subject: [ 45/56] NFC: pn533: Fix use after free
Date: Fri, 30 Nov 2012 10:55:37 -0800
Message-Id: <20121130185122.956146382@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Szymon Janc <szymon.janc@tieto.com>

commit 770f750bc2b8312489c8e45306f551d08a319d3c upstream.

cmd was freed in pn533_dep_link_up regardless of
pn533_send_cmd_frame_async return code. Cmd is passed as argument to
pn533_in_dep_link_up_complete callback and should be freed there.

Signed-off-by: Szymon Janc <szymon.janc@tieto.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nfc/pn533.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1385,12 +1385,8 @@ static int pn533_dep_link_up(struct nfc_
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


