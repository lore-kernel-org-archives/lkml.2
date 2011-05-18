Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab1ERBlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 21:41:20 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42007 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932728Ab1ERBlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 21:41:18 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Joe Perches <joe@perches.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH 4/4] checkpatch.pl: Add check for task comm references
Date: Tue, 17 May 2011 18:41:05 -0700
Message-Id: <1305682865-27111-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1305682865-27111-1-git-send-email-john.stultz@linaro.org>
References: <1305682865-27111-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that accessing current->comm needs to be protected,
avoid new current->comm or other task->comm usage by adding
a warning to checkpatch.pl.

Fair warning: I know zero perl, so this was written in the
style of "monkey see, monkey do". It does appear to work
in my testing though.

Thanks to Jiri Slaby, Michal Nazarewicz and Joe Perches
for help improving the regex!

Close review and feedback would be appreciated.

CC: Joe Perches <joe@perches.com>
CC: Michal Nazarewicz <mina86@mina86.com>
CC: Andy Whitcroft <apw@canonical.com>
CC: Jiri Slaby <jirislaby@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d867081..a16ded7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2868,6 +2868,12 @@ sub process {
 			WARN("usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" . $herecurr);
 		}
 
+# check for current->comm usage
+		my $comm_vars = qr/current|tsk|p|task|curr|t|me/;
+		if ($line =~ /\b$comm_vars\s*->\s*comm\b/) {
+			WARN("task comm access needs to be protected. Use get_task_comm, or printk's \%ptc formatting.\n" . $herecurr);
+		}
+
 # check for %L{u,d,i} in strings
 		my $string;
 		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
-- 
1.7.3.2.146.gca209

