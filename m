Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab2FTKjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:39:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34286 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2FTKi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:38:58 -0400
Date: Wed, 20 Jun 2012 03:38:32 -0700
From: tip-bot for Borislav Petkov <bp@amd64.org>
Message-ID: <tip-8d240dd88cca33b704adf3fe281aa64b5aac2dd8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jkacur@redhat.com, rostedt@goodmis.org, tglx@linutronix.de,
        bp@amd64.org, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jkacur@redhat.com, rostedt@goodmis.org, tglx@linutronix.de,
        bp@amd64.org, borislav.petkov@amd.com
In-Reply-To: <20120329171140.GE6409@aftab>
References: <20120329171140.GE6409@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: Remove a superfluous check
Git-Commit-ID: 8d240dd88cca33b704adf3fe281aa64b5aac2dd8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 03:38:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d240dd88cca33b704adf3fe281aa64b5aac2dd8
Gitweb:     http://git.kernel.org/tip/8d240dd88cca33b704adf3fe281aa64b5aac2dd8
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Thu, 29 Mar 2012 19:11:40 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 14 Jun 2012 15:22:12 -0400

ftrace: Remove a superfluous check

register_ftrace_function() checks ftrace_disabled and calls
__register_ftrace_function which does it again.

Drop the first check and add the unlikely hint to the second one. Also,
drop the label as John correctly notices.

No functional change.

Link: http://lkml.kernel.org/r/20120329171140.GE6409@aftab

Cc: Borislav Petkov <bp@amd64.org>
Cc: John Kacur <jkacur@redhat.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a008663..b4f20fb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -312,7 +312,7 @@ static int remove_ftrace_list_ops(struct ftrace_ops **list,
 
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
-	if (ftrace_disabled)
+	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
 	if (FTRACE_WARN_ON(ops == &global_ops))
@@ -4299,16 +4299,12 @@ int register_ftrace_function(struct ftrace_ops *ops)
 
 	mutex_lock(&ftrace_lock);
 
-	if (unlikely(ftrace_disabled))
-		goto out_unlock;
-
 	ret = __register_ftrace_function(ops);
 	if (!ret)
 		ret = ftrace_startup(ops, 0);
 
-
- out_unlock:
 	mutex_unlock(&ftrace_lock);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(register_ftrace_function);
