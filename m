Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1DUCjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:39:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41031 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1DUChk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:37:40 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=vhdKIqpQuCYA:10 a=-1fcEHDpavgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ugbHTpIJB3eJMHMI0FsA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110421023738.714956282@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 22:28:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: [RFC][PATCH 07/11] kbuild/recordmcount: Add RECORDMCOUNT_WARN to warn about mcount callers
References: <20110421022825.535486725@goodmis.org>
Content-Disposition: inline; filename=0007-kbuild-recordmcount-Add-RECORDMCOUNT_WARN-to-warn-ab.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When mcount is called in a section that ftrace will not modify it into
a nop, we want to warn about this. But not warn about this always. Now
if the user builds the kernel with the option RECORDMCOUNT_WARN=1 then
the build will warn about mcount callers that are ignored and will just
waste execution time.

Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Makefile               |    1 +
 scripts/Makefile.build |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 8392b64..4e484cf 100644
--- a/Makefile
+++ b/Makefile
@@ -1268,6 +1268,7 @@ help:
 	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
 	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
 	@echo  '  make W=1   [targets] Enable extra gcc checks'
+	@echo  '  make RECORDMCOUNT_WARN=1 [targets] Warn about ignored mcount sections'
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5f925a..fdca952 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -244,13 +244,16 @@ endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
 ifdef BUILD_C_RECORDMCOUNT
+ifeq ("$(origin RECORDMCOUNT_WARN)", "command line")
+  RECORDMCOUNT_FLAGS = -w
+endif
 # Due to recursion, we must skip empty.o.
 # The empty.o file is created in the make process in order to determine
 #  the target endianness and word size. It is made before all other C
 #  files, including recordmcount.
 sub_cmd_record_mcount =					\
 	if [ $(@) != "scripts/mod/empty.o" ]; then	\
-		$(objtree)/scripts/recordmcount "$(@)";	\
+		$(objtree)/scripts/recordmcount $(RECORDMCOUNT_FLAGS) "$(@)";	\
 	fi;
 else
 sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
-- 
1.7.2.3


