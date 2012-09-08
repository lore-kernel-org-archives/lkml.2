Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab2IHIbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 04:31:36 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:35822 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab2IHIbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 04:31:32 -0400
Date: Sat, 8 Sep 2012 10:31:42 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: James Morris <james.l.morris@oracle.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] samples/seccomp: fix 31 bit build on s390
Message-ID: <20120908083142.GA4959@osiris.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12090808-3548-0000-0000-0000030D6009
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From cea999ef4e68e23c70e64baf054768bdebe15e1b Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Sat, 8 Sep 2012 10:23:42 +0200
Subject: [PATCH] samples/seccomp: fix 31 bit build on s390

On s390 the flag to force 31 builds is -m31 instead of -m32 unlike
on all (?) other architectures.

Fixes this compile error:

  HOSTCC  samples/seccomp/bpf-direct.o
cc1: error: unrecognized command line option "-m32"
make[2]: *** [samples/seccomp/bpf-direct.o] Error 1

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

Patch is on top of linux-next of today.

 samples/seccomp/Makefile | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/samples/seccomp/Makefile b/samples/seccomp/Makefile
index 16aa2d4..bbbd276 100644
--- a/samples/seccomp/Makefile
+++ b/samples/seccomp/Makefile
@@ -18,14 +18,22 @@ HOSTCFLAGS_bpf-direct.o += -idirafter $(objtree)/include
 bpf-direct-objs := bpf-direct.o
 
 # Try to match the kernel target.
-ifeq ($(CONFIG_64BIT),)
-HOSTCFLAGS_bpf-direct.o += -m32
-HOSTCFLAGS_dropper.o += -m32
-HOSTCFLAGS_bpf-helper.o += -m32
-HOSTCFLAGS_bpf-fancy.o += -m32
-HOSTLOADLIBES_bpf-direct += -m32
-HOSTLOADLIBES_bpf-fancy += -m32
-HOSTLOADLIBES_dropper += -m32
+ifndef CONFIG_64BIT
+
+# s390 has -m31 flag to build 31 bit binaries
+ifndef CONFIG_S390
+MFLAG = -m32
+else
+MFLAG = -m31
+endif
+
+HOSTCFLAGS_bpf-direct.o += $(MFLAG)
+HOSTCFLAGS_dropper.o += $(MFLAG)
+HOSTCFLAGS_bpf-helper.o += $(MFLAG)
+HOSTCFLAGS_bpf-fancy.o += $(MFLAG)
+HOSTLOADLIBES_bpf-direct += $(MFLAG)
+HOSTLOADLIBES_bpf-fancy += $(MFLAG)
+HOSTLOADLIBES_dropper += $(MFLAG)
 endif
 
 # Tell kbuild to always build the programs
-- 
1.7.11.5

