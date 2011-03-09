Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab1CINOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:14:12 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:47203 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932144Ab1CINOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:14:10 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 9 Mar 2011 14:16:44 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] hid-multitouch: Auto detection of maxcontacts
Message-ID: <20110309131643.GA10925@polaris.bitmath.org>
References: <1299601979-4871-1-git-send-email-benjamin.tissoires@enac.fr>
 <1299601979-4871-2-git-send-email-benjamin.tissoires@enac.fr>
 <20110309112255.GA9020@polaris.bitmath.org>
 <AANLkTimU0dt_XJVvnD+-JxEhVXMb0pzar0kip56zs11u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimU0dt_XJVvnD+-JxEhVXMb0pzar0kip56zs11u@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PxJDE-0001NQ-6K.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PxJDE-0001NQ-6K c9c699ff9595b2095f75058b619af9c4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > if (td->mtclass->maxcontacts > td->maxcontacts)
> >
> >> +                     /* check if the maxcontacts is given by the class */
> >> +                     td->maxcontacts = td->mtclass->maxcontacts;
> >> +
> >> +             if (!td->maxcontacts)
> >> +                     td->maxcontacts = MT_CONTACTMAX_DEFAULT;
> >
> > this part can be then dropped
> 
> Well, it works the way you are suggesting. BTW this let the corner
> case where someone adds a device (MT_CLS) that does not send the
> contact max and does not initialize the .maxcontact field.

Yes, the patch changes the current, perfectly reasonable assumption
that maxcontact is set. If that change is removed from the patch, it
makes the logic simpler, without changing the semantics of the current
code.

> >> +     td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
> >> +                             GFP_KERNEL);
> >> +
> >
> > Don't we have a race problem here?  It seems the device is started at
> > this point, so I worry that events will be handled when slots is still
> > NULL.
> 
> I tried again yesterday: if I put this line above the hid_hw_start ->
> kernel oops at first touch.
> The point is that hid_hw_start calls hid_connect that do the actual
> calls to input_mapping and feature_mapping.

Yes, that is clear, but the urbs are running, and as fas as I can see,
irqs can be delivered to mt_event(). Minute time window, testing is
not likely to hit this. Adding a test for completed initialization in
mt_event() would make sure.

Oh, and there is no test for failed memory allocation.

Thanks.
Henrik
