Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1HDWGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:06:36 -0400
Received: from www17.your-server.de ([213.133.104.17]:45246 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab1HDWGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:06:30 -0400
Subject: [PATCH] GFP_KERNEL malloc with lock held in net/wireless/mwifiex
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Date: Fri, 05 Aug 2011 00:05:58 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312495562.2629.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Find functions that refer to GFP_KERNEL but are called with locks held.
 The proposed change of converting the GFP_KERNEL is not necessarily the
 correct one.  It may be desired to unlock the lock, or to not call the
 function under the lock in the first place.

 The semantic patch that makes this output is available
 in scripts/coccinelle/locks/call_kern.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
the function mwifiex_save_curr_bcn() is guarded by:

 spin_lock_irqsave(&priv->curr_bcn_buf_lock, flags);
 mwifiex_save_curr_bcn(priv);
 spin_unlock_irqrestore(&priv->curr_bcn_buf_lock, flags);

Is it okay to allocate memory with a spin lock held and interrupts
disabled in this case?

diff -u -p a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
--- a/drivers/net/wireless/mwifiex/scan.c 2011-07-26 00:46:08.483511656 +0200
+++ b/drivers/net/wireless/mwifiex/scan.c 2011-08-02 09:36:50.174808818 +0200
@@ -2998,7 +2998,7 @@ mwifiex_save_curr_bcn(struct mwifiex_pri
 
 		kfree(priv->curr_bcn_buf);
 		priv->curr_bcn_buf = kzalloc(curr_bss->beacon_buf_size,
-						GFP_KERNEL);
+						GFP_ATOMIC);
 		if (!priv->curr_bcn_buf) {
 			dev_err(priv->adapter->dev,
 					"failed to alloc curr_bcn_buf\n");


