Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1B1QvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:51:15 -0500
Received: from kroah.org ([198.145.64.141]:41254 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab1B1QhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:07 2011
Message-Id: <20110228162407.340934539@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        David Howells <dhowells@redhat.com>
Subject: [17/68] CRED: Fix memory and refcount leaks upon security_prepare_creds() failure
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit fb2b2a1d37f80cc818fd4487b510f4e11816e5e1 upstream.

In prepare_kernel_cred() since 2.6.29, put_cred(new) is called without
assigning new->usage when security_prepare_creds() returned an error.  As a
result, memory for new and refcount for new->{user,group_info,tgcred} are
leaked because put_cred(new) won't call __put_cred() unless old->usage == 1.

Fix these leaks by assigning new->usage (and new->subscribers which was added
in 2.6.32) before calling security_prepare_creds().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cred.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -718,6 +718,8 @@ struct cred *prepare_kernel_cred(struct
 	validate_creds(old);
 
 	*new = *old;
+	atomic_set(&new->usage, 1);
+	set_cred_subscribers(new, 0);
 	get_uid(new->user);
 	get_group_info(new->group_info);
 
@@ -735,8 +737,6 @@ struct cred *prepare_kernel_cred(struct
 	if (security_prepare_creds(new, old, GFP_KERNEL) < 0)
 		goto error;
 
-	atomic_set(&new->usage, 1);
-	set_cred_subscribers(new, 0);
 	put_cred(old);
 	validate_creds(new);
 	return new;


