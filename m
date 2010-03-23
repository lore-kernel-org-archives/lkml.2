Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab0CWOX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:23:27 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46441 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab0CWOX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:23:26 -0400
Date: Tue, 23 Mar 2010 15:23:49 +0100
From: Borislav Petkov <bp@amd64.org>
To: Thomas Renninger <trenn@suse.de>
Cc: akpm@linux-foundation.org, davej@redhat.com, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 5/5] cpufreq: Add support for actual freq
Message-ID: <20100323142349.GG16493@aftab>
References: <1269283121-11894-1-git-send-email-bp@amd64.org>
 <1269283121-11894-6-git-send-email-bp@amd64.org>
 <201003231251.18181.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003231251.18181.trenn@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>
Date: Tue, Mar 23, 2010 at 12:51:18PM +0100

Hi,

> scaling_cur freq should show the frequency the kernel/cpufreq
> subsystem thinks it's in.

Well, we have also
/sys/devices/system/cpu/cpu<NUM>/cpufreq/cpuinfo_cur_freq and it reads
also policy->cur. Why not show the actual frequency in scaling_cur_freq
then?

> You show the average freq and the time of the measured average
> frequency depends on when the cpufreq subsystem called getavg()
> the last time.
> Also the time frame of the average freq the cpufreq subsystem
> gets when calling getavg() now depends on whether and how often
> userspace calls scaling_cur_freq which influences switching policy.
> 
> Latest cpufrequtils (ver 006) supports cpufreq-aperf to check whether
> cores enter boost mode. Len Brown afaik also has a userspace tool, but
> if it has any advantages, it should IMO get integrated into cpufrequtils
> which people know to use when looking at cpufreq.
> 
> I once thought about adding scaling_avg_freq which gets an own
> aperf_mperf counter, but you don't know whether another app read out the
> average freq in between and your expected measured time frame is wrong then.
> You could remember aperf/mperf per pid and free the saved aperf/mperf value
> if the process dies..., but what for if this can be read out in userspace.

Ah yes, I see what you mean. Yet, I still don't like the idea of having
to use a special userspace tool just to read the actual frequency. How
about we hook into <drivers/cpufreq/cpufreq_ondemand.c:dbs_check_cpu()>
and passively output the freq_avg after being computed in

                freq_avg = __cpufreq_driver_getavg(policy, j);
                if (freq_avg <= 0)
                        freq_avg = policy->cur;

through sysfs. Hmm...?

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
