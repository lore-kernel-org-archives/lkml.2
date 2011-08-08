Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1HHPxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:53:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40603 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab1HHPxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:53:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jonathan Nieder <jrnieder@gmail.com>,
        632923@bugs.debian.org, Ben Hutchings <ben@decadent.org.uk>,
        Christian Ohm <chr.ohm@gmx.net>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/4] perf tools: do not look at ./config for configuration
Date: Mon,  8 Aug 2011 12:52:56 -0300
Message-Id: <1312818776-19530-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1312818776-19530-1-git-send-email-acme@infradead.org>
References: <1312818776-19530-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Nieder <jrnieder@gmail.com>

In addition to /etc/perfconfig and $HOME/.perfconfig, perf looks for
configuration in the file ./config, imitating git which looks at
$GIT_DIR/config.  If ./config is not a perf configuration file, it
fails, or worse, treats it as a configuration file and changes behavior
in some unexpected way.

"config" is not an unusual name for a file to be lying around and perf
does not have a private directory dedicated for its own use, so let's
just stop looking for configuration in the cwd.  Callers needing
context-sensitive configuration can use the PERF_CONFIG environment
variable.

Requested-by: Christian Ohm <chr.ohm@gmx.net>
Cc: 632923@bugs.debian.org
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Christian Ohm <chr.ohm@gmx.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110805165838.GA7237@elie.gateway.2wire.net
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/config.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index e02d78c..6c86eca 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -399,7 +399,6 @@ static int perf_config_global(void)
 int perf_config(config_fn_t fn, void *data)
 {
 	int ret = 0, found = 0;
-	char *repo_config = NULL;
 	const char *home = NULL;
 
 	/* Setting $PERF_CONFIG makes perf read _only_ the given config file. */
@@ -421,12 +420,6 @@ int perf_config(config_fn_t fn, void *data)
 		free(user_config);
 	}
 
-	repo_config = perf_pathdup("config");
-	if (!access(repo_config, R_OK)) {
-		ret += perf_config_from_file(fn, repo_config, data);
-		found += 1;
-	}
-	free(repo_config);
 	if (found == 0)
 		return -1;
 	return ret;
-- 
1.6.2.5

