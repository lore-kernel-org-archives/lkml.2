Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab2KVV2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:28:14 -0500
Received: from mail.kernel.org ([198.145.19.201]:49635 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab2KVSkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 158/171] libceph: avoid dropping con mutex before fault
Date: Wed, 21 Nov 2012 16:41:44 -0800
Message-Id: <20121122004049.212668349@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

(cherry picked from commit 8636ea672f0c5ab7478c42c5b6705ebd1db7eb6a)

The ceph_fault() function takes the con mutex, so we should avoid
dropping it before calling it.  This fixes a potential race with
another thread calling ceph_con_close(), or _open(), or similar (we
don't reverify con->state after retaking the lock).

Add annotation so that lockdep realizes we will drop the mutex before
returning.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2336,7 +2336,6 @@ done_unlocked:
 	return;
 
 fault:
-	mutex_unlock(&con->mutex);
 	ceph_fault(con);     /* error/fault path */
 	goto done_unlocked;
 }
@@ -2347,9 +2346,8 @@ fault:
  * exponential backoff
  */
 static void ceph_fault(struct ceph_connection *con)
+	__releases(con->mutex)
 {
-	mutex_lock(&con->mutex);
-
 	pr_err("%s%lld %s %s\n", ENTITY_NAME(con->peer_name),
 	       ceph_pr_addr(&con->peer_addr.in_addr), con->error_msg);
 	dout("fault %p state %lu to peer %s\n",


