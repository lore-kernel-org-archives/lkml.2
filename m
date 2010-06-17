Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913Ab0FQMvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 08:51:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57874 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0FQMvq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 08:51:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=MLyYWIfPPKp3pwO53A8W+YLVCbqeySkHq34sZm4/Kp9Q0pVxzrxK2+1XVCJhMF7F2r
         d02pRyb9tDFT5Ai1EurxQSMnt36IhkFUFjp+805LNhAifkX9y8bnWhpgfZgo4hySxTHr
         NOAkryiLTYN3wRl6E2bjrynsFKzUuqiAch3ho=
MIME-Version: 1.0
From: Tiago Maluta <tiago.maluta@gmail.com>
Date: Thu, 17 Jun 2010 12:50:52 +0000
Message-ID: <AANLkTim2mi0wbJJl17OkbCJbRt-s5phR4sumn5GsJKUp@mail.gmail.com>
Subject: [PATCH] Fix CONFIG_CROSS_COMPILE issue in .config
To: linux-kernel@vger.kernel.org
Cc: Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux has an recent option to define CROSS_COMPILE in menuconfig.

Typically, one of the options when building for another target is
('arm' is just an example):

# make ARCH=arm CROSS_COMPILE=arm-cc O=../build

If I omit CROSS_COMPILE and use the new way in .config:
CONFIG_CROSS_COMPILE="arm-cc"

I got:

   cc1: error: unrecognized command line option "-mlittle-endian"
   cc1: error: unrecognized command line option "-mabi=aapcs-linux"
   cc1: error: unrecognized command line option "-mno-thumb-interwork"
   /usr/src/linux/kernel/bounds.c:1: error: bad value (armv5t) for
-march= switch
   /usr/src/linux/kernel/bounds.c:1: error: bad value (armv5t) for
-mtune= switch
   make[2]: *** [kernel/bounds.s] Error 1
   make[1]: *** [prepare0] Error 2
   make: *** [sub-make] Error 2

Verbose output clearly says that I'm using the host compiler instead
cross compiler.
This patch fixed my problem:

---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index d49d96c..5a6c7d5 100644
--- a/Makefile
+++ b/Makefile
@@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/
-e s/sun4u/sparc64/ \
 export KBUILD_BUILDHOST := $(SUBARCH)
 ARCH           ?= $(SUBARCH)
 CROSS_COMPILE  ?=
-CROSS_COMPILE  ?= $(CONFIG_CROSS_COMPILE:"%"=%)
+CROSS_COMPILE  := $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)

 # Architecture as present in compile.h
 UTS_MACHINE    := $(ARCH)
--
1.7.0.2


--tm
