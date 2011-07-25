Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750958Ab1GYEWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 00:22:20 -0400
Received: from ozlabs.org ([203.10.76.45]:54727 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab1GYEWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 00:22:14 -0400
Date: Mon, 25 Jul 2011 14:22:09 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, emunson@mgebm.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Fix ppc64 SEGV in dso__load_sym with debuginfo files
Message-ID: <20110725142209.66d540fd@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


64bit PowerPC debuginfo files have an empty function descriptor
section. I hit a SEGV when perf tried to use this section for
symbol resolution.

To fix this we need to check the section is valid and we can
do this by checking for type SHT_PROGBITS.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: <stable@kernel.org>
---

Index: linux-2.6-tip/tools/perf/util/symbol.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/symbol.c	2011-07-11 12:49:12.341506269 +1000
+++ linux-2.6-tip/tools/perf/util/symbol.c	2011-07-24 14:48:00.203783423 +1000
@@ -1111,6 +1111,8 @@ static int dso__load_sym(struct dso *dso
 	}
 
 	opdsec = elf_section_by_name(elf, &ehdr, &opdshdr, ".opd", &opdidx);
+	if (opdshdr.sh_type != SHT_PROGBITS)
+		opdsec = NULL;
 	if (opdsec)
 		opddata = elf_rawdata(opdsec, NULL);
 
