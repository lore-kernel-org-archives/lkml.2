Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab2BVNMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:12:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44460 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab2BVNMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:12:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djkurtz@google.com designates 10.50.236.5 as permitted sender) smtp.mail=djkurtz@google.com; dkim=pass header.i=djkurtz@google.com
MIME-Version: 1.0
In-Reply-To: <20120222110459.GA28126@polaris.bitmath.org>
References: <1329896503-28394-1-git-send-email-cywang@chromium.org>
 <20120222083858.GA26570@polaris.bitmath.org> <CAGS+omCU9f=DyC442+4HOF=sGhZYXne+E2ephFiOmuj-XKciMA@mail.gmail.com>
 <20120222110459.GA28126@polaris.bitmath.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 22 Feb 2012 21:12:30 +0800
X-Google-Sender-Auth: _45kYtGqSVrfwOJZr-ObtOMACoo
Message-ID: <CAGS+omB0GCQHOjrb_T6h7DzHrH2sp4Xqb5av6JC-ttJ8HZ5BcQ@mail.gmail.com>
Subject: Re: [PATCH] CHROMIUM: Input: synaptics - filter out the events with
 low z values
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Chung-yih Wang <cywang@chromium.org>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 7:04 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Daniel,
>
>> > So if num_fingers == 2 and only one of a and b returns
>> > finger_touched() == true, we fall back to zero fingers?
>>
>> Actually, yes.   In this case, we will have 2 x's and 2 y's, but not
>> know which belong to a good finger and which belong to a too light
>> finger....  sigh... synaptics... sigh...
>
> I see the problem. However, ignoring it will just move the problem
> forward to another bug report, will it not?  Hysteresis is a slam dunk
> here.  In addition, since the low-pressure state is bound to be
> transitional (soon to be followed by a real num_fingers==1 package),
> simply skipping such packages might be a better option.

In practice, we don't actually see the profile sensor pad sending one
low-z finger, and one high-z finger.  In the case where one finger is
solidly on the pad, and another finger is hovering, lifting, or
alighting, the pad sends 2 high-z fingers, with one of them having a
completely wrong x or y coordinate.  The two reported z-values are
nearly, but not exactly, identical.  I can't think of good fix for
this, other than adding finger tracking and filtering out via
'moved-too-far-too-fast', where possible, and I'd prefer that this be
handled in userspace.  The 1-low-z && 1-high-z case that we are
discussing here isn't actually ever triggered; either both fingers are
high-z, or neither are.

The real usefulness of this patch is filtering out the 1-low-z-finger
and 2-low-z fingers cases.

As for the hypothetical 1-finger-hi, 1-finger-low case, which I asked
Chung-yih to add because it seemed like a good idea in theory...

Yes, I think you have a good point.  Thanks to evdev's stateful
nature, simply skipping the (1-strong,1-weak) packet might actually
work better than forcing num_fingers == 0.

For cases where a second finger is temporarily reporting low-z because
it is arriving or leaving, evdev would just lock the (1 or 2 initial)
fingers in their current position until the transition is over, and
then start reporting the new number of fingers at their new positions.

For cases where there is one high-z finger, and a hovering thumb or
palm triggers 2-finger reporting temporarily (without ever going above
the threshold), the original finger will get frozen in its current
position until the hovering finger is no longer detected, and then
snap to its new position.  This might cause strange sudden jumps, but
that seems unavoidable.

I'm not sure hysteresis is a "slam dunk"...  in fact, I don't see how
it would help much.  But, it is hard to argue against adding the
functionality, since the hysteresis window can be made arbitrarily
small.  Perhaps if you are inclined, you can elaborate on why you
think it is important.

Thanks for you excellent feedback!
-Daniel

>
>> > Why not introduce hysteresis for all fingers here? There is an example
>> > implementation in bcm5974.c in the same directory.
>>
>> Good idea, can it be in a different, follow-up patch?
>
> Why should it be?
>
> Thanks,
> Henrik
