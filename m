Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab1GHFEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:04:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782Ab1GHFEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:04:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:59 2011
Message-Id: <20110708001659.293625795@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Casey Bodley <cbodley@citi.umich.edu>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [067/107] nfsd: link returns nfserr_delay when breaking lease
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Casey Bodley <cbodley@citi.umich.edu>

commit 7d751f6f8c679f51b73d01a1b5269347a929004c upstream.

fix for commit 4795bb37effb7b8fe77e2d2034545d062d3788a8, nfsd: break
lease on unlink, link, and rename

if the LINK operation breaks a delegation, it returns NFS4ERR_NOENT
(which is not a valid error in rfc 5661) instead of NFS4ERR_DELAY.
the return value of nfsd_break_lease() in nfsd_link() must be
converted from host_err to err

Signed-off-by: Casey Bodley <cbodley@citi.umich.edu>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/vfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1653,8 +1653,10 @@ nfsd_link(struct svc_rqst *rqstp, struct
 	if (!dold->d_inode)
 		goto out_drop_write;
 	host_err = nfsd_break_lease(dold->d_inode);
-	if (host_err)
+	if (host_err) {
+		err = nfserrno(host_err);
 		goto out_drop_write;
+	}
 	host_err = vfs_link(dold, dirp, dnew);
 	if (!host_err) {
 		err = nfserrno(commit_metadata(ffhp));


