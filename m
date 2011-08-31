Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1HaBtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 21:49:50 -0400
Received: from ozlabs.org ([203.10.76.45]:51255 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab1HaBtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 21:49:47 -0400
Date: Wed, 31 Aug 2011 11:49:44 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, emunson@mgebm.net,
        imunsie@au1.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf sort: Improve dso sort output by separating
 unresolved samples by type
Message-ID: <20110831114944.25df45df@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We currently roll up all unresolved kernel, user, hypervisor and guest
samples into the one bucket:

    59.64%  [unknown]         
    22.71%  [kernel.kallsyms] 
     9.40%  libj9jit26.so     

We can get a much better high level view by separating these unresolved
samples by symbol type:

    56.64%  [unknown:.]       
    22.71%  [kernel.kallsyms] 
     9.40%  libj9jit26.so     
     2.81%  [unknown:H]       

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-tip/tools/perf/util/sort.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/sort.c	2011-08-31 11:34:53.070439428 +1000
+++ linux-2.6-tip/tools/perf/util/sort.c	2011-08-31 11:37:57.543628167 +1000
@@ -111,6 +111,9 @@ sort__dso_cmp(struct hist_entry *left, s
 	struct dso *dso_r = right->ms.map ? right->ms.map->dso : NULL;
 	const char *dso_name_l, *dso_name_r;
 
+	if (!dso_l && !dso_r)
+		return right->level - left->level;
+
 	if (!dso_l || !dso_r)
 		return cmp_null(dso_l, dso_r);
 
@@ -128,13 +131,16 @@ sort__dso_cmp(struct hist_entry *left, s
 static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
 				    size_t size, unsigned int width)
 {
+	char unknown[] = "[unknown:.]";
+
 	if (self->ms.map && self->ms.map->dso) {
 		const char *dso_name = !verbose ? self->ms.map->dso->short_name :
 						  self->ms.map->dso->long_name;
 		return repsep_snprintf(bf, size, "%-*s", width, dso_name);
 	}
 
-	return repsep_snprintf(bf, size, "%-*s", width, "[unknown]");
+	unknown[strlen(unknown) - 2] = self->level;
+	return repsep_snprintf(bf, size, "%-*s", width, unknown);
 }
 
 struct sort_entry sort_dso = {
