Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1HXG7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:59:13 -0400
Received: from ozlabs.org ([203.10.76.45]:55457 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab1HXG6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:58:51 -0400
X-Mailbox-Line: From anton@samba.org Wed Aug 24 16:52:43 2011
Message-Id: <20110824065243.077125989@samba.org>
User-Agent: quilt/0.48-1
Date: Wed, 24 Aug 2011 16:40:16 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, emunson@mgebm.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] perf symbols: Preserve symbol scope when parsing /proc/kallsyms
References: <20110824064013.205515988@samba.org>
Content-Disposition: inline; filename=kallsyms_2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kallsyms__parse capitalises the symbol type, so every symbol 
is marked global. Remove this and fix symbol_type__is_a to handle
both local and global symbols.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-tip/tools/perf/util/symbol.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/symbol.c	2011-08-24 13:12:00.873072535 +1000
+++ linux-2.6-tip/tools/perf/util/symbol.c	2011-08-24 14:19:10.975819103 +1000
@@ -76,11 +76,13 @@ static void dso__set_sorted_by_name(stru
 
 bool symbol_type__is_a(char symbol_type, enum map_type map_type)
 {
+	symbol_type = toupper(symbol_type);
+
 	switch (map_type) {
 	case MAP__FUNCTION:
 		return symbol_type == 'T' || symbol_type == 'W';
 	case MAP__VARIABLE:
-		return symbol_type == 'D' || symbol_type == 'd';
+		return symbol_type == 'D';
 	default:
 		return false;
 	}
@@ -465,7 +467,7 @@ int kallsyms__parse(const char *filename
 		if (len + 2 >= line_len)
 			continue;
 
-		symbol_type = toupper(line[len]);
+		symbol_type = line[len];
 		len += 2;
 		symbol_name = line + len;
 		len = line_len - len;


