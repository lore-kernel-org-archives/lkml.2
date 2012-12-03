Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab2LCO4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:56:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43582 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932109Ab2LCOfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:48 -0500
Message-Id: <20121203143147.609467839@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:31:52 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Aristeu Rozanski <aris@redhat.com>, Li Zefan <lizefan@huawei.com>
Subject: [ 06/89] device_cgroup: fix RCU usage
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 201e72acb2d3821e2de9ce6091e98859c316b29a upstream.

dev_cgroup->exceptions is protected with devcgroup_mutex for writes
and RCU for reads; however, RCU usage isn't correct.

* dev_exception_clean() doesn't use RCU variant of list_del() and
  kfree().  The function can race with may_access() and may_access()
  may end up dereferencing already freed memory.  Use list_del_rcu()
  and kfree_rcu() instead.

* may_access() may be called only with RCU read locked but doesn't use
  RCU safe traversal over ->exceptions.  Use list_for_each_entry_rcu().

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Exception list is called whitelist]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/device_cgroup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -202,8 +202,8 @@ static void devcgroup_destroy(struct cgr
 
 	dev_cgroup = cgroup_to_devcgroup(cgroup);
 	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
-		list_del(&wh->list);
-		kfree(wh);
+		list_del_rcu(&wh->list);
+		kfree_rcu(wh, rcu);
 	}
 	kfree(dev_cgroup);
 }
@@ -278,7 +278,7 @@ static int may_access_whitelist(struct d
 {
 	struct dev_whitelist_item *whitem;
 
-	list_for_each_entry(whitem, &c->whitelist, list) {
+	list_for_each_entry_rcu(whitem, &c->whitelist, list) {
 		if (whitem->type & DEV_ALL)
 			return 1;
 		if ((refwh->type & DEV_BLOCK) && !(whitem->type & DEV_BLOCK))


