Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab2GZVWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:22:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2GZVWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:22:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 19/23] dm thin: do not send discards to shared blocks
Date: Thu, 26 Jul 2012 14:19:58 -0700
Message-Id: <20120726211407.616176925@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211405.959857593@linuxfoundation.org>
References: <20120726211420.GA7678@kroah.com>
 <20120726211405.959857593@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 650d2a06b4fe1cc1d218c20e256650f68bf0ca31 upstream.

When process_discard receives a partial discard that doesn't cover a
full block, it sends this discard down to that block. Unfortunately, the
block can be shared and the discard would corrupt the other snapshots
sharing this block.

This patch detects block sharing and ends the discard with success when
sending it to the shared block.

The above change means that if the device supports discard it can't be
guaranteed that a discard request zeroes data. Therefore, we set
ti->discard_zeroes_data_unsupported.

Thin target discard support with this bug arrived in commit
104655fd4dcebd50068ef30253a001da72e3a081 (dm thin: support discards).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1240,7 +1240,10 @@ static void process_discard(struct thin_
 
 			cell_release_singleton(cell, bio);
 			cell_release_singleton(cell2, bio);
-			remap_and_issue(tc, bio, lookup_result.block);
+			if ((!lookup_result.shared) && pool->pf.discard_passdown)
+				remap_and_issue(tc, bio, lookup_result.block);
+			else
+				bio_endio(bio, 0);
 		}
 		break;
 
@@ -2575,6 +2578,7 @@ static int thin_ctr(struct dm_target *ti
 	if (tc->pool->pf.discard_enabled) {
 		ti->discards_supported = 1;
 		ti->num_discard_requests = 1;
+		ti->discard_zeroes_data_unsupported = 1;
 	}
 
 	dm_put(pool_md);


