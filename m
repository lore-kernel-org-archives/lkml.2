Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab1J1KZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 06:25:15 -0400
Received: from mail.df.lth.se ([194.47.250.12]:59254 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab1J1KZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 06:25:14 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Oct 2011 06:25:14 EDT
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] RFC: fs to be compiled with -Dlinux
Date: Fri, 28 Oct 2011 12:15:04 +0200
Message-Id: <1319796904-799-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I dunno how to solve this problem the real way or if I'm just doing
something idiotic. I'm using a vanilla GCC "arm-none-eabi-gcc" not
targeted at any specific OS so the environment variable "linux" is
not set. Then I try to compile an arch that by default wants to
generate an a.out image, actually mach-rpc (Acorn RISC PC) from
rpc_defconfig. (This is the grandfather in arch/arm/* if I'm not
mistaken.)

Without this patch that currently fails like this with a "none"
compiler:

  CC      fs/binfmt_aout.o
/home/elinwal/linux/fs/binfmt_aout.c: In function 'load_aout_binary':
/home/elinwal/linux/fs/binfmt_aout.c:256: error: 'SEGMENT_SIZE' undeclared (first use in this function)
/home/elinwal/linux/fs/binfmt_aout.c:256: error: (Each undeclared identifier is reported only once
/home/elinwal/linux/fs/binfmt_aout.c:256: error: for each function it appears in.)
make[3]: *** [fs/binfmt_aout.o] Error 1
make[2]: *** [fs] Error 2

However the kernel compilation process in fs/binmft_aout.c require
SEGMENT_SIZE which is in turn defined in <linux/a.out.h> like this:

  #ifdef linux
  #ifdef __KERNEL__
  #include <asm/page.h>
  #else
  #include <unistd.h>
  #endif
  #if defined(__i386__) || defined(__mc68000__)
  #define SEGMENT_SIZE    1024
  #else
  #ifndef SEGMENT_SIZE
  #ifdef __KERNEL__
  #define SEGMENT_SIZE    PAGE_SIZE
  #else
  #define SEGMENT_SIZE   getpagesize()
  #endif
  #endif
  #endif
  #endif

I don't know what the intent of all the pre-git
specific-machine detection code surrounding this statement
is, sorry I'm too young and naive. I don't dare to just delete
it though since it looks like stuff some userspace programs may
depend on, or intended for cross-compilation somekindof or
both.

Instead I chicken out and stick -Dlinux into the fs
Makefile, since that sure as hell cannot get the definition
of SEGMENT_SIZE from any other place than this file.

That doesn't feel good either, so: help.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 fs/Makefile |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/Makefile b/fs/Makefile
index d2c3353..128debc 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -3,7 +3,12 @@
 #
 # 14 Sep 2000, Christoph Hellwig <hch@infradead.org>
 # Rewritten to use lists instead of if-statements.
-# 
+#
+
+# binfmt_aout includes <linux/a.out.h> which requires that the compiler
+# defines "linux" to provide SEGMENT_SIZE and such things for the kernel
+# compilation
+ccflags-y  := -Dlinux
 
 obj-y :=	open.o read_write.o file_table.o super.o \
 		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
-- 
1.7.3.2

