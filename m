Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2DGTBY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 15:01:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45361 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab2DGTBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 15:01:20 -0400
Date: Sat, 7 Apr 2012 22:01:17 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] proc: don't do dummy rcu_read_lock/rcu_read_unlock on
 error path
Message-ID: <20120407190117.GA5946@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu_read_lock()/rcu_read_unlock() is nop for TINY_RCU,
but is not a nop for, say, PREEMPT_RCU.

proc_fill_cache() is called without RCU lock,
there is no need to lock/unlock on error path,
simply jump out of the loop.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1943,21 +1943,22 @@ static int proc_readfd_common(struct file * filp, void * dirent,
 			     fd++, filp->f_pos++) {
 				char name[PROC_NUMBUF];
 				int len;
+				int rv;
 
 				if (!fcheck_files(files, fd))
 					continue;
 				rcu_read_unlock();
 
 				len = snprintf(name, sizeof(name), "%d", fd);
-				if (proc_fill_cache(filp, dirent, filldir,
-						    name, len, instantiate,
-						    p, &fd) < 0) {
-					rcu_read_lock();
-					break;
-				}
+				rv = proc_fill_cache(filp, dirent, filldir,
+						     name, len, instantiate, p,
+						     &fd);
+				if (rv < 0)
+					goto out_fd_loop;
 				rcu_read_lock();
 			}
 			rcu_read_unlock();
+out_fd_loop:
 			put_files_struct(files);
 	}
 out:
