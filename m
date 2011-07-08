Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab1GIGIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:08:17 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:40836 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173Ab1GIGA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:00:56 -0400
X-Sasl-enc: NY8np8vJTPJqXxK6tOY4g9JzwBBow3GHAT7170dlHbD1 1310191256
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 16:01:11 2011
Message-Id: <20110708230111.047815903@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 16:00:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shaohua Li <shaohua.li@intel.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: [15/35] cfq-iosched: fix a rcu warning
In-Reply-To: <20110708230122.GA18807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 3181faa85bda3dc3f5e630a1846526c9caaa38e3 upstream.

I got a rcu warnning at boot. the ioc->ioc_data is rcu_deferenced, but
doesn't hold rcu_read_lock.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/cfq-iosched.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2537,11 +2537,14 @@ static void __cfq_exit_single_io_context
 	cic->dead_key = (unsigned long) cic->key;
 	cic->key = NULL;
 
+	rcu_read_lock();
 	if (rcu_dereference(ioc->ioc_data) == cic) {
+		rcu_read_unlock();
 		spin_lock(&ioc->lock);
 		rcu_assign_pointer(ioc->ioc_data, NULL);
 		spin_unlock(&ioc->lock);
-	}
+	} else
+		rcu_read_unlock();
 
 	if (cic->cfqq[BLK_RW_ASYNC]) {
 		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);


