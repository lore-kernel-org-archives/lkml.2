Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab0I0IBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:01:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43171 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab0I0IBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HoYls0hX1HT++yPDhXxQdMeMtW/O0pydVK4MHU3bxnwGdWuwjMkNQrGViFThIFYv+X
         ufPY70ERYJzVjAKrwAOUeRsMa3Sb7BgC2pdvreZcOdOVvN8NMDO4RQjuY1PYjDOJph9W
         4Z/yaYhP5Otw/XtMrH1rxd2xnxzk6h7yRKrc4=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/user.c: add lock release annotation on free_user()
Date: Mon, 27 Sep 2010 17:01:42 +0900
Message-Id: <1285574502-15339-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_user() releases uidhash_lock but was missing annotation.
Add it. This removes following sparse warnings:

 include/linux/spinlock.h:339:9: warning: context imbalance in 'free_user' - unexpected unlock
 kernel/user.c:120:6: warning: context imbalance in 'free_uid' - wrong count at exit

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/user.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/user.c b/kernel/user.c
index 7e72614..2c7d8d5 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -91,6 +91,7 @@ static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
  * upon function exit.
  */
 static void free_user(struct user_struct *up, unsigned long flags)
+	__releases(&uidhash_lock)
 {
 	uid_hash_remove(up);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
-- 
1.7.2.2

