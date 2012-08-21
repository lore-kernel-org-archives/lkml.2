Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab2HUUy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:54:57 -0400
Received: from relay1.sgi.com ([192.48.179.29]:39506 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab2HUUy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:54:56 -0400
Date: Tue, 21 Aug 2012 15:54:54 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adobriyan@gmail.com
Subject: [RFC] Move kfree outside pde_unload_lock
Message-ID: <20120821205454.GA7772@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am currently tracking a hotlock reported by a customer on a large, 512 cores,
system, I am currently running 3.6.0 rc1 but the issue looks like it has been
this way for a very long time.
The offending lock is proc_dir_entry->pde_unload_lock.  

In proc_reg_release we are doing a kfree under the spinlock which is ok but it
means we are holding the lock longer then required. Scaling improved when I 
moved kfree out.

Also shouldn't the comment on pde_unload_lock also note that pde_openers and 
pde_unload_completion are both used under the lock?

Here is some data from quick test program which just reads from /proc/cpuinfo.
Lower is better, as you can see the worst case scenario is improved.
	baseline	moved kfree	
tasks	read-sec	read-sec	
1	0.0141		0.0141
2	0.0140		0.0140
4	0.0140		0.0141
8	0.0145		0.0145
16	0.0553		0.0548
32	0.1688		0.1622
64	0.5017		0.3856
128	1.7005		0.9710
256	5.2513		2.6519
512	8.0529		6.2976

If the patch looks agreeable I will resend it properly.
 
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 7ac817b..46016c1 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -403,9 +403,11 @@ static int proc_reg_release(struct inode *inode, struct file *file)
 	release = pde->proc_fops->release;
 	if (pdeo) {
 		list_del(&pdeo->lh);
-		kfree(pdeo);
 	}
 	spin_unlock(&pde->pde_unload_lock);
+	if (pdeo) {
+		kfree(pdeo);
+	}
 
 	if (release)
 		rv = release(inode, file);

