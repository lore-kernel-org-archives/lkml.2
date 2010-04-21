Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab0DUBku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 21:40:50 -0400
Received: from relay1.sgi.com ([192.48.179.29]:33948 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab0DUBkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 21:40:49 -0400
Message-ID: <4BCE579C.5070100@sgi.com>
Date: Tue, 20 Apr 2010 18:40:44 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Hedi Berriche <hedi@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [Patch 1/1] init: Provide a kernel start parameter to increase pid_max
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [Patch 1/1] init: Provide a kernel start parameter to increase pid_max
From: Hedi Berriche <hedi@sgi.com>

On a system with a substantial number of processors, the early default pid_max
of 32k will not be enough.  A system with 1664 CPU's, there are 25163 processes
started before the login prompt.  It's estimated that with 2048 CPU's we will pass
the 32k limit.  With 4096, we'll reach that limit very early during the boot cycle,
and processes would stall waiting for an available pid.

This provides a kernel start parameter to increase the early maximum number of
pids available.  It does not change any of the defaults.

Signed-off-by: Hedi Berriche <hedi@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Robin Holt <holt@sgi.com>

---
 Documentation/kernel-parameters.txt |   11 +++++++++++
 kernel/pid.c                        |   30 ++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

--- linux-2.6.32.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.32/Documentation/kernel-parameters.txt
@@ -1327,6 +1327,17 @@ and is between 256 and 4096 characters.
 	max_luns=	[SCSI] Maximum number of LUNs to probe.
 			Should be between 1 and 2^32-1.
 
+	max_pid=nn[KMG]	[KNL] Maximum number of PID's to use.  On a system
+			with a large amount of processors, the default
+			pid_max may not be sufficient to allow the system
+			to boot.  The range of allowed values is limited from
+			pid_max_min to pid_max_max (configuration dependent.)
+			See kernel/pid.c and include/linux/threads.h for
+			specific values.  Note that specifying a value
+			too small may cause the system to fail to boot,
+			so that value is ignored.  Using a value too large,
+			and the largest allowed value will be used instead.
+
 	max_report_luns=
 			[SCSI] Maximum number of LUNs received.
 			Should be between 1 and 16384.
--- linux-2.6.32.orig/kernel/pid.c
+++ linux-2.6.32/kernel/pid.c
@@ -53,6 +53,36 @@ int pid_max_max = PID_MAX_LIMIT;
 #define BITS_PER_PAGE		(PAGE_SIZE*8)
 #define BITS_PER_PAGE_MASK	(BITS_PER_PAGE-1)
 
+static int __init set_pid_max(char *str)
+{
+	u64 maxp;
+
+	if (!str)
+		return -EINVAL;
+
+	maxp = memparse(str, &str);
+
+	if (maxp < pid_max_min) {
+		pr_warning(
+		    "pid_max smaller than minimum allowed value (%u)\n",
+			pid_max_min);
+		return -EINVAL;
+	}
+	if (maxp > pid_max_max) {
+		pr_warning(
+		    "pid_max larger than maximum allowed value, using %u\n",
+			pid_max_max);
+		pid_max = pid_max_max;
+	} else {
+		pid_max = maxp;
+		pr_info("pid_max set to %u\n", pid_max);
+	}
+
+	return 0;
+}
+
+early_param("pid_max", set_pid_max);
+
 static inline int mk_pid(struct pid_namespace *pid_ns,
 		struct pidmap *map, int off)
 {
