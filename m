Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743Ab0FQUsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:48:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47968 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760727Ab0FQUsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:48:13 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
Date: Thu, 17 Jun 2010 13:48:11 -0700
Message-ID: <AANLkTilkblF0tfSnvLdVZVOi0r-dc32uAMuaiUlKesdn@mail.gmail.com>
Subject: Re: RFC: /sys/power/policy_preference
From: Mike Chan <mike@android.com>
To: Len Brown <lenb@kernel.org>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 2:05 PM, Len Brown <lenb@kernel.org> wrote:
> Create /sys/power/policy_preference, giving user-space
> the ability to express its preference for kernel based
> power vs. performance decisions in a single place.
>
> This gives kernel sub-systems and drivers a central place
> to discover this system-wide policy preference.
> It also allows user-space to not have to be updated
> every time a sub-system or driver adds a new power/perf knob.
>

This might be ok as a convince feature for userspace, but if that is
the sole intention, is 5 states enough? Are these values sufficient? I
can say at least for Android this will probably won't be as useful
(but perhaps on your platforms it makes sense).

As for a place for subsystems and drivers to check for what
performance mode you're in, do my driver how to check two places now?
Whats stopping someone from overriding cpufreq, or cpuidle? I might be
confused here (if I am someone please correct me) but isn't this
somewhat along he lines of pm runtime / pm qos if drivers want to
check what power / performance state the system is in?

-- Mike

> policy_preference has 5 levels, from max_performance
> through max_powersave.  Here is how 4 parts of the kernel
> might respond to those 5 levels:
>
> max_performance (unwilling to sacrifice any performance)
>        scheduler: default (optimized for performance)
>        cpuidle: disable all C-states except polling mode
>        ondemand: disable all P-states except max perf
>        msr_ia32_energy_perf_bias: 0 of 15
>
> performance (care primarily about performance)
>        scheduler: default (optimized for performance)
>        cpuidle: enable all C-states subject to QOS
>        ondemand: all P-states, using no bias
>        msr_ia32_energy_perf_bias: 3 of 15
>
> balanced (default)
>        scheduler: enable sched_mc_power_savings
>        cpuidle: enable all C-states subject to QOS
>        ondemand: all P-states, powersave_bias=5
>        msr_ia32_energy_perf_bias: 7 of 15
>
> powersave (can sacrifice measurable performance)
>        scheduler: enable sched_smt_power_savings
>        cpuidle: enable all C-states, subject to QOS
>        ondemand: disable turbo mode, powersave_bias=10
>        msr_ia32_energy_perf_bias: 11 of 15
>
> max_powersave (can sacrifice significant performance)
>        scheduler: enable sched_smt_power_savings
>        cpuidle: enable all C-states, subject to QOS
>        ondemand: min P-state (do not invoke T-states)
>        msr_ia32_energy_perf_bias: 15 of 15
>
> Note that today Linux is typically operating in the mode
> called "performance" above, rather than "balanced",
> which is proposed to be the default.  While a system
> should work well if left in "balanced" mode, it is likely
> that some users would want to use "powersave" when on
> battery and perhaps shift to "performance" on A/C.
>
> Please let me know what you think.
>
> thanks,
> Len Brown, Intel Open Source Technology Center
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
