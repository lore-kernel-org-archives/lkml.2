Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab1HEOXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 10:23:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab1HEOXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 10:23:52 -0400
Date: Fri, 5 Aug 2011 16:23:50 +0200
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, cpufreq@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 3/3] proc: consider NO_HZ when printing idle and iowait
 times
Message-ID: <20110805142349.GE12657@tiehlicka.suse.cz>
References: <20110802170249.GA23698@tiehlicka.suse.cz>
 <cover.1312544541.git.mhocko@suse.cz>
 <9314d03604802205b02524ebda1e534547042dfa.1312544541.git.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9314d03604802205b02524ebda1e534547042dfa.1312544541.git.mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-08-11 17:20:32, Michal Hocko wrote:
> show_stat handler of the /proc/stat file relies on kstat_cpu(cpu)
> statistics when priting information about idle and iowait times.
> This is OK if we are not using tickless kernel (CONFIG_NO_HZ) because
> counters are updated periodically.
> With NO_HZ things got more tricky because we are not doing idle/iowait
> accounting while we are tickless so the value might get outdated.
> Users of /proc/stat will notice that by unchanged idle/iowait values
> which is then interpreted as 0% idle/iowait time. From the user space
> POV this is an unexpected behavior and a change of the interface.
> 
> Let's fix this by using get_cpu_{idle,iowait}_time_us which accounts the
> total idle/iowait time since boot and it doesn't rely on sampling or any
> other periodic activity. Fall back to the previous behavior if NO_HZ is
> disabled or not configured.

I forgot to mention that this might be racy because we are updating
those per-cpu values without having preemption disabled or any other
locking which would be necessary as governors iterate over all CPUs.
Governors do not have to care about that because they are singletons. 
Introducing locks doesn't look like an option but I was thinking
about adding __get_cpu_{idle,iowait}_time_us which wouldn't call
update_ts_timestat and calculate the result instead.
I can add a patch which does that but I wanted to hear about general
approach first.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
