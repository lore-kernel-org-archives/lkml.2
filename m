Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab1C3HRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:17:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:47703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1C3HRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:17:34 -0400
Date: Wed, 30 Mar 2011 07:17:18 GMT
From: "tip-bot for David S. Miller" <davem@davemloft.net>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        davem@davemloft.net, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        davem@davemloft.net, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110328.175849.112593455.davem@davemloft.net>
References: <20110328.175849.112593455.davem@davemloft.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Properly align symbol_conf.priv_size
Message-ID: <tip-4d439517561d009e170e2fe20be1ba25e19abe75@git.kernel.org>
Git-Commit-ID: 4d439517561d009e170e2fe20be1ba25e19abe75
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 30 Mar 2011 07:17:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d439517561d009e170e2fe20be1ba25e19abe75
Gitweb:     http://git.kernel.org/tip/4d439517561d009e170e2fe20be1ba25e19abe75
Author:     David S. Miller <davem@davemloft.net>
AuthorDate: Tue, 29 Mar 2011 14:18:39 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 29 Mar 2011 14:18:39 -0300

perf symbols: Properly align symbol_conf.priv_size

If symbol_conf.priv_size is not a multiple of "sizeof(u64)" we'll bus
error on sparc64 in symbol__new because the "struct symbol *" pointer
is computed by adding symbol_conf.priv_size to the memory allocated.

We cannot isolate the fix to symbol__new and symbol__delete since the
private area is computed by subtracting the priv_size value from a
"struct symbol" pointer, so then the private area can still be
potentially unaligned.

So, simply align the symbol_conf.priv_size value in symbol__init()

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110328.175849.112593455.davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 8f73907..f06c10f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2406,6 +2406,8 @@ int symbol__init(void)
 	if (symbol_conf.initialized)
 		return 0;
 
+	symbol_conf.priv_size = ALIGN(symbol_conf.priv_size, sizeof(u64));
+
 	elf_version(EV_CURRENT);
 	if (symbol_conf.sort_by_name)
 		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
