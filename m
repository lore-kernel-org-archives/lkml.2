Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1HJJrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:47:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:43251 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab1HJJrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:47:11 -0400
Date: Wed, 10 Aug 2011 09:46:26 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-qgokmxsmvppwpc5404qhyk7e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, chr.ohm@gmx.net,
        peterz@infradead.org, efault@gmx.de, ben@decadent.org.uk,
        fweisbec@gmail.com, jrnieder@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, chr.ohm@gmx.net,
        efault@gmx.de, peterz@infradead.org, ben@decadent.org.uk,
        fweisbec@gmail.com, jrnieder@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Check $HOME/.perfconfig ownership
Git-Commit-ID: 069e3725dd9be3b759a98e8c80ac5fc38b392b23
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Aug 2011 09:46:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  069e3725dd9be3b759a98e8c80ac5fc38b392b23
Gitweb:     http://git.kernel.org/tip/069e3725dd9be3b759a98e8c80ac5fc38b392b23
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 9 Aug 2011 12:42:13 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 9 Aug 2011 12:42:13 -0300

perf tools: Check $HOME/.perfconfig ownership

Just like we do already for perf.data files.

Requested-by: Ingo Molnar <mingo@elte.hu>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Christian Ohm <chr.ohm@gmx.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-qgokmxsmvppwpc5404qhyk7e@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/config.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 6c86eca..fe02903 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -413,13 +413,32 @@ int perf_config(config_fn_t fn, void *data)
 	home = getenv("HOME");
 	if (perf_config_global() && home) {
 		char *user_config = strdup(mkpath("%s/.perfconfig", home));
-		if (!access(user_config, R_OK)) {
-			ret += perf_config_from_file(fn, user_config, data);
-			found += 1;
+		struct stat st;
+
+		if (user_config == NULL) {
+			warning("Not enough memory to process %s/.perfconfig, "
+				"ignoring it.", home);
+			goto out;
+		}
+
+		if (stat(user_config, &st) < 0)
+			goto out_free;
+
+		if (st.st_uid && (st.st_uid != geteuid())) {
+			warning("File %s not owned by current user or root, "
+				"ignoring it.", user_config);
+			goto out_free;
 		}
+
+		if (!st.st_size)
+			goto out_free;
+
+		ret += perf_config_from_file(fn, user_config, data);
+		found += 1;
+out_free:
 		free(user_config);
 	}
-
+out:
 	if (found == 0)
 		return -1;
 	return ret;
