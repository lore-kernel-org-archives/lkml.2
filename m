Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1GFXah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:30:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36843 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1GFXaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:30:35 -0400
From: reimth@googlemail.com
To: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexdeucher@gmail.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Thomas Reim <rdratlos@yahoo.co.uk>
Subject: [PATCH 0/3] drm/radeon: Fix Asus M2A-VM HDMI EDID error flooding problem
Date: Thu,  7 Jul 2011 01:30:09 +0200
Message-Id: <1309995012-5873-1-git-send-email-reimth@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <CADnq5_M5NAd2PVbS0FPB_VSmg8+41HUsDL1TcbKK94GK6MF_jA@mail.gmail.com>
References: <CADnq5_M5NAd2PVbS0FPB_VSmg8+41HUsDL1TcbKK94GK6MF_jA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Reim <rdratlos@yahoo.co.uk>

Dear Alex,

> > From: Thomas Reim <rdratlos@yahoo.co.uk>
> >
> >    Some integrated ATI Radeon chipset implementations
> >    with add-on HDMI card (e. g. Asus M2A-VM HDMI) indicate the availability
> >    of a DDC even when the add-on card is not plugged in or HDMI is disabled
> >    in BIOS setup. In this case, drm_get_edid() and drm_edid_block_valid()
> >    periodically dump data and kernel errors into system log files and onto
> >    terminals. For these chipsets DDC probing is extended by a check for a
> >    correct EDID header. Only in case a valid EDID header is also found, the
> >    (HDMI) connector will be used by the Radeon driver. This prevents the
> >    kernel driver from useless flooding of logs and terminal sessions with
> >    EDID dumps and error messages.
> >    This patch adds a flag 'requires_extended_probe' to the radeon_connector
> >    structure. In function radeon_connector_needs_extended_probe() this flag
> >    can be set on a chipset family/vendor/connector type specific basis.
> >    In addition, function drm_edid_header_is_valid() has been added for EDID
> >    header check and function radeon_ddc_probe() has been adapted to perform
> >    extended DDC probing if required by the connector's flag.
> >
> >    Tested for kernel 2.35, 2.38 and 3.0 on Asus M2A-VM HDMI board
> >
> 
> Once it's ready, just add:
> Cc: stable@kernel.org
> to the commit message and it will go into the stable kernels as well.
> Might want to mention the bug report in your commit message as well.
> Just a couple comments below.  With those fixed:
> 
> Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
> 
> > Signed-off-by: Thomas Reim <rdratlos@yahoo.co.uk>
> 
thank you for the review and your feedback. I've incorporated your comments as follows:

>  * Sanity check the EDID block (base or extension).  Return 0 if the block
> >  * doesn't check out, or 1 if it's valid.
> > @@ -139,12 +156,7 @@ drm_edid_block_valid(u8 *raw_edid)
> >        struct edid *edid = (struct edid *)raw_edid;
> >
> >        if (raw_edid[0] == 0x00) {
> > -               int score = 0;
> > -
> > -               for (i = 0; i < sizeof(edid_header); i++)
> > -                       if (raw_edid[i] == edid_header[i])
> > -                               score++;
> > -
> > +               int score = drm_edid_header_is_valid(raw_edid);
> >                if (score == 8) ;
> >                else if (score >= 6) {
> >                        DRM_DEBUG("Fixing EDID header, your hardware may be failing\n");
> 
> Might want to break this hunk out as a separate patch.

Done. Moved to [PATCH 1/3] drm: Separate EDID Header Check from EDID Block Check  

> --- a/drivers/gpu/drm/radeon/radeon_device.c
> > +++ b/drivers/gpu/drm/radeon/radeon_device.c
> > @@ -704,8 +704,13 @@ int radeon_device_init(struct radeon_device *rdev,
> >        rdev->gpu_lockup = false;
> >        rdev->accel_working = false;
> >
> > -       DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X).\n",
> > +       if (pdev->subsystem_vendor == 0)
> > +               DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X).\n",
> >                radeon_family_name[rdev->family], pdev->vendor, pdev->device);
> > +       else
> > +               DRM_INFO("initializing kernel modesetting (%s 0x%04X:0x%04X 0x%04X:0x%04X).\n",
> > +               radeon_family_name[rdev->family], pdev->vendor, pdev->device,
> > +               pdev->subsystem_vendor, pdev->subsystem_device);
> >
> 
> No need for the if block.  Just always print both the pci and
> subsystem ids.  Also, I'd suggest making that a separate patch as it's
> not related to the actual fix.

Done. Moved to [PATCH 3/3] drm/radeon: Log Subsystem Vendor and Device Information.

The following mails will contain the three patches:
[PATCH 1/3] drm: Separate EDID Header Check from EDID Block Check
[PATCH 2/3] drm/radeon: Fix Asus M2A-VM HDMI EDID error flooding problem
[PATCH 3/3] drm/radeon: Log Subsystem Vendor and Device Information

[PATCH 2/3] requires [PATCH 1/3] (new function drm_edid_header_is_valid). [PATCH 3/3] 
is an add-on that helps people to identify also the subsystem vendor and device PCI ID 
of a Radeon chipset within the kernel log. So all information that is needed to include 
Radeon implementations other than Asus M2A-VM HDMI for extended DDC probing should now 
be available in dmesg. 

The patches were generated against revision 'Linux 3.0-rc6' in Linux kernel git repository.

Best regards

Thomas Reim


Thomas Reim (3):
  drm: Separate EDID Header Check from EDID Block Check
  drm/radeon: Fix Asus M2A-VM HDMI EDID error flooding problem
  drm/radeon: Log Subsystem Vendor and Device Information

 drivers/gpu/drm/drm_edid.c                 |   24 +++++++++++----
 drivers/gpu/drm/radeon/radeon_connectors.c |   45 ++++++++++++++++++++++++++--
 drivers/gpu/drm/radeon/radeon_device.c     |    5 ++-
 drivers/gpu/drm/radeon/radeon_display.c    |    9 +++++
 drivers/gpu/drm/radeon/radeon_i2c.c        |   32 +++++++++++++++-----
 drivers/gpu/drm/radeon/radeon_mode.h       |    6 +++-
 include/drm/drm_crtc.h                     |    1 +
 7 files changed, 102 insertions(+), 20 deletions(-)

