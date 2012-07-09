Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2GIOiC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:38:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38082 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753970Ab2GIOhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:55 -0400
Message-Id: <20120709143119.439549211@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 19/48] dm persistent data: fix shadow_info_leak on dm_tm_destroy
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 25d7cd6faa7ae6ed2565617c3ee2500ccb8a9f7f upstream.

Cleanup the shadow table before destroying the transaction manager.

Reference: leak was identified with kmemleak when running
test_discard_random_sectors in the thinp-test-suite.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/persistent-data/dm-transaction-manager.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
index 400fe14..02bf78e 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -138,6 +138,9 @@ EXPORT_SYMBOL_GPL(dm_tm_create_non_blocking_clone);
 
 void dm_tm_destroy(struct dm_transaction_manager *tm)
 {
+	if (!tm->is_clone)
+		wipe_shadow_table(tm);
+
 	kfree(tm);
 }
 EXPORT_SYMBOL_GPL(dm_tm_destroy);


