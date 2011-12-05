Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1LEI4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 03:56:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab1LEI4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 03:56:01 -0500
Date: Mon, 5 Dec 2011 09:55:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, pomac@vapor.com,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tino Keitel <tino.keitel@tikei.de>,
        "Artem S. Tashkinov" <t.artem@mailcity.com>
Subject: [PATCH for 3.2] proc: Do not overflow get_{idle,iowait}_time for nohz
Message-ID: <20111205085559.GA20044@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, Thomas,
this is a regression fix (reported https://lkml.org/lkml/2011/11/24/102)
introduced by an earlier patch merged in 3.2-rc4.
I am not sure what is the correct channel so I am adding both of you. 
The original nohz /proc/stat fixlet was picked by Andrew and later
merged by Thomas IIRC.

Thanks!

---
>From 1c74dec8565ef56f815dbbde333214e9e14410b8 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 2 Dec 2011 16:17:03 +0100
Subject: [PATCH] proc: Do not overflow get_{idle,iowait}_time for nohz

Since a25cac51 [proc: Consider NO_HZ when printing idle and iowait times]
we are reporting idle/io_wait time also while a CPU is tickless. We rely
on get_{idle,iowait}_time functions to retrieve proper data.

These functions, however, use usecs_to_cputime to translate micro
seconds time to cputime64_t. This is just an alias to usecs_to_jiffies
which reduces the data type from u64 to unsigned int and also checks
whether the given parameter overflows jiffies_to_usecs(MAX_JIFFY_OFFSET)
and returns MAX_JIFFY_OFFSET in that case.

When do we overflow depends on CONFIG_HZ but especially for
CONFIG_HZ_300 it is quite low (1431649781) so we are getting
MAX_JIFFY_OFFSET for >3000s! until we overflow unsigned int.
Just for reference CONFIG_HZ_100 has an overflow window around 20s,
CONFIG_HZ_250 ~8s and CONFIG_HZ_1000 ~2s.

This results in a bug when people saw [h]top going mad reporting 100%
CPU usage even though there was basically no CPU load. The reason was
simply that /proc/stat stopped reporting idle/io_wait changes (and
reported MAX_JIFFY_OFFSET) and so the only change happening was for
user system time.

Let's use nsecs_to_jiffies64 instead which doesn't reduce the precision
to 32b type and it is much more appropriate for cumulative time values
(unlike usecs_to_jiffies which intended for timeout calculations).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Tested-by: Artem S. Tashkinov <t.artem@mailcity.com>
---
 fs/proc/stat.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 42b274d..2a30d67 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -32,7 +32,7 @@ static cputime64_t get_idle_time(int cpu)
 		idle = kstat_cpu(cpu).cpustat.idle;
 		idle = cputime64_add(idle, arch_idle_time(cpu));
 	} else
-		idle = usecs_to_cputime(idle_time);
+		idle = nsecs_to_jiffies64(1000 * idle_time);
 
 	return idle;
 }
@@ -46,7 +46,7 @@ static cputime64_t get_iowait_time(int cpu)
 		/* !NO_HZ so we can rely on cpustat.iowait */
 		iowait = kstat_cpu(cpu).cpustat.iowait;
 	else
-		iowait = usecs_to_cputime(iowait_time);
+		iowait = nsecs_to_jiffies64(1000 * iowait_time);
 
 	return iowait;
 }
-- 
1.7.7.3

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
