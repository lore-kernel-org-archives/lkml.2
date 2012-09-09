Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2III7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 04:59:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46521 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2III7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 04:59:30 -0400
Date: Sun, 9 Sep 2012 01:59:17 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-bfd14b9a7231e7cf77520bca1848c40c6b6360ae@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, penberg@kernel.org, dsahern@gmail.com,
        irina.tirdea@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, penberg@kernel.org, irina.tirdea@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1347116812-93646-2-git-send-email-dsahern@gmail.com>
References: <1347116812-93646-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Make a copy of filename for passing to basename
Git-Commit-ID: bfd14b9a7231e7cf77520bca1848c40c6b6360ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 09 Sep 2012 01:59:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bfd14b9a7231e7cf77520bca1848c40c6b6360ae
Gitweb:     http://git.kernel.org/tip/bfd14b9a7231e7cf77520bca1848c40c6b6360ae
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sat, 8 Sep 2012 09:06:50 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 8 Sep 2012 17:14:43 -0300

perf annotate: Make a copy of filename for passing to basename

The basename function may modify the string passed to it, so the string
should not be marked const.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1347116812-93646-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 51ef69c..04eafd3 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -984,7 +984,8 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 			    int context)
 {
 	struct dso *dso = map->dso;
-	const char *filename = dso->long_name, *d_filename;
+	char *filename;
+	const char *d_filename;
 	struct annotation *notes = symbol__annotation(sym);
 	struct disasm_line *pos, *queue = NULL;
 	u64 start = map__rip_2objdump(map, sym->start);
@@ -992,6 +993,10 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 	int more = 0;
 	u64 len;
 
+	filename = strdup(dso->long_name);
+	if (!filename)
+		return -ENOMEM;
+
 	if (full_paths)
 		d_filename = filename;
 	else
@@ -1042,6 +1047,8 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 		}
 	}
 
+	free(filename);
+
 	return more;
 }
 
