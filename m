Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162903Ab2GLXIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:08:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63192 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162802Ab2GLXGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:06:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shaohua Li <shli@fusionio.com>, NeilBrown <neilb@suse.de>
Subject: [ 56/68] raid5: delayed stripe fix
Date: Thu, 12 Jul 2012 16:02:30 -0700
Message-Id: <20120712175040.389702193@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -199,12 +199,14 @@ static void __release_stripe(raid5_conf_
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


