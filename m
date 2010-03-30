Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab0C3GU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:20:29 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:32918 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab0C3GUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:20:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bMUJmy7XEkjyYJ2uqs5sms7ekDBsmrMo5hGyNY3JnB8aHFZyOXkVzF9pf7xrJm4tZ3
         pis7r1X0SWLyHPeiWRUR1P9KKYIXMqU3WqxWCF/Q1ilCRr9unaW0wUBSejHDzAJdrhOH
         Teyao938dr0vUusfK6Nuo0ItAFgw5T5bTdn7U=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 6/6] procfs: Kill the bkl in ioctl
Date: Tue, 30 Mar 2010 08:20:15 +0200
Message-Id: <1269930015-863-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no more users of procfs that implement the ioctl
callback. Drop the bkl from this path and warn on any use
of this callback.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 fs/proc/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 445a02b..afcda85 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -231,9 +231,9 @@ static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigne
 		if (rv == -ENOIOCTLCMD)
 			rv = -EINVAL;
 	} else if (ioctl) {
-		lock_kernel();
+		WARN_ONCE(1, "Procfs ioctl handlers must use unlocked_ioctl, "
+			  "%pf will be called without the Bkl held\n", ioctl);
 		rv = ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
-		unlock_kernel();
 	}
 
 	pde_users_dec(pde);
-- 
1.6.2.3

