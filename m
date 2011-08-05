Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab1HEQ6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:58:52 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33085 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1HEQ6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:58:48 -0400
Date: Fri, 5 Aug 2011 18:58:38 +0200
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        632923@bugs.debian.org, Christian Ohm <chr.ohm@gmx.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf: do not look at ./config for configuration
Message-ID: <20110805165838.GA7237@elie.gateway.2wire.net>
References: <20110707024506.GA32088@moongate.localnet>
 <1310010913.4280.36.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310010913.4280.36.camel@localhost>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to /etc/perfconfig and $HOME/.perfconfig, perf looks for
configuration in the file ./config, imitating git which looks at
$GIT_DIR/config.  If ./config is not a perf configuration file, it
fails, or worse, treats it as a configuration file and changes
behavior in some unexpected way.

"config" is not an unusual name for a file to be lying around and perf
does not have a private directory dedicated for its own use, so let's
just stop looking for configuration in the cwd.  Callers needing
context-sensitive configuration can use the PERF_CONFIG environment
variable.

Requested-by: Christian Ohm <chr.ohm@gmx.net>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Thoughts?

 tools/perf/util/config.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index e02d78ca..6c86eca8 100644
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
1.7.6

