Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440Ab1C3VrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:47:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:61722 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933135Ab1C3VHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237163"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: kashyap.desai@lsi.com, James.Bottomley@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [111/275] mptfusion: mptctl_release is required in mptctl.c
Message-Id: <20110330210550.8965D3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Kashyap, Desai <kashyap.desai@lsi.com>

commit 84857c8bf83e8aa87afc57d2956ba01f11d82386 upstream.

Added missing release callback for file_operations mptctl_fops.
Without release callback there will be never freed. It remains on
mptctl's eent list even after the file is closed and released.

Relavent RHEL bugzilla is 660871

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/message/fusion/mptctl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.35.y/drivers/message/fusion/mptctl.c
===================================================================
--- linux-2.6.35.y.orig/drivers/message/fusion/mptctl.c	2011-03-29 22:51:24.407098651 -0700
+++ linux-2.6.35.y/drivers/message/fusion/mptctl.c	2011-03-29 23:03:00.501287344 -0700
@@ -588,6 +588,13 @@
 }
 
 static int
+mptctl_release(struct inode *inode, struct file *filep)
+{
+	fasync_helper(-1, filep, 0, &async_queue);
+	return 0;
+}
+
+static int
 mptctl_fasync(int fd, struct file *filep, int mode)
 {
 	MPT_ADAPTER	*ioc;
@@ -2796,6 +2803,7 @@
 	.llseek =	no_llseek,
 	.fasync = 	mptctl_fasync,
 	.unlocked_ioctl = mptctl_ioctl,
+	.release =	mptctl_release,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = compat_mpctl_ioctl,
 #endif
