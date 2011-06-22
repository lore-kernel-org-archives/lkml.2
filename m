Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab1FVPSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:18:06 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:27216 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab1FVPSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:18:04 -0400
X-RZG-AUTH: :O2kGeEG7b/pS1EO8W3C+nMaWotNRcyCeCTTmQgOI2iYXpKw2M5aRJ08f0ltfYr+LLg==
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH 1/1] drm/radeon: Fix Asus M2A-VM HDMI EDID error
 flooding problem
From: Thomas Reim <thomas.reim@nepomuc.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: reimth@googlemail.com, Dave Airlie <airlied@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Reim <rdratlos@yahoo.co.uk>
In-Reply-To: <BANLkTin-04ki+BgW-d1HqS5oupsx05ThUQ@mail.gmail.com>
References: <1308670305-7096-1-git-send-email-rdratlos@yahoo.co.uk>
	 <1308705639-4215-1-git-send-email-reimth@gmail.com>
	 <BANLkTin-04ki+BgW-d1HqS5oupsx05ThUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 17:17:50 +0200
Message-ID: <1308755870.3655.36.camel@Mark-Aurel.gas.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alex, 

> This is going to enable your quirk on every board with an HDMI port.
> If we need to add a quirk for your board, let's make it board
> specific.  It might be better to just disable edid polling for certain
> connectors on certain boards if they cause problems when no monitor is
> detected.
> 
> Alex

Initially, I made the quirk only for the Asus board, because I only have
this one to test. But the quirk applies of course to all boards that use
the RS690 type chipset.

I went through a couple of the many and various bugs that reported the
EDID error/dump flooding problem. Beside of RS690, also at least RS630,
RV770 and R350 are affected by this problem. In addition, I also found a
bug report on Intel 945 GM that seems to have the same root cause.

The majority of the bugs (ca. 80%) report a problem with the HDMI-A
connector. 15% have a problem with the DVI-I connector and 5% have a
problem with the LVDS connector. 

The proposed patch currently concentrates on the HDMI-A connector, only.

Based on Jean's proposal I updated the patch, so that
radeon_ddc_edid_probe() now replaces radeon_ddc_probe() for all HDMI-A
connectors. 

According to the VESA standards we could also do this for all connector
types in general. DDC is i2c plus EDID. Without the patch
radeon_ddc_probe() probes DDC by checking, if data at all can be
retrieved from i2c port 0x50 (where the EDID is provided). New
radeon_ddc_edid_probe() just checks in addition, if the EDID header and
version/revision information is available and according to the VESA
standards. 

Then and only then (for the HDMI-A connectors) we let drm_get_edid() and
drm_edid_block_valid() check the EDID checksum and probe the validity of
the EDID.

According to VESA's implementation guide this is the right approach:
Checking the exact match of the EDID header and that the revision number
is in valid range is mandatory. 

Based on Jean's comments, I believe that it makes sense to have EDID
polling enabled as there might be temporary communication problems
between graphics card and monitor. These should be logged. This also
applies for the buggy HDMI-A connectors, as soon as a monitor is
connected to them.

Hope this helps you.

Best regards

Thomas



