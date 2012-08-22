Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab2HVQig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:38:36 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40676 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757411Ab2HVQic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:38:32 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adobriyan@gmail.com, Nathan Zimmer <nzimmer@sgi.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] fs/proc: Move kfree outside pde_unload_lock
Date: Wed, 22 Aug 2012 11:38:29 -0500
Message-Id: <1345653510-22000-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <n>
References: <n>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves a kfree outside a spinlock to help scaling on larger (512 core)
systems.

I ran a simple test which just reads from /proc/cpuinfo.
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

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 fs/proc/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 7ac817b..bf36266 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -403,9 +403,9 @@ static int proc_reg_release(struct inode *inode, struct file *file)
 	release = pde->proc_fops->release;
 	if (pdeo) {
 		list_del(&pdeo->lh);
-		kfree(pdeo);
 	}
 	spin_unlock(&pde->pde_unload_lock);
+	kfree(pdeo);
 
 	if (release)
 		rv = release(inode, file);
-- 
1.6.0.2

