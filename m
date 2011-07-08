Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab1GHFEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:04:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42306 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782Ab1GHFEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:04:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:59 2011
Message-Id: <20110708001659.393585376@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [068/107] nfsd4: fix break_lease flags on nfsd open
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 105f4622104848ff1ee1f644d661bef9dec3eb27 upstream.

Thanks to Casey Bodley for pointing out that on a read open we pass 0,
instead of O_RDONLY, to break_lease, with the result that a read open is
treated like a write open for the purposes of lease breaking!

Reported-by: Casey Bodley <cbodley@citi.umich.edu>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/vfs.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -699,7 +699,15 @@ nfsd_access(struct svc_rqst *rqstp, stru
 }
 #endif /* CONFIG_NFSD_V3 */
 
+static int nfsd_open_break_lease(struct inode *inode, int access)
+{
+	unsigned int mode;
 
+	if (access & NFSD_MAY_NOT_BREAK_LEASE)
+		return 0;
+	mode = (access & NFSD_MAY_WRITE) ? O_WRONLY : O_RDONLY;
+	return break_lease(inode, mode | O_NONBLOCK);
+}
 
 /*
  * Open an existing file or directory.
@@ -747,12 +755,7 @@ nfsd_open(struct svc_rqst *rqstp, struct
 	if (!inode->i_fop)
 		goto out;
 
-	/*
-	 * Check to see if there are any leases on this file.
-	 * This may block while leases are broken.
-	 */
-	if (!(access & NFSD_MAY_NOT_BREAK_LEASE))
-		host_err = break_lease(inode, O_NONBLOCK | ((access & NFSD_MAY_WRITE) ? O_WRONLY : 0));
+	host_err = nfsd_open_break_lease(inode, access);
 	if (host_err) /* NOMEM or WOULDBLOCK */
 		goto out_nfserr;
 


