Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab3ABOsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 09:48:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55150 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab3ABOsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 09:48:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC PATCH v1 26/31] ARC: Build system: Makefiles, Kconfig, Linker script
Date: Wed, 2 Jan 2013 14:48:19 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Noam Camus <noamc@ezchip.com>,
        linux-kernel@vger.kernel.org
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <201211071413.49178.arnd@arndb.de> <50E4449A.7010606@synopsys.com>
In-Reply-To: <50E4449A.7010606@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301021448.20119.arnd@arndb.de>
X-Provags-ID: V02:K0:PnuykyEZm+alIuuKw0Ya9VLR+jbwwZiLp4buF2PpgWG
 FjOS080mFjl/2oV67d6kZW9ZQduBPFLp02AxuvADj2paGAnZ8i
 WLahOaA76X0JQwXz6c6im+fDwV6iwQgyDp1DpxDe1X1PU53FV0
 fIiZdVT4p10lr+g54G398bi0ixAWvXNVSBkdol9wFioO0gXFMc
 uXPPebZQSJJPY+z4O6hiJfb+J8CfgnGMFAlbAzLvOc6Egvpbzr
 rkWn+nzF/za/eY7TwRm1H00Z065AuGu4yMs0SiNpvtrMwuLf0U
 dFBF7R0/VxVHlv+udl2zZldG+T4UAq7nqHR4NF+gWCNQUTCSX/
 rKSktWIKMYQ69URMtlbY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2013, Vineet Gupta wrote:
> On Wednesday 07 November 2012 07:43 PM, Arnd Bergmann wrote:
> > On Wednesday 07 November 2012, Vineet Gupta wrote:
> > 
> > Platform selection should generally be non-exclusive. Just remove the
> > "choice" statement here, and make sure that any platforms can be enabled
> > together to build a single kernel.
> 
> So technically this is not in same league as usage of devicetree. Although it
> seems to have it's own merits (single image, code coverage,..) but is this a hard
> requirement for all arches. Here's my problem.
> 
> We have default implementations of clocksource using in-core local TIMER1. This
> however might not suffice for some SMP ARC SoCs which need cross-core synchronized
> timers. Obviously they want to use their own versions. In orig code (not v1 - but
> in my new v2) I have a platform specific hook local_counter_setup() called from
> time_init(). With #def PLAT1 and #def PLAT2, there could be 2 mutually exclusive
> versions of those. With the "all-platform-build-together" paradigm, this simple
> design is not possible - not to mention the needless code bloat for a simple run
> in simulator. So now using devicetree, I first need to find what platform we are
> on and then need to setup a platform specific function pointer (and same applies
> to several other platform specific stuff). Is there a better way of doing this -
> maybe the long dy has taken toll on me :-(

Regarding the code bloat, there should be practically no run-time cost, because
all the decisions are made in __init functions that are discarded after boot.
There will be a little vmlinux size overhead from turning build-time into
run-time configuration though. Of course you don't have to always build
everything together, it's totally fine to have a separate defconfig file
for each platform that just enables the parts that are required, as long
as it's also possible to build an allyesconfig that enables everything
(or most things, in cases where there are hard reasons not to make something
a run-time decision)

The generic timer code is already quite flexible and allows plugging in
clocksources at run-time, as this is essential to do on x86.

The way to do this with device tree is normally not to identify a global
"platform", but rather to identify the individual devices. E.g. when
you have an SMP system with a synchronized timer, there would be
a device node describing that timer and your driver looks for that node.

> >> +menu "ARC CPU Configuration"
> >> +
> >> +choice
> >> +	prompt "ARC Core"
> >> +	default ARC_CPU_770
> >> +
> >> +config ARC_CPU_750D
> >> +	bool "ARC750D"
> >> +	help
> >> +	  Support for ARC750 core
> >> +
> >> +config ARC_CPU_770
> >> +	bool "ARC770"
> >> +	select ARC_CPU_REL_4_10
> >> +	help
> >> +	  Support for ARC770 core introduced with Rel 4.10 (Summer 2011)
> >> +	  This core has a bunch of cool new features:
> >> +	  -MMU-v3: Variable Page Sz (4k, 8k, 16k), bigger J-TLB (128x4)
> >> +                   Shared Address Spaces (for sharing TLB entires in MMU)
> >> +	  -Caches: New Prog Model, Region Flush
> >> +	  -Insns: endian swap, load-locked/store-conditional, time-stamp-ctr
> >> +
> >> +endchoice
> > 
> > Same thing here: If the different CPUs can in theory run the same kernel
> > code, they should allow that. It doesn't stop you from making the default
> > to enable only one of them and optimize for that case.
> 
> Background: ARC770 supports newer instructions (LOCK/SCOND) + MMUv3 which are not
> available on ARC750. So code needs to be built differently for each. Having said
> that above config items don't have any code under them - they are just high level
> selectors for correct MMU versions and e.g. whether we allow the usage of new insns.

So a kernel built for ARC750 could potentially run on an ARC770, but not use
all the features, right?

The way we handle this on ARM and PowerPC is to allow selecting each CPU
individually, but falling back on the common subset. So you could build
a kernel that supports running on ARC750 and on ARC770, but that would 
make it impossible to use SMP, so on an ARC770 SMP machine, it would
only run on the first CPU.

If ARC770 cannot actually run the MMU_V2 code, that would mean that they
are indeed mutually exclusive by design, unless you also support a NOMMU
kernel. In that case you could only build a kernel for both 750 and 770
if you don't use the MMU. That would be much less interesting for actually
running things, but it could still make sense for build testing.

If you don't need NOMMU support otherwise (I forgot whether or not you
have this), you should of course not implement it just for this.

> > 
> > For MMU, page size and endianess, I would not expect that to work though,
> > so they probably need to remain mutually exclusive.
> 
> Ofcourse - given that PAGE_SIZE needs to be a compile time constant.

Actually, it is possible to support multiple page sizes (I think IA64
does this), but I don't recommend implementing it unless you have
a specific need for that.

	Arnd

