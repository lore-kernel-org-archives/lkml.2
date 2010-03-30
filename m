Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab0C3Jll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 05:41:41 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:64381 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab0C3Jlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 05:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=kzH1rwISKCukjqKl49oInZMRH8xD3z8UmN2rXlc7fqgFxDNZZdzCkMh6YvvXDZQYT3
         uXLeqJGZl/T42cnKwLfoynnDcgQaAZYUnnnnhVKUNQNQzofmjV77CfRg39VVoe1NhhZr
         ABxtl1CCgihnZSw90hNFAIuoHaR78kzfHuqhQ=
Date: Tue, 30 Mar 2010 12:41:25 +0300
From: Dan Carpenter <error27@gmail.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
       Sripathi Kodi <sripathik@in.ibm.com>, Jim Garlick <garlick@llnl.gov>,
       Martin Stava <martin.stava@gmail.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] 9p: return on mutex_lock_interruptible()
Message-ID: <20100330094125.GH5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Eric Van Hensbergen <ericvh@gmail.com>,
	Ron Minnich <rminnich@sandia.gov>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Sripathi Kodi <sripathik@in.ibm.com>,
	Jim Garlick <garlick@llnl.gov>,
	Martin Stava <martin.stava@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If "err" is -EINTR here the original code calls mutex_unlock() and then
returns, but it should just return directly.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index d8a3afe..bbe00cf 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -130,6 +130,8 @@ static int v9fs_dir_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	rdir = (struct p9_rdir *) fid->rdir;
 
 	err = mutex_lock_interruptible(&rdir->mutex);
+	if (err)
+		return err;
 	while (err == 0) {
 		if (rdir->tail == rdir->head) {
 			err = v9fs_file_readn(filp, rdir->buf, NULL,
