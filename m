Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab1HOHqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 03:46:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:33381 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab1HOHqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 03:46:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:x-system-of-record;
	b=lesGY58TWO0ADgM2vKUSGgTld7ryzRVkh0BfdKjYGI/typ2Ijgp8iCWp90/QPL/bv
	zPAqHtHYMqNWRksgJVDuw==
MIME-Version: 1.0
In-Reply-To: <20110812215253.GB9124@polaris.bitmath.org>
References: <1313169407-4358-1-git-send-email-djkurtz@chromium.org>
 <1313169407-4358-7-git-send-email-djkurtz@chromium.org> <20110812215253.GB9124@polaris.bitmath.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Mon, 15 Aug 2011 15:46:07 +0800
X-Google-Sender-Auth: R83cDQHRe0eL4wfCiUXGlVEvLGo
Message-ID: <CAGS+omDpg51Bky7gu8+EpD=2QQz4j_o=SV997fVJDMzUSOv7SA@mail.gmail.com>
Subject: Re: [PATCH 6/8 v3] Input: synaptics - process finger (<=3) transitions
To: Henrik Rydberg <rydberg@euromail.se>
Cc: chase.douglas@canonical.com, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

Thanks for the feedback.

On Sat, Aug 13, 2011 at 5:52 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>
> Hi Daniel,
>
> > Synaptics image sensor touchpads track 5 fingers, but only report 2.
> > This patch attempts to deal with some idiosyncrasies of these
> > touchpads:
>
> I appreciate the complexity of the protocol at hand, and the patch is
> doing an excellent job documenting it. However, it does constitute a
> fair deal of code... What about the statements below:
>
> 1. When two subsequent sgm packets report the same number of fingers
> (and unless told otherwise in some other fashion?), the sgm and the
> previous agm contains data for the same fingers as the previous (agm,
> sgm) pair, i.e., there is no transition.
>
> 2. There is no general way to know which fingers are being reported
> after a transition.
>
> If both points above are true, how about something like this:
>
> a) Always report slots zero and one (for two or more fingers)
>
> b) Keep a global number, trackid
>
> c) Parse are buffer agm
>
> d) Parse sgm
>
> e) If a transition occured, increase trackid by two
>
> f) Set TRACKING_ID to trackid in slot zero and trackid+1 in slot one.
>
> It seems to me the above will result in contiuous handling of two
> unknown contacts in between transitions, and during transitions, new
> contacts will be generated.
>
> The algorithm above could possibly be improved for the 2->1
> transition, but from what I gather, 1->2 and 2->3 as well as 3->2 does
> not seem to be generally solvable, hence resulting in the above
> anyways.
>
> If any of points 1 and 2 are wrong, I am sure you will
> enlighten/remind me. ;-)
>
> Cheers,
> Henrik

Actually, "in general", it is possible to know which fingers are being
reported _after_ a transition.

However:
  (1) Since the number of fingers is only reported in SGM packets, it
is not possible, _during_ a transition, to know whether the AGM was
sent for the old number of fingers, or the new number of fingers.
  (2) There is no way to tell which fingers remain when going from
3->2 fingers. Once we lose track, we can't really know what fingers we
are tracking until:
     (a) All fingers are removed
     (b) All but the 'primary' (finger slot[0]) are removed
     (c) 4 or 5 fingers are touched (this triggers an AGM_CONTACT
packet, which properly resets the driver's state)
  (3) Similarly, on 3->1 transitions, if the 'primary' (finger
slot[0]) finger is NOT the one that remains, we don't know which
finger remains.  Tracking state must be restored with (a), (b), or (c)
above.
  (4) A quick finger change, can generate a 1->1 (non-)transition with
an intervening AGM packet. In this case, the new SGM is actually
tracking slot[1], not slot[0].  If a second finger touches, this new
second finger will fill the now-empty slot[0], and, thus, be reported
in the SGM.

This results in a lot of the special handling in the switch/cases.

The resulting algorithm can accurately handle 1->2->1 transitions very
well (including drum roll, and no matter which of the two fingers is
being reported in the second '1' state).
It can deal with 1->2->3 properly in the typical "adding fingers" case.
Lastly, it also realizes when it has lost track (after 3->2 / 3->1
transition), and handles subsequent (1->2, 2->1, 2->3) transitions
carefully (by invalidating slots).

So, I think even if we started with a simpler "always use two new
slots" approach, once we added back the special casing, it would be
just as much code...

A simple example:
  On 2->3, even if we always used two new slots, we still couldn't
report them accurately, immediately, because we don't know whether the
AGM during the transition was for the "2" state, or the "3" state.
Instead, we'd need to do something like what I'm doing now: report
3:[0,-1] "three fingers down, the only one I can report is that the
one in slot[0]"

-Dan
