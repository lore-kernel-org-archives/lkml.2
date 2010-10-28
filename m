Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab0J1PfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:35:18 -0400
Received: from atl.turmel.org ([74.117.157.138]:54932 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab0J1PfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:35:12 -0400
Message-ID: <4CC9981E.80202@turmel.org>
Date: Thu, 28 Oct 2010 11:34:54 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101023 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Lee Revell <rlrevell@joe-job.com>, Chun-Yi <jlee@novell.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Francisco Jerez <currojerez@riseup.net>
Subject: Re: -tip: origin tree build failure (Was: [git pull] drm tree for
 merge window)
References: <alpine.DEB.2.00.1010270214140.28394@skynet.skynet.ie> <alpine.DEB.2.00.1010270228090.28394@skynet.skynet.ie> <20101028131204.GA29323@elte.hu>
In-Reply-To: <20101028131204.GA29323@elte.hu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2010 09:12 AM, Ingo Molnar wrote:
> 
> * Dave Airlie <airlied@linux.ie> wrote:
> 
>>> Lee, Chun-Yi (1):
>>>       gpu: Add Intel GMA500(Poulsbo) Stub Driver
> 
> Today's -tip fails to build due to upstream commit e26fd11 ("gpu: Add Intel 
> GMA500(Poulsbo) Stub Driver"), committed two days ago and merged yesterday, on
> x86 allmodconfig with BACKLIGHT_CLASS_DEVICE disabled:
> 
>  drivers/built-in.o: In function `acpi_video_bus_put_one_device':
>  video.c:(.text+0x7d26f): undefined reference to `backlight_device_unregister'
>  drivers/built-in.o: In function `acpi_video_switch_brightness':
>  video.c:(.text+0x7d6f5): undefined reference to `backlight_force_update'
>  drivers/built-in.o: In function `acpi_video_device_find_cap':
>  video.c:(.text+0x7dfdb): undefined reference to `backlight_device_register'
> 
> drivers/gpu/stub/Kconfig selects ACPI_VIDEO, but ACPI_VIDEO is a complex interactive 
> Kconfig option with a lot of dependencies:
> 
>  config ACPI_VIDEO
> 	tristate "Video"
> 	depends on X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL
> 	depends on INPUT
> 	select THERMAL
> 	help
> 	  This driver implements the ACPI Extensions For Display Adapters
> 
> and if any of its dependencies are not met, we get a build failure. This problem was 
> apparently realized in the driver at a certain stage:
> 
>  config STUB_POULSBO
>         tristate "Intel GMA500 Stub Driver"
>         depends on PCI
>         # Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
>         # but for select to work, need to select ACPI_VIDEO's dependencies, ick
>         select ACPI_VIDEO if ACPI
> 
> but not fully understood and not fully fixed.

I submitted a nouveau patch that does this as well.  Part of the same merge.  I was
copying from the Intel driver but didn't catch the comment on the dependencies.

(Added Francisco to the CC: list)

> As a quick fix select these secondary dependencies, like drivers/gpu/drm/Kconfig 
> does:
> 
>  config DRM_I915
> 	tristate "i915 driver"
> 	depends on AGP_INTEL
> 	select SHMEM
> 	select DRM_KMS_HELPER
> 	select FB_CFB_FILLRECT
> 	select FB_CFB_COPYAREA
> 	select FB_CFB_IMAGEBLIT
> 	# i915 depends on ACPI_VIDEO when ACPI is enabled
> 	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
> 	select VIDEO_OUTPUT_CONTROL if ACPI
> 	select BACKLIGHT_CLASS_DEVICE if ACPI
> 	select INPUT if ACPI
> 	select ACPI_VIDEO if ACPI
> 	select ACPI_BUTTON if ACPI
> 	help
> 	  Choose this option if you have a system that has Intel 830M, 845G,
> 	  852GM, 855GM 865G or 915G integrated graphics.  If M is selected, the
> 
> But it's arguably not particularly nice looking, so maybe this area of code is ripe 
> for a Kconfig restructuring/cleanup.

I have no idea what such a cleanup would look like, but I'm guessing the following is
needed for nouveau in the meantime:

Signed-off-by: Philip J. Turmel <philip@turmel.org>
---

The build fix for nouveau's use of acpi_video_get_edid omitted the
dependencies of ACPI_VIDEO.

diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index 72730e9..c33ecb6 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -11,6 +11,9 @@ config DRM_NOUVEAU
 	select FRAMEBUFFER_CONSOLE if !EMBEDDED
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
 	select ACPI_VIDEO if ACPI
+	select VIDEO_OUTPUT_CONTROL if ACPI
+	select BACKLIGHT_CLASS_DEVICE if ACPI
+	select INPUT if ACPI
 	help
 	  Choose this option for open-source nVidia support.
 
