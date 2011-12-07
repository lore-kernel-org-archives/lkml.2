Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab1LGBha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 20:37:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51897 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab1LGBh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 20:37:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EDEC34B.302@jp.fujitsu.com>
Date: Wed, 07 Dec 2011 10:37:15 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-btrfs@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 2/3] perf: allow processing single op args
References: <4EDEC207.90403@jp.fujitsu.com>
In-Reply-To: <4EDEC207.90403@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got following error from record with btrfs tracepoints:

  $ perf script
  Fatal: unknown op '-'

It seems that perf failed to handle '-' in the following format:

  print fmt: "%s", ((REC->id >= -9) || (REC->id <= 7)) ? "x" : "y"
                                ~
process_arg() have code to parse '-9' as a "single op" arg, which is
PRINT_OP as type, '-' as op and have '9' as right arg but no left arg.
However arg_num_eval() have no code to handle this "single op" arg
even it is parsed successfully.

This patch allow perf to process such "single op" args.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 tools/perf/util/trace-event-parse.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index c2adc76..b709f78 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1355,6 +1355,24 @@ static long long arg_num_eval(struct print_arg *arg)
 		val = arg_num_eval(arg->typecast.item);
 		break;
 	case PRINT_OP:
+		if (!arg->op.left || arg->op.left->type == PRINT_NULL) {
+			/* handle single op */
+			right = arg_num_eval(arg->op.right);
+			switch (arg->op.op[0]) {
+			case '!':
+				val = !right;
+				break;
+			case '+':
+				val = right;
+				break;
+			case '-':
+				val = -right;
+				break;
+			default:
+				die("unknown single op %s", arg->op.op);
+			}
+			break;
+		}
 		switch (arg->op.op[0]) {
 		case '|':
 			left = arg_num_eval(arg->op.left);
-- 
1.7.7.3


