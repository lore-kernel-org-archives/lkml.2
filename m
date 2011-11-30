Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1K3T6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 14:58:22 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46897 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab1K3T6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:58:17 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 23/25] dynamic_debug: allow wildcard modname in boot-line query
Date: Wed, 30 Nov 2011 12:56:52 -0700
Message-Id: <1322683014-13285-24-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Allow use of "*.dyndbg=+p" in boot-line, to turn on all debugging.
This works almost exactly like ddebug_query="+p"; it enables all
callsites for builtin modules, but does so after ddebug_query=... is
processed, and in the order of given mod.dyndbg args.

IOW, these are equivalent:

  ddebug_query="+p"		foo.dyndbg=+p
  ddebug_query="" *.dyndbg=+p	foo.dyndbg=+p

So this turns on module, function, line flags on all callsites,
which can then be enabled separately:

  *.dyndbg="+mfl"

Note that order matters if flags are set rather than added (= not +),
these are slightly different:

  " foo.dyndbg=p *.dyndbg=+mf "
  " *.dyndbg=+mf foo.dyndbg=p "

This obsoletes the remaining usage of ddebug_query; module specific
uses of ddebug_query were already covered by modname.dyndbg="...".  It
may however offend the tastes of some, or perhaps "*" should be
spelled as "dynamic_debug".  Removing ddebug_query probably also needs
a deprecation cycle, so I've deferred.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index fc3f68a..a077cd4 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -946,7 +946,8 @@ static __init void ddebug_boot_parse_args(void)
 		if (verbose)
 			pr_info("Param: %s, val: %s\n", param, val);
 
-		ddebug_exec_queries((val ? val : "+p"), module);
+		ddebug_exec_queries((val ? val : "+p"),
+				    !strcmp(module, "*") ? NULL : module);
 	}
 }
 
-- 
1.7.7.3

