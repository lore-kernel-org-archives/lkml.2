Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab2HUQ3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:29:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32934 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab2HUQ3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:29:39 -0400
Date: Tue, 21 Aug 2012 09:29:18 -0700
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-2708bf3a30b7bfa02d60a3f03603b6b92d093f1a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, penberg@kernel.org,
        namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, penberg@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1345222583-3964-1-git-send-email-namhyung@kernel.org>
References: <1345222583-3964-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui gtk: Ensure not to call gtk_main_quit()
  twice
Git-Commit-ID: 2708bf3a30b7bfa02d60a3f03603b6b92d093f1a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:29:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2708bf3a30b7bfa02d60a3f03603b6b92d093f1a
Gitweb:     http://git.kernel.org/tip/2708bf3a30b7bfa02d60a3f03603b6b92d093f1a
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Sat, 18 Aug 2012 01:56:23 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 20 Aug 2012 09:29:12 -0300

perf ui gtk: Ensure not to call gtk_main_quit() twice

Currently the gtk_main_quit() is called twice when perf exits so the
following warning is emitted:

  [penberg@tux perf]$ ./perf report --gtk
  ^Cperf: Interrupt

  (perf:4048): Gtk-CRITICAL **: IA__gtk_main_quit: assertion `main_loops != NULL' failed

Fix it by not to call it unnecessarily.

Reported-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1345222583-3964-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/setup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
index ad40b36..ec1ee26 100644
--- a/tools/perf/ui/gtk/setup.c
+++ b/tools/perf/ui/gtk/setup.c
@@ -13,6 +13,8 @@ int perf_gtk__init(void)
 
 void perf_gtk__exit(bool wait_for_ok __used)
 {
+	if (!perf_gtk__is_active_context(pgctx))
+		return;
 	perf_error__unregister(&perf_gtk_eops);
 	gtk_main_quit();
 }
