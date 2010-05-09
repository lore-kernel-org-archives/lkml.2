Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0EIXkQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 19:40:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:45151 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab0EIXjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 19:39:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/4] perf symbols: Consider unresolved DSOs in the dso__col_widt calculation
Date: Sun,  9 May 2010 20:39:26 -0300
Message-Id: <1273448369-7479-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273448369-7479-1-git-send-email-acme@infradead.org>
References: <1273448369-7479-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

By using BITS_PER_LONG / 4, that is the number of chars that will be
used in such cases as the DSO "name".

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 23d5dfd..46563e1 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -676,6 +676,13 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 			dso__calc_col_width(al->map->dso);
 
 		al->sym = map__find_symbol(al->map, al->addr, filter);
+	} else {
+		const unsigned int unresolved_col_width = BITS_PER_LONG / 4;
+
+		if (dsos__col_width < unresolved_col_width &&
+		    !symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
+		    !symbol_conf.dso_list)
+			dsos__col_width = unresolved_col_width;
 	}
 
 	if (symbol_conf.sym_list && al->sym &&
-- 
1.6.2.5

