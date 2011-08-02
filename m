Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1HBRC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 13:02:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab1HBRCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 13:02:51 -0400
Date: Tue, 2 Aug 2011 19:02:49 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: Have we changed /proc/stat idle statistics by NOHZ kernel?
Message-ID: <20110802170249.GA23698@tiehlicka.suse.cz>
References: <20110725143313.GE9445@tiehlicka.suse.cz>
 <20110801125916.1855ff3f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801125916.1855ff3f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 01-08-11 12:59:16, Andrew Morton wrote:
> On Mon, 25 Jul 2011 16:33:13 +0200
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > Hi,
> > we have a customer reporting that /proc/stat doesn't provide correct
> > results about idle time if the machine is idle.
> > The issue is caused by the fact that tickles kernel doesn't update
> > kstat_cpu(i).cpustat.idle while it is tickles. Tools that parse this
> > file interpret the unchanged value as 0% idle since the last time.
> > While I personally do not think that measuring the idle machine is
> > that important one could say that the semantic of the file has changed
> > with NOHZ which is not good as we are trying to keep this interface
> > stable.
> > One way to fix this is to consider the current status of idle in
> > show_stat. The very primitive attempt of that can be seen bellow (on
> > top of the current Linus tree). I know it has several issue it just
> > illustrates what I am trying to say.  It will not work if jiffies
> > overflow while the CPU was tickles and it also misses locking and
> > handling !NOHZ configuration.
> > 
> > I have also noticed we have get_cpu_idle_time_us which should do
> > something similar. Should it be used instead or it is more intrusive?
> > 
> > Btw. is this considered to be a problem at all?
> > 
> 
> I'd consider it a bug and a regression.  If the machine was idle and
> /proc/stat says "zero idle time" then that is simply incorrect.
> 
> Can we just cheat?  subtract elapsed R and D time from elapsed wall
> time and print that out?

I was thinking about that as well. Something like 
now - (cpustat.user + cpustat.system + cpustat.iowait)

but this has the similar problem because iowait is accounted the same
way as idle.
Or did you mean some other counters?

I am currently looking into using get_cpu_idle_time_us which should be
more convenient but I do not like that it calls update_ts_time_stats
unconditionally (because then we will race with governors which use that
function as well). 

I will try to rip the core out of the function and reuse it here. 
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
