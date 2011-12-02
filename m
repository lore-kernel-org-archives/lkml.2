Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab1LBQtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:49:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757Ab1LBQtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:49:19 -0500
Date: Fri, 2 Dec 2011 17:49:17 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: pomac@vapor.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        tino.keitel@tikei.de
Subject: [PATCH] proc: Do not overflow get_{idle,iowait}_time for nohz (was:
 Re: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage)
Message-ID: <20111202164917.GA6139@tiehlicka.suse.cz>
References: <20111128222803.GA4925@pomac.netswarm.net>
 <20111129075242.GB2675@tiehlicka.suse.cz>
 <2146795727.780801.1322566727488.JavaMail.mail@webmail05>
 <20111202133515.GB21070@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111202133515.GB21070@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 02-12-11 14:35:15, Michal Hocko wrote:
> On Tue 29-11-11 11:38:47, Artem S. Tashkinov wrote:
> > On Nov 29, 2011, Michal Hocko <mhocko@suse.cz> wrote: 
> >  
> > > As I have written in other email could you post your config and collect
> > > the following data?
> > > for i in `seq 30`; 
> > > do 
> > >         cat /proc/stat > `date +'%s'`
> > >         sleep 1
> > > done
> > > export old_user=0 old_nice=0 old_sys=0 old_idle=0 old_iowait=0; 
> > > 
> > > # for all your available CPUs
> > > grep cpu0 * | while read cpu user nice sys idle iowait rest; 
> > > do 
> > >         echo $cpu $(($user-$old_user)) $(($nice-$old_nice)) $(($sys-$old_sys)) $(($idle-$old_idle)) $(($iowait-$old_iowait))
> > >         old_user=$user old_nice=$nice old_sys=$sys old_idle=$idle old_iowait=$iowait
> > > done
> > 
> > 1322566208:cpu0 5199 0 2931 357890604 2541
> > 1322566209:cpu0 0 0 1 0 0
> > 1322566210:cpu0 0 0 0 0 0
> > 1322566211:cpu0 0 0 0 0 0
[...]
> 
> Could you post raw data as well? Ideally starting right after boot and
> collected for more than 30s (longer better...)

Ahh, missed that you attached data. And also noticed that you are using
CONFIG_HZ_300 which explains the problem and why I do cannot reproduce
it.

get_{idle,iowait}_time translates us to cputime64_t and it uses
usecs_to_cputime which is just an alias for usecs_to_jiffies and it does
	if (u > jiffies_to_usecs(MAX_JIFFY_OFFSET))
                return MAX_JIFFY_OFFSET;
which in your case (HZ=300) means that we overflow much more often than
for HZ==100. The patch below should fix this:
---
>From 23882e2aabe27934df4d23b0ed52749fd4f61ab4 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 2 Dec 2011 16:17:03 +0100
Subject: [PATCH] proc: Do not overflow get_{idle,iowait}_time for nohz

get_{idle,iowait}_time use usecs_to_cputime to translate micro seconds
time to cputime64_t. This is just an alias to usecs_to_jiffies which
reduces the data type from u64 to unsigned int and also checks whether
the given paramerer overflows jiffies_to_usecs(MAX_JIFFY_OFFSET) and
returns MAX_JIFFY_OFFSET in that case. How much we overflow depends on
CONFIG_HZ and especially for CONFIG_HZ_300 it is quite low (1431649781).

This results in a bug when people saw [h]top going mad reporting 100%
CPU usage even though there was basically no CPU load at all. The reason
was simply that /proc/stat stopped reporting idle/io_wait changes (and
reported MAX_JIFFY_OFFSET) and so the only change happenning was for
user system time.

Let's use nsecs_to_jiffies64 instead as it doesn't overflow.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
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
