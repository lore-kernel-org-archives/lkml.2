Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1G3PVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 11:21:47 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37782 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1G3PVn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 11:21:43 -0400
MIME-Version: 1.0
In-Reply-To: <1312015064.20983.58.camel@i7.infradead.org>
References: <1306707270.2029.377.camel@i7.infradead.org>
	<20110530072300.GA9802@elte.hu>
	<1306745835.2029.389.camel@i7.infradead.org>
	<20110530104231.GF17821@elte.hu>
	<20110530104656.GA19532@elte.hu>
	<E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	<20110530105809.GA20133@elte.hu>
	<1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	<alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	<20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	<alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	<1306795186.2029.459.camel@i7.infradead.org>
	<BANLkTik=uHr1eX44XV1pAHUfVQ-MorzOnw@mail.gmail.com>
	<1306856937.27477.3.camel@i7.infradead.org>
	<BANLkTi=VoL8ze0AcdkG_QmEH5049X2K6Zw@mail.gmail.com>
	<4E0495F4.7080300@suse.cz>
	<1311986969.20983.52.camel@i7.infradead.org>
	<CACqU3MUnUHafhHFye2x1gR_b4ebN1zUK7PfSiUp1j=24y07yuA@mail.gmail.com>
	<1312015064.20983.58.camel@i7.infradead.org>
Date: Sat, 30 Jul 2011 11:21:42 -0400
Message-ID: <CACqU3MVh7JYsO94UEcxOp+jx2PCO_J3o+5MyU-ivx1utP9aDnw@mail.gmail.com>
Subject: Re: [PATCH v3] x86, kconfig: Default to ARCH=x86 to avoid overriding CONFIG_64BIT
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        hpa@zytor.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sat, Jul 30, 2011 at 4:37 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Fri, 2011-07-29 at 21:26 -0400, Arnaud Lacombe wrote:
>>
>> Should we not try to fix this rather than introduce a new interface ?
>
> This patch *does* fix it, without needing the new interface that I
> presented in a separate patch. The two patches I sent are not strictly
> dependent on one another.
>
>> From my point of view, we (ie. Kbuild) should be intelligent enough to
>> take the default from the .config, if one is present in the object
>> directory, rather than trying to impose it's own view on what the ARCH
>> should be.
>>
>> Is there case where we would have a .config, but would not use its
>> content ?
>
> Heh, I think you've missed some of the history here.
>
> I originally, a year or two ago, posted a patch which took precisely the
> approach I think you're advocating.
Just to make my point clearer, here is what I'd be advocating:

diff --git a/Makefile b/Makefile
index b927e75..a15b773 100644
--- a/Makefile
+++ b/Makefile
@@ -192,7 +192,11 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/
-e s/sun4u/sparc64/ \
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
 export KBUILD_BUILDHOST := $(SUBARCH)
+ifeq ($(shell test -e .config && echo n),n)
 ARCH           ?= $(SUBARCH)
+else
+ARCH           ?= $(shell sed '/^\# Linux\/\(.*\) .* Kernel
Configuration/!d; s//\1/' .config)
+endif
 CROSS_COMPILE  ?= $(CONFIG_CROSS_COMPILE:"%"=%)

this work but smells hackish.

 - Arnaud

> It basically made the ARCH=x86
> behaviour apply in all cases. It was reverted because it made 'make
> randconfig' actually *random* — *even* for the setting of CONFIG_64BIT,
> *even* when ARCH=i386 or ARCH=x86_64.
>
> The fact that KCONFIG_ALLCONFIG allows you to override *all* config
> options and not just CONFIG_64BIT, and that using the legacy ARCH=
> settings wasn't really necessary, was evidently not sufficient. It
> apparently *had* to be possible to switch using the command line.
>
> So I did two things — I fixed this patch so that it doesn't break that
> legacy use case of 'make ARCH=i386' or 'make ARCH=x86_64' to force the
> value of CONFIG_64BIT on or off, and I also posted a separate patch
> which gives a more *sensible* way to force *any* config options on or
> off from the 'make' command line, since the world is apparently going to
> end if we can't do that.
>
> The two patches can be considered to be entirely independent.
>
> --
> dwmw2
>
>
