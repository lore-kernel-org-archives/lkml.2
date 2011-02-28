Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1B1RGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 12:06:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:19040 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab1B1RGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:06:10 -0500
Date: Mon, 28 Feb 2011 09:03:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Luming Yu <luming.yu@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH upstream build breakage] acpi: several drivers depend on NET
Message-Id: <20110228090332.9ffe2087.randy.dunlap@oracle.com>
In-Reply-To: <20110201120323.GA6714@elte.hu>
References: <20101220200013.df8fbc88.sfr@canb.auug.org.au>
	<20101220085340.7ba098b9.randy.dunlap@oracle.com>
	<20110126114203.GA16754@elte.hu>
	<20110201120323.GA6714@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D6BD5C3.00E0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 13:03:23 +0100 Ingo Molnar wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > On Mon, 20 Dec 2010 20:00:13 +1100 Stephen Rothwell wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > [The mirroring on kernel.org is running slowly]
> > > > 
> > > > Changes since 20101217:
> > > 
> > > ERROR: "thermal_cooling_device_register" [drivers/acpi/video.ko] undefined!
> > > ERROR: "thermal_cooling_device_unregister" [drivers/acpi/video.ko] undefined!
> > 
> > This bug has been reported two months ago, one month ago, it has been ignored twice 
> > and now the bug has been pushed upstream and it's triggering there as well.
> > 
> > What's going on?
> 
> *Tap*, *tap*, is this thing on? :)
> 
> acpi-video is still build-broken upstream, as of .38-rc3:
> 
>    MODPOST 651 modules
>  ERROR: "thermal_cooling_device_register" [drivers/acpi/video.ko] undefined!
>  ERROR: "thermal_cooling_device_unregister" [drivers/acpi/video.ko] undefined!
>  WARNING: modpost: Found 37 section mismatch(es).
>  To see full details build your kernel with:
>  'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>  make[1]: *** [__modpost] Error 1
>  make: *** [modules] Error 2
> 
> Triggers in about 10% of all randconfig builds. Config attached.


From: Randy Dunlap <randy.dunlap@oracle.com>

Several ACPI drivers select THERMAL, but THERMAL depends on NET
(for netlink).  Fix build breakage by making the ACPI drivers
also depend on NET.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/acpi/Kconfig |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

This is what is needed to fix the breakage, but it seems
that Len does not care.
It would be better just to eliminate the netlink dependency.


--- linux-next-20110228.orig/drivers/acpi/Kconfig
+++ linux-next-20110228/drivers/acpi/Kconfig
@@ -163,7 +163,7 @@ config ACPI_BUTTON
 config ACPI_VIDEO
 	tristate "Video"
 	depends on X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL
-	depends on INPUT
+	depends on INPUT && NET
 	select THERMAL
 	help
 	  This driver implements the ACPI Extensions For Display Adapters
@@ -177,6 +177,7 @@ config ACPI_VIDEO
 
 config ACPI_FAN
 	tristate "Fan"
+	depends on NET
 	select THERMAL
 	default y
 	help
@@ -195,6 +196,7 @@ config ACPI_DOCK
 
 config ACPI_PROCESSOR
 	tristate "Processor"
+	depends on NET
 	select THERMAL
 	select CPU_IDLE
 	default y
@@ -238,7 +240,7 @@ config ACPI_PROCESSOR_AGGREGATOR
 
 config ACPI_THERMAL
 	tristate "Thermal Zone"
-	depends on ACPI_PROCESSOR
+	depends on ACPI_PROCESSOR && NET
 	select THERMAL
 	default y
 	help
