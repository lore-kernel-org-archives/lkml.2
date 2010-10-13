Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab0JMT6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 15:58:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55404 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0JMT6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 15:58:04 -0400
Date: Wed, 13 Oct 2010 12:57:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, dri-devel@lists.freedesktop.org,
        akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH -next] gpu/drm: fix build errors and kconfig dependency
 warnings
Message-Id: <20101013125738.24a0bd95.randy.dunlap@oracle.com>
In-Reply-To: <20101013154522.7b087a20.sfr@canb.auug.org.au>
References: <20101013154522.7b087a20.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 15:45:22 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101012:
> 
> The drm tree gained a conflict against the kgdb tree.


ERROR: "hwmon_device_unregister" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
ERROR: "hwmon_device_register" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
ERROR: "video_output_unregister" [drivers/acpi/video.ko] undefined!
ERROR: "video_output_register" [drivers/acpi/video.ko] undefined!

The latter 2 are simple to fix:
in drivers/gpu/drm/nouveau/Kconfig, for config DRM_NOUVEAU:

@@ -11,6 +11,7 @@ config DRM_NOUVEAU
 	select FRAMEBUFFER_CONSOLE if !EMBEDDED
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
 	select ACPI_VIDEO if ACPI
+	select VIDEO_OUTPUT_CONTROL if ACPI
 	help
 	  Choose this option for open-source nVidia support.


The first 2 are a problem.  I'd like to add "depends on HWMON" to DRM_NOUVEAU,
but doing so gives:

drivers/video/Kconfig:30:error: recursive dependency detected!
drivers/video/Kconfig:30:	symbol FB is selected by DRM_KMS_HELPER
drivers/gpu/drm/Kconfig:22:	symbol DRM_KMS_HELPER is selected by DRM_NOUVEAU
drivers/gpu/drm/nouveau/Kconfig:1:	symbol DRM_NOUVEAU depends on HWMON
drivers/hwmon/Kconfig:5:	symbol HWMON is selected by THINKPAD_ACPI
drivers/platform/x86/Kconfig:232:	symbol THINKPAD_ACPI depends on INPUT
drivers/input/Kconfig:8:	symbol INPUT is selected by VT
drivers/char/Kconfig:7:	symbol VT is selected by FB_STI
drivers/video/Kconfig:636:	symbol FB_STI depends on FB

so that must not be the right thing to do.  Aha, that change along with
changing all "select FB" (in drivers/gpu/drm/*) to "depends on FB"
fixes the kconfig warnings.  But feel free to fix it some other way.

My working patch is below.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix drm and drm/nouveau kconfigs so that build succeeds and
kconfig warnings are eliminated.

Fixes these build errors:
ERROR: "hwmon_device_unregister" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
ERROR: "hwmon_device_register" [drivers/gpu/drm/nouveau/nouveau.ko] undefined!
ERROR: "video_output_unregister" [drivers/acpi/video.ko] undefined!
ERROR: "video_output_register" [drivers/acpi/video.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/gpu/drm/Kconfig         |    2 +-
 drivers/gpu/drm/nouveau/Kconfig |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- linux-next-20101013.orig/drivers/gpu/drm/nouveau/Kconfig
+++ linux-next-20101013/drivers/gpu/drm/nouveau/Kconfig
@@ -1,16 +1,17 @@
 config DRM_NOUVEAU
 	tristate "Nouveau (nVidia) cards"
-	depends on DRM && PCI
+	depends on DRM && PCI && HWMON
+	depends on FB
         select FW_LOADER
 	select DRM_KMS_HELPER
 	select DRM_TTM
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select FB
 	select FRAMEBUFFER_CONSOLE if !EMBEDDED
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
 	select ACPI_VIDEO if ACPI
+	select VIDEO_OUTPUT_CONTROL if ACPI
 	help
 	  Choose this option for open-source nVidia support.
 
--- linux-next-20101013.orig/drivers/gpu/drm/Kconfig
+++ linux-next-20101013/drivers/gpu/drm/Kconfig
@@ -22,7 +22,7 @@ menuconfig DRM
 config DRM_KMS_HELPER
 	tristate
 	depends on DRM
-	select FB
+	depends on FB
 	select FRAMEBUFFER_CONSOLE if !EMBEDDED
 	help
 	  FB and CRTC helpers for KMS drivers.
