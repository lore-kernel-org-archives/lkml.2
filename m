Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab2HTP5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:57:18 -0400
Received: from csmtp2.one.com ([91.198.169.22]:21187 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361Ab2HTP5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:57:14 -0400
From: "Henrik Rydberg" <rydberg@bitmath.se>
Date: Mon, 20 Aug 2012 18:01:50 +0200
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/19] HID: multitouch: Remove the redundant touch state
Message-ID: <20120820160150.GA660@polaris.bitmath.org>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
 <1344807757-2217-20-git-send-email-rydberg@euromail.se>
 <CAN+gG=F6hhOxU--mF2v3sCTzFLHqd6vK5JqcvvDXigss7EkPHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=F6hhOxU--mF2v3sCTzFLHqd6vK5JqcvvDXigss7EkPHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> This patch seems to be a little bit complex.
> It has very good things, but also many things that hinders the readability.
> 
> And you should also remove the /* touchscreen emulation */ things in
> mt_input_mapping as input_mt_init_slots handles now the init of ABS_X
> ABS_Y and ABS_PRESSURE.

Yes, it could be changed as well, like the bit patterns. As you
mention below, the logic around the bits could be enhanced, and the
ABS_X/Y should go in that set of changes.

> > -struct mt_slot {
> > -       __s32 x, y, p, w, h;
> > -       __s32 contactid;        /* the device ContactID assigned to this slot */
> > -       bool touch_state;       /* is the touch valid? */
> > -       bool seen_in_this_frame;/* has this slot been updated */
> > -};
> 
> Why removing this struct?
> Removing it infers a lot of unneeded changes in the patch.
> 
> As the mt_sync_frame handle the quirk NOT_SEEN_MEANS_UP, we should
> just remove the field seen_in_this_frame.

Well, it is no longer needed, but sure, one could keep it and just
remove the unused fields.

> > @@ -464,12 +438,31 @@ static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
> >         return -1;
> >  }
> >
> > -static int mt_compute_slot(struct mt_device *td)
> > +static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
> > +
> > +{
> > +       struct mt_device *td = hid_get_drvdata(hdev);
> > +       struct mt_class *cls = &td->mtclass;
> > +       struct input_dev *input = hi->input;
> > +       unsigned int flags = 0;
> > +
> > +       if (test_bit(INPUT_PROP_POINTER, input->propbit))
> > +               flags |= INPUT_MT_POINTER;
> > +       if (test_bit(INPUT_PROP_DIRECT, input->propbit))
> > +               flags |= INPUT_MT_DIRECT;
> 
> These two tests are really strange: the function input_mt_init_slots
> already sets those bits....
> Maybe we should handle INPUT_PROP_POINTER, INPUT_PROP_DIRECT by
> keeping the flag instead of setting the bits and re-read them to
> finally re-set them...

Ok, I will extend the patchset for hid-multitouch to include such
changes as well.

Thanks,
Henrik

