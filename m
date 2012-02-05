Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab2BEW05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:57 -0500
Received: from 1wt.eu ([62.212.114.60]:62054 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab2BEW0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:52 -0500
Message-Id: <20120205220952.526747546@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:01 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 72/91] svcrpc: fix double-free on shutdown of nfsd after changing pool mode
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 3 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/net/sunrpc/svc.c
===================================================================
--- longterm-2.6.27.orig/net/sunrpc/svc.c	2012-02-05 22:34:32.810915144 +0100
+++ longterm-2.6.27/net/sunrpc/svc.c	2012-02-05 22:34:45.104915090 +0100
@@ -163,6 +163,7 @@
 
 fail_free:
 	kfree(m->to_pool);
+	m->to_pool = NULL;
 fail:
 	return -ENOMEM;
 }
@@ -283,7 +284,9 @@
 	if (!--m->count) {
 		m->mode = SVC_POOL_DEFAULT;
 		kfree(m->to_pool);
+		m->to_pool = NULL;
 		kfree(m->pool_to);
+		m->pool_to = NULL;
 		m->npools = 0;
 	}
 


