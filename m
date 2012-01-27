Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2A0RcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:32:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56095 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2A0RcS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:32:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAKfTPtAsO8z_8AnR8zSGZ9cm_7orDNxB3r09JAFk+2jdezUVmQ@mail.gmail.com>
References: <1324426147-16735-1-git-send-email-ccross@android.com>
	<4F1929E9.7070707@linaro.org>
	<CAMbhsRTbVqV6p0py9NGZrpFPf2yvp-B0dr+o-m7qbdja_-Lfzw@mail.gmail.com>
	<CAKfTPtAsO8z_8AnR8zSGZ9cm_7orDNxB3r09JAFk+2jdezUVmQ@mail.gmail.com>
Date: Fri, 27 Jan 2012 09:32:17 -0800
X-Google-Sender-Auth: 6B2YfFX9eml3mPqg5_-kS7b7e8s
Message-ID: <CAMbhsRQYVXTZ2pX4mBrM6=SyGTqn_GY8xsW4rt_e21zerEzctA@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/3] coupled cpuidle state support
From: Colin Cross <ccross@android.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>, linux-tegra@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 12:54 AM, Vincent Guittot
<vincent.guittot@linaro.org> wrote:
> On 20 January 2012 21:40, Colin Cross <ccross@android.com> wrote:
>> On Fri, Jan 20, 2012 at 12:46 AM, Daniel Lezcano
>> <daniel.lezcano@linaro.org> wrote:
>>> Hi Colin,
>>>
>>> this patchset could be interesting to resolve in a generic way the cpu
>>> dependencies.
>>> What is the status of this patchset ?
>>
>> I can't do much with it right now, because I don't have any devices
>> that can do SMP idle with a v3.2 kernel.  I've started working on an
>> updated version that avoids the spinlock, but it might be a while
>> before I can test and post it.  I'm mostly looking for feedback on the
>> approach taken in this patch, and whether it will be useful for other
>> SoCs besides Tegra and OMAP4.
>>
>
> Hi Colin,
>
> In your patch, you put in safe state (WFI for most of platform) the
> cpus that become idle and these cpus are woken up each time a new cpu
> of the cluster becomes idle. Then, the cluster state is chosen and the
> cpus enter the selected C-state. On ux500, we are using another
> behavior for synchronizing  the cpus. The cpus are prepared to enter
> the c-state that has been chosen by the governor and the last cpu,
> that enters idle, chooses the final cluster state (according to cpus'
> C-state). The main advantage of this solution is that you don't need
> to wake other cpus to enter the C-state of a cluster. This can be
> quite worth full when tasks mainly run on one cpu. Have you also think
> about such behavior when developing the coupled cpuidle driver ? It
> could be interesting to add such behavior.

Waking up the cpus that are in the safe state is not done just to
choose the target state, it's done to allow the cpus to take
themselves to the target low power state.  On ux500, are you saying
you take the cpus directly from the safe state to a lower power state
without ever going back to the active state?  I once implemented Tegra
that way, and it required lots of nasty synchronization to prevent
resetting the cpu at the same time that it was booting due to an
interrupt, and I was later told that Tegra can't handle that sequence
at all, although I haven't verified it yet.

On platforms that can't turn the cpus off in a random order, or that
can't take a cpu directly from the safe state to the target state,
something like these coupled cpuidle patches are required.  On
platforms that can, the low power modes can be implemented without
these patches, although it is very hard to do without race conditions.
