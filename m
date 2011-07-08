Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1GIGBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:01:07 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:51660 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988Ab1GIGAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:00:55 -0400
X-Sasl-enc: jfEzZYCeJWGU+1CwWSzwau9dZ8ur426ZpFFFV5eoWHSN 1310191254
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 16:01:11 2011
Message-Id: <20110708230110.951393553@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 16:00:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [14/35] cfq-iosched: fix locking around ioc->ioc_data assignment
In-Reply-To: <20110708230122.GA18807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jens Axboe <jaxboe@fusionio.com>

commit ab4bd22d3cce6977dc039664cc2d052e3147d662 upstream.

Since we are modifying this RCU pointer, we need to hold
the lock protecting it around it.

This fixes a potential reuse and double free of a cfq
io_context structure. The bug has been in CFQ for a long
time, it hit very few people but those it did hit seemed
to see it a lot.

Tracked in RH bugzilla here:

https://bugzilla.redhat.com/show_bug.cgi?id=577968

Credit goes to Paul Bolle for figuring out that the issue
was around the one-hit ioc->ioc_data cache. Thanks to his
hard work the issue is now fixed.

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/cfq-iosched.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2537,8 +2537,11 @@ static void __cfq_exit_single_io_context
 	cic->dead_key = (unsigned long) cic->key;
 	cic->key = NULL;
 
-	if (ioc->ioc_data == cic)
+	if (rcu_dereference(ioc->ioc_data) == cic) {
+		spin_lock(&ioc->lock);
 		rcu_assign_pointer(ioc->ioc_data, NULL);
+		spin_unlock(&ioc->lock);
+	}
 
 	if (cic->cfqq[BLK_RW_ASYNC]) {
 		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);


