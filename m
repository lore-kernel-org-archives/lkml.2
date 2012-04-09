Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2DICyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:54:43 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53136 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2DICyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:54:41 -0400
X-AuditID: 9c930197-b7b09ae000000a5d-ce-4f824f6df097
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] parse-events: Fix a possibly wrong memory dereference
Date: Mon,  9 Apr 2012 11:54:34 +0900
Message-Id: <1333940074-19052-8-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
References: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If set_op_prio() failed, the token will be freed at out_free,
then arg->op.op would turn out to be a dangle pointer. After
returning EVENT_ERROR from process_op(), free_arg() will be
called and then it will finally see the dangling pointer.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index e789275..bd078ba 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -1741,6 +1741,8 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 
 		if (set_op_prio(arg) == -1) {
 			event->flags |= EVENT_FL_FAILED;
+			/* arg->op.op (= token) will be freed at out_free */
+			arg->op.op = NULL;
 			goto out_free;
 		}
 
-- 
1.7.7.6

