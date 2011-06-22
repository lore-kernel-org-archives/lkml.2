Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab1FVPlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:41:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49562 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab1FVPls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:41:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=juy6pCQTfYrX/D3CuivtcBjHySaHirL7DSfIVPEGffSKYwBiAq/CKxAEtO6OP44CeE
         d+wYuu3Lqyhyn9AcFm4WW9X59eRl/YyZggj9CZ5yZx94sRP+oXkzljPLjRwmHYb4bFD3
         NMrMyeKiE4k2NeQE8A7DgXc/zP3gs1nPzzKkQ=
MIME-Version: 1.0
In-Reply-To: <1308755870.3655.36.camel@Mark-Aurel.gas.de>
References: <1308670305-7096-1-git-send-email-rdratlos@yahoo.co.uk>
	<1308705639-4215-1-git-send-email-reimth@gmail.com>
	<BANLkTin-04ki+BgW-d1HqS5oupsx05ThUQ@mail.gmail.com>
	<1308755870.3655.36.camel@Mark-Aurel.gas.de>
Date: Wed, 22 Jun 2011 11:41:47 -0400
Message-ID: <BANLkTinZAuJv-Bb-iQas8Yc8bZTtg2eq6Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] drm/radeon: Fix Asus M2A-VM HDMI EDID error flooding problem
From: Alex Deucher <alexdeucher@gmail.com>
To: Thomas Reim <thomas.reim@nepomuc.de>
Cc: reimth@googlemail.com, Dave Airlie <airlied@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Reim <rdratlos@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 11:17 AM, Thomas Reim <thomas.reim@nepomuc.de> wrote:
> Dear Alex,
>
>> This is going to enable your quirk on every board with an HDMI port.
>> If we need to add a quirk for your board, let's make it board
>> specific.  It might be better to just disable edid polling for certain
>> connectors on certain boards if they cause problems when no monitor is
>> detected.
>>
>> Alex
>
> Initially, I made the quirk only for the Asus board, because I only have
> this one to test. But the quirk applies of course to all boards that use
> the RS690 type chipset.
>
> I went through a couple of the many and various bugs that reported the
> EDID error/dump flooding problem. Beside of RS690, also at least RS630,
> RV770 and R350 are affected by this problem. In addition, I also found a
> bug report on Intel 945 GM that seems to have the same root cause.
>
> The majority of the bugs (ca. 80%) report a problem with the HDMI-A
> connector. 15% have a problem with the DVI-I connector and 5% have a
> problem with the LVDS connector.

Got links?  I'm not sure this is the same root cause.  A lot of hdmi
monitors have broken edid checksums and other edid problems due to
hdmi switches and receivers messing with the edid or just plain broken
edids (tv's are particularly bad).  These problems are reported the
same way via log spam, but are not the same issue.

In the particular case of your board (and probably a few other similar
rs690/rs740 boards), the oem provides an optional hdmi add-in card
that uses pcie lanes for display.  The oem usually has the same
connector table regardless of whether the add-in card is installed or
not so we have no way of knowing whether there is actually a connector
there or not.  Even when there is a add-in board present it sounds
like perhaps the i2c lines are not terminated properly when no monitor
is attached.

>
> The proposed patch currently concentrates on the HDMI-A connector, only.
>
> Based on Jean's proposal I updated the patch, so that
> radeon_ddc_edid_probe() now replaces radeon_ddc_probe() for all HDMI-A
> connectors.
>
> According to the VESA standards we could also do this for all connector
> types in general. DDC is i2c plus EDID. Without the patch
> radeon_ddc_probe() probes DDC by checking, if data at all can be
> retrieved from i2c port 0x50 (where the EDID is provided). New
> radeon_ddc_edid_probe() just checks in addition, if the EDID header and
> version/revision information is available and according to the VESA
> standards.
>
> Then and only then (for the HDMI-A connectors) we let drm_get_edid() and
> drm_edid_block_valid() check the EDID checksum and probe the validity of
> the EDID.
>
> According to VESA's implementation guide this is the right approach:
> Checking the exact match of the EDID header and that the revision number
> is in valid range is mandatory.
>

radeon_ddc_probe() is supposed to be lightweight.  It's used in the
detect() functions just to probe if something is attached or not.
There is a separate function to fetch the full edid and check if it's
valid.  For connectors without HPD (hot plug detect), the polling code
probes the edid every 10 seconds.

> Based on Jean's comments, I believe that it makes sense to have EDID
> polling enabled as there might be temporary communication problems
> between graphics card and monitor. These should be logged. This also
> applies for the buggy HDMI-A connectors, as soon as a monitor is
> connected to them.
>

edid polling was only added to deal with analog connectors that do not
support hotplug interrupts and digital connectors that don't have HPD.
 You can still manually probe the monitor, you just won't get an event
like you would with HPD or edid polling.

Alex

> Hope this helps you.
>
> Best regards
>
> Thomas
>
>
>
>
