Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab1GFRpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:45:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35426 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1GFRpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:45:12 -0400
Date: Wed, 6 Jul 2011 10:45:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Henrik Rydberg <rydberg@euromail.se>, chase.douglas@canonical.com,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 09/12] Input: synaptics - add image sensor support
Message-ID: <20110706174503.GA5695@core.coreip.homeip.net>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-10-git-send-email-djkurtz@chromium.org>
 <20110704214220.GE23915@polaris.bitmath.org>
 <CAGS+omAzKe5frVYuV2MPXBTugKD1xNZCHsaz53H+tDO7EWw8xQ@mail.gmail.com>
 <20110705192759.GA29549@polaris.bitmath.org>
 <CAGS+omDzg-xADYxKQmWy1KRhJ=n9pn9XR_HMc01xqCSDSLa5UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGS+omDzg-xADYxKQmWy1KRhJ=n9pn9XR_HMc01xqCSDSLa5UA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 12:41:26AM +0800, Daniel Kurtz wrote:
> On Wed, Jul 6, 2011 at 3:27 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> >> ...
> >> This implementation addresses the following issues:
> >>
> >>   (1) Improves handling of the 2-finger case.  Image sensors due allow
> >> true MT-B for two finger case.  This, for example, allows detecting
> >> whether the click in a click+drag is happening in bottom right or
> >> bottom left quadrant of the pad.
> >
> > In principle, this could be done within the semi-mt realm by adding a
> > binary value to the protocol, distinguishing the diagonals of the
> > bounding box. It would be ugly too, but at least it would be
> > compatible with the current semi-mt effort in userspace.
> 
> (A) I think the "semi-mt" protocol works like this:
>   (1) When two or more fingers are on the pad, report two MT-B slots, where:
>     (a) slot[0] contains (x_min, y_min) of the two fingers
>     (b) slot[1] contains (x_max, y_max) of the two fingers
>     (c) Total number of fingers on pad is indicated by EV_KEY/BTN_TOOL_* is set.
>   (2) If one of the two fingers is removed, then the first slot is
> used to report
>       the remaining finger, whichever it is, without changing the
> slot's tracking_id.
>   (3) Advertise this behavior with the SEMI_MT device property
> 
> (B) This is what the proposed T5R2 driver does:
>   (1) When N fingers are on the pad, report N MT-B slots, where:
>     (a) The lowest indexed active slot (tracking_id != -1) contains
> valid finger position data.
>     (b) The highest indexed active slot (tracking_id != -1) contains
> valid finger position data.
>     (c) Any active slots (tracking_id != -1) between these does not
> contain valid finger position data, these 'hidden' slots are just
> active to indicate that there are that many fingers on the pad.
>     (d) Total number of fingers on the pad is always the number of active slots.
>   (2) When fingers are removed from the pad:
>     (a) keep reporting the fingers that are left in the same slots,
> with the same tracking_ids, if possible.
>     (b) If the identities of the fingers that remain is ambiguous,
> invalidate all slots,then re-assign the fingers that remain to new
> slots, with new tracking ids.
>   (3) Advertise this behavior with the T5R2 device property
> 

This is a no-go. I do not want to add TxRy or similar "properties". We
have a workable semi-mt (counding box) and full mt concepts and we
should present userspace with data stream that conforms either one or
another.

> (C) A third, compromise implementation might be to do something like this:
>   (1) When >=2 fingers are on the pad, report 2 MT-B slots, where:
>     (a) slot[0] reports finger 1
>     (b) slot[1] reports finger 2
>     (c) Total number of fingers on pad is indicated by EV_KEY/BTN_TOOL_* is set.
>   (2) If 1 finger is removed, the tracking_id for its slot is invalidated;
>       but, the finger that remains stays in its same slot with the
> same tracking_id.
>   (3) Whenever the number of fingers changes from/to 3 or more
> fingers, both slots are always invalidated.
>       New tracking_ids are assigned to both slots which contain the
> two fingers now being reported.
>   (4) No special driver property is required for this, not even "semi-mt".
>       It should be as pure MT-B as we can get (plus BTN_TOOL_* hack).
> 

This is the best option in my opinion. We will present 2 finger position
data plus extended finger count.

Thanks.

-- 
Dmitry
