Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab2HIOcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:32:13 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:45635 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932902Ab2HIOcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:32:08 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@gmail.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/3] perf tools: Fix /etc config related installation
Date: Thu,  9 Aug 2012 16:31:53 +0200
Message-Id: <1344522713-27951-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344522713-27951-1-git-send-email-fweisbec@gmail.com>
References: <1344522713-27951-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

Fix missing /etc/bash_completion.d directory creation, otherwise
the installation fails miserably on systems that don't have bash
completion installed yet or on specific target:

	   $ make DESTDIR=/tmp/junk-perf O=/tmp/pbuild -C tools/perf/ install
	   ...
	   install -m 755 bash_completion /tmp/junk-perf/etc/bash_completion.d/perf
	   install: cannot create regular file
	   `/tmp/junk-perf/etc/bash_completion.d/perf': No such file or directory
	   make: *** [install] Error 1
	   make: Leaving directory `/opt/sw/ahern/perf.git/tools/perf'

Also use sysconfdir variable instead of the hardcoded /etc to handle
overriden conf directory.

Reported-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 84b4227..a9458b9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -700,6 +700,7 @@ perfexecdir_SQ = $(subst ','\'',$(perfexecdir))
 template_dir_SQ = $(subst ','\'',$(template_dir))
 htmldir_SQ = $(subst ','\'',$(htmldir))
 prefix_SQ = $(subst ','\'',$(prefix))
+sysconfdir_SQ = $(subst ','\'',$(sysconfdir))
 
 SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
 
@@ -951,7 +952,8 @@ install: all
 	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
 	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
 	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
-	$(INSTALL) -m 755 bash_completion $(DESTDIR_SQ)/etc/bash_completion.d/perf
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d'
+	$(INSTALL) bash_completion '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
 
 install-python_ext:
 	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
-- 
1.7.5.4

