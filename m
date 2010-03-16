Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937537Ab0CPHzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:55:13 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:45489 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936551Ab0CPHzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:55:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Ps6oO7fknGjiecPIyr1Ye9VMHgpiTZPqkIbkOk7TY2nrBdLTtKXH0/+LvBXatc5ikO
         9UnbqDC2FtsPscKC8VpUCKVRAktJecgRgoUQoxNT0VsuVHWe22eMlbGf28hCRKtF5fi9
         I0ujKqZD4mt6P/M68ETMYQYr+ICL6X/h2BN00=
Date: Tue, 16 Mar 2010 23:53:50 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, aelder@sgi.com
Subject: [PATCH] xfs: Fix integer overflow in fs/xfs/linux-2.6/xfs_ioctl*.c
Message-ID: <20100316155350.GB18579@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

STATIC int
xfs_compat_attrmulti_by_handle(
        struct file                             *parfilp,
        void                                    __user *arg)
{
...
        if (copy_from_user(&am_hreq, arg,
                           sizeof(compat_xfs_fsop_attrmulti_handlereq_t)))
                return -XFS_ERROR(EFAULT);
...
        error = E2BIG;
        /* Not check the am_hreq.opcount max value from userspace, 
        m_hreq.opcount * sizeof(compat_xfs_attr_multiop_t) can make
        integer overflow, and the if condition can be bypass. Though,
        it can not make security problem, but fix it maybe better. */
        size = am_hreq.opcount * sizeof(compat_xfs_attr_multiop_t);
        if (!size || size > 16 * PAGE_SIZE)
                goto out_dput;
...
}

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 fs/xfs/linux-2.6/xfs_ioctl.c   |    4 ++++
 fs/xfs/linux-2.6/xfs_ioctl32.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index 4ea1ee1..b05b3b7 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -526,6 +526,10 @@ xfs_attrmulti_by_handle(
 	if (copy_from_user(&am_hreq, arg, sizeof(xfs_fsop_attrmulti_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
+	/* overflow check */
+	if (am_hreq.opcount >= INT_MAX / sizeof(xfs_attr_multiop_t))
+		return -ENOMEM;
+
 	dentry = xfs_handlereq_to_dentry(parfilp, &am_hreq.hreq);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
index 0bf6d61..7b8673e 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -419,6 +419,10 @@ xfs_compat_attrmulti_by_handle(
 			   sizeof(compat_xfs_fsop_attrmulti_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
 
+	/* overflow check */
+	if (am_hreq.opcount >= INT_MAX / sizeof(compat_xfs_attr_multiop_t))
+		return -ENOMEM;
+
 	dentry = xfs_compat_handlereq_to_dentry(parfilp, &am_hreq.hreq);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
-- 
1.6.5.3

