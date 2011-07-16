Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1GPL0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:26:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab1GPLWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:22:54 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=XniPwxdQP1EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=mr3KQaQw5ee4Qqh_WgoA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112252.247623234@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/20] ftrace: Update filter when tracing enabled in set_ftrace_filter()
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-Update-filter-when-tracing-enabled-in-set_ftr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently, if set_ftrace_filter() is called when the ftrace_ops is
active, the function filters will not be updated. They will only be updated
when tracing is disabled and re-enabled.

Update the functions immediately during set_ftrace_filter().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 853f6f0..a0dc0de 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2869,6 +2869,10 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 
 	mutex_lock(&ftrace_lock);
 	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
+	if (!ret && ops->flags & FTRACE_OPS_FL_ENABLED
+	    && ftrace_enabled)
+		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+
 	mutex_unlock(&ftrace_lock);
 
 	mutex_unlock(&ftrace_regex_lock);
-- 
1.7.5.4


