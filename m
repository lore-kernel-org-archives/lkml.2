Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab1B1Qgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:36:48 -0500
Received: from kroah.org ([198.145.64.141]:41146 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab1B1Qgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:36:47 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:05 2011
Message-Id: <20110228162405.780148249@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Konstantin Khorenko <khorenko@openvz.org>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [01/68] NFSD: memory corruption due to writing beyond the stat array
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Konstantin Khorenko <khorenko@parallels.com>

commit 3aa6e0aa8ab3e64bbfba092c64d42fd1d006b124 upstream.

If nfsd fails to find an exported via NFS file in the readahead cache, it
should increment corresponding nfsdstats counter (ra_depth[10]), but due to a
bug it may instead write to ra_depth[11], corrupting the following field.

In a kernel with NFSDv4 compiled in the corruption takes the form of an
increment of a counter of the number of NFSv4 operation 0's received; since
there is no operation 0, this is harmless.

In a kernel with NFSDv4 disabled it corrupts whatever happens to be in the
memory beyond nfsdstats.

Signed-off-by: Konstantin Khorenko <khorenko@openvz.org>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -823,7 +823,7 @@ nfsd_get_raparms(dev_t dev, ino_t ino)
 		if (ra->p_count == 0)
 			frap = rap;
 	}
-	depth = nfsdstats.ra_size*11/10;
+	depth = nfsdstats.ra_size;
 	if (!frap) {	
 		spin_unlock(&rab->pb_lock);
 		return NULL;


