Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0DLWBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 18:01:14 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:64810 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab0DLWBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 18:01:12 -0400
MIME-Version: 1.0
In-Reply-To: <201004122203.42436.trenn@suse.de>
References: <1270603319-28907-1-git-send-email-mike@android.com>
	 <201004091147.32505.trenn@suse.de>
	 <k2m8bb80c381004091350oa2dd702bk2e9647453c59d645@mail.gmail.com>
	 <201004122203.42436.trenn@suse.de>
Date: Mon, 12 Apr 2010 15:01:11 -0700
Message-ID: <j2r8bb80c381004121501vc6e9a6e4r37810aaf33fd8a4c@mail.gmail.com>
Subject: Re: [PATCH] sched: cpuacct: Track cpuusage for CPU frequencies
From: Mike Chan <mike@android.com>
To: Thomas Renninger <trenn@suse.de>
Cc: menage@google.com, balbir@linux.vnet.ibm.com, dwalker@fifo99.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 1:03 PM, Thomas Renninger <trenn@suse.de> wrote:
> On Friday 09 April 2010 10:50:33 pm Mike Chan wrote:
>> 2010/4/9 Thomas Renninger <trenn@suse.de>:
>> > On Wednesday 07 April 2010 03:21:59 Mike Chan wrote:
>> >> New file: cpuacct.cpufreq when CONFIG_CPU_FREQ_STATS is enabled.
>> >>
>> >> cpuacct.cpufreq reports the CPU time (nanoseconds) spent at each CPU
>> >> frequency
>> >>
>> >> Maximum number of frequencies supported is 32. As future architectures
>> >> are added that support more than 32 frequency levels, CPUFREQ_TABLE_MAX
>> >> in sched.c needs to be updated.
>> >
>> > Why is accounting of each frequency needed?
>>
>> The intent is to track time spent at each cpu frequency to measure
>> power consumption. Userspace can figure out the mapping between
>> frequency and power consumption. This is also a useful indication of
>> what kind of hw performance userspace apps need (does Chrome really
>> need 1ghz?).
>>
>> Paul Menage had suggested an integral earlier in my [RFC] patch. I
>> wasn't completely against the idea but it had a few shortcomings that
>> I couldn't think of decent solutions for. You would have to either
>> pre-define power consumption for the cpu frequences per-arch or board
>> file. Or have a way to calculate.
> Sounds as if this is for specific CPUs/boards only then.
> X86 boosting and PCC driver are hard, possibly impossible to track (in respect
> to real power consumption).
>

Good point, although the class of CPUs that would benefit would be
ones with fixed frequencies, very common in the ARM world. For X86 and
PPC, if they are not using CONFIG_CPU_FREQ_STAT these statistics will
not be enabled. Perhaps what I should really be checking for is
CONFIG_CPU_FREQ_TABLE.

>> > pcc-cpufreq driver can do every frequency in a range and supports
>> > hundreds of different frequencies, thus it does not depend on
>> > CPU_FREQ_TABLE. Would the average frequency be enough to track/account?
>> Humm, this is a tricky case we haven't yet run into for ARM. Average
>> frequency might not be too useful because power is not linear with
>> speed. We could possibly have buckets for speeds (hi/lo).
> Your whole concept sounds as if it requires limited amount of frequencies.
> Don't mind for the special case I mentioned.
>

True, this was mostly inspired by cpufreq stats/time_in_state file,
which shows how much time the CPU has spent globally at each
frequency.
However applying this to cpu acct groups allows us to track how
userspace applications are consuming processing power.

So here are some thoughts after everyone's feedback:

1) Keep tracking in kernel/sched.c: For CPUs that do not use fixed
frequencies (PPC, x86), this is disabled, as its too difficult (at
least for now) to track. Perhaps later someone with more intelligence
than myself and more knowledge of these architectures can figure out a
way to track.

2) Add cpuacct notifiers: Introduce cpuacct notifiers that board or
mach-cpu files could register. We have the benefit here that at the
arch level we know if / how many fixed frequencies we can run at. This
is probably going to result in a little bit of code duplication across
several architectures, omap, msm and tegra at least for Android.

3) Not useful for upstream. In which case this will go into our
android/common branch.

I'm slightly favoring #2. This also gives us the benefit of
(optionally) exporting some power integral value Paul Menage suggested
earlier, if such power numbers are available from the board-file.

-- Mike

>      Thomas
>
