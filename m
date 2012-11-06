Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab2KFUpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:45:31 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33312 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2KFUpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:45:30 -0500
MIME-Version: 1.0
In-Reply-To: <A5170602-2AE7-4EC4-BE0F-0DF015A287D7@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com>
 <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com> <A5170602-2AE7-4EC4-BE0F-0DF015A287D7@antoniou-consulting.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 6 Nov 2012 20:45:09 +0000
X-Google-Sender-Auth: aZHmV0rRQYY8CDsyq5eJOtTXn4w
Message-ID: <CACxGe6sJXubOSGGg5AmDK6DQMjv60H44nax9wUnnCGsqXGbfxw@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Rob Herring <robherring2@gmail.com>, Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 7:34 PM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
> On Nov 6, 2012, at 12:14 PM, Grant Likely wrote:
>> On Tue, Nov 6, 2012 at 10:30 AM, Pantelis Antoniou
>> <panto@antoniou-consulting.com> wrote:
>>> For hot-plugging, you need it. Whether kernel code can deal with
>>> large parts of the DT going away... How about we use the dead
>>> properties method and move/tag the removed modes as such, and not
>>> really remove them.
>>
>> Nodes already use krefs, and I'm thinking about making them kobjects
>> so that they appear in sysfs and we'll have some tools to figure out
>> when reference counts don't get decremented properly.
>>
>
> From the little I've looked in the of code, and the drivers, it's going
> to be pretty bad. I don't think all users take references properly, and
> we have a big global lock for accessing the DT.

I'm a lot more optimistic on this front... I wrote a patch today to
make the change and took some measurements:

On the versatile express qemu model I measured the free memory with
/proc/device-tree, with /sys/device-tree, and with both. Here's what I
found:

/proc/device-tree only: 114776kB free
/sys/device-tree only: 114792kB free
both enabled: 114716kB free

The back of a napkin calculation indicates that on this platform
/proc/devicetree costs 76kB and /sys/device-tree costs 60kb. I'm happy
to see that using /sys instead of /proc appears to be slightly cheaper
which makes it easier to justify the change. The diffstat makes me
even happier:

arch/arm/plat-omap/Kconfig                |    1 -
 arch/powerpc/platforms/pseries/dlpar.c    |   23 -----------
 arch/powerpc/platforms/pseries/reconfig.c |   40 ------------------
 drivers/of/Kconfig                        |    8 ----
 drivers/of/base.c                         |  116
++++++++++++++++++++++++++++------------------------
 drivers/of/fdt.c                          |    5 ++-
 fs/proc/Makefile                          |    1 -
 fs/proc/proc_devtree.c                    |   13 +-----
 fs/proc/root.c                            |    4 +-
 include/linux/of.h                        |   35 ++++++++++++----
 include/linux/proc_fs.h                   |   16 --------
 include/linux/string.h                    |   11 +++++
 12 files changed, 107 insertions(+), 166 deletions(-)

There are still a few odds and ends that need to be tidied up, but
I'll get it out for review shortly. I've not touched the sparc code
yet, and I need to take another look over the existing OF_DYNAMIC
code. I think that CONFIG_OF_DYNAMIC will probably go away and the add
node/property functions will get used by fdt.c and pdt.c for initial
construction of the device tree.

> Adding and removing nodes at runtime as part of the normal operation of
> the system (and not as something that happens once in a blue moon under
> controlled conditions) will uncover lots of bugs.

I'm hoping so! Its time to clean that mess up. :-) Fortunately adding
nodes is not where we're going to have problems. The problems will be
on node removal. Addition-only at least means we can have something
useful before hunting down and squashing all the bugs.

> So let's think about locking too

Yes, the locking does need to be sorted out.

g.
