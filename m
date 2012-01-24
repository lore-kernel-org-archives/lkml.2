Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab2AXC7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:59:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581Ab2AXCqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:46:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:31 2012
Message-Id: <20120124023931.854823057@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Michael Abbott <michael.abbott@diamond.ac.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [089/129] [S390] fix cputime overflow in uptime_proc_show
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1352
Lines: 43

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit c3e0ef9a298e028a82ada28101ccd5cf64d209ee upstream.

For 32-bit architectures using standard jiffies the idletime calculation
in uptime_proc_show will quickly overflow. It takes (2^32 / HZ) seconds
of idle-time, or e.g. 12.45 days with no load on a quad-core with HZ=1000.
Switch to 64-bit calculations.

Cc: Michael Abbott <michael.abbott@diamond.ac.uk>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/uptime.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -11,15 +11,20 @@ static int uptime_proc_show(struct seq_f
 {
 	struct timespec uptime;
 	struct timespec idle;
+	cputime64_t idletime;
+	u64 nsec;
+	u32 rem;
 	int i;
-	cputime_t idletime = cputime_zero;
 
+	idletime = 0;
 	for_each_possible_cpu(i)
 		idletime = cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	monotonic_to_bootbased(&uptime);
-	cputime_to_timespec(idletime, &idle);
+	nsec = cputime64_to_jiffies64(idletime) * TICK_NSEC;
+	idle.tv_sec = div_u64_rem(nsec, NSEC_PER_SEC, &rem);
+	idle.tv_nsec = rem;
 	seq_printf(m, "%lu.%02lu %lu.%02lu\n",
 			(unsigned long) uptime.tv_sec,
 			(uptime.tv_nsec / (NSEC_PER_SEC / 100)),


