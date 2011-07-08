Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1GHFLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:11:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab1GHFEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:04:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:00 2011
Message-Id: <20110708001700.044146952@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shaohua Li <shaohua.li@intel.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: [075/107] cfq-iosched: fix a rcu warning
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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
@@ -2704,11 +2704,14 @@ static void __cfq_exit_single_io_context
 	smp_wmb();
 	cic->key = cfqd_dead_key(cfqd);
 
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


