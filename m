Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3ACH6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 02:58:46 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:45632 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab3ACH6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 02:58:43 -0500
Message-ID: <50E53A15.8040007@synopsys.com>
Date: Thu, 3 Jan 2013 13:28:13 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "Gilad Ben Yossef" <giladb@ezchip.com>, Noam Camus <noamc@ezchip.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 26/31] ARC: Build system: Makefiles, Kconfig, Linker
 script
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <201211071413.49178.arnd@arndb.de> <50E4449A.7010606@synopsys.com> <201301021448.20119.arnd@arndb.de>
In-Reply-To: <201301021448.20119.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2013 08:18 PM, Arnd Bergmann wrote:
> On Wednesday 02 January 2013, Vineet Gupta wrote:
>> On Wednesday 07 November 2012 07:43 PM, Arnd Bergmann wrote:
>>> On Wednesday 07 November 2012, Vineet Gupta wrote:
>>> +menu "ARC CPU Configuration"
>>> +
>>> +choice
>>> +	prompt "ARC Core"
>>> +	default ARC_CPU_770
>>> +
>>> +config ARC_CPU_750D
>>> +	bool "ARC750D"
>>> +	help
>>> +	  Support for ARC750 core
>>> +
>>> +config ARC_CPU_770
>>> +	bool "ARC770"
>>> +	select ARC_CPU_REL_4_10
>>> +	help
>>> +	  Support for ARC770 core introduced with Rel 4.10 (Summer 2011)
>>> +	  This core has a bunch of cool new features:
>>> +	  -MMU-v3: Variable Page Sz (4k, 8k, 16k), bigger J-TLB (128x4)
>>> +                   Shared Address Spaces (for sharing TLB entires in MMU)
>>> +	  -Caches: New Prog Model, Region Flush
>>> +	  -Insns: endian swap, load-locked/store-conditional, time-stamp-ctr
>>> +
>>> +endchoice
>>> Same thing here: If the different CPUs can in theory run the same kernel
>>> code, they should allow that. It doesn't stop you from making the default
>>> to enable only one of them and optimize for that case.
>> Background: ARC770 supports newer instructions (LOCK/SCOND) + MMUv3 which are not
>> available on ARC750. So code needs to be built differently for each. Having said
>> that above config items don't have any code under them - they are just high level
>> selectors for correct MMU versions and e.g. whether we allow the usage of new insns.
> So a kernel built for ARC750 could potentially run on an ARC770, but not use
> all the features, right?

Only for features which are non conflicting - so even now a CONFIG_ARC_CPU_750
built kernel (so no LLOCK/SCOND support) will run fine on 770 hardware (which has
LLOCK/SCOND)- assuming everything else being constant. However MMUv3 (770 only)
has a different programming model vs. MMUv2 (e.g. TLB descriptor layout among
others) hence a kernel for MMU v2 "simply" can't run on MMUv3 w/o making
runtime-checks or runtime-overrides (akin to function pointers) in things like TLB
refill handlers and such.

> The way we handle this on ARM and PowerPC is to allow selecting each CPU
> individually,

> but falling back on the common subset. So you could build
> a kernel that supports running on ARC750 and on ARC770, but that would 
> make it impossible to use SMP, so on an ARC770 SMP machine, it would
> only run on the first CPU.

Good for pre-built distros and such ! Nice concept - I like it.

> If ARC770 cannot actually run the MMU_V2 code, that would mean that they
> are indeed mutually exclusive by design,

Given the immense hardware configurability of ARC, all crazy combinations are
possible - how many are practically used is a different topic. So someone could in
theory build 770 with MMUv2 and infact the current build system even allows that.
See ARC_CPU_{750,770} are only about selecting a bunch of defaults (MMU ver,
LLOCK)  - to prevent the user from hand doing that. So lets say we rip off both of
these (to emulate kernel built for one running on other) - then it would boil down
to letting support for both v2 and v3 co-exist (not to forget there's also an
arcane historic v1). Now these fellows really are mutually exclusive by design:
* code written for v3 won't work on v2 (e.g. ARC_REG_IC_PTAG doesn't exist)
* code written for v2 won't work on v3 (e.g ARC_REG_IC_PTAG needs to be written
for correct behaviour)

> unless you also support a NOMMU
> kernel. In that case you could only build a kernel for both 750 and 770
> if you don't use the MMU. That would be much less interesting for actually
> running things, but it could still make sense for build testing.
>
> If you don't need NOMMU support otherwise (I forgot whether or not you
> have this), you should of course not implement it just for this.

NOMMU is not supported yet.

So how do we conclude on this topic - given the caveats above ?

Thx,
-Vineet
