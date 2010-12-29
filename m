Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab0L2Nzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 08:55:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35789 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab0L2Nza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 08:55:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BuA4XNxiae7R9ngiKXMQ6Lh4F6qcde6uLxzv5ok6Ed1CcCZwrj4F7dbmdy+e9ICQl5
         hqEe45e45hkn2MGwa9CVK/7uxX8K6evM1Jz8dxW6txqdfV2EpIh+QEuDS4s0kpCOZ2Fo
         sNEOZAz36AMiExG3BjsAbV2HH1SMGDRF51kp8=
MIME-Version: 1.0
In-Reply-To: <20101229030936.GA9275@mail.hallyn.com>
References: <AANLkTi=vfO-rs_iStXkPC7STSqfgUEW_JKt2w1=Wmf6Z@mail.gmail.com>
	<20101224035523.GC25057@suse.de>
	<AANLkTi=PwGXTKKyXDA1sckosbGmeo+D0bGuXt3Jb-ttc@mail.gmail.com>
	<20101224171459.GA31815@suse.de>
	<AANLkTimvjGvoSs2T0BmdaMdKyAsnttSXXRiJp0wB4+bG@mail.gmail.com>
	<20101229030936.GA9275@mail.hallyn.com>
Date: Wed, 29 Dec 2010 21:55:28 +0800
Message-ID: <AANLkTinD9OUjmYpUwnCX47YeL6-DRwWyw=pwmiiZJQNH@mail.gmail.com>
Subject: [PATCH] fix freeing user_struct in user cache
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When racing on adding into user cache, the new allocated from mm slab
is freed without putting user namespace.

Since the user namespace is already operated by getting, putting has
to be issued.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/user.c	2010-11-01 19:54:12.000000000 +0800
+++ b/kernel/user.c	2010-12-23 20:42:00.000000000 +0800
@@ -158,6 +158,7 @@ struct user_struct *alloc_uid(struct use
 		spin_lock_irq(&uidhash_lock);
 		up = uid_hash_find(uid, hashent);
 		if (up) {
+			put_user_ns(ns);
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);
