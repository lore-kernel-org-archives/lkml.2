Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935199Ab2C3Wpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:45:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935137Ab2C3VHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:07:00 -0400
Message-Id: <20120330195732.950887007@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
        Justin Pettit <jpettit@nicira.com>,
        Pravin B Shelar <pshelar@nicira.com>, Jesse Gross <jesse@nicira.com>,
        David Miller <davem@davemloft.net>
Subject: [ 075/108] proc-ns: use d_set_d_op() API to set dentry ops in proc_ns_instantiate().
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pravin B Shelar <pshelar@nicira.com>

commit 1b26c9b334044cff6d1d2698f2be41bc7d9a0864 upstream.

The namespace cleanup path leaks a dentry which holds a reference count
on a network namespace.  Keeping that network namespace from being freed
when the last user goes away.  Leaving things like vlan devices in the
leaked network namespace.

If you use ip netns add for much real work this problem becomes apparent
pretty quickly.  It light testing the problem hides because frequently
you simply don't notice the leak.

Use d_set_d_op() so that DCACHE_OP_* flags are set correctly.

This issue exists back to 3.0.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reported-by: Justin Pettit <jpettit@nicira.com>
Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Jesse Gross <jesse@nicira.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/namespaces.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -54,7 +54,7 @@ static struct dentry *proc_ns_instantiat
 	ei->ns_ops    = ns_ops;
 	ei->ns	      = ns;
 
-	dentry->d_op = &pid_dentry_operations;
+	d_set_d_op(dentry, &pid_dentry_operations);
 	d_add(dentry, inode);
 	/* Close the race of the process dying before we return the dentry */
 	if (pid_revalidate(dentry, NULL))


