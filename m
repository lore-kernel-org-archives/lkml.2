Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab0EJRVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:21:47 -0400
Received: from iona.labri.fr ([147.210.8.143]:34297 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab0EJRVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:21:23 -0400
X-Greylist: delayed 1563 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 May 2010 13:21:23 EDT
Message-ID: <4BE83A75.7050003@inria.fr>
Date: Mon, 10 May 2010 18:55:17 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: Nadia Derbey <Nadia.Derbey@bull.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Jim Houston <jim.houston@comcast.net>
Subject: [PATCH] idr: document that idr_for_each may be used under rcu_read_lock()
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nadia,

In commit f9c46d6ea5ce138a886c3a0f10a46130afab75f5, you converted
idr_find() and idr_for_each() to rcu_dereference(). The documentation
of idr_find() was updated to say that it may now be called under
rcu_read_lock(). But the doc of idr_for_each() still says:
"The caller must serialize idr_for_each() vs idr_get_new() and
idr_remove()."

I might be missing something, but assuming idr_for_each() may also be
called under rcu_read_lock(), we need something like the patch below,
right? (I just duplicated the doc update of idr_find())

thanks,
Brice


>From 35a05eba9cc16d7fe786a9a7ff17f88fcf8b06e2 Mon Sep 17 00:00:00 2001
From: Brice Goglin <Brice.Goglin@inria.fr>
Date: Mon, 10 May 2010 18:49:51 +0200
Subject: [PATCH] idr: document that idr_for_each may be used under rcu_read_lock()

Since commit f9c46d6ea5ce138a886c3a0f10a46130afab75f5, idr_for_each()
may be called under rcu_read_lock(). It does not need serialization
against idr_get_new() and idr_remove() anymore.

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
---
 lib/idr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 2eb1dca..7eb435d 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -541,7 +541,8 @@ EXPORT_SYMBOL(idr_find);
  * We check the return of @fn each time. If it returns anything other
  * than 0, we break out and return that value.
  *
- * The caller must serialize idr_for_each() vs idr_get_new() and idr_remove().
+ * This function can be called under rcu_read_lock(), given that the leaf
+ * pointers lifetimes are correctly managed.
  */
 int idr_for_each(struct idr *idp,
 		 int (*fn)(int id, void *p, void *data), void *data)
-- 
1.7.1



