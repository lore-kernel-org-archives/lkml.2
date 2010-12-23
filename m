Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0LWPEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 10:04:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65197 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0LWPE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 10:04:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=lIE3jJW1kNs3YKSR0cOyJHeWd6jeAZNFgULqb0TXghmKjy8Q8orrvM2KV/y9nOk5CQ
         OLIuuHpporAInwzRgbzf4SIrISYanDwAcO8GfAx1Fho+sC4xqf5egCmLJC5bmReequlu
         mysJhUb2ZW+O4/YQ96lsUbXHt1xcNGDvTskOo=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] perf-probe: fix perf-probe(1)'s report
Date: Thu, 23 Dec 2010 16:04:23 +0100
Message-ID: <m31v588r9k.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Franck Bui-Huu <fbuihuu@gmail.com>

After adding probes, perf-probe(1) reports the probes locations which
include filenames for certain cases.

But for short file names (whose length < 32), perf-probe didn't display
the name correctly. It actually skipped the first character.

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

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/perf/util/probe-event.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 10ad1ad..adc2620 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1077,13 +1077,13 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
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
@@ -1099,7 +1099,7 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 
 	return buf;
 error:
-	pr_debug("Failed to synthesize perf probe point: %s",
+	pr_debug("Failed to synthesize perf probe point: %s\n",
 		 strerror(-ret));
 	if (buf)
 		free(buf);
-- 
1.7.3.2

