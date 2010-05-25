Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192Ab0EYUdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:33:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33206 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996Ab0EYUdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:33:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=BAL22jQw3oLM3e3Tb9s3aofQhMFi05FaiwQHdEeIiB/XOP23KRCFFBkdmmz+etgAQ
	PJb5t+oN5jBVfjzC9p3rw==
From: Venkatesh Pallipadi <venki@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Venkatesh Pallipadi <venki@google.com>
Subject: Re: [patch 1/2] genirq: Run irq handlers with interrupts disabled
Date: Tue, 25 May 2010 13:32:53 -0700
Message-Id: <1274819573-18977-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100326000405.758579387@linutronix.de>
References: <20100326000405.758579387@linutronix.de>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just noticed a minor side effect of this patch on /proc/stat.

As int handlers run with ints disabled, timer interrupt based
samples will no longer account for any irq time. As a result, irq
time in /proc/stat, top, etc will be mostly zero (unless some handler
is enabling ints).

This is not a problem on s390, powerpc, ia64 when VIRT_CPU_ACCOUNTING is
enabled.

May be we should gracefully call it out as zero, with patch like below?

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 Documentation/filesystems/proc.txt |    2 +-
 fs/proc/stat.c                     |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 6507d2a..8f5254a 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1123,7 +1123,7 @@ second).  The meanings of the columns are as follows, from left to right:
 - system: processes executing in kernel mode
 - idle: twiddling thumbs
 - iowait: waiting for I/O to complete
-- irq: servicing interrupts
+- irq: servicing interrupts (valid only with VIRT_CPU_ACCOUNTING, 0 otherwise)
 - softirq: servicing softirqs
 - steal: involuntary wait
 - guest: running a normal guest
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index bf31b03..d92bea8 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -46,7 +46,9 @@ static int show_stat(struct seq_file *p, void *v)
 		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
 		idle = cputime64_add(idle, arch_idle_time(i));
 		iowait = cputime64_add(iowait, kstat_cpu(i).cpustat.iowait);
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
 		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
+#endif
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
@@ -87,7 +89,9 @@ static int show_stat(struct seq_file *p, void *v)
 		idle = kstat_cpu(i).cpustat.idle;
 		idle = cputime64_add(idle, arch_idle_time(i));
 		iowait = kstat_cpu(i).cpustat.iowait;
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
 		irq = kstat_cpu(i).cpustat.irq;
+#endif
 		softirq = kstat_cpu(i).cpustat.softirq;
 		steal = kstat_cpu(i).cpustat.steal;
 		guest = kstat_cpu(i).cpustat.guest;
-- 
1.7.0.1

