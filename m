Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0DZTsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:48:15 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37165 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0DZTsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:48:14 -0400
Message-ID: <4BD5EDF9.6030504@sgi.com>
Date: Mon, 26 Apr 2010 12:48:09 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
CC: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Rik van Riel <riel@redhat.com>,
       John Stoffel <john@stoffel.org>, Hedi Berriche <hedi@sgi.com>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [Patch 1/1] init: Provide a kernel start parameter to increase pid_max
 v3
References: <20100421165934.GN16427@zorg.emea.sgi.com> <4BCF336B.1050706@redhat.com> <19407.20109.308816.104856@stoffel.org> <20100421193350.GU16427@zorg.emea.sgi.com> <19407.23456.469074.256306@stoffel.org> <20100421222414.GA26241@suse.de> <4BCF80F2.2010906@redhat.com> <20100421232200.GA22877@suse.de> <20100422102852.72837494@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1004220743080.9086@i5.linux-foundation.org> <20100425071606.GB1275@ucw.cz> <alpine.LFD.2.00.1004251002480.3739@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004251002480.3739@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [Patch 1/1] init: Provide a kernel start parameter to increase pid_max v3
From: Hedi Berriche <hedi@sgi.com>

On a system with a substantial number of processors, the early default pid_max
of 32k will not be enough.  A system with 1664 CPU's, there are 25163 processes
started before the login prompt.  It's estimated that with 2048 CPU's we will pass
the 32k limit.  With 4096, we'll reach that limit very early during the boot cycle,
and processes would stall waiting for an available pid.

This patch increases the early maximum number of pids available, and increases
the minimum number of pids that can be set during runtime.

Signed-off-by: Hedi Berriche <hedi@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Robin Holt <holt@sgi.com>

---
 include/linux/threads.h |    9 +++++++++
 kernel/pid.c            |    7 +++++++
 2 files changed, 16 insertions(+)

--- linux-2.6.32.orig/include/linux/threads.h
+++ linux-2.6.32/include/linux/threads.h
@@ -33,4 +33,13 @@
 #define PID_MAX_LIMIT (CONFIG_BASE_SMALL ? PAGE_SIZE * 8 : \
 	(sizeof(long) > 4 ? 4 * 1024 * 1024 : PID_MAX_DEFAULT))
 
+/*
+ * Define a minimum number of pids per cpu.  Heuristically based
+ * on original pid max of 32k for 32 cpus.  Also, increase the
+ * minimum settable value for pid_max on the running system based
+ * on similar defaults.  See kernel/pid.c:pidmap_init() for details.
+ */
+#define PIDS_PER_CPU_DEFAULT	1024
+#define PIDS_PER_CPU_MIN	8
+
 #endif
--- linux-2.6.32.orig/kernel/pid.c
+++ linux-2.6.32/kernel/pid.c
@@ -511,6 +511,13 @@ void __init pidhash_init(void)
 
 void __init pidmap_init(void)
 {
+	/* bump default and minimum pid_max based on number of cpus */
+	pid_max = min(pid_max_max, max(pid_max,
+				PIDS_PER_CPU_DEFAULT * num_possible_cpus()));
+	pid_max_min = max(pid_max_min,
+				PIDS_PER_CPU_MIN * num_possible_cpus());
+	pr_info("pid_max: default: %u minimum: %u\n", pid_max, pid_max_min);
+
 	init_pid_ns.pidmap[0].page = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	/* Reserve PID 0. We never call free_pidmap(0) */
 	set_bit(0, init_pid_ns.pidmap[0].page);

