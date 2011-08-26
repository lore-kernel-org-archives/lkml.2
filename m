Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1H0PIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 11:08:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab1H0O40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:56:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:01:20 2011
Message-Id: <20110826220120.509076650@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:58:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        632923@bugs.debian.org, Ben Hutchings <ben@decadent.org.uk>,
        Christian Ohm <chr.ohm@gmx.net>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [09/19] perf tools: do not look at ./config for configuration
In-Reply-To: <20110826220137.GA14059@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jonathan Nieder <jrnieder@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/util/config.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -416,7 +416,6 @@ int perf_config_global(void)
 int perf_config(config_fn_t fn, void *data)
 {
 	int ret = 0, found = 0;
-	char *repo_config = NULL;
 	const char *home = NULL;
 
 	/* Setting $PERF_CONFIG makes perf read _only_ the given config file. */
@@ -438,12 +437,6 @@ int perf_config(config_fn_t fn, void *da
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


