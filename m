Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab2KGPgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:36:07 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:17289
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428Ab2KGPgF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:36:05 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz98dI9371I936eI1432I1418Izz1de0h1202h1d1ah1d2ahzz8275bh8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h1155h)
Message-ID: <1352302401.4067.11.camel@atull-linux1>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
From: Alan Tull <atull@altera.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Date: Wed, 7 Nov 2012 09:33:21 -0600
In-Reply-To: <B1277EA3-9284-4856-A7E8-1B1CA9D30327@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
	 <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com>
	 <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com>
	 <A5170602-2AE7-4EC4-BE0F-0DF015A287D7@antoniou-consulting.com>
	 <CACxGe6sJXubOSGGg5AmDK6DQMjv60H44nax9wUnnCGsqXGbfxw@mail.gmail.com>
	 <B1277EA3-9284-4856-A7E8-1B1CA9D30327@antoniou-consulting.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-07 at 09:06 +0100, Pantelis Antoniou wrote:
> Hi Grant,
> 
> On Nov 6, 2012, at 9:45 PM, Grant Likely wrote:
> 
> > On Tue, Nov 6, 2012 at 7:34 PM, Pantelis Antoniou
> > <panto@antoniou-consulting.com> wrote:
> >> On Nov 6, 2012, at 12:14 PM, Grant Likely wrote:
> >>> On Tue, Nov 6, 2012 at 10:30 AM, Pantelis Antoniou
> >>> <panto@antoniou-consulting.com> wrote:
> >>>> For hot-plugging, you need it. Whether kernel code can deal with
> >>>> large parts of the DT going away... How about we use the dead
> >>>> properties method and move/tag the removed modes as such, and not
> >>>> really remove them.
> >>> 
> >>> Nodes already use krefs, and I'm thinking about making them kobjects
> >>> so that they appear in sysfs and we'll have some tools to figure out
> >>> when reference counts don't get decremented properly.
> >>> 
> >> 
> >> From the little I've looked in the of code, and the drivers, it's going
> >> to be pretty bad. I don't think all users take references properly, and
> >> we have a big global lock for accessing the DT.
> > 
> > I'm a lot more optimistic on this front... I wrote a patch today to
> > make the change and took some measurements:
> > 
> > On the versatile express qemu model I measured the free memory with
> > /proc/device-tree, with /sys/device-tree, and with both. Here's what I
> > found:
> > 
> > /proc/device-tree only: 114776kB free
> > /sys/device-tree only: 114792kB free
> > both enabled: 114716kB free
> > 
> > The back of a napkin calculation indicates that on this platform
> > /proc/devicetree costs 76kB and /sys/device-tree costs 60kb. I'm happy
> > to see that using /sys instead of /proc appears to be slightly cheaper
> > which makes it easier to justify the change. The diffstat makes me
> > even happier:
> > 
> > arch/arm/plat-omap/Kconfig                |    1 -
> > arch/powerpc/platforms/pseries/dlpar.c    |   23 -----------
> > arch/powerpc/platforms/pseries/reconfig.c |   40 ------------------
> > drivers/of/Kconfig                        |    8 ----
> > drivers/of/base.c                         |  116
> > ++++++++++++++++++++++++++++------------------------
> > drivers/of/fdt.c                          |    5 ++-
> > fs/proc/Makefile                          |    1 -
> > fs/proc/proc_devtree.c                    |   13 +-----
> > fs/proc/root.c                            |    4 +-
> > include/linux/of.h                        |   35 ++++++++++++----
> > include/linux/proc_fs.h                   |   16 --------
> > include/linux/string.h                    |   11 +++++
> > 12 files changed, 107 insertions(+), 166 deletions(-)
> > 
> 
> Interesting. Not so bad then.
> 
> > There are still a few odds and ends that need to be tidied up, but
> > I'll get it out for review shortly. I've not touched the sparc code
> > yet, and I need to take another look over the existing OF_DYNAMIC
> > code. I think that CONFIG_OF_DYNAMIC will probably go away and the add
> > node/property functions will get used by fdt.c and pdt.c for initial
> > construction of the device tree.
> 
> CONFIG_OF_DYNAMIC never made sense to me. Glad to see the config option
> gone. I'm not totally up to date with the -next dt stuff, but if we're
> there can we rename all the prom_ functions to something saner?
> 
I'd be glad to see the dynamic stuff be integrated better than it
currently is.  Currently unflatten_dt_node assumes that the flattened
tree will stay around and not be freed.  So using it to unflatten dynamic
nodes after boot is problematic if the nodes may be later removed.

> > 
> >> Adding and removing nodes at runtime as part of the normal operation of
> >> the system (and not as something that happens once in a blue moon under
> >> controlled conditions) will uncover lots of bugs.
> > 
> > I'm hoping so! Its time to clean that mess up. :-) Fortunately adding
> > nodes is not where we're going to have problems. The problems will be
> > on node removal. Addition-only at least means we can have something
> > useful before hunting down and squashing all the bugs.
> 
> I'll admit that removing nodes is going to be quite rare at least for
> me use cases. I did come across a couple of people that do hot-plugging
> (using something completely different) that could use it for sure.
>

We have been looking at an approach that would allow adding/deleting
whole nodes under userspace direction.  Such as a variation of the real-time
video processing system example where the FPGA has some IP blocks that are
dsp filters.  The user could rearrange them from
some userspace GUI without having to reboot.  For that to work, device nodes that
are removed really have to be freed or there's a memory leak.


> > 
> >> So let's think about locking too
> > 
> > Yes, the locking does need to be sorted out.
> > 
> 
> Perhaps come up with a dt-stress test tool/boot time validator?
> 
> > g.
> 
> Regards
> 
> -- Pantelis
> 
> P.S. Lots of teeth grinding in the ELCE about the lack of a DT preprocessor.
> The pinctrl arguments have been mentioned more than once.
> 
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 




