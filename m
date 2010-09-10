Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab0IJDxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 23:53:45 -0400
Received: from atl.turmel.org ([74.117.157.138]:33230 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab0IJDxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 23:53:44 -0400
Message-ID: <4C89ABC3.8080701@turmel.org>
Date: Thu, 09 Sep 2010 23:53:39 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100908 Lightning/1.0b2 Thunderbird/3.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ben Skeggs <bskeggs@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        David Airlie <airlied@linux.ie>,
        =?UTF-8?B?TWFyY2luIEtvxZtjaWVsbmlja2k=?= <koriakin@0x04.net>,
        Francisco Jerez <currojerez@riseup.net>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH] nouveau build regression, undefined reference to `acpi_video_get_edid'
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've got a build breakage on my laptop:

drivers/built-in.o: In function `nouveau_acpi_edid':
(.text+0x13404e): undefined reference to `acpi_video_get_edid'
make: *** [.tmp_vmlinux1] Error 1

Introduced by:

a6ed76d7ffc62ffa474b41d31b011b6853c5de32 is the first bad commit
commit a6ed76d7ffc62ffa474b41d31b011b6853c5de32
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon Jul 12 15:33:07 2010 +1000

    drm/nouveau: support fetching LVDS EDID from ACPI

    Based on a patch from Matthew Garrett.

    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
    Acked-by: Matthew Garrett <mjg@redhat.com>

:040000 040000 2fbe9b4d9778329908107e72c11b100c2f5a460b 97dcf06923bb576298746584c45d17d3be9edcf8 M      drivers

It doesn't seem to revert cleanly, but I believe the problem lies in these
two config entries:

CONFIG_ACPI=y
CONFIG_ACPI_VIDEO=m

Having the nouveau ACPI features depend on CONFIG_ACPI_VIDEO instead of
bare CONFIG_ACPI builds, boots, and works for me.

Signed-off-by: Philip J. Turmel <philip@turmel.org>
---

Presumably, this could also be solved by adding
"select ACPI_VIDEO if ACPI" to the nouveau Kconfig.
I'd be happy to try that, if this approach is flawed.

diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Makefile
index e9b06e4..4e295b5 100644
--- a/drivers/gpu/drm/nouveau/Makefile
+++ b/drivers/gpu/drm/nouveau/Makefile
@@ -28,6 +28,6 @@ nouveau-y := nouveau_drv.o nouveau_state.o nouveau_channel.o nouveau_mem.o \
 nouveau-$(CONFIG_DRM_NOUVEAU_DEBUG) += nouveau_debugfs.o
 nouveau-$(CONFIG_COMPAT) += nouveau_ioc32.o
 nouveau-$(CONFIG_DRM_NOUVEAU_BACKLIGHT) += nouveau_backlight.o
-nouveau-$(CONFIG_ACPI) += nouveau_acpi.o
+nouveau-$(CONFIG_ACPI_VIDEO) += nouveau_acpi.o
 
 obj-$(CONFIG_DRM_NOUVEAU)+= nouveau.o
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index b1be617..bd995b4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -842,7 +842,7 @@ extern int  nouveau_dma_wait(struct nouveau_channel *, int slots, int size);
 
 /* nouveau_acpi.c */
 #define ROM_BIOS_PAGE 4096
-#if defined(CONFIG_ACPI)
+#if defined(CONFIG_ACPI_VIDEO)
 void nouveau_register_dsm_handler(void);
 void nouveau_unregister_dsm_handler(void);
 int nouveau_acpi_get_bios_chunk(uint8_t *bios, int offset, int len);

