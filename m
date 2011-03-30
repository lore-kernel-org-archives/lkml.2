Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964884Ab1C3VHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:43212 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933501Ab1C3VHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447632"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: penguin-kernel@I-love.SAKURA.ne.jp, dhowells@redhat.com,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [121/275] CRED: Fix memory and refcount leaks upon security_prepare_creds() failure
Message-Id: <20110330210601.1BE2C3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/cred.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/kernel/cred.c
===================================================================
--- linux-2.6.35.y.orig/kernel/cred.c	2011-03-29 23:03:00.710281996 -0700
+++ linux-2.6.35.y/kernel/cred.c	2011-03-29 23:03:00.732281432 -0700
@@ -663,6 +663,8 @@
 	validate_creds(old);
 
 	*new = *old;
+	atomic_set(&new->usage, 1);
+	set_cred_subscribers(new, 0);
 	get_uid(new->user);
 	get_group_info(new->group_info);
 
@@ -680,8 +682,6 @@
 	if (security_prepare_creds(new, old, GFP_KERNEL) < 0)
 		goto error;
 
-	atomic_set(&new->usage, 1);
-	set_cred_subscribers(new, 0);
 	put_cred(old);
 	validate_creds(new);
 	return new;
