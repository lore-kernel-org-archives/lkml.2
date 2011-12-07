Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab1LGBiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 20:38:13 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51924 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab1LGBiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 20:38:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EDEC375.2090808@jp.fujitsu.com>
Date: Wed, 07 Dec 2011 10:37:57 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-btrfs@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 3/3] perf: allow typecast for signed value
References: <4EDEC207.90403@jp.fujitsu.com>
In-Reply-To: <4EDEC207.90403@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still I got following warning with btrfs tracepoints:

  $ perf script
  Warning: Error: expected type 5 but read 4
  Warning: Error: expected type 5 but read 0

I found that the complained format is:

  print fmt: "%s", (REC->val >= (u64)-4) ? "-" : __print_symbolic(...)
                                     ~
In perf's parser, the typecast, which is processed in process_paren(),
only expects that (unsigned) token or another parenthesis will follow
to the typecast.  It should expect signed tokens can be there too.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 tools/perf/util/trace-event-parse.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index b709f78..032f3de 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1645,10 +1645,11 @@ process_paren(struct event *event, struct print_arg *arg, char **tok)
 	type = read_token_item(&token);
 
 	/*
-	 * If the next token is an item or another open paren, then
-	 * this was a typecast.
+	 * If the next token is an item (might be signed, with single op "-")
+	 * or another open paren, then this was a typecast.
 	 */
 	if (event_item_type(type) ||
+	    (type == EVENT_OP && strcmp(token, "-") == 0) ||
 	    (type == EVENT_DELIM && strcmp(token, "(") == 0)) {
 
 		/* make this a typecast and contine */
-- 
1.7.7.3


