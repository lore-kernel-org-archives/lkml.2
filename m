Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab1G3B0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 21:26:18 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46712 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1G3B0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 21:26:16 -0400
MIME-Version: 1.0
In-Reply-To: <1311986969.20983.52.camel@i7.infradead.org>
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
Date: Fri, 29 Jul 2011 21:26:15 -0400
Message-ID: <CACqU3MUnUHafhHFye2x1gR_b4ebN1zUK7PfSiUp1j=24y07yuA@mail.gmail.com>
Subject: Re: [PATCH v3] x86, kconfig: Default to ARCH=x86 to avoid overriding CONFIG_64BIT
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 29, 2011 at 8:49 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> I *frequently* waste a bunch of time when I take a 32-bit .config from a
> test machine and try to build it on a faster 64-bit system, and its
> existing setting of CONFIG_64BIT=n gets *changed* to match the build host.
>
Should we not try to fix this rather than introduce a new interface ?
>From my point of view, we (ie. Kbuild) should be intelligent enough to
take the default from the .config, if one is present in the object
directory, rather than trying to impose it's own view on what the ARCH
should be.

Is there case where we would have a .config, but would not use its content ?

Thanks,
 - Arnaud

> This is because the default setting for $ARCH when discovered from
> 'uname' is one of the legacy pre-x86-merge values (i386 or x86_64),
> which effectively force the setting of CONFIG_64BIT to match. We should
> default to ARCH=x86 instead, finally completing the merge that we
> started so long ago.
>
> This patch preserves the behaviour of the legacy ARCH settings for commands
> such as:
>
>   make ARCH=x86_64 randconfig
>   make ARCH=i386 randconfig
>
> ... although since my commit "Enable 'make CONFIG_FOO=y oldconfig'" those
> would be better expressed as:
>
>   make CONFIG_64BIT=y randconfig
>   make CONFIG_64BIT=n randconfig
>
> ... since that is a more generic way to set *any* config option, and
> there's no other technical reason to keep the legacy ARCH values around
> any more just to achieve that purpose; they could be removed at any
> time.
>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> Link: http://lkml.kernel.org/r/1306707270.2029.377.camel@i7.infradead.org
> ---
> v2: Explicitly turn off CONFIG_64BIT in i386_defconfig. The default for
>    CONFIG_64BIT has *changed* (from n to y) for ARCH=x86, so it needs to
>    be explicitly turned off or 'make i386_defconfig' will give you 64-bit.
> v3: Same patch as before; just updated changelog.
>
>  Makefile                        |    3 ++-
>  arch/x86/Kconfig                |    2 +-
>  arch/x86/Makefile               |    4 ++++
>  arch/x86/configs/i386_defconfig |    1 +
>  4 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index d018956..303df9b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -165,7 +165,8 @@ export srctree objtree VPATH
>  # then ARCH is assigned, getting whatever value it gets normally, and
>  # SUBARCH is subsequently ignored.
>
> -SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
> +SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
> +                                 -e s/sun4u/sparc64/ \
>                                  -e s/arm.*/arm/ -e s/sa110/arm/ \
>                                  -e s/s390x/s390/ -e s/parisc64/parisc/ \
>                                  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 153aa6f..9467fdd 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1,7 +1,7 @@
>  # Select 32 or 64 bit
>  config 64BIT
>        bool "64-bit kernel" if ARCH = "x86"
> -       default ARCH = "x86_64"
> +       default ARCH != "i386"
>        ---help---
>          Say yes to build a 64-bit kernel - formerly known as x86_64
>          Say no to build a 32-bit kernel - formerly known as i386
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index b02e509..94c2d8c 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -2,7 +2,11 @@
>
>  # select defconfig based on actual architecture
>  ifeq ($(ARCH),x86)
> +  ifeq ($(shell uname -m),x86_64)
> +        KBUILD_DEFCONFIG := x86_64_defconfig
> +  else
>         KBUILD_DEFCONFIG := i386_defconfig
> +  endif
>  else
>         KBUILD_DEFCONFIG := $(ARCH)_defconfig
>  endif
> diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
> index 2bf18059f..5f96c1c 100644
> --- a/arch/x86/configs/i386_defconfig
> +++ b/arch/x86/configs/i386_defconfig
> @@ -1,3 +1,4 @@
> +# CONFIG_64BIT is not set
>  CONFIG_EXPERIMENTAL=y
>  # CONFIG_LOCALVERSION_AUTO is not set
>  CONFIG_SYSVIPC=y
> --
> 1.7.6
>
>
>
> --
> dwmw2
>
>
