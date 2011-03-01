Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1CAI40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:56:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:36547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab1CAI4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:56:25 -0500
Date: Tue, 1 Mar 2011 08:55:51 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, daahern@cisco.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, daahern@cisco.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Fix vmlinux path when not using --symfs
Message-ID: <tip-a639dc64e52183a361c260e562e73b0800b89072@git.kernel.org>
Git-Commit-ID: a639dc64e52183a361c260e562e73b0800b89072
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 01 Mar 2011 08:55:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a639dc64e52183a361c260e562e73b0800b89072
Gitweb:     http://git.kernel.org/tip/a639dc64e52183a361c260e562e73b0800b89072
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 28 Feb 2011 13:54:38 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Feb 2011 13:54:38 -0300

perf symbols: Fix vmlinux path when not using --symfs

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
