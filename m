Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab1HXG7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:59:31 -0400
Received: from ozlabs.org ([203.10.76.45]:42198 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab1HXG6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:58:50 -0400
X-Mailbox-Line: From anton@samba.org Wed Aug 24 16:52:42 2011
Message-Id: <20110824065242.895239970@samba.org>
User-Agent: quilt/0.48-1
Date: Wed, 24 Aug 2011 16:40:14 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, emunson@mgebm.net
Cc: linux-kernel@vger.kernel.org, <stable@kernel.org>
Subject: [PATCH 1/4] perf symbols: Fix ppc64 SEGV in dso__load_sym with debuginfo files
References: <20110824064013.205515988@samba.org>
Content-Disposition: inline; filename=perf_fix_segv
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
--- linux-2.6-tip.orig/tools/perf/util/symbol.c	2011-08-19 12:33:08.271144414 +1000
+++ linux-2.6-tip/tools/perf/util/symbol.c	2011-08-19 12:33:21.501373684 +1000
@@ -1113,6 +1113,8 @@ static int dso__load_sym(struct dso *dso
 	}
 
 	opdsec = elf_section_by_name(elf, &ehdr, &opdshdr, ".opd", &opdidx);
+	if (opdshdr.sh_type != SHT_PROGBITS)
+		opdsec = NULL;
 	if (opdsec)
 		opddata = elf_rawdata(opdsec, NULL);
 


