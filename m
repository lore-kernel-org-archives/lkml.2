Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030829Ab2HQHkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:40:12 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34597 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030708Ab2HQHkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:40:09 -0400
From: Adam Lee <adam8157@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org (open list:KERNEL BUILD + fi...)
Subject: [PATCH] kconfig: allow ARCH set to 'the machine hardware name', like 's390x' but not 's390'
Date: Fri, 17 Aug 2012 15:39:59 +0800
Message-Id: <1345189199-22145-1-git-send-email-adam8157@gmail.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for setting ARCH to 'the machine hardware
name'(`uname -m).

UTS_MACHINE is not always the same as SRCARCH, for example, s390x, we
should set UTS_MACHINE=s390x, and SRCARCH=s390. This patch makes that
working when "make ARCH=s390x".

And it avoid some error during invocation of make when ARCH set to
s390x, ppc64 or some machine hardware name else. Lots of scripts will
have no need to hack(like what we did in Red Hat), just use `uname -m`.

Signed-off-by: Adam Lee <adam8157@gmail.com>
---
 Makefile | 37 ++++++++-----------------------------
 1 file changed, 8 insertions(+), 29 deletions(-)

diff --git a/Makefile b/Makefile
index 9cc77ac..4f06c64 100644
--- a/Makefile
+++ b/Makefile
@@ -197,36 +197,15 @@ CROSS_COMPILE	?= $(CONFIG_CROSS_COMPILE:"%"=%)
 
 # Architecture as present in compile.h
 UTS_MACHINE 	:= $(ARCH)
-SRCARCH 	:= $(ARCH)
 
-# Additional ARCH settings for x86
-ifeq ($(ARCH),i386)
-        SRCARCH := x86
-endif
-ifeq ($(ARCH),x86_64)
-        SRCARCH := x86
-endif
-
-# Additional ARCH settings for sparc
-ifeq ($(ARCH),sparc32)
-       SRCARCH := sparc
-endif
-ifeq ($(ARCH),sparc64)
-       SRCARCH := sparc
-endif
-
-# Additional ARCH settings for sh
-ifeq ($(ARCH),sh64)
-       SRCARCH := sh
-endif
-
-# Additional ARCH settings for tile
-ifeq ($(ARCH),tilepro)
-       SRCARCH := tile
-endif
-ifeq ($(ARCH),tilegx)
-       SRCARCH := tile
-endif
+# Where arch specific source located
+SRCARCH	:= $(shell echo $(ARCH) | \
+	sed -e s/i.86/x86/ -e s/x86_64/x86/ \
+	-e s/arm.*/arm/ -e s/sa110/arm/ \
+	-e s/m68k.*/m68k/ -e s/mips.*/mips/ \
+	-e s/parisc64/parisc/ -e s/ppc.*/powerpc/ \
+	-e s/s390x/s390/ -e s/sh.*/sh/ -e s/sun4u/sparc/ \
+	-e s/sparc.*/sparc/ -e s/tile.*/tile/ )
 
 # Where to locate arch specific headers
 hdr-arch  := $(SRCARCH)
-- 
1.7.11.2

