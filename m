Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1GDRLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:11:46 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:32985 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab1GDRKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:10:00 -0400
Message-Id: <20110704170958.874632821@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Mon, 04 Jul 2011 19:09:24 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: ebiederm@xmission.com, vgoyal@redhat.com, hbabu@us.ibm.com,
        mahesh@linux.vnet.ibm.com
Cc: oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 2/9] kdump: Add machine_kexec_finish()
References: <20110704170922.976299676@linux.vnet.ibm.com>
Content-Disposition: inline; filename=02-s390-kdump-common-kexec_finish.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

On s390 we create checksums for the loaded kexec segments case of kdump.
Therefore we need an additional callback at the end of the kexec_load()
system call. This patch introduces machine_kexec_finish() with an empty
implementation for all architectures that do not need the callback.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 include/linux/kexec.h |    1 +
 kernel/kexec.c        |    8 ++++++++
 2 files changed, 9 insertions(+)

--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -115,6 +115,7 @@ struct kimage {
 /* kexec interface functions */
 extern void machine_kexec(struct kimage *image);
 extern int machine_kexec_prepare(struct kimage *image);
+extern void machine_kexec_finish(struct kimage *image, int flags);
 extern void machine_kexec_cleanup(struct kimage *image);
 extern asmlinkage long sys_kexec_load(unsigned long entry,
 					unsigned long nr_segments,
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1017,6 +1017,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned lon
 		kimage_terminate(image);
 	}
 	/* Install the new kernel, and  Uninstall the old */
+	machine_kexec_finish(image, flags);
 	image = xchg(dest_image, image);
 
 out:
@@ -1026,6 +1027,13 @@ out:
 	return result;
 }
 
+/*
+ * provide an empty default implementation here -- architecture
+ * code may override this
+ */
+void __weak machine_kexec_finish(struct kimage *image, int flags)
+{}
+
 #ifdef CONFIG_COMPAT
 asmlinkage long compat_sys_kexec_load(unsigned long entry,
 				unsigned long nr_segments,

