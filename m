Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab0HTVx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 17:53:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:18417 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab0HTVxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 17:53:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,242,1280732400"; 
   d="scan'208";a="315204071"
Date: Fri, 20 Aug 2010 14:53:53 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Jean Delvare <khali@nerim.net>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, Rudolf Marek <r.marek@assembler.cz>,
        "Wan, Huaxu" <huaxu.wan@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] drivers/hwmon/coretemp: Fix incorrect hot-removed CPU's core sensor issue
Message-ID: <20100820215353.GC22602@linux-os.sc.intel.com>
References: <1282172027-640-1-git-send-email-fenghua.yu@intel.com> <20100820102646.7659b6b7@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820102646.7659b6b7@hyperion.delvare>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 01:26:46AM -0700, Jean Delvare wrote:
> Hi Fenghua,
> 
> On Wed, 18 Aug 2010 15:53:45 -0700, Fenghua Yu wrote:
> > From: Fenghua Yu <fenghua.yu@intel.com>
> > When a CPU is hot-removed, its core sensor should be still available to upper
> > level application as long as the hot-removed CPU's HT sibling is still running.
> > A core sensor is invisible to user level only when all of siblings in a core are
> > hot-removed.
> 
> Good point. I admit I didn't think about this scenario when fixing the
> duplicate HT entries. I thought both hyperthreads would go away at the
> same time, but since then I learned that individual HT can be removed
> using the sysfs "online" attributes.
> 
> That being said, I'm curious if this is really a problem in practice?
> Why would one disable only one hyperthread on a given core? I can't
> think of a real-world scenario.

Overall we need to keep state integrity for hot-removed CPU and shared core
sensor. Without fixing this issue, we end up with inconsistent system info.

As for usage scenario, I can think of some:
1. Power saving. Management application may offline some threads or all thread
siblings to save power. Image all of HT is disabled during run-time, less power
is consumed with less performance.
2. RAS. A bad thread may be offlined which its sibling is still running. This
could be becaused of logical CPU spcific state e.g. instruction TLB.

> 
> I don't mean to suggest that we don't have to fix the problem. I'm
> simply trying to figure out how fast we need to fix it, and whether the
> fix is worth adding to the stable kernel series or not.
> 
> As you can see, the switch of hyperthreads on Core 1 caused hwmon
> device coretemp-isa-0001 to be removed and be replaced with
> coretemp-isa-0005. There is also a change in the underlying
> directories, /sys/class/hwmon/hwmon1/device now points
> to /sys/devices/platform/coretemp.5 instead
> of /sys/devices/platform/coretemp.1. This has three drawbacks:
> 1* Configuration statements from /etc/sensors.conf will no longer be
>    applied.
> 2* Some monitoring applications may lose their path to the sensors.
>    Thankfully, libsensors uses hwmon device paths rather than physical
>    device paths, so the effect should be limited, but other tools (e.g.
>    the fancontrol script) tend to prefer physical device paths, so they
>    will break.
> 3* If you disable several HTs at once, you have no guarantee that the
>    new hwmon devices will be numbered in the same order as the old hwmon
>    devices. If you are unlucky and the number changes, then all
>    libsensors-based applications will start reporting garbage.
> 
> I admit that these issues are not critical ones, and are rather
> unlikely to happen in the real world, but so is the problem you are
> trying to solve in the first place.
> 
> Point 1* could be easily solved by changing the way the coretemp device
> ID is allocated. Instead of using the CPU ID directly, we would use the
> smallest CPU ID amongst all the siblings. This ensures a consistent ID
> no matter which sibling is used.
> 
> Points 2* and 3*, however, can't be solved without reworking the driver
> significantly. I think we should not only skip duplicate HT entries on
> driver registration as my naive patch did. We should instead keep track
> of them, i.e. all coretemp entries should know the list of CPU entries
> they are backed up by, and a coretemp device would be unregistered only
> when this list shrinks to zero elements (all HT have been removed.)
> 
> As you said you agree to give a try to a rework of the coretemp driver
> to keep all related cores into the same hwmon device, I think this
> additional constraint might fit well in the new driver design. What do
> you think?

Yes, I agree with you on that. Since I'm rewriting coretemp/pkgtemp, this issue
will be fixed in a new coding.

Thanks.

-Fenghua
