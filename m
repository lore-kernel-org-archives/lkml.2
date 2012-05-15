Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965527Ab2EOC3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:29:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:49866 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965500Ab2EOCSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 164/179] perf tools: do not look at ./config for configuration
Date: Mon, 14 May 2012 22:14:20 -0400
Message-ID: <1337048075-6132-165-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Nieder <jrnieder@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit aba8d056078e47350d85b06a9cabd5afcc4b72ea upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 tools/perf/util/config.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 8784649..1720d01 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -416,7 +416,6 @@ int perf_config_global(void)
 int perf_config(config_fn_t fn, void *data)
 {
 	int ret = 0, found = 0;
-	char *repo_config = NULL;
 	const char *home = NULL;
 
 	/* Setting $PERF_CONFIG makes perf read _only_ the given config file. */
@@ -438,12 +437,6 @@ int perf_config(config_fn_t fn, void *data)
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
1.7.9.6

