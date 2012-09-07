Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2IGPWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:22:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50019 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2IGPWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:22:20 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 0/7] Fixes for hybrid graphics Apple machines
Date: Fri,  7 Sep 2012 10:22:03 -0500
Message-Id: <1347031330-19657-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many hybrid graphics Apple laptops fail to set up LVDS on the secondary
GPU due to missing or incorrect mode information for the panel at init
time. The only way to get the LVDS mode on these machines is via the
DDC, but this is muxed to the active GPU at boot. However, the graphics
mux on these machines supports muxing the i2c idependently of the
display, making it possible for the secondary graphics driver to read
the EDID without a full display switch.

In order to support this, these patches modify vga_switcheroo to allow
muxing of the DDC idependently of the display. apple-gmux is updated to
support this new functionality, and drm_get_edid() is modified to switch
the DDC mux as needed.

For this to work we also need to ensure that sufficient switcheroo
suport is available before initializing the secondary GPU. This is done
by adding any non-active GPUs that try to initialize before switcheroo
is ready to a list and initializing these devices once switcheroo
becomes ready. This behavior is restricted to Apple laptops to prevent
causing problems on other machines.

Thanks,
Seth

Seth Forshee (7):
  vga_switcheroo: Add support for switching only the DDC
  vga_switcheroo: Add helper function to get the active client
  vga_switcheroo: Add notifier call chain for switcheroo events
  apple-gmux: Add switch_ddc support
  drm/edid: Switch DDC when reading the EDID
  drm/pci: Add drm_put_pci_dev()
  drm/pci: Defer initialization of secondary graphics devices until
    switcheroo is ready

 drivers/gpu/drm/ast/ast_drv.c         |    2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.c   |    2 +-
 drivers/gpu/drm/drm_drv.c             |    3 +
 drivers/gpu/drm/drm_edid.c            |   17 ++++
 drivers/gpu/drm/drm_pci.c             |  172 +++++++++++++++++++++++++++++----
 drivers/gpu/drm/gma500/psb_drv.c      |    2 +-
 drivers/gpu/drm/i915/i915_drv.c       |    2 +-
 drivers/gpu/drm/mgag200/mgag200_drv.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_drv.c |    2 +-
 drivers/gpu/drm/radeon/radeon_drv.c   |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c   |    2 +-
 drivers/gpu/vga/vga_switcheroo.c      |   87 ++++++++++++++++-
 drivers/platform/x86/apple-gmux.c     |   12 ++-
 include/drm/drmP.h                    |    3 +
 include/linux/vga_switcheroo.h        |   20 ++++
 15 files changed, 302 insertions(+), 28 deletions(-)

