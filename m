Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab2L1TQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:16:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54831 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045Ab2L1TQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:40 -0500
Message-Id: <20121228190330.315115164@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [ 001/173] Revert "device_cgroup: fix RCU usage"
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit c5ee58688baa98bc3a4f6095a1acf6fd7fd9e967,
which was commit 201e72acb2d3821e2de9ce6091e98859c316b29a upstream.

Herton Ronaldo Krzesinski pointed out that the race condition this
dealt with does not exist in 3.2.y.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/device_cgroup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 92e24bb..4450fbe 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -202,8 +202,8 @@ static void devcgroup_destroy(struct cgroup_subsys *ss,
 
 	dev_cgroup = cgroup_to_devcgroup(cgroup);
 	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
-		list_del_rcu(&wh->list);
-		kfree_rcu(wh, rcu);
+		list_del(&wh->list);
+		kfree(wh);
 	}
 	kfree(dev_cgroup);
 }
@@ -278,7 +278,7 @@ static int may_access_whitelist(struct dev_cgroup *c,
 {
 	struct dev_whitelist_item *whitem;
 
-	list_for_each_entry_rcu(whitem, &c->whitelist, list) {
+	list_for_each_entry(whitem, &c->whitelist, list) {
 		if (whitem->type & DEV_ALL)
 			return 1;
 		if ((refwh->type & DEV_BLOCK) && !(whitem->type & DEV_BLOCK))


