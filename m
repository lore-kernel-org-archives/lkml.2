Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2KMSWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:22:06 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:33002 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab2KMSWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:22:05 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai+wAF6MolBV5h1yPGdsb2JhbABEhTGFI7gmAgF+GQEBAQEfGQ0ngh4BAQQBOhwjBQsIA0YUJQoaMYdmCqobkC0UjQ+BfoJ8YQOVe4V7g06Jaw
X-IronPort-AV: E=Sophos;i="4.80,768,1344204000"; 
   d="scan'208";a="229014840"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 13 Nov 2012 19:28:25 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 13/13] HID: hid-multitouch: forwards ABS_SCAN_TIME
Message-ID: <20121113182825.GA3627@polaris.bitmath.org>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352306256-12180-14-git-send-email-benjamin.tissoires@gmail.com>
 <50A25990.6040302@gmail.com>
 <20121113172711.GA856@polaris.bitmath.org>
 <CAN+gG=HdOqVu1M2pycMZUBd4Z7wK9Bx=NLkCaaFwFie1-E3tdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=HdOqVu1M2pycMZUBd4Z7wK9Bx=NLkCaaFwFie1-E3tdQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> @@ -98,6 +99,9 @@ struct mt_device {
> >>       bool serial_maybe;      /* need to check for serial protocol */
> >>       bool curvalid;          /* is the current contact valid? */
> >>       unsigned mt_flags;      /* flags to pass to input-mt */
> >> +     __s32 dev_time;         /* the scan time provided by the device */
> >> +     unsigned long jiffies;  /* the frame's jiffies */
> >> +     unsigned timestamp;     /* the timestamp to be sent */
> >
> > Why not just dev_time here?
> 
> because max dev_time is at least 65535 according to the norm, and the
> win 8 device I have has his max value of 65535.
> Which means that every 6 seconds and a half the counter resets, and
> the value is not properly reset in the way I understand the
> specification. The device just forwards an internal clock that is
> never reset.

Ok, I though it was a 32-bit value, and that it would wrap with a
longer period. It does not change the essence of the definition,
though. If we say "seconds" instead of "hours", we should still be
fine, no?

> So if you wait 653500 us + 8ms, everything happens as if the device
> sent this frame right after the previous one (you get the same value).

Yes, but we have this effect on a 32-bit counter as well.

> I think that it's the job of the kernel to provide clean and coherent
> values through evdev, which won't be the case if the jiffies thing is
> not in place: every devices will have a different behavior, leading to
> complicate things in the user-space.

The whole point is to provide the device clock to userland when it
exists, isn't it? Thus, the jiffies would never be used. If a future
device needs additions to work conformly, we just have to deal with it
at that point in time.

To conclude, we obviously have devices with a rather short wrap-around
time. However, since the normal inter-frame time is in the millisecond
range, it should not be overly restrictive to change the definition of
the minimum wraparound time from hours to seconds.

Thanks,
Henrik
