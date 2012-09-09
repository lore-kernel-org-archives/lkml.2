Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab2IIJEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 05:04:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46564 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2IIJEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 05:04:05 -0400
Date: Sun, 9 Sep 2012 02:00:13 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-1fb89448871500e5d5e7ad93d6dae68ee4fa464a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, penberg@kernel.org, srikar@linux.vnet.ibm.com,
        dsahern@gmail.com, irina.tirdea@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, penberg@kernel.org, srikar@linux.vnet.ibm.com,
        dsahern@gmail.com, irina.tirdea@gmail.com, tglx@linutronix.de
In-Reply-To: <1347116812-93646-3-git-send-email-dsahern@gmail.com>
References: <1347116812-93646-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Make a copy of exec path for passing to basename
Git-Commit-ID: 1fb89448871500e5d5e7ad93d6dae68ee4fa464a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 09 Sep 2012 02:00:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1fb89448871500e5d5e7ad93d6dae68ee4fa464a
Gitweb:     http://git.kernel.org/tip/1fb89448871500e5d5e7ad93d6dae68ee4fa464a
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sat, 8 Sep 2012 09:06:51 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 8 Sep 2012 17:15:04 -0300

perf probe: Make a copy of exec path for passing to basename

The basename function may modify the string passed to it, so the string
should not be marked const.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1347116812-93646-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 0dda25d..e8c72de 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2307,10 +2307,17 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 		function = NULL;
 	}
 	if (!pev->group) {
-		char *ptr1, *ptr2;
+		char *ptr1, *ptr2, *exec_copy;
 
 		pev->group = zalloc(sizeof(char *) * 64);
-		ptr1 = strdup(basename(exec));
+		exec_copy = strdup(exec);
+		if (!exec_copy) {
+			ret = -ENOMEM;
+			pr_warning("Failed to copy exec string.\n");
+			goto out;
+		}
+
+		ptr1 = strdup(basename(exec_copy));
 		if (ptr1) {
 			ptr2 = strpbrk(ptr1, "-._");
 			if (ptr2)
@@ -2319,6 +2326,7 @@ static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
 					ptr1);
 			free(ptr1);
 		}
+		free(exec_copy);
 	}
 	free(pp->function);
 	pp->function = zalloc(sizeof(char *) * MAX_PROBE_ARGS);
