Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1ADIUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:20:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:50102 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1ADIUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:20:31 -0500
Date: Tue, 4 Jan 2011 08:20:22 GMT
From: tip-bot for Franck Bui-Huu <fbuihuu@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
In-Reply-To: <m31v588r9k.fsf@gmail.com>
References: <m31v588r9k.fsf@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix short file name probe location reporting
Message-ID: <tip-32ae2ade462146729580117d9886cc9efd83dfbe@git.kernel.org>
Git-Commit-ID: 32ae2ade462146729580117d9886cc9efd83dfbe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 08:20:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  32ae2ade462146729580117d9886cc9efd83dfbe
Gitweb:     http://git.kernel.org/tip/32ae2ade462146729580117d9886cc9efd83dfbe
Author:     Franck Bui-Huu <fbuihuu@gmail.com>
AuthorDate: Thu, 23 Dec 2010 16:04:23 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 27 Dec 2010 19:48:21 -0200

perf probe: Fix short file name probe location reporting

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
