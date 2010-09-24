Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0IXQcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:32:17 -0400
Received: from kroah.org ([198.145.64.141]:38520 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800Ab0IXQ2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:50 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:20 2010
Message-Id: <20100924162620.497230599@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>, Alex Elder <aelder@sgi.com>,
        dann frazier <dannf@debian.org>
Subject: [64/80] xfs: prevent reading uninitialized stack memory
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <dan.j.rosenberg@gmail.com>

commit a122eb2fdfd78b58c6dd992d6f4b1aaef667eef9 upstream.

The XFS_IOC_FSGETXATTR ioctl allows unprivileged users to read 12
bytes of uninitialized stack memory, because the fsxattr struct
declared on the stack in xfs_ioc_fsgetxattr() does not alter (or zero)
the 12-byte fsx_pad member before copying it back to the user.  This
patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Cc: dann frazier <dannf@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -794,6 +794,8 @@ xfs_ioc_fsgetxattr(
 {
 	struct fsxattr		fa;
 
+	memset(&fa, 0, sizeof(struct fsxattr));
+
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	fa.fsx_xflags = xfs_ip2xflags(ip);
 	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;


