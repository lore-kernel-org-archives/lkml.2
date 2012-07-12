Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162143Ab2GLW7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:59:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162092Ab2GLWnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:43:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 133/187] dm persistent data: fix shadow_info_leak on dm_tm_destroy
Date: Thu, 12 Jul 2012 15:34:49 -0700
Message-Id: <20120712191534.720240901@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 25d7cd6faa7ae6ed2565617c3ee2500ccb8a9f7f upstream.

Cleanup the shadow table before destroying the transaction manager.

Reference: leak was identified with kmemleak when running
test_discard_random_sectors in the thinp-test-suite.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/persistent-data/dm-transaction-manager.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -138,6 +138,9 @@ EXPORT_SYMBOL_GPL(dm_tm_create_non_block
 
 void dm_tm_destroy(struct dm_transaction_manager *tm)
 {
+	if (!tm->is_clone)
+		wipe_shadow_table(tm);
+
 	kfree(tm);
 }
 EXPORT_SYMBOL_GPL(dm_tm_destroy);


