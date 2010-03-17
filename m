Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab0CQDTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:19:54 -0400
Received: from mail-yw0-f201.google.com ([209.85.211.201]:36181 "EHLO
	mail-yw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0CQDTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Kt+wHG/CO6FY0i6V+f3Je85pm/gq9hnNYJly3Ut6tiU8MTRXJmF2tymyPHb1fPvDMl
         z3hkrvR7xKBxmVDHNKkKDqW3qn+csWTN9YmQiW0zKAjdq6BSQ/YXEy0AzZ5wtFW4Lhon
         aQq26P6Q1WNhpcDsoDp6BCc56B9ZGCIcxL7dc=
Date: Wed, 17 Mar 2010 11:19:47 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: xfs-masters@oss.sgi.com, aelder@sgi.com, david@fromorbit.com
Subject: [PATCH] xfs: Fix integer overflow in fs/xfs/linux-2.6/xfs_ioctl*.c
Message-ID: <20100317031947.GB2796@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The am_hreq.opcount field in the xfs_attrmulti_by_handle() interface
is not bounded correctly. The opcount is used to determine the size
of the buffer required. The size is bounded, but can overflow and so
the size checks may not be sufficient to catch invalid opcounts.
Fix it by catching opcount values that would cause overflows before
calculating the size.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 fs/xfs/linux-2.6/xfs_ioctl.c   |    4 ++++
 fs/xfs/linux-2.6/xfs_ioctl32.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index a034cf6..b716ec8 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -526,6 +526,10 @@ xfs_attrmulti_by_handle(
 	if (copy_from_user(&am_hreq, arg, sizeof(xfs_fsop_attrmulti_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
+	/* overflow check */
+	if (am_hreq.opcount >= INT_MAX / sizeof(xfs_attr_multiop_t))
+		return -E2BIG;
+
 	dentry = xfs_handlereq_to_dentry(parfilp, &am_hreq.hreq);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
index be1527b..c9d9d5e 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -419,6 +419,10 @@ xfs_compat_attrmulti_by_handle(
 			   sizeof(compat_xfs_fsop_attrmulti_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
+	/* overflow check */
+	if (am_hreq.opcount >= INT_MAX / sizeof(compat_xfs_attr_multiop_t))
+		return -E2BIG;
+
 	dentry = xfs_compat_handlereq_to_dentry(parfilp, &am_hreq.hreq);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
-- 
1.6.5.3

