Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0IOAOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 20:14:17 -0400
Received: from atl.turmel.org ([74.117.157.138]:60864 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab0IOAOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 20:14:16 -0400
Message-ID: <4C900FD3.80500@turmel.org>
Date: Tue, 14 Sep 2010 20:14:11 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100908 Lightning/1.0b2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Francisco Jerez <currojerez@riseup.net>
CC: linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, David Airlie <airlied@linux.ie>,
        "Marcin Kos'cielnicki" <koriakin@0x04.net>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH v2] nouveau build regression, undefined reference to `acpi_video_get_edid'
References: <4C89ABC3.8080701@turmel.org> <87hbhslatm.fsf@riseup.net> <4C8F7FDF.6090904@turmel.org>
In-Reply-To: <4C8F7FDF.6090904@turmel.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Build breakage:

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

It doesn't seem to revert cleanly, but the problem lies in these
two config entries:

CONFIG_ACPI=y
CONFIG_ACPI_VIDEO=m

Adding a select for ACPI_VIDEO appears to be the best solution, and
is comparable to what is done in DRM_I915.  Builds, boots, and appears to
work correctly.

Signed-off-by: Philip J. Turmel <philip@turmel.org>
---

The first version disabled all ACPI functions in the nouveau driver if
ACPI_VIDEO wasn't set.  Francisco Jerez <currojerez@riseup.net> pointed out
that this didn't make much sense.

diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index d2d2804..72730e9 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -10,6 +10,7 @@ config DRM_NOUVEAU
 	select FB
 	select FRAMEBUFFER_CONSOLE if !EMBEDDED
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
+	select ACPI_VIDEO if ACPI
 	help
 	  Choose this option for open-source nVidia support.
