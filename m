Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab0JRV04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:26:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39060 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933126Ab0JRV0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:26:55 -0400
X-Authority-Analysis: v=1.1 cv=QISHQ+x4xS+apxgDHgAvNvlUjyrXCzYsHvuXcbPYiKg= c=1 sm=0 a=OrGMES_b0tgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7gkXJVJtAAAA:8 a=meVymXHHAAAA:8 a=WpJrq3Wj8nnjNOLwjU4A:9 a=gqfhFpUgW0abB67MVfcA:7 a=KC6nLmr-wN_Nnoe8ipI9NQBE3QMA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=JmBWkid0h3cA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH v2][GIT PULL] ftrace: Remove recursion between recordmcount
 and scripts/mod/empty
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Oct 2010 17:26:53 -0400
Message-ID: <1287437213.16971.333.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/recordmcount-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/recordmcount-2


Steven Rostedt (1):
      ftrace: Remove recursion between recordmcount and scripts/mod/empty

----
 scripts/Makefile.build |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)
---------------------------
commit d7b4d6de57d414a6384376880f2caf7125a45494
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon Oct 18 14:42:00 2010 -0400

    ftrace: Remove recursion between recordmcount and scripts/mod/empty
    
    When DYNAMIC_FTRACE is enabled and we use the C version of recordmcount,
    all objects are run through the recordmcount program to create a
    separate section that stores all the callers of mcount.
    
    The build process has a special file: scripts/mod/empty.o. This is
    built from empty.c which is literally an empty file (except for a
    single comment). This file is used to find information about the target
    elf format, like endianness and word size.
    
    The problem comes up when we need to build recordmcount. The
    build process requires that empty.o is built first. The build rules
    for empty.o will try to execute recordmcount on the empty.o file.
    We get an error that recordmcount does not exist.
    
    To avoid this recursion, the build file will skip running recordmcount
    if the file that it is building is script/mod/empty.o.
    
    [ extra comment Suggested-by: Sam Ravnborg <sam@ravnborg.org> ]
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Tested-by: Ingo Molnar <mingo@elte.hu>
    Cc: Michal Marek <mmarek@suse.cz>
    Cc: linux-kbuild@vger.kernel.org
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 4db60b2..843bd4f 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -210,7 +210,13 @@ endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
 ifdef BUILD_C_RECORDMCOUNT
-cmd_record_mcount = $(objtree)/scripts/recordmcount "$(@)";
+# Due to recursion, we must skip empty.o.
+# The empty.o file is created in the make process in order to determine
+#  the target endianness and word size. It is made before all other C
+#  files, including recordmcount.
+cmd_record_mcount = if [ $(@) != "scripts/mod/empty.o" ]; then			\
+			$(objtree)/scripts/recordmcount "$(@)";			\
+		    fi;
 else
 cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \


