Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1AFAi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:38:56 -0500
Received: from kroah.org ([198.145.64.141]:36014 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab1AFAbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:20 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:08 2011
Message-Id: <20110106002308.070668351@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hillf Danton <dhillf@gmail.com>, Serge Hallyn <serge@hallyn.com>
Subject: [120/152] fix freeing user_struct in user cache
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 kernel/user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/user.c
+++ b/kernel/user.c
@@ -157,6 +157,7 @@ struct user_struct *alloc_uid(struct use
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
 		if (up) {
+			put_user_ns(ns);
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);


