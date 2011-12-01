Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1LAOHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:07:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582Ab1LAOHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:07:51 -0500
Date: Thu, 1 Dec 2011 15:07:49 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>, pomac@vapor.com,
        linux-kernel@vger.kernel.org, tino.keitel@tikei.de,
        Len Brown <lenb@kernel.org>
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
Message-ID: <20111201140749.GB4269@tiehlicka.suse.cz>
References: <20111128222803.GA4925@pomac.netswarm.net>
 <201111292351.16233.rjw@sisk.pl>
 <20111130101227.GA3187@tiehlicka.suse.cz>
 <201111302056.54697.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111302056.54697.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Let's add Len to the CC for idle driver]

On Wed 30-11-11 20:56:54, Rafael J. Wysocki wrote:
> On Wednesday, November 30, 2011, Michal Hocko wrote:
> > On Tue 29-11-11 23:51:16, Rafael J. Wysocki wrote:
> > > On Tuesday, November 29, 2011, Michal Hocko wrote:
[...]
> > > > I haven't found any intel_idle machine in my lab so far and all other
> > > > acpi_idle machines seem to work (or at least randomly selected ones) so
> > > > this smells like a major difference in the setup.
> > > 
> > > I'm able to reproduce that with acpi_driver on one box, but not on demand.
> > 
> > And do you see the same thing (no idle/io_wait) updates?
> 
> Actaully, I was wrong.  The box I'm seeing the issue on also has "none"
> in /sys/devices/system/cpu/cpuidle/current_driver.  Sorry for the confusion.

OK. So we have seen the issue only with intel_idle and none drivers so
far. acpi_idle which is at my machines works just fine. 
I think we should focus on those drivers.

To summarize this issue. 
Users are seeing weird values reported by [h]top. CPUs seem to be at
100% even though there is nothing hogging them. /proc/stat collected
data on the affected system shown that idle/io_wait are not accounted
properly.
It has been identified that problem disappears if a25cac51 [proc:
Consider NO_HZ when printing idle and iowait times] is reverted. 
This patch fixes a bug when idle/io_wait times are not repororted
properly when a CPU is tickless. It relies on get_cpu_idle_time_us
which either reports sched_time idle_sleeptime or 
(idle_sleeptime + now-idle_entrytime) if we are idle at the moment.

While implementation is not race free (we better not use locks in that
path...) so we might race:

E.g.

CPU1			CPU2
now = ktime_get
			tick_nohz_start_idle
				ts->idle_entrytime = now;
if (ts->idle_active)
				ts->idle_active = 1
[...]
return idle_sleeptime

But this is OK because sleeptime will be more or less accurate. We just
skip few ticks.

It would be worse if we had a race like:
CPU1			CPU2
now = ktime_get
			tick_nohz_start_idle
				now = ktime_get
				update_ts_time_stats()
				ts->idle_entrytime = now;
				ts->idle_active = 1
if (ts->idle_active)
	delta = ktime_sub(now, idle_entrytime)
	ktime_add(idle_sleeptime, delta)

In this case we might get an overflow from ktime_sub but AFAIU the
ktime_* magic the overflow should cause to get smaller idle_sleeptime
in the end after ktime_add (we do not add a small number but rather
subtract it), right?
So it shouldn't be a big deal as well.

So the question is. What is the role of the idle driver here?

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
