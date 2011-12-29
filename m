Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab1L2Uub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 15:50:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39546 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab1L2Uu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 15:50:28 -0500
Date: Thu, 29 Dec 2011 12:50:01 -0800
From: tip-bot for Nelson Elhage <nelhage@nelhage.com>
Message-ID: <tip-18e6093904abfd51671ff5846c2fdaba9ebbf21b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        nelhage@nelhage.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        nelhage@nelhage.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1324301972-22740-3-git-send-email-nelhage@nelhage.com>
References: <1324301972-22740-3-git-send-email-nelhage@nelhage.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: builtin-record: Provide advice if mmap'
 ing fails with EPERM.
Git-Commit-ID: 18e6093904abfd51671ff5846c2fdaba9ebbf21b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Dec 2011 12:50:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18e6093904abfd51671ff5846c2fdaba9ebbf21b
Gitweb:     http://git.kernel.org/tip/18e6093904abfd51671ff5846c2fdaba9ebbf21b
Author:     Nelson Elhage <nelhage@nelhage.com>
AuthorDate: Mon, 19 Dec 2011 08:39:31 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 23 Dec 2011 16:44:34 -0200

perf: builtin-record: Provide advice if mmap'ing fails with EPERM.

This failure is most likely due to running up against the
kernel.perf_event_mlock_kb sysctl, so we can tell the user what to do to
fix the issue.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1324301972-22740-3-git-send-email-nelhage@nelhage.com
Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f8fd14f..56bb447 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -272,8 +272,15 @@ try_again:
 		exit(-1);
 	}
 
-	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0)
+	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
+		if (errno == EPERM)
+			die("Permission error mapping pages.\n"
+			    "Consider increasing "
+			    "/proc/sys/kernel/perf_event_mlock_kb,\n"
+			    "or try again with a smaller value of -m/--mmap_pages.\n"
+			    "(current value: %d)\n", opts->mmap_pages);
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
+	}
 
 	if (rec->file_new)
 		session->evlist = evlist;
