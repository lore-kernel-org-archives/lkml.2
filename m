Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab0EJXEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:04:54 -0400
Received: from kroah.org ([198.145.64.141]:45394 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932944Ab0EJW6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:34 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:42 2010
Message-Id: <20100510223542.044835782@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Gabriele A. Trombetti" <g.trombetti.lkrnl1213@logicschema.com>,
       NeilBrown <neilb@suse.de>
Subject: [85/98] md/raid6: Fix raid-6 read-error correction in degraded state
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gabriele A. Trombetti <g.trombetti.lkrnl1213@logicschema.com>

commit 87aa63000c484bfb9909989316f615240dfee018 upstream.

Fix: Raid-6 was not trying to correct a read-error when in
singly-degraded state and was instead dropping one more device, going to
doubly-degraded state. This patch fixes this behaviour.

Tested-by: Janos Haar <janos.haar@netcenter.hu>
Signed-off-by: Gabriele A. Trombetti <g.trombetti.lkrnl1213@logicschema.com>
Reported-by: Janos Haar <janos.haar@netcenter.hu>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1526,7 +1526,7 @@ static void raid5_end_read_request(struc
 
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		atomic_inc(&rdev->read_errors);
-		if (conf->mddev->degraded)
+		if (conf->mddev->degraded >= conf->max_degraded)
 			printk_rl(KERN_WARNING
 				  "raid5:%s: read error not correctable "
 				  "(sector %llu on %s).\n",


