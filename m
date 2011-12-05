Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1LEI4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 03:56:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab1LEI4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 03:56:37 -0500
Date: Mon, 5 Dec 2011 09:56:35 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: pomac@vapor.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        tino.keitel@tikei.de
Subject: Re: Re: [PATCH] proc: Do not overflow get_{idle,iowait}_time for
 nohz (was: Re: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU
 usage)
Message-ID: <20111205085635.GB20044@tiehlicka.suse.cz>
References: <20111128222803.GA4925@pomac.netswarm.net>
 <20111129075242.GB2675@tiehlicka.suse.cz>
 <2146795727.780801.1322566727488.JavaMail.mail@webmail05>
 <20111202133515.GB21070@tiehlicka.suse.cz>
 <20111202164917.GA6139@tiehlicka.suse.cz>
 <20111202175932.GA3894@tiehlicka.suse.cz>
 <594802130.20617.1322856734286.JavaMail.mail@webmail10>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <594802130.20617.1322856734286.JavaMail.mail@webmail10>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 02-12-11 20:12:14, Artem S. Tashkinov wrote:
> On Dec 2, 2011, Michal Hocko wrote: 
> 
> > And the one with a more cleaned up changelog. No functional changes
> > ---
> > From 107887016b91de59194a93c751d040b05d5e37fe Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <>
> > Date: Fri, 2 Dec 2011 16:17:03 +0100
> > Subject: [PATCH] proc: Do not overflow get_{idle,iowait}_time for nohz
> > 
> > Since a25cac51 [proc: Consider NO_HZ when printing idle and iowait times]
> > we are reporting idle/io_wait time also while a CPU is tickless. We rely
> > on get_{idle,iowait}_time functions to retrieve proper data.
> > 
> > These functions, however, use usecs_to_cputime to translate micro
> > seconds time to cputime64_t. This is just an alias to usecs_to_jiffies
> > which reduces the data type from u64 to unsigned int and also checks
> > whether the given parameter overflows jiffies_to_usecs(MAX_JIFFY_OFFSET)
> > and returns MAX_JIFFY_OFFSET in that case.
> > 
> > When do we overflow depends on CONFIG_HZ but especially for
> > CONFIG_HZ_300 it is quite low (1431649781) so we are getting
> > MAX_JIFFY_OFFSET for >3000s! until we overflow unsigned int.
> > Just for reference CONFIG_100 has an overflow window around 20s,
> > CONFIG_250 ~8s and CONFIG_1000 ~2s.
> > 
> > This results in a bug when people saw [h]top going mad reporting 100%
> > CPU usage even though there was basically no CPU load. The reason was
> > simply that /proc/stat stopped reporting idle/io_wait changes (and
> > reported MAX_JIFFY_OFFSET) and so the only change happening was for
> > user system time.
> > 
> > Let's use nsecs_to_jiffies64 instead which doesn't reduce the precision
> > to 32b type and it is much more appropriate for cumulative time values
> > (unlike usecs_to_jiffies which intended for timeout calculations).
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > ---
> >  fs/proc/stat.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/proc/stat.c b/fs/proc/stat.c
> > index 42b274d..2a30d67 100644
> > --- a/fs/proc/stat.c
> > +++ b/fs/proc/stat.c
> > @@ -32,7 +32,7 @@ static cputime64_t get_idle_time(int cpu)
> >  		idle = kstat_cpu(cpu).cpustat.idle;
> >  		idle = cputime64_add(idle, arch_idle_time(cpu));
> >  	} else
> > -		idle = usecs_to_cputime(idle_time);
> > +		idle = nsecs_to_jiffies64(1000 * idle_time);
> >  
> >  	return idle;
> >  }
> > @@ -46,7 +46,7 @@ static cputime64_t get_iowait_time(int cpu)
> >  		/* !NO_HZ so we can rely on cpustat.iowait */
> >  		iowait = kstat_cpu(cpu).cpustat.iowait;
> >  	else
> > -		iowait = usecs_to_cputime(iowait_time);
> > +		iowait = nsecs_to_jiffies64(1000 * iowait_time);
> >  
> >  	return iowait;
> >  }
> > -- 
> > 1.7.7.3
> 
> Thank you, this patch has fixed the issue for me.
> 
> Tested-by: Artem S. Tashkinov <t.artem@mailcity.com>

Thanks for retesting!

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
