Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1CKLFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 06:05:01 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:58228 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131Ab1CKLE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 06:04:59 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 11 Mar 2011 12:07:27 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] hid-multitouch: migrate 3M PCT touch screens to
 hid-multitouch
Message-ID: <20110311110727.GA3145@polaris.bitmath.org>
References: <1299686450-5475-1-git-send-email-benjamin.tissoires@enac.fr>
 <1299686450-5475-5-git-send-email-benjamin.tissoires@enac.fr>
 <20110310155225.GA23034@polaris.bitmath.org>
 <AANLkTi=jnd_gq8U+Fv7YSNk1iqt19paFQ3do=f5VrcSC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=jnd_gq8U+Fv7YSNk1iqt19paFQ3do=f5VrcSC@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Py093-0001op-6m.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Py093-0001op-6m 3150bae3bc7e67fe331b3946ec5be90d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I realize several of the entries are missing maxcontacts now, so all
> > patches needs to be checked...
> 
> This is really annoying. The idea behind the auto-detection was to
> simplify the writing of the driver and to let the device inform us on
> its capabilities.
> It's not a bug, it's a feature in this particular case. My idea was to
> remove all those .maxcontact (for instance, I know that it works for
> cypress, stantum and 3M) but I didn't want to bother my testers about
> such a little change.
> 
> Can I remember you that you where the first complaining about the
> maxcontact? You asked if it could not be given by the device. And as
> we where in a hurry, we didn't include it and said that we will do it
> later.

*sigh*

The generally problem seems to be that the patch cycles are too short,
leading to buggy implementations.

> And this one would be false: should I write 10 or 60? As it depends on
> the device, we'll have to let the device decide.
> If you remember the commit message of the auto-detection patch, I have
> written that we keep the .maxcontact field in case the device _lies_.
> And 3M does not lie.

Which is why max(default-value, device-value) was suggested.

> >>                       field->logical_maximum = 1;
> >>                       field->logical_minimum = 0;
> >>                       set_abs(hi->input, ABS_MT_ORIENTATION, field, 0);
> >
> > These limits are not right - I doubt they are for any device.
> 
> I was a little surprise too while looking at these. But This is not
> related to ABS_MT_TOUCH_MINOR, but ABS_MT_ORIENTATION.
> And if I'm forced to modify those values this way it's because _you_
> made me introduce the set_abs function which takes in parameter the
> field. Thus, it's more complicated to introduce new fields and usages.

Enough with the accusations. Simply replace those lines with

input_set_abs_params(hi->input, ABS_MT_ORIENTATION, 0, 1, 0, 0);

> > Also, this line needs to be added in case no feature reports are sent:
> >
> > @@ -481,6 +481,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
> >                return -ENOMEM;
> >        }
> >        td->mtclass = mtclass;
> > +       td->maxcontacts = mtclass->maxcontacts;
> >        td->inputmode = -1;
> >        hid_set_drvdata(hdev, td);
> >
> 
> So:
> 1) If a device does not send the feature report related to maxcontact,
> then it won't pass the Win7 certification, then we will need to write
> a special driver for it.
> 2) This is wrong because I do not want to add in all those classes the
> field maxcontact. So I'll revert the MT_DEFAULT_MAXCONTACT, and I will
> add this sort of line just before allocating the slots.
> Oh, and I'll remove the .maxcontact = 2 for MT_CLS_DEFAULT.

Take a deep breath and take your time. We don't want to waste anybodys
time by going through more cycles than necessary.

Henrik
