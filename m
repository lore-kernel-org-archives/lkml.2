Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2DICzO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:55:14 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53136 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab2DICyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:54:40 -0400
X-AuditID: 9c930197-b7b09ae000000a5d-c9-4f824f6ddca6
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] parse-events: Fix a possible memory leak
Date: Mon,  9 Apr 2012 11:54:32 +0900
Message-Id: <1333940074-19052-6-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
References: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If event_read_fields failed in the middle, each member of
struct format_field should be freed also.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 773c928..710a9e8 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -1431,8 +1431,11 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 fail:
 	free_token(token);
 fail_expect:
-	if (field)
+	if (field) {
+		free(field->type);
+		free(field->name);
 		free(field);
+	}
 	return -1;
 }
 
-- 
1.7.7.6

