Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab1C3CaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:30:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:40699 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab1C3CaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:30:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf symbols: Properly align symbol_conf.priv_size
Date: Tue, 29 Mar 2011 23:29:50 -0300
Message-Id: <1301452191-906-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1301452191-906-1-git-send-email-acme@infradead.org>
References: <1301452191-906-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David S. Miller <davem@davemloft.net>

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
-- 
1.6.2.5

