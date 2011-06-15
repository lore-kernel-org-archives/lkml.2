Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab1FOVDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:03:41 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:43626 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1FOVDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:03:40 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] tools/perf: fix static build of perf tool
Date: Wed, 15 Jun 2011 23:03:38 +0200
Message-Id: <1308171818-20370-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To build a statically linked version of the perf tool all needed
libraries must be added in the correct order to get the symbols
resolved. Currently this is broken when, e.g. python or newt support is
enabled -- libpython needs libpthread which is an unconditional link
dependency of the perf tool; libslang needs libm, another unconditional
dependency. To solve the problem in the long run without the need to
keep track of transitive library dependencies, simply make the linker
look at the EXTLIBS multiple times until it has all symbols resolved.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc:  Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc:  Paul Mackerras <paulus@samba.org>
Cc:  Ingo Molnar <mingo@elte.hu>
Cc:  Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 032ba63..940257b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -633,7 +633,7 @@ prefix_SQ = $(subst ','\'',$(prefix))
 
 SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
 
-LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive $(EXTLIBS)
+LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
 
 ALL_CFLAGS += $(BASIC_CFLAGS)
 ALL_CFLAGS += $(ARCH_CFLAGS)
-- 
1.5.6.5

