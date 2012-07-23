Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2GWCJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:09:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53984 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877Ab2GWBmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:15 -0400
Message-Id: <20120723010651.806320180@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:06:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shaohua Li <shli@kernel.org>,
        Shaohua Li <shli@fusionio.com>, NeilBrown <neilb@suse.de>
Subject: [ 002/108] raid5: delayed stripe fix
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaohua Li <shli@kernel.org>

commit fab363b5ff502d1b39ddcfec04271f5858d9f26e upstream.

There isn't locking setting STRIPE_DELAYED and STRIPE_PREREAD_ACTIVE bits, but
the two bits have relationship. A delayed stripe can be moved to hold list only
when preread active stripe count is below IO_THRESHOLD. If a stripe has both
the bits set, such stripe will be in delayed list and preread count not 0,
which will make such stripe never leave delayed list.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid5.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 51169ec..7245a9d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -196,12 +196,14 @@ static void __release_stripe(struct r5conf *conf, struct stripe_head *sh)
 		BUG_ON(!list_empty(&sh->lru));
 		BUG_ON(atomic_read(&conf->active_stripes)==0);
 		if (test_bit(STRIPE_HANDLE, &sh->state)) {
-			if (test_bit(STRIPE_DELAYED, &sh->state))
+			if (test_bit(STRIPE_DELAYED, &sh->state) &&
+			    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				list_add_tail(&sh->lru, &conf->delayed_list);
 			else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
 				   sh->bm_seq - conf->seq_write > 0)
 				list_add_tail(&sh->lru, &conf->bitmap_list);
 			else {
+				clear_bit(STRIPE_DELAYED, &sh->state);
 				clear_bit(STRIPE_BIT_DELAY, &sh->state);
 				list_add_tail(&sh->lru, &conf->handle_list);
 			}


