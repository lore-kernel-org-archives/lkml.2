Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab2AWXsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:48:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839Ab2AWXsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:48:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:26 2012
Message-Id: <20120123234026.682400204@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>
Subject: [44/90] svcrpc: fix double-free on shutdown of nfsd after changing pool mode
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 61c8504c428edcebf23b97775a129c5b393a302b upstream.

The pool_to and to_pool fields of the global svc_pool_map are freed on
shutdown, but are initialized in nfsd startup only in the
SVC_POOL_PERCPU and SVC_POOL_PERNODE cases.

They *are* initialized to zero on kernel startup.  So as long as you use
only SVC_POOL_GLOBAL (the default), this will never be a problem.

You're also OK if you only ever use SVC_POOL_PERCPU or SVC_POOL_PERNODE.

However, the following sequence events leads to a double-free:

	1. set SVC_POOL_PERCPU or SVC_POOL_PERNODE
	2. start nfsd: both fields are initialized.
	3. shutdown nfsd: both fields are freed.
	4. set SVC_POOL_GLOBAL
	5. start nfsd: the fields are left untouched.
	6. shutdown nfsd: now we try to free them again.

Step 4 is actually unnecessary, since (for some bizarre reason), nfsd
automatically resets the pool mode to SVC_POOL_GLOBAL on shutdown.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/svc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -167,6 +167,7 @@ svc_pool_map_alloc_arrays(struct svc_poo
 
 fail_free:
 	kfree(m->to_pool);
+	m->to_pool = NULL;
 fail:
 	return -ENOMEM;
 }
@@ -287,7 +288,9 @@ svc_pool_map_put(void)
 	if (!--m->count) {
 		m->mode = SVC_POOL_DEFAULT;
 		kfree(m->to_pool);
+		m->to_pool = NULL;
 		kfree(m->pool_to);
+		m->pool_to = NULL;
 		m->npools = 0;
 	}
 


