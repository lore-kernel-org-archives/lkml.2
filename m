Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0IJDYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 23:24:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60319 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0IJDYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 23:24:13 -0400
X-Authority-Analysis: v=1.1 cv=wzyXQce4f/sB7S4CXh7s7HNi1LDwQ/VYTdqot4lsObg= c=1 sm=0 a=I9jzT8ZWCyQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=xn_2uDM6AAAA:8 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=2niUiYxm5_X9GpK37HgA:9 a=hbyIB03sRtfZeAUNYQMA:7 a=ZHPkAU_GWA2ea9-XN1BatS676iIA:4 a=PUjeQqilurYA:10 a=AlnqcuNMsHEA:10 a=UTB_XpHje0EA:10 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL][v2.6.36] tracing: t_start: reset
 FTRACE_ITER_HASH in case of seek/pread
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Swiecki <swiecki@google.com>,
        Eugene Teo <eugene@redhat.com>, stable@kernel.org,
        Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 09 Sep 2010 23:24:08 -0400
Message-ID: <1284089048.5786.752.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The previous fixed only fixed lseek, Chris's fix also handles pread().

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Chris Wright (1):
      tracing: t_start: reset FTRACE_ITER_HASH in case of seek/pread

----
 kernel/trace/ftrace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
---------------------------
commit df09162550fbb53354f0c88e85b5d0e6129ee9cc
Author: Chris Wright <chrisw@sous-sol.org>
Date:   Thu Sep 9 16:34:59 2010 -0700

    tracing: t_start: reset FTRACE_ITER_HASH in case of seek/pread
    
    Be sure to avoid entering t_show() with FTRACE_ITER_HASH set without
    having properly started the iterator to iterate the hash.  This case is
    degenerate and, as discovered by Robert Swiecki, can cause t_hash_show()
    to misuse a pointer.  This causes a NULL ptr deref with possible security
    implications.  Tracked as CVE-2010-3079.
    
    Cc: Robert Swiecki <swiecki@google.com>
    Cc: Eugene Teo <eugene@redhat.com>
    Cc: <stable@kernel.org>
    Signed-off-by: Chris Wright <chrisw@sous-sol.org>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 83a16e9..fa7ece6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1510,6 +1510,8 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;
+		/* reset in case of seek/pread */
+		iter->flags &= ~FTRACE_ITER_HASH;
 		return iter;
 	}
 


