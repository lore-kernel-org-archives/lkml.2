Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1HITnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:43:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:50079 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1HITnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:43:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>, Christian Ohm <chr.ohm@gmx.net>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/4] perf tools: Check $HOME/.perfconfig ownership
Date: Tue,  9 Aug 2011 16:43:06 -0300
Message-Id: <1312918988-24146-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1312918988-24146-1-git-send-email-acme@infradead.org>
References: <1312918988-24146-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.6.2.5

