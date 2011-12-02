Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab1LBKjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 05:39:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab1LBKjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 05:39:23 -0500
Date: Fri, 2 Dec 2011 11:39:21 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>, pomac@vapor.com,
        linux-kernel@vger.kernel.org, tino.keitel@tikei.de,
        Len Brown <lenb@kernel.org>
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
Message-ID: <20111202103921.GA29180@tiehlicka.suse.cz>
References: <20111128222803.GA4925@pomac.netswarm.net>
 <201111292351.16233.rjw@sisk.pl>
 <20111130101227.GA3187@tiehlicka.suse.cz>
 <201111302056.54697.rjw@sisk.pl>
 <20111201140749.GB4269@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201140749.GB4269@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-12-11 15:07:49, Michal Hocko wrote:
[...]
> While implementation is not race free (we better not use locks in that
> path...) so we might race:
> 
> E.g.
> 
> CPU1			CPU2
> now = ktime_get
> 			tick_nohz_start_idle
> 				ts->idle_entrytime = now;
> if (ts->idle_active)
> 				ts->idle_active = 1
> [...]
> return idle_sleeptime
> 
> But this is OK because sleeptime will be more or less accurate. We just
> skip few ticks.
> 
> It would be worse if we had a race like:
> CPU1			CPU2
> now = ktime_get
> 			tick_nohz_start_idle
> 				now = ktime_get
> 				update_ts_time_stats()
> 				ts->idle_entrytime = now;
> 				ts->idle_active = 1
> if (ts->idle_active)
> 	delta = ktime_sub(now, idle_entrytime)
> 	ktime_add(idle_sleeptime, delta)
> 
> In this case we might get an overflow from ktime_sub but AFAIU the
> ktime_* magic the overflow should cause to get smaller idle_sleeptime
> in the end after ktime_add (we do not add a small number but rather
> subtract it), right?

Scratch that. Dunno why but I thought that ktime_t has unsigned values
but it is apparently not true (tv64 is s64). Anyway the above races should
be safe.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
