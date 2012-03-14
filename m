Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2CNAr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:47:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37651 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760064Ab2CNArV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:47:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAMbhsRRZ+xt179RN32-+eBWngbRow=MpKV1XcLvG-sHGF6VOJA@mail.gmail.com>
References: <1324426147-16735-1-git-send-email-ccross@android.com>
	<4F1929E9.7070707@linaro.org>
	<8762e8kqi6.fsf@ti.com>
	<CAMbhsRRZ+xt179RN32-+eBWngbRow=MpKV1XcLvG-sHGF6VOJA@mail.gmail.com>
Date: Tue, 13 Mar 2012 17:47:20 -0700
X-Google-Sender-Auth: lgUrPICN7usrNZNZQGgXqmdUlMg
Message-ID: <CAMbhsRRD2bdkcUZvScb-cF05e=R3h69bNVaTPFX4jBKBBOjuMg@mail.gmail.com>
Subject: Re: [PATCH 0/3] coupled cpuidle state support
From: Colin Cross <ccross@android.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 5:28 PM, Colin Cross <ccross@android.com> wrote:
> On Tue, Mar 13, 2012 at 4:52 PM, Kevin Hilman <khilman@ti.com> wrote:
>> Hi Colin,
>>
>> On 12/21/2011 01:09 AM, Colin Cross wrote:
>>
>>> To use coupled cpuidle states, a cpuidle driver must:
>>
>> [...]
>>
>>>     Provide a struct cpuidle_state.enter function for each state
>>>     that affects multiple cpus.  This function is guaranteed to be
>>>     called on all cpus at approximately the same time.  The driver
>>>     should ensure that the cpus all abort together if any cpu tries
>>>     to abort once the function is called.
>>
>> I've discoved the last sentence above is crucial, and in order to catch
>> all the corner cases I found it useful to have the struct
>> cpuidle_coupled in cpuidle.h so that the driver can check ready_count
>> itself (patch below, on top of $SUBJECT series.)
>
> ready_count is an internal state of core coupled code, and will change
> significantly in the next version of the patches.  Drivers cannot
> depend on it.
>
>> As you know, on OMAP4, when entering the coupled state, CPU0 has to wait
>> for CPU1 to enter its low power state before entering itself.  The first
>> pass at implementing this was to just spin waiting for the powerdomain
>> of CPU1 to hit off.  That works... most of the time.
>>
>> If CPU1 wakes up immediately (or before CPU0 starts checking), or more
>> likely, fails to hit the low-power state because of other hardware
>> "conditions", CPU0 will end up stuck in the loop waiting for CPU1.
>>
>> To solve this, in addition to checking the power state of CPU1, I also
>> check if (coupled->ready_count != cpumask_weight(&coupled->alive_coupled_cpus)).
>> If true, it means that CPU1 has already exited/aborted so CPU0 had
>> better abort as well.
>>
>> Checking the ready_count seemed like an easy way to do this, but did you
>> have any other mechanisms in mind for CPUs to communicate that they've
>> exited/aborted?
>
> Why not set a flag from CPU1 when it exits the low power state, and
> have CPU0 spin on the powerdomain register or the flag?  You can then
> use the parallel barrier function to ensure both cpus have seen the
> flag and reset it to 0 before returning.

I realized the parallel barrier helper was not included in the patch
set I posted, it will be in the next patch set.  Short version, no
caller to cpuidle_coupled_parallel_barrier will return before all cpus
in the coupled set have called it.  It allows you to resynchronize the
cpus after an abort to ensure they have all seen the abort flag before
clearing it and returning, leaving everything in the correct state for
the next idle attempt.
