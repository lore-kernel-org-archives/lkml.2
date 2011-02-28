Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1B1UKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 15:10:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36652 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab1B1UKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:10:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/1] perf symbols: Fix vmlinux path when not using --symfs
Date: Mon, 28 Feb 2011 17:10:22 -0300
Message-Id: <1298923822-25376-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1298923822-25376-1-git-send-email-acme@infradead.org>
References: <1298923822-25376-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The ec5761e cset introduced the symfs feature with a bug for loading vmlinux
files that ended up causing this failure:

[root@emilia v2.6.38-rc5+]# strace -e trace=open perf top --vmlinux ./vmlinux 2>&1 | tail -3
open("/./vmlinux", O_RDONLY)            = -1 ENOENT (No such file or directory)
./vmlinux with build id b9266bf40e98dadb5d43a2f3e95d3c5d4aff46dc not found, continuing without symbols
The ./vmlinux file can't be used
[root@emilia v2.6.38-rc5+]#

Remove the extra slash, just like is done in the DSO__ORIG_DSO handling in
dso__load() and other parts of the ec5761e cset.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <daahern@cisco.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 7821d0e..b1bf490 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1836,7 +1836,7 @@ int dso__load_vmlinux(struct dso *self, struct map *map,
 	int err = -1, fd;
 	char symfs_vmlinux[PATH_MAX];
 
-	snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s/%s",
+	snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s%s",
 		 symbol_conf.symfs, vmlinux);
 	fd = open(symfs_vmlinux, O_RDONLY);
 	if (fd < 0)
-- 
1.6.2.5

