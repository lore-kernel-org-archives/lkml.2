Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab2HMShr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:37:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49343 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2HMShe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:37:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/38] perf tools: Fix /etc config related installation
Date: Mon, 13 Aug 2012 15:36:46 -0300
Message-Id: <1344883039-13495-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344883039-13495-1-git-send-email-acme@infradead.org>
References: <1344883039-13495-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
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
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1344522713-27951-4-git-send-email-fweisbec@gmail.com
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.7.1

