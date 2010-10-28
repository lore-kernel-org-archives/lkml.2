Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab0J1NM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:12:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43206 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318Ab0J1NM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:12:26 -0400
Date: Thu, 28 Oct 2010 15:12:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Lee Revell <rlrevell@joe-job.com>, Chun-Yi <jlee@novell.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: -tip: origin tree build failure (Was: [git pull] drm tree for merge
 window)
Message-ID: <20101028131204.GA29323@elte.hu>
References: <alpine.DEB.2.00.1010270214140.28394@skynet.skynet.ie>
 <alpine.DEB.2.00.1010270228090.28394@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1010270228090.28394@skynet.skynet.ie>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Airlie <airlied@linux.ie> wrote:

> > Lee, Chun-Yi (1):
> >       gpu: Add Intel GMA500(Poulsbo) Stub Driver

Today's -tip fails to build due to upstream commit e26fd11 ("gpu: Add Intel 
GMA500(Poulsbo) Stub Driver"), committed two days ago and merged yesterday, on
x86 allmodconfig with BACKLIGHT_CLASS_DEVICE disabled:

 drivers/built-in.o: In function `acpi_video_bus_put_one_device':
 video.c:(.text+0x7d26f): undefined reference to `backlight_device_unregister'
 drivers/built-in.o: In function `acpi_video_switch_brightness':
 video.c:(.text+0x7d6f5): undefined reference to `backlight_force_update'
 drivers/built-in.o: In function `acpi_video_device_find_cap':
 video.c:(.text+0x7dfdb): undefined reference to `backlight_device_register'

drivers/gpu/stub/Kconfig selects ACPI_VIDEO, but ACPI_VIDEO is a complex interactive 
Kconfig option with a lot of dependencies:

 config ACPI_VIDEO
	tristate "Video"
	depends on X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL
	depends on INPUT
	select THERMAL
	help
	  This driver implements the ACPI Extensions For Display Adapters

and if any of its dependencies are not met, we get a build failure. This problem was 
apparently realized in the driver at a certain stage:

 config STUB_POULSBO
        tristate "Intel GMA500 Stub Driver"
        depends on PCI
        # Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
        # but for select to work, need to select ACPI_VIDEO's dependencies, ick
        select ACPI_VIDEO if ACPI

but not fully understood and not fully fixed.

As a quick fix select these secondary dependencies, like drivers/gpu/drm/Kconfig 
does:

 config DRM_I915
	tristate "i915 driver"
	depends on AGP_INTEL
	select SHMEM
	select DRM_KMS_HELPER
	select FB_CFB_FILLRECT
	select FB_CFB_COPYAREA
	select FB_CFB_IMAGEBLIT
	# i915 depends on ACPI_VIDEO when ACPI is enabled
	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
	select VIDEO_OUTPUT_CONTROL if ACPI
	select BACKLIGHT_CLASS_DEVICE if ACPI
	select INPUT if ACPI
	select ACPI_VIDEO if ACPI
	select ACPI_BUTTON if ACPI
	help
	  Choose this option if you have a system that has Intel 830M, 845G,
	  852GM, 855GM 865G or 915G integrated graphics.  If M is selected, the

But it's arguably not particularly nice looking, so maybe this area of code is ripe 
for a Kconfig restructuring/cleanup.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/gpu/stub/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/stub/Kconfig b/drivers/gpu/stub/Kconfig
index 742c423..0e1edd7 100644
--- a/drivers/gpu/stub/Kconfig
+++ b/drivers/gpu/stub/Kconfig
@@ -3,6 +3,9 @@ config STUB_POULSBO
 	depends on PCI
 	# Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
 	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
+	select VIDEO_OUTPUT_CONTROL if ACPI
+	select BACKLIGHT_CLASS_DEVICE if ACPI
+	select INPUT if ACPI
 	select ACPI_VIDEO if ACPI
 	help
 	  Choose this option if you have a system that has Intel GMA500
