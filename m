Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab0L0WAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 17:00:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:40042 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0L0WAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 17:00:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Franck Bui-Huu <fbuihuu@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/4] perf probe: Fix short file name probe location reporting
Date: Mon, 27 Dec 2010 20:00:13 -0200
Message-Id: <1293487213-533-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1293487213-533-1-git-send-email-acme@infradead.org>
References: <1293487213-533-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

After adding probes, perf-probe(1) reports the probes locations which include
filenames for certain cases.

But for short file names (whose length < 32), perf-probe didn't display the
name correctly. It actually skipped the first character.

Here's an example where 'icmp.c' was screwed:

   $ perf probe -n -a "icmp.c;sk=*"
   Add new events:
     probe:icmp_push_reply (on @cmp.c)
     probe:icmp_reply     (on @cmp.c)
     probe:icmp_reply_1   (on @cmp.c)
     probe:icmp_send      (on @cmp.c)
     probe:icmp_send_1    (on @cmp.c)
     probe:icmp_error     (on @cmp.c)
     probe:icmp_error_1   (on @cmp.c)
     probe:icmp_error_2   (on @cmp.c)
     probe:icmp_error_3   (on @cmp.c)

This patch fixes this bug in synthesize_perf_probe_point().

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <m31v588r9k.fsf@gmail.com>
Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 4bde988..d3af30d 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1068,13 +1068,13 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 			goto error;
 	}
 	if (pp->file) {
-		len = strlen(pp->file) - 31;
-		if (len < 0)
-			len = 0;
-		tmp = strchr(pp->file + len, '/');
-		if (!tmp)
-			tmp = pp->file + len;
-		ret = e_snprintf(file, 32, "@%s", tmp + 1);
+		tmp = pp->file;
+		len = strlen(tmp);
+		if (len > 30) {
+			tmp = strchr(pp->file + len - 30, '/');
+			tmp = tmp ? tmp + 1 : pp->file + len - 30;
+		}
+		ret = e_snprintf(file, 32, "@%s", tmp);
 		if (ret <= 0)
 			goto error;
 	}
-- 
1.6.2.5

