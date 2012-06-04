Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab2FDF3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:29:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63890 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab2FDF3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:29:49 -0400
Message-ID: <4FCC47C9.8050904@lwfinger.net>
Date: Mon, 04 Jun 2012 00:29:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Question about do_mmap changes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

In commit e3fc629d7bb70848fbf479688a66d4e76dff46ac in 3.5-rc1, you change 
do_mmap() to static, and use do_mmap_pgoff() instaed. The VirtualBox kernel 
module calls do_mmap(), and no longer compiles. I fixed the compile problem with 
the patch

Index: vboxhost/vboxdrv/r0drv/linux/memobj-r0drv-linux.c
===================================================================
--- vboxhost.orig/vboxdrv/r0drv/linux/memobj-r0drv-linux.c
+++ vboxhost/vboxdrv/r0drv/linux/memobj-r0drv-linux.c
@@ -65,6 +65,13 @@
  # define VBOX_USE_PAE_HACK
  #endif

+/*
+ * 3.5+ kernels no longer have do_mmap(). They need to call
+ * do_mmap_pgoff() instead.
+ */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 5, 0)
+#define do_mmap do_mmap_pgoff
+#endif

  /*******************************************************************************
  *   Structures and Typedefs

================================

Although the code now compiles OK, the link step results in

WARNING: "do_mmap_pgoff" [/usr/share/virtualbox/src/vboxhost/vboxdrv/vboxdrv.ko] 
undefined!
WARNING: "do_munmap" [/usr/share/virtualbox/src/vboxhost/vboxdrv/vboxdrv.ko] 
undefined!

================================

I am not quite sure why do_munmap() is undefined as the symbol is exported; 
however, should do_mmap_pgoff() be exported?

Thanks,

Larry
