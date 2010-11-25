Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab0KYEN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 23:13:26 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57330 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0KYENY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 23:13:24 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: tom.leiming@gmail.com, Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 2/3] perf: Allow strong and weak functions in LIB_OBJS
Date: Thu, 25 Nov 2010 15:12:54 +1100
Message-Id: <1290658375-10342-2-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290658375-10342-1-git-send-email-imunsie@au1.ibm.com>
References: <1290658375-10342-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

When we build perf we place all of the .o files from the library files
(util, arch/x/util, etc) into libperf.a which is then linked into perf.
The problem is that the linker will by default only consider .o files
within the .a archive if they are necessary to satisfy an unresolved
symbol. As weak functions are not unresolved, it will not consider a .o
file from the archive containing the strong versions of weak functions
unless it requires it for another reason.

This patch adds the --whole-archive flags to the linker when passing in
the libperf.a file to ensure that it will consider every .o file in the
archive, not just what it believes that it needs. The end result is that
weak functions can now be overridden by strong variants of them in the
libperf.a file.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2d414b3..c5f7b7f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -940,7 +940,8 @@ $(OUTPUT)perf.o: perf.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 
 $(OUTPUT)perf$X: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) $(OUTPUT)perf.o \
-               $(BUILTIN_OBJS) $(LIBS) -o $@
+               $(BUILTIN_OBJS) -Wl,--whole-archive $(LIBS) \
+	       -Wl,--no-whole-archive -o $@
 	@rm -f trace
 	@ln perf$X trace 2>/dev/null
 
-- 
1.7.2.3

