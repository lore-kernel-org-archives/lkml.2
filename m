Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0LWMwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 07:52:46 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53351 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab0LWMwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 07:52:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=WEtiaVs7IPswhhFSRb5A/AZWX6BmpNyXrhDLBtd+4d7j7wz/GTsy4bVZlD6iSpaAD0
         FYy0CLIRYBcJ6SGsJTZEEiqBKwx4HRBiRGM5qiZzNbqLLgcW4fSqXbAW78kj3094o7bN
         Zfxe3PMvxsNDr9p2/oTXdpROawMRpssO4AmRM=
MIME-Version: 1.0
Date: Thu, 23 Dec 2010 20:52:34 +0800
Message-ID: <AANLkTi=vfO-rs_iStXkPC7STSqfgUEW_JKt2w1=Wmf6Z@mail.gmail.com>
Subject: [PATCH] fix freeing user_struct in user cache
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When racing on adding into user cache, the new allocated from mm slab
is freed without putting user namespace.

Since the user namespace is already operated by getting, putting has
to be issued.

btw, it could be freed out of lock?

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
