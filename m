Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab0CWPMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:12:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab0CWPMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:12:21 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 5/5] cpufreq: Add support for actual freq
Date: Tue, 23 Mar 2010 16:12:18 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: akpm@linux-foundation.org, davej@redhat.com, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
References: <1269283121-11894-1-git-send-email-bp@amd64.org> <201003231251.18181.trenn@suse.de> <20100323142349.GG16493@aftab>
In-Reply-To: <20100323142349.GG16493@aftab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003231612.18907.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 March 2010 15:23:49 Borislav Petkov wrote:
> From: Thomas Renninger <trenn@suse.de>
> Date: Tue, Mar 23, 2010 at 12:51:18PM +0100
> 
> Hi,
> 
> > scaling_cur freq should show the frequency the kernel/cpufreq
> > subsystem thinks it's in.
> 
> Well, we have also
> /sys/devices/system/cpu/cpu<NUM>/cpufreq/cpuinfo_cur_freq and it reads
> also policy->cur. Why not show the actual frequency in scaling_cur_freq
> then?
> 
> > You show the average freq and the time of the measured average
> > frequency depends on when the cpufreq subsystem called getavg()
> > the last time.
> > Also the time frame of the average freq the cpufreq subsystem
> > gets when calling getavg() now depends on whether and how often
> > userspace calls scaling_cur_freq which influences switching policy.
> > 
> > Latest cpufrequtils (ver 006) supports cpufreq-aperf to check whether
> > cores enter boost mode. Len Brown afaik also has a userspace tool, but
> > if it has any advantages, it should IMO get integrated into cpufrequtils
> > which people know to use when looking at cpufreq.
> > 
> > I once thought about adding scaling_avg_freq which gets an own
> > aperf_mperf counter, but you don't know whether another app read out the
> > average freq in between and your expected measured time frame is wrong then.
> > You could remember aperf/mperf per pid and free the saved aperf/mperf value
> > if the process dies..., but what for if this can be read out in userspace.
> 
> Ah yes, I see what you mean. Yet, I still don't like the idea of having
> to use a special userspace tool just to read the actual frequency. How
> about we hook into <drivers/cpufreq/cpufreq_ondemand.c:dbs_check_cpu()>
> and passively output the freq_avg after being computed in
> 
>                 freq_avg = __cpufreq_driver_getavg(policy, j);
>                 if (freq_avg <= 0)
>                         freq_avg = policy->cur;
> 
> through sysfs. Hmm...?
But what data would you get then? It's defintely not cur_freq.
It's some kind of average, but you don't know the time frame.

I posted a solution with an extra aperf/mperf save for scaling_avg_freq
(or similar).
First read would return nothing valid.
cat scaling_avg_freq > /dev/null
watch -n1 cat scaling_avg_freq
would return the average freq of the last seconds, exactly the same
what you can do with cpufreq-aperf from userspace.
But if another user app does the same, it's messed up.
You can find out the pid of the process doing the cat and remember
aperf/mperf for it if it does not exist yet..., but now it gets to a
point where cpufreq-aperf is really more convenient and straight foward.

Possibly documenting cpufreq-aperf in Documentation/cpu-freq would
be worth it. Also mentioning "boost" somewhere would be great:
grep -i boost Documentation/cpu-freq/ -r
Documentation/cpu-freq/pcc-cpufreq.txt:This is due to "turbo boost" ...

Another idea is to have a separate cpufreq_avg_freq and update it on
every target() call, but that's overhead...


   Thomas

