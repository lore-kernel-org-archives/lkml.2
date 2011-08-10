Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab1HJI1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:27:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:50573 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1HJI1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:27:07 -0400
Date: Wed, 10 Aug 2011 08:26:38 GMT
From: tip-bot for Jonathan Nieder <jrnieder@gmail.com>
Message-ID: <tip-aba8d056078e47350d85b06a9cabd5afcc4b72ea@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, chr.ohm@gmx.net,
        a.p.zijlstra@chello.nl, ben@decadent.org.uk, jrnieder@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, chr.ohm@gmx.net,
        a.p.zijlstra@chello.nl, ben@decadent.org.uk, jrnieder@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110805165838.GA7237@elie.gateway.2wire.net>
References: <20110805165838.GA7237@elie.gateway.2wire.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: do not look at ./config for configuration
Git-Commit-ID: aba8d056078e47350d85b06a9cabd5afcc4b72ea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Aug 2011 08:26:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aba8d056078e47350d85b06a9cabd5afcc4b72ea
Gitweb:     http://git.kernel.org/tip/aba8d056078e47350d85b06a9cabd5afcc4b72ea
Author:     Jonathan Nieder <jrnieder@gmail.com>
AuthorDate: Fri, 5 Aug 2011 18:58:38 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Aug 2011 09:46:32 -0300

perf tools: do not look at ./config for configuration

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
