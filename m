Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1FFTn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:43:26 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:45567 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab1FFTnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:43:24 -0400
Date: Mon, 6 Jun 2011 21:43:21 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: David C Niemi <dniemi@verisign.com>, cpufreq@vger.kernel.org,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: switching to top frequency too frequent with ondemand governor
 and no_hz
Message-ID: <20110606194321.GA1773@x4.trippels.de>
References: <20110601160805.GA1775@x4.trippels.de>
 <4DE6783E.70508@verisign.com>
 <20110601180038.GA1780@x4.trippels.de>
 <20110602114113.GA1771@x4.trippels.de>
 <BANLkTimB5OdiHhRKwB1KpuNnXD55MmXWjQ@mail.gmail.com>
 <20110606112015.GA1776@x4.trippels.de>
 <BANLkTik0UeiieJDY7FHJHC9H4fwgBTh=PQ@mail.gmail.com>
 <20110606141625.GA1768@x4.trippels.de>
 <BANLkTinWQ1YBWHsCgK_JfHqXwETCy1mxEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinWQ1YBWHsCgK_JfHqXwETCy1mxEQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.06.06 at 18:34 +0200, Vincent Guittot wrote:
> On 6 June 2011 16:16, Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> > On 2011.06.06 at 15:11 +0200, Vincent Guittot wrote:
> >> On 6 June 2011 13:20, Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> >> > On 2011.06.06 at 09:35 +0200, Vincent Guittot wrote:
> >> >> On 2 June 2011 13:41, Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> >> >> > On 2011.06.01 at 20:00 +0200, Markus Trippelsdorf wrote:
> >> >> >> But I have found the root cause of symptoms described above by
> >> >> >> bisection. It turned out that 2.6.39 is also affected, so I've bisected
> >> >> >> down to 2.6.38.
> >> >> >> This is the result:
> >> >> >>
> >> >> >>  5cb2c3bd0c5e0f3ced63f250ec2ad59d7c5c626a is the first bad commit
> >> >> >>  commit 5cb2c3bd0c5e0f3ced63f250ec2ad59d7c5c626a
> >> >> >>  Author: Vincent Guittot <vincent.guittot@linaro.org>
> >> >> >>  Date:   Mon Feb 7 17:14:25 2011 +0100
> >> >> >>
> >> >> >>      [CPUFREQ] calculate delay after dbs_check_cpu
> >> >> >>
> >> >> >> When I revert the above in 3.0-rc1 the CONFIG_NO_HZ=y symptoms vanish.
> >> >> >
> >> >>
> >> >> The patch, you have mentioned, solves a problem when ondemand governor
> >> >> goes  from highest frequency to a lower one. Without the patch, the
> >> >> governor uses the longest sampling period (sampling period * scaling
> >> >> down factor) with a low frequency during the 1st period after
> >> >> decreasing the frequency. This can lead to a large time frame
> >> >> (sampling period * scaling down factor) with a low frequency but an
> >> >> overloaded cpu.
> >> >
> >> > The problem with the patch is that it results in an ondemand behavior
> >> > that almost totally ignores the middle frequencies (2100 and 2500 MHz in
> >> > my case) with CONFIG_NO_HZ. If you also set the sampling_down_factor to
> >> > something like >=100 then the CPU will spend much of the time at the top
> >> > frequency even if there is no workload whatsoever.
> >> >
> >>
> >> In fact, one main goal of the ondemand governor is to switch to max
> >> frequency as soon as there is a cpu activity is detected to ensure the
> >> responsiveness of the system. If your idle activity is made of burst
> >> of cpu activity and your sampling period is small,  your sytems will
> >> switch between the highest and the lowest frequency. At the contrary,
> >> the conservative governor modifies the frequency in a step by step
> >> manner.
> >
> > Understood. But this a change in behavior due to your patch.
> >
> >> >> The other correction of the patch is linked to the powersave bias
> >> >> mode. The governor didn't use the right period for the low frequency
> >> >> step (freq_lo_jiffies) but a larger one (sampling period * scaling
> >> >> down factor). The ratio between low and high frequency was not the
> >> >> right one.
> >> >>
> >> >> Do you use the powersave bias mode ?
> >> >
> >> > No.
> >> >
> >> >> Could you give us more statistics : the number of state transition
> >> >> could be an interesting value. Is there a difference with and without
> >> >> CONFIG_NO_HZ ? What is your sampling rate ?
> >> >
> >> > These are my settings:
> >> >
> >> > ignore_nice_load 0
> >> > io_is_busy 0
> >> > powersave_bias 0
> >> > sampling_down_factor 200
> >> > sampling_rate 10000
> >> > sampling_rate_min 10000
> >> > up_threshold 95
> >> >
> >> > cat sys/devices/system/cpu/cpu0/cpufreq/stats/* on an otherwise idle
> >> > machine with CONFIG_NO_HZ and 5cb2c3bd0c5e0f reverted:
> >> > 3200000 532
> >> > 2500000 172
> >> > 2100000 2703
> >> > 800000 20995
> >> > 153
> >> >
> >>
> >> With this configuration (without the patch), there is a period of 2
> >> seconds with a low frequency when the governor comes back from the
> >> highest frequency. During these 2 seconds, you will not be able to go
> >> back to max frequency. So, if your cpu is overloaded during this 2
> >> seconds period, you will not increase your frequency. For this use
> >> case, your cpufreq responsiveness is more then 2 seconds.
> >
> > I don't see these 2 second delays (being stuck on a low frequency) on my
> > system. On the contrary as soon as there is sufficient load it switches
> > to the highest frequency immediately.
> >
> 
> Let assume that your system is at the highest frequency
> 
> without the patch, you have the following sequence :
> 
> ->do_dbs_timer
>     -> delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate *
> dbs_info->rate_mult); // delay will be equal to 10000*200=2000000us
>     -> dbs_check_cpu
>            Let assume that your cpu load is quite small
>           -> freq_next = max_load_freq / (dbs_tuners_ins.up_threshold
> - dbs_tuners_ins.down_differential); //freq_next is set to your lowest
> frequency
>           -> __cpufreq_driver_target(policy, freq_next, CPUFREQ_RELATION_L);
>     -> 	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
> 
> the delay value is set to sampling_rate * rate_mult but the frequency
> is the lowest one which is not the correct behavior of the
> sampling_down_factor feature.
> the patch only solves this issue.

> 
> IMHO, the previous results were "good" because of the bug in the
> sampling_down_factor which was "filtering" some cpu activities after
> decreasing the frequency.

OK, this explains the issue that I was seeing.

To prove the point here are the "emerge" times of the ncurses library in
Gentoo (unpacking, configuration, compiling and installing) for
different sampling_down_factors.

sampling_down_factor    merge time                                                                                                                   
(with your patch)                                                                                                                                    
1                       1 minute and 59 seconds.                                                                                                     
20                      1 minute and 47 seconds.                                                                                                     
100                     1 minute and 29 seconds.                                                                                                     
150                     1 minute and 24 seconds.                                                                                                     
200                     1 minute and 22 seconds.                                                                                                     
300                     1 minute and 20 seconds.                                                                                                     
500                     1 minute and 12 seconds.                                                                                                     
1500                    1 minute and 7 seconds.                                                                                                      
(with patch reverted)                                                                                                                                
1                       2 minutes and 4 seconds.                                                                                                     
20                      1 minute and 55 seconds.                                                                                                     
200                     1 minute and 41 seconds.                                                                                                     

As you can see your patch always beats the reverted case. It also shows
that sampling_down_factor makes a huge difference in compilation
time.

-- 
Markus
