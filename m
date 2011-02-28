Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1B1UhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 15:37:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37425 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab1B1UhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:37:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH upstream build breakage] acpi: several drivers depend on NET
Date: Mon, 28 Feb 2011 21:37:15 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Luming Yu <luming.yu@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20101220200013.df8fbc88.sfr@canb.auug.org.au> <20110201120323.GA6714@elte.hu> <20110228090332.9ffe2087.randy.dunlap@oracle.com>
In-Reply-To: <20110228090332.9ffe2087.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102282137.15390.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 28, 2011, Randy Dunlap wrote:
> On Tue, 1 Feb 2011 13:03:23 +0100 Ingo Molnar wrote:
> 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > 
> > > > On Mon, 20 Dec 2010 20:00:13 +1100 Stephen Rothwell wrote:
> > > > 
> > > > > Hi all,
> > > > > 
> > > > > [The mirroring on kernel.org is running slowly]
> > > > > 
> > > > > Changes since 20101217:
> > > > 
> > > > ERROR: "thermal_cooling_device_register" [drivers/acpi/video.ko] undefined!
> > > > ERROR: "thermal_cooling_device_unregister" [drivers/acpi/video.ko] undefined!
> > > 
> > > This bug has been reported two months ago, one month ago, it has been ignored twice 
> > > and now the bug has been pushed upstream and it's triggering there as well.
> > > 
> > > What's going on?
> > 
> > *Tap*, *tap*, is this thing on? :)
> > 
> > acpi-video is still build-broken upstream, as of .38-rc3:
> > 
> >    MODPOST 651 modules
> >  ERROR: "thermal_cooling_device_register" [drivers/acpi/video.ko] undefined!
> >  ERROR: "thermal_cooling_device_unregister" [drivers/acpi/video.ko] undefined!
> >  WARNING: modpost: Found 37 section mismatch(es).
> >  To see full details build your kernel with:
> >  'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >  make[1]: *** [__modpost] Error 1
> >  make: *** [modules] Error 2
> > 
> > Triggers in about 10% of all randconfig builds. Config attached.
> 
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Several ACPI drivers select THERMAL, but THERMAL depends on NET
> (for netlink).  Fix build breakage by making the ACPI drivers
> also depend on NET.

Well, making ACPI_FAN depend on NET seems to be a kind of an overstretch to me.
A proper fix would be to disable the netlink interface in THERMAL when
NET is unset, I guess.  I'll see what can be done to that end (although I had
hoped that the people who introduced the breakage would handle it).

Thanks,
Rafael


> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/acpi/Kconfig |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> This is what is needed to fix the breakage, but it seems
> that Len does not care.
> It would be better just to eliminate the netlink dependency.
> 
> 
> --- linux-next-20110228.orig/drivers/acpi/Kconfig
> +++ linux-next-20110228/drivers/acpi/Kconfig
> @@ -163,7 +163,7 @@ config ACPI_BUTTON
>  config ACPI_VIDEO
>  	tristate "Video"
>  	depends on X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL
> -	depends on INPUT
> +	depends on INPUT && NET
>  	select THERMAL
>  	help
>  	  This driver implements the ACPI Extensions For Display Adapters
> @@ -177,6 +177,7 @@ config ACPI_VIDEO
>  
>  config ACPI_FAN
>  	tristate "Fan"
> +	depends on NET
>  	select THERMAL
>  	default y
>  	help
> @@ -195,6 +196,7 @@ config ACPI_DOCK
>  
>  config ACPI_PROCESSOR
>  	tristate "Processor"
> +	depends on NET
>  	select THERMAL
>  	select CPU_IDLE
>  	default y
> @@ -238,7 +240,7 @@ config ACPI_PROCESSOR_AGGREGATOR
>  
>  config ACPI_THERMAL
>  	tristate "Thermal Zone"
> -	depends on ACPI_PROCESSOR
> +	depends on ACPI_PROCESSOR && NET
>  	select THERMAL
>  	default y
>  	help
> 
> 

