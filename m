Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab2CARZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:25:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:60877 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2CARZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:25:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/4] perf tools: Ensure comm string is properly terminated
Date: Thu,  1 Mar 2012 14:25:27 -0300
Message-Id: <1330622728-12759-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1330622728-12759-1-git-send-email-acme@infradead.org>
References: <1330622728-12759-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

If threads in a multi-threaded process have names shorter than the main
thread the comm for the named threads is not properly terminated.

E.g., for the process 'namedthreads' where each thread is named noploop%d
where %d is the thread number:

Before:
    perf script -f comm,tid,ip,sym,dso
    noploop:4ads 21616  400a49 noploop (/tmp/namedthreads)
The 'ads' in the thread comm bleeds over from the process name.

After:
    perf script -f comm,tid,ip,sym,dso
       noploop:4 21616  400a49 noploop (/tmp/namedthreads)

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1330111898-68071-1-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 2044324..2a6f33c 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -74,6 +74,7 @@ static pid_t perf_event__get_comm_tgid(pid_t pid, char *comm, size_t len)
 			if (size >= len)
 				size = len - 1;
 			memcpy(comm, name, size);
+			comm[size] = '\0';
 
 		} else if (memcmp(bf, "Tgid:", 5) == 0) {
 			char *tgids = bf + 5;
-- 
1.7.9.123.g65da0

