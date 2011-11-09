Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965986Ab1KJDtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:49:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45306 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966155Ab1KJDtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:49:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:08 2011
Message-Id: <20111109213208.240820913@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:35:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Williams <dan.j.williams@intel.com>,
        NeilBrown <neilb@suse.de>
Subject: [255/264] md/raid5: STRIPE_ACTIVE has lock semantics, add barriers
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 257a4b42af7586fab4eaec7f04e6896b86551843 upstream.

All updates that occur under STRIPE_ACTIVE should be globally visible
when STRIPE_ACTIVE clears.  test_and_set_bit() implies a barrier, but
clear_bit() does not.

This is suitable for 3.1-stable.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3116,7 +3116,7 @@ static void handle_stripe(struct stripe_
 	struct r5dev *pdev, *qdev;
 
 	clear_bit(STRIPE_HANDLE, &sh->state);
-	if (test_and_set_bit(STRIPE_ACTIVE, &sh->state)) {
+	if (test_and_set_bit_lock(STRIPE_ACTIVE, &sh->state)) {
 		/* already being handled, ensure it gets handled
 		 * again when current action finishes */
 		set_bit(STRIPE_HANDLE, &sh->state);
@@ -3381,7 +3381,7 @@ finish:
 
 	return_io(s.return_bi);
 
-	clear_bit(STRIPE_ACTIVE, &sh->state);
+	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
 }
 
 static void raid5_activate_delayed(raid5_conf_t *conf)


