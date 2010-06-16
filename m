Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424Ab0FPS7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:59:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759022Ab0FPS7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:59:49 -0400
Date: Wed, 16 Jun 2010 14:59:13 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] d_ino considered harmful
Message-ID: <20100616185913.GA15566@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Who needs d_ino anyway?  I am running a kernel with this patch -
Gnome, a browser, IRC, kernel compile, etc. and everything works.

-VAL

commit 184f3919d0071f3bfa40010aa6919ea89999d79b
Author: Valerie Aurora <vaurora@redhat.com>
Date:   Wed Jun 16 11:05:06 2010 -0700

    VFS: Always return 0 for d_ino
    
    Use of d_ino without the corresponding st_dev is always buggy in the
    presence of submounts, bind mounts, and union mounts.  E.g., the d_ino
    of a mountpoint will be the inode number of the directory under the
    mountpoint, not the mounted directory.  Correct code must call stat(),
    which returns the correct device ID and inode in st_dev and st_ino.
    Since no one should be using d_ino anyway, always return 0 to detect
    bugs.

diff --git a/fs/readdir.c b/fs/readdir.c
index dd3eae1..38ea772 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -91,7 +91,9 @@ static int fillonedir(void * __buf, const char * name, int namlen, loff_t offset
 
 	if (buf->result)
 		return -EINVAL;
-	d_ino = ino;
+	/* Use of d_ino without st_dev is always buggy. */
+	d_ino = 0;
+
 	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
 		buf->result = -EOVERFLOW;
 		return -EOVERFLOW;
