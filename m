Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1LBUMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:12:17 -0500
Received: from smtprelay0032.b.hostedemail.com ([64.98.42.32]:51450 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751395Ab1LBUMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:12:16 -0500
X-Panda: scanned!
X-Spam-Summary: 2,-1.05263,0,b7cf883a0725da62,d41d8cd98f00b204,t.artem@lycos.com,mhocko@suse.cz:pomac@vapor.com:linux-kernel@vger.kernel.org:rjw@sisk.pl:tino.keitel@tikei.de,RULES_HIT:152:355:379:541:582:599:601:800:945:960:973:988:989:1152:1260:1277:1311:1313:1314:1345:1358:1437:1515:1516:1518:1534:1542:1593:1594:1676:1711:1730:1747:1766:1792:2393:2553:2559:2562:3027:3138:3355:3622:3834:3865:3867:3868:3869:3870:3871:3872:3873:3874:4250:4321:4362:4560:5007:6261:7576:9545:10004:10016:10400:10471:10967:11473:11658:11914:12043,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:none,DNSBL:none,Custom_rules:0:0:0
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 3911
Date: Fri, 2 Dec 2011 20:12:14 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: mhocko@suse.cz
Cc: pomac@vapor.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        tino.keitel@tikei.de
Message-ID: <594802130.20617.1322856734286.JavaMail.mail@webmail10>
References: <20111128222803.GA4925@pomac.netswarm.net>
 <20111129075242.GB2675@tiehlicka.suse.cz>
 <2146795727.780801.1322566727488.JavaMail.mail@webmail05>
 <20111202133515.GB21070@tiehlicka.suse.cz>
 <20111202164917.GA6139@tiehlicka.suse.cz>
 <20111202175932.GA3894@tiehlicka.suse.cz>
Subject: Re: Re: [PATCH] proc: Do not overflow get_{idle,iowait}_time for
 nohz (was: Re: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU
 usage)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.121.104]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 2, 2011, Michal Hocko wrote: 

> And the one with a more cleaned up changelog. No functional changes
> ---
> From 107887016b91de59194a93c751d040b05d5e37fe Mon Sep 17 00:00:00 2001
> From: Michal Hocko <>
> Date: Fri, 2 Dec 2011 16:17:03 +0100
> Subject: [PATCH] proc: Do not overflow get_{idle,iowait}_time for nohz
> 
> Since a25cac51 [proc: Consider NO_HZ when printing idle and iowait times]
> we are reporting idle/io_wait time also while a CPU is tickless. We rely
> on get_{idle,iowait}_time functions to retrieve proper data.
> 
> These functions, however, use usecs_to_cputime to translate micro
> seconds time to cputime64_t. This is just an alias to usecs_to_jiffies
> which reduces the data type from u64 to unsigned int and also checks
> whether the given parameter overflows jiffies_to_usecs(MAX_JIFFY_OFFSET)
> and returns MAX_JIFFY_OFFSET in that case.
> 
> When do we overflow depends on CONFIG_HZ but especially for
> CONFIG_HZ_300 it is quite low (1431649781) so we are getting
> MAX_JIFFY_OFFSET for >3000s! until we overflow unsigned int.
> Just for reference CONFIG_100 has an overflow window around 20s,
> CONFIG_250 ~8s and CONFIG_1000 ~2s.
> 
> This results in a bug when people saw [h]top going mad reporting 100%
> CPU usage even though there was basically no CPU load. The reason was
> simply that /proc/stat stopped reporting idle/io_wait changes (and
> reported MAX_JIFFY_OFFSET) and so the only change happening was for
> user system time.
> 
> Let's use nsecs_to_jiffies64 instead which doesn't reduce the precision
> to 32b type and it is much more appropriate for cumulative time values
> (unlike usecs_to_jiffies which intended for timeout calculations).
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  fs/proc/stat.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/stat.c b/fs/proc/stat.c
> index 42b274d..2a30d67 100644
> --- a/fs/proc/stat.c
> +++ b/fs/proc/stat.c
> @@ -32,7 +32,7 @@ static cputime64_t get_idle_time(int cpu)
>  		idle = kstat_cpu(cpu).cpustat.idle;
>  		idle = cputime64_add(idle, arch_idle_time(cpu));
>  	} else
> -		idle = usecs_to_cputime(idle_time);
> +		idle = nsecs_to_jiffies64(1000 * idle_time);
>  
>  	return idle;
>  }
> @@ -46,7 +46,7 @@ static cputime64_t get_iowait_time(int cpu)
>  		/* !NO_HZ so we can rely on cpustat.iowait */
>  		iowait = kstat_cpu(cpu).cpustat.iowait;
>  	else
> -		iowait = usecs_to_cputime(iowait_time);
> +		iowait = nsecs_to_jiffies64(1000 * iowait_time);
>  
>  	return iowait;
>  }
> -- 
> 1.7.7.3

Thank you, this patch has fixed the issue for me.

Tested-by: Artem S. Tashkinov <t.artem@mailcity.com>
