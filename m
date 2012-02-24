Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab2BXTbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:31:46 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49952 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab2BXTbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:31:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dsahern@gmail.com designates 10.68.218.161 as permitted sender) smtp.mail=dsahern@gmail.com; dkim=pass header.i=dsahern@gmail.com
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf tools: ensure comm properly terminated If threads in a multi-threaded process have names shorter than the main thread the comm for the named threads is not properly terminated.
Date: Fri, 24 Feb 2012 12:31:38 -0700
Message-Id: <1330111898-68071-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

e.g., for the process 'namedthreads' where each thread is named noploop%d
where %d is the thread number:

Before:
    perf script -f comm,tid,ip,sym,dso
    noploop:4ads 21616  400a49 noploop (/tmp/namedthreads)
The 'ads' in the thread comm bleeds over from the process name.

After:
    perf script -f comm,tid,ip,sym,dso
       noploop:4 21616  400a49 noploop (/tmp/namedthreads)

Signed-off-by: David Ahern <dsahern@gmail.com>
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
1.7.5.4

