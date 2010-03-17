Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0CQOOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:14:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11078 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab0CQOOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:14:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=mNw1OUMCDk2YG9btyUiahzbC0/EnUO16yUtp3pW4IqBltuumfEY/KXx8qajgDQwAt
	QoSmsR2QvPPwH/Me0xI8Q==
Message-ID: <4ba0e3c7.1c185e0a.7786.ffffb1d9@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 17 Mar 2010 15:11:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf: fix stat attach bogus counts
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	When perf stat -p pid is used, the events must be enabled
	immediately as there is no exec and thus no enable_on_exec.

	Signed-off-by: Stephane Eranian <eranian@google.com>

--
 builtin-stat.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 95db31c..3a91fad 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -159,8 +159,10 @@ static void create_perf_stat_counter(int counter, int pid)
 		}
 	} else {
 		attr->inherit	     = inherit;
-		attr->disabled	     = 1;
-		attr->enable_on_exec = 1;
+		if (target_pid == -1) {
+			attr->disabled	     = 1;
+			attr->enable_on_exec = 1;
+		}
 
 		fd[0][counter] = sys_perf_event_open(attr, pid, -1, -1, 0);
 		if (fd[0][counter] < 0 && verbose)
