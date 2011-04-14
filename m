Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab1DNPlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:41:25 -0400
Received: from mail4.comsite.net ([205.238.176.238]:32765 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab1DNPlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:41:24 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Nick Piggin <npiggin@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-Id: <fs-unreg-rcu@mdm.bga.com>
Subject: [PATCH] fs: synchronize_rcu when unregister_filesystem success not failure
In-Reply-To: <ext4-masq@mdm.bga.com>
X-send-attempt: 2
References: <4DA48AF4.5080803@teksavvy.com>
	<20110413004938.GE3682@thunk.org>
	<4DA5ADA6.5060301@teksavvy.com>
	<5A35771F-49B6-491E-B012-DBE68907E382@mit.edu>
	<ext4-masq@mdm.bga.com>
Date: Thu, 14 Apr 2011 10:41:24 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While checking unregister_filesystem for saftey vs extra calls for
"ext4: register ext2 and ext3 alias after ext4" I realized that
the synchronize_rcu() was called on the error path but not on
the success path.

Should we call it in both?
Cc: stable (2.6.38)
Signed-off-by: Milton Miller <miltonm@bga.com>

Index: work.git/fs/filesystems.c
===================================================================
--- work.git.orig/fs/filesystems.c	2011-04-14 10:06:44.360068116 -0500
+++ work.git/fs/filesystems.c	2011-04-14 10:08:41.880061794 -0500
@@ -110,14 +110,13 @@ int unregister_filesystem(struct file_sy
 			*tmp = fs->next;
 			fs->next = NULL;
 			write_unlock(&file_systems_lock);
+			synchronize_rcu();
 			return 0;
 		}
 		tmp = &(*tmp)->next;
 	}
 	write_unlock(&file_systems_lock);
 
-	synchronize_rcu();
-
 	return -EINVAL;
 }
