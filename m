Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab1C2A72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 20:59:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40718
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542Ab1C2A71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 20:59:27 -0400
Date: Mon, 28 Mar 2011 17:58:49 -0700 (PDT)
Message-Id: <20110328.175849.112593455.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: paulus@samba.org, mingo@elte.hu, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Properly align symbol_conf.priv_size
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If symbol_conf.priv_size is not a multiple of "sizeof(u64)" we'll bus
error on sparc64 in symbol__new because the "struct symbol *" pointer
is computed by adding symbol_conf.priv_size to the memory allocated.

We cannot isloate the fix to symbol__new and symbol__delete since the
private area is computed by subtracting the priv_size value from a
"struct symbol" pointer, so then the private area can still be
potentially unaligned.

So, simply align the symbol_conf.priv_size value in symbol__init()

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 17df793..76c09099 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2403,6 +2403,8 @@ int symbol__init(void)
 	if (symbol_conf.initialized)
 		return 0;
 
+	symbol_conf.priv_size = ALIGN(symbol_conf.priv_size, sizeof(u64));
+
 	elf_version(EV_CURRENT);
 	if (symbol_conf.sort_by_name)
 		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
