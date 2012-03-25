Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab2CYVMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 17:12:33 -0400
Received: from uucp.gnuu.de ([83.246.114.63]:2800 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab2CYVMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 17:12:32 -0400
From: =?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@alea.gnuu.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@alea.gnuu.de>
Subject: [PATCH 1/2] perf tools: Concatenate strings in expressions
Date: Sun, 25 Mar 2012 23:08:39 +0200
Message-Id: <05a6b9ad17375452aedc994c4553137750db0a13.1332709498.git.joerg@alea.gnuu.de>
X-Mailer: git-send-email 1.7.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracepoint event kvm_userspace_exit uses string snippet the C
compiler concatenates to a big string, e.g. "KVM_EXIT_" "UNKNOWN". The
parser of the data must do the same and join successive strings.

print fmt: "reason %s (%d)", … __print_symbolic(REC->reason, { 0, "KVM_EXIT_" "UNKNOWN" }, { 1, "KVM_EXIT_" "EXCEPTION" } …

Signed-off-by: Jörg Sommer <joerg@alea.gnuu.de>
---
 tools/perf/util/trace-event-parse.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 1a8d4dc..185e284 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1726,6 +1726,21 @@ process_arg_token(struct event *event, struct print_arg *arg,
 		}
 		break;
 	case EVENT_DQUOTE:
+		atom = token;
+		type = read_token_item(&token);
+
+		/* merge with following strings */
+		while (type == EVENT_DQUOTE) {
+			atom = realloc(atom, strlen(atom) + strlen(token) + 1);
+			strcat(atom, token);
+			free_token(token);
+			type = read_token_item(&token);
+		}
+
+		arg->type = PRINT_ATOM;
+		arg->atom.atom = atom;
+
+		break;
 	case EVENT_SQUOTE:
 		arg->type = PRINT_ATOM;
 		arg->atom.atom = token;
-- 
1.7.9.1

