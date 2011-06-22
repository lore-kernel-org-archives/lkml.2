Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab1FVPpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:45:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53281 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab1FVPpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R5HS7y8pRZtNnrOj5DiFC+ooZTFrtOarPAzRiXqgQvfucvw+i6VSEJKYWgicW9I6h9
         FwVjXYerrOYDQfUaAIl0DYchAIP54i5ey4Vm+/OOBF+o6CTYlKQQLSuiJ+gDTpnutozI
         v3huGCbgnMaBpLwdWXHwbNITWi9mEP0rykP60=
MIME-Version: 1.0
In-Reply-To: <1308755870.3655.36.camel@Mark-Aurel.gas.de>
References: <1308670305-7096-1-git-send-email-rdratlos@yahoo.co.uk>
	<1308705639-4215-1-git-send-email-reimth@gmail.com>
	<BANLkTin-04ki+BgW-d1HqS5oupsx05ThUQ@mail.gmail.com>
	<1308755870.3655.36.camel@Mark-Aurel.gas.de>
Date: Wed, 22 Jun 2011 11:45:15 -0400
Message-ID: <BANLkTin8PpQWrGaCCQMQY+6A5QnXWxsKDQ@mail.gmail.com>
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
>
> The proposed patch currently concentrates on the HDMI-A connector, only.
>

I think it would be better to add a quirk flag and only do the
extended probe on specific boards where it is required.  E.g.,

if (radeon_connector->requires_extended_probe)
    radeon_ddc_probe_extended();
else
    radeon_ddc_probe();

Alex

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
> Based on Jean's comments, I believe that it makes sense to have EDID
> polling enabled as there might be temporary communication problems
> between graphics card and monitor. These should be logged. This also
> applies for the buggy HDMI-A connectors, as soon as a monitor is
> connected to them.
>
> Hope this helps you.
>
> Best regards
>
> Thomas
>
>
>
>
