Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab2LaUog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 15:44:36 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:53123 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab2LaUoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 15:44:34 -0500
MIME-Version: 1.0
Date: Mon, 31 Dec 2012 15:44:30 -0500
Message-ID: <CAErYnsgFhW3Cf-W1CQJGOUstcyfdQxWUcGkGbd0uxM1R=XYuSw@mail.gmail.com>
Subject: [PATCH] Access control in Xen privcmd_ioctl_mmap
From: Tamas Lengyel <tamas.lengyel@zentific.com>
To: konrad.wilk@oracle.com, jeremy@goop.org
Cc: Daniel De Graaf <dgdegra@tycho.nsa.gov>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the privcmd Linux driver two checks in the functions
privcmd_ioctl_mmap and privcmd_ioctl_mmap_batch are not needed as they
are trying to enforce hypervisor-level access control.  They should be
removed as they break secondary control domains when performing dom0
disaggregation. Xen itself provides adequate security controls around
these hypercalls and these checks prevent those controls from
functioning as intended.

The patch applies to the stable Linux 3.7.1 kernel.

Signed-off-by: Tamas K Lengyel <tamas.lengyel@zentific.com>
Cc: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Cc: xen-devel@lists.xensource.com
Cc: linux-kernel@vger.kernel.org
---
 drivers/xen/privcmd.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 71f5c45..adaa260 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -196,9 +196,6 @@ static long privcmd_ioctl_mmap(void __user *udata)
        LIST_HEAD(pagelist);
        struct mmap_mfn_state state;

-       if (!xen_initial_domain())
-               return -EPERM;
-
        if (copy_from_user(&mmapcmd, udata, sizeof(mmapcmd)))
                return -EFAULT;

@@ -316,9 +313,6 @@ static long privcmd_ioctl_mmap_batch(void __user
*udata, int version)
        int *err_array = NULL;
        struct mmap_batch_state state;

-       if (!xen_initial_domain())
-               return -EPERM;
-
        switch (version) {
        case 1:
                if (copy_from_user(&m, udata, sizeof(struct privcmd_mmapbatch)))
