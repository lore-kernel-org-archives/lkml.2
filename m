Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab1BPAVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:21:18 -0500
Received: from kroah.org ([198.145.64.141]:39233 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180Ab1BPAVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:10 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:36 2011
Message-Id: <20110216001436.192746685@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [111/272] NFS: Fix an NFS client lockdep issue
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit e00b8a24041f37e56b4b8415ce4eba1cbc238065 upstream.

There is no reason to be freeing the delegation cred in the rcu callback,
and doing so is resulting in a lockdep complaint that rpc_credcache_lock
is being called from both softirq and non-softirq contexts.

Reported-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/delegation.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -23,8 +23,6 @@
 
 static void nfs_do_free_delegation(struct nfs_delegation *delegation)
 {
-	if (delegation->cred)
-		put_rpccred(delegation->cred);
 	kfree(delegation);
 }
 
@@ -37,6 +35,10 @@ static void nfs_free_delegation_callback
 
 static void nfs_free_delegation(struct nfs_delegation *delegation)
 {
+	if (delegation->cred) {
+		put_rpccred(delegation->cred);
+		delegation->cred = NULL;
+	}
 	call_rcu(&delegation->rcu, nfs_free_delegation_callback);
 }
 


