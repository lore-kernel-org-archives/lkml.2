Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1BBApO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:45:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:23328 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab1BBApH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653505254"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: dhillf@gmail.com, serge@hallyn.com, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [113/139] fix freeing user_struct in user cache
Message-Id: <20110202004512.0B1FE3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Hillf Danton <dhillf@gmail.com>

commit 4ef9e11d6867f88951e30db910fa015300e31871 upstream.

When racing on adding into user cache, the new allocated from mm slab
is freed without putting user namespace.

Since the user namespace is already operated by getting, putting has
to be issued.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/user.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/kernel/user.c
===================================================================
--- linux-2.6.35.y.orig/kernel/user.c
+++ linux-2.6.35.y/kernel/user.c
@@ -157,6 +157,7 @@ struct user_struct *alloc_uid(struct use
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
 		if (up) {
+			put_user_ns(ns);
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);
