Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab0C3Xqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:46:38 -0400
Received: from kroah.org ([198.145.64.141]:46020 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523Ab0C3XUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:01 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:53 2010
Message-Id: <20100330224753.366751809@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Masami Hiramatsu <mhiramat@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [052/156] perf probe: Fix probe_point buffer overrun
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Masami Hiramatsu <mhiramat@redhat.com>

commit 594087a04eea544356f9c52e83c1a9bc380ce80f upstream.

Fix probe_point array-size overrun problem. In some cases (e.g.
inline function), one user-specified probe-point can be
translated to many probe address, and it overruns pre-defined
array-size. This also removes redundant MAX_PROBES macro
definition.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20100312232217.2017.45017.stgit@localhost6.localdomain6>
[ Note that only root can create new probes. Eventually we should remove
  the MAX_PROBES limit, but that is a larger patch not eligible to
  perf/urgent treatment. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/builtin-probe.c     |    1 -
 tools/perf/util/probe-finder.c |    3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -48,7 +48,6 @@
 #include "util/probe-event.h"
 
 #define MAX_PATH_LEN 256
-#define MAX_PROBES 128
 
 /* Session management structure */
 static struct {
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -544,6 +544,9 @@ static void show_probepoint(Dwarf_Die sp
 	}
 	free_current_frame_base(pf);
 
+	if (pp->found == MAX_PROBES)
+		die("Too many( > %d) probe point found.\n", MAX_PROBES);
+
 	pp->probes[pp->found] = strdup(tmp);
 	pp->found++;
 }


