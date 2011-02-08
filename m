Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1BHPRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:17:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:34191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab1BHPRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:17:21 -0500
Date: Tue, 8 Feb 2011 15:16:54 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110204125153.9507.49335.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110204125153.9507.49335.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/kprobes: Cleanup strict_strtol() using code
Message-ID: <tip-76022db323dd6d7c6958df3d595f7dedf7a14778@git.kernel.org>
Git-Commit-ID: 76022db323dd6d7c6958df3d595f7dedf7a14778
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Feb 2011 15:16:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76022db323dd6d7c6958df3d595f7dedf7a14778
Gitweb:     http://git.kernel.org/tip/76022db323dd6d7c6958df3d595f7dedf7a14778
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 4 Feb 2011 21:51:53 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Feb 2011 09:13:36 -0200

tracing/kprobes: Cleanup strict_strtol() using code

Since strict_strtol() accepts minus digits started with '-', it doesn't
need to invert after converting.

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20110204125153.9507.49335.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/trace/trace_kprobe.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 2dec9bc..2088893 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -767,16 +767,15 @@ static int __parse_probe_arg(char *arg, const struct fetch_type *t,
 		}
 		break;
 	case '+':	/* deref memory */
+		arg++;	/* Skip '+', because strict_strtol() rejects it. */
 	case '-':
 		tmp = strchr(arg, '(');
 		if (!tmp)
 			break;
 		*tmp = '\0';
-		ret = strict_strtol(arg + 1, 0, &offset);
+		ret = strict_strtol(arg, 0, &offset);
 		if (ret)
 			break;
-		if (arg[0] == '-')
-			offset = -offset;
 		arg = tmp + 1;
 		tmp = strrchr(arg, ')');
 		if (tmp) {
