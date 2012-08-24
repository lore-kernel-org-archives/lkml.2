Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab2HXDLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 23:11:24 -0400
Received: from mail1.windriver.com ([147.11.146.13]:39509 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab2HXDLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 23:11:20 -0400
From: Liang Li <liang.li@windriver.com>
To: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, <richard.purdie@linuxfoundation.org>
Subject: [RFC PATCH] perf: add SLANG_INC for slang.h
Date: Fri, 24 Aug 2012 11:10:39 +0800
Message-ID: <1345777839-15843-1-git-send-email-liang.li@windriver.com>
X-Mailer: git-send-email 1.7.11.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CFLAGS was previously hard coded to contain "-I/usr/include/slang" to
work with hosts that have "/usr/include/slang/slang.h" as well as hosts
that have "/usr/include/slang.h". This path can cause compile warnings
like:

cc1: warning: '/usr/include/slang' doesn't exists.

or

cc1: warning: include location "/usr/include/slang" is unsafe for
cross-compilation [-Wpoison-system-directories]

Then in some cases warnings become errors if WERROR is enabled hence
build errors.

To fix this issue, we can use -idirafter to downgrade the priority of the
default hard coded path. We can also make the slang include directory
a variable, to allow the user to specify SLANG_INC and set their own
include location. And add a '=' prefix to indicate better
compatibility with sysroot/cross compile cases.

Signed-off-by: Liang Li <liang.li@windriver.com>
---
 tools/perf/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b7a7a87..e403c36 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -496,8 +496,10 @@ else
 		msg := $(warning newt not found, disables TUI support. Please install newt-devel or libnewt-dev);
 		BASIC_CFLAGS += -DNO_NEWT_SUPPORT
 	else
-		# Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
-		BASIC_CFLAGS += -I/usr/include/slang
+		# Some releases like Fedora has /usr/include/slang/slang.h other than /usr/include/slang.h
+		SLANG_INC ?= -idirafter =/usr/include/slang
+		BASIC_CFLAGS += $(SLANG_INC)
+
 		EXTLIBS += -lnewt -lslang
 		LIB_OBJS += $(OUTPUT)ui/setup.o
 		LIB_OBJS += $(OUTPUT)ui/browser.o
-- 
1.7.11.4

