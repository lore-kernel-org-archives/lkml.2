Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab2CBJwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:52:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644Ab2CBJwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:52:18 -0500
Date: Fri, 2 Mar 2012 01:51:26 -0800
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-cfbd70c17c4535e64be92ea442a2a45078a18184@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1330111898-68071-1-git-send-email-dsahern@gmail.com>
References: <1330111898-68071-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Ensure comm string is properly terminated
Git-Commit-ID: cfbd70c17c4535e64be92ea442a2a45078a18184
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 02 Mar 2012 01:51:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfbd70c17c4535e64be92ea442a2a45078a18184
Gitweb:     http://git.kernel.org/tip/cfbd70c17c4535e64be92ea442a2a45078a18184
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 24 Feb 2012 12:31:38 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Feb 2012 18:29:45 -0300

perf tools: Ensure comm string is properly terminated

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
