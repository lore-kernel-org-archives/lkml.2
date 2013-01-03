Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3ACI0C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 03:26:02 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60704 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab3ACI0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 03:26:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC PATCH v1 26/31] ARC: Build system: Makefiles, Kconfig, Linker script
Date: Thu, 3 Jan 2013 08:25:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "Gilad Ben Yossef" <giladb@ezchip.com>, Noam Camus <noamc@ezchip.com>,
        linux-kernel@vger.kernel.org
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <201301021448.20119.arnd@arndb.de> <50E53A15.8040007@synopsys.com>
In-Reply-To: <50E53A15.8040007@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301030825.45867.arnd@arndb.de>
X-Provags-ID: V02:K0:4qYRnwXaNkGWxpywwO5K9qN3LRHg6oOR3kC1CP5VR8Y
 g8+1r3FMeZyFdIM0Lu04QQ7S3lYLDjVMPh9kz6ManLHlXa3TsM
 BD5gKg3B726NGhy8oswb+h1GgtrlG35ALotb6yfFJ5jfLnh5gX
 ntAKz5fpjLuYbo7LCoHiXqIUoXWgupy/RorY6MQuM3fia9FNbd
 dERjfh6GLC1olQLn4wR+2A8lfHJWBQ2KU1fkrdde3UYk87MXZm
 n7yPA2GaIEdD7iQKDduG87ztVmQpxzYnKuZ0QNnay5StWvZ6vl
 PDgLqXARb3dShO/f6hxyND76TGKNZohNCOcvrbyp2QU6fs32SI
 65Nbuf8Lu6G78ie3elkU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2013, Vineet Gupta wrote:
> On Wednesday 02 January 2013 08:18 PM, Arnd Bergmann wrote:
> > On Wednesday 02 January 2013, Vineet Gupta wrote:
> >> On Wednesday 07 November 2012 07:43 PM, Arnd Bergmann wrote:

> > So a kernel built for ARC750 could potentially run on an ARC770, but not use
> > all the features, right?
> 
> Only for features which are non conflicting - so even now a CONFIG_ARC_CPU_750
> built kernel (so no LLOCK/SCOND support) will run fine on 770 hardware (which has
> LLOCK/SCOND)- assuming everything else being constant. However MMUv3 (770 only)
> has a different programming model vs. MMUv2 (e.g. TLB descriptor layout among
> others) hence a kernel for MMU v2 "simply" can't run on MMUv3 w/o making
> runtime-checks or runtime-overrides (akin to function pointers) in things like TLB
> refill handlers and such.

Ok.

> > If ARC770 cannot actually run the MMU_V2 code, that would mean that they
> > are indeed mutually exclusive by design,
> 
> Given the immense hardware configurability of ARC, all crazy combinations are
> possible - how many are practically used is a different topic. So someone could in
> theory build 770 with MMUv2 and infact the current build system even allows that.
> See ARC_CPU_{750,770} are only about selecting a bunch of defaults (MMU ver,
> LLOCK)  - to prevent the user from hand doing that. So lets say we rip off both of
> these (to emulate kernel built for one running on other) - then it would boil down
> to letting support for both v2 and v3 co-exist (not to forget there's also an
> arcane historic v1). Now these fellows really are mutually exclusive by design:
> * code written for v3 won't work on v2 (e.g. ARC_REG_IC_PTAG doesn't exist)
> * code written for v2 won't work on v3 (e.g ARC_REG_IC_PTAG needs to be written
> for correct behaviour)

I think in a case like this, it's pretty clearly not worth supporting both
in the same kernel. This is very similar to the difference between ARMv5 and
ARMv6, or between PowerPC Classic (6xx) and BookE (4xx), which are never
supported in a single kernel because the cost of doing it would be much
bigger than the benefit.

> > unless you also support a NOMMU
> > kernel. In that case you could only build a kernel for both 750 and 770
> > if you don't use the MMU. That would be much less interesting for actually
> > running things, but it could still make sense for build testing.
> >
> > If you don't need NOMMU support otherwise (I forgot whether or not you
> > have this), you should of course not implement it just for this.
> 
> NOMMU is not supported yet.
> 
> So how do we conclude on this topic - given the caveats above ?

For the CPU options, you should leave 750 and 770 mutually exclusive,
but for each other option, you should first see if it can reasonably
be a run-time option. It may not be possible to eliminate incompatible
compile-time options, but you should reduce the number of those options
as much as possible.

	Arnd
