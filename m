Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab0DUBw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 21:52:57 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42070 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753534Ab0DUBw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 21:52:56 -0400
Message-ID: <4BCE5A73.3000904@sgi.com>
Date: Tue, 20 Apr 2010 18:52:51 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Hedi Berriche <hedi@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [Patch 1/1] init: Provide a kernel start parameter to increase pid_max
 v2
References: <4BCE579C.5070100@sgi.com>
In-Reply-To: <4BCE579C.5070100@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry, the previous patch I sent was an incorrect version.  The arg specified
in the Documentation file was wrong.]

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
@@ -2033,6 +2033,17 @@ and is between 256 and 4096 characters.
 	pg.		[PARIDE]
 			See Documentation/blockdev/paride.txt.
 
+	pid_max=nn[KMG]	[KNL] Maximum number of PID's to use.  On a system
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
 	pirq=		[SMP,APIC] Manual mp-table setup
 			See Documentation/x86/i386/IO-APIC.txt.
 
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
