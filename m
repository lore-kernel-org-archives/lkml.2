Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1K1Vl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:41:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab1K1Vl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:41:28 -0500
Date: Mon, 28 Nov 2011 22:41:26 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tino Keitel <tino.keitel@tikei.de>, linux-kernel@vger.kernel.org,
        "Artem S. Tashkinov" <t.artem@lycos.com>
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
 metering applications has gone crackers
Message-ID: <20111128214125.GA29558@tiehlicka.suse.cz>
References: <1718181782.740375.1322130615898.JavaMail.mail@webmail19>
 <201111271245.57772.rjw@sisk.pl>
 <20111128195533.GA26460@mac.home>
 <201111282119.26474.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111282119.26474.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon 28-11-11 21:19:26, Rafael J. Wysocki wrote:
> On Monday, November 28, 2011, Tino Keitel wrote:
> > On Sun, Nov 27, 2011 at 12:45:57 +0100, Rafael J. Wysocki wrote:
> > > On Sunday, November 27, 2011, Tino Keitel wrote:
> > > > On Thu, Nov 24, 2011 at 21:05:53 +0100, Tino Keitel wrote:
> > > > > On Thu, Nov 24, 2011 at 10:30:15 +0000, Artem S. Tashkinov wrote:
> > > > > > Hello,
> > > > > > 
> > > > > > I'd like to report a weird regression in Linux 3.2 (running rc3 now) - all CPU metering applications have gone terribly mad
> > > > > > under this kernel:
> > > > > 
> > > > > I get the same using top, htop and the gnome system monitor with kernel
> > > > > 3.2 on a Sandy Bridge quad core box, running Debian unstable.
> > > > 
> > > > I just tested 3.2-rc2, and see the same bug.
> > > 
> > > I'm seeing that too on one of my test boxes, but not all the time
> > > (i.e. there are periods in which the readings are correct).  The other boxes
> > > I've tested with 3.2-rc are fine in that respect.
> > > 
> > > Also, it seems that it shows 100%-(real load) when it is wrong.  So, it looks
> > > like there's an overflow somewhere in the CPU load measuring code, at least
> > > on some CPUs.
> > 
> > Hi,
> > 
> > I reverted this commit and so far it looks good:
> > 
> > commit a25cac5198d4ff2842ccca63b423962848ad24b2
> > Author: Michal Hocko <mhocko@suse.cz>
> > Date:   Wed Aug 24 09:40:25 2011 +0200
> > 
> >     proc: Consider NO_HZ when printing idle and iowait times
> > 
> > I'll report back tomorrow how the kernel behaves.
> 
> Hmm.  Michal, can you have a look at that, please?

Hmm, my testing didn't show anything like that. Could you post
cat /proc/stat collected every second during 30s or so?

Here is the output of my run with 3.2.0-rc3-00004-gdd38d29 and the attached config:
for i in `seq 30`; 
do 
	cat /proc/stat > `date +'%s'`
	sleep 1
done
export old_user=0 old_nice=0 old_sys=0 old_idle=0 old_iowait=0; 
grep cpu0 * | while read cpu user nice sys idle iowait rest; 
do 
	echo $cpu $(($user-$old_user)) $(($nice-$old_nice)) $(($sys-$old_sys)) $(($idle-$old_idle)) $(($iowait-$old_iowait))
	old_user=$user old_nice=$nice old_sys=$sys old_idle=$idle old_iowait=$iowait
done

Mostly no workload (idle desktop) - few seconds of bosy loop:
1322516060:cpu0 621150 1978 148367 299773 196163
1322516061:cpu0 4 0 3 92 0
1322516062:cpu0 16 0 9 79 0
1322516063:cpu0 0 0 0 97 0
1322516064:cpu0 70 0 2 28 0    << Busy loop started
1322516065:cpu0 100 0 0 0 0
1322516066:cpu0 100 0 0 0 0
1322516067:cpu0 41 0 1 58 0    << Busy loop finished
1322516068:cpu0 0 0 2 96 0
1322516069:cpu0 1 0 2 97 0
1322516070:cpu0 100 0 0 0 0
1322516071:cpu0 42 0 1 58 0
1322516072:cpu0 0 0 2 97 0
1322516073:cpu0 1 0 2 97 0
1322516074:cpu0 1 0 1 98 0
1322516075:cpu0 2 0 1 97 0
1322516076:cpu0 1 0 1 91 7
1322516077:cpu0 1 0 0 97 0
1322516078:cpu0 0 0 0 97 0
1322516079:cpu0 2 0 1 97 0
1322516080:cpu0 0 0 1 97 1
1322516081:cpu0 1 0 4 90 4
1322516082:cpu0 2 0 0 97 0
1322516083:cpu0 1 0 2 98 0
1322516084:cpu0 2 0 1 96 0
1322516085:cpu0 0 0 2 98 0
1322516086:cpu0 1 0 1 91 7
1322516087:cpu0 0 0 0 97 0
1322516088:cpu0 1 0 0 97 0
1322516089:cpu0 1 0 1 100 0

Which looks correct (matches USER_HZ 100) to me.
Governors are updating those values and maybe idle driver might be relevant.
Here is my setting:
$ grep . -r /sys/devices/system/cpu/cpuidle/
/sys/devices/system/cpu/cpuidle/current_driver:acpi_idle
/sys/devices/system/cpu/cpuidle/current_governor_ro:menu
$ grep . -r /sys/devices/system/cpu/cpufreq/
/sys/devices/system/cpu/cpufreq/ondemand/sampling_rate_min:10000
/sys/devices/system/cpu/cpufreq/ondemand/sampling_rate:10000
/sys/devices/system/cpu/cpufreq/ondemand/up_threshold:95
/sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor:1
/sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load:0
/sys/devices/system/cpu/cpufreq/ondemand/powersave_bias:0
/sys/devices/system/cpu/cpufreq/ondemand/io_is_busy:1

> 
> Rafael

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
