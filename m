Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1GET0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:26:10 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:39149 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab1GET0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:26:07 -0400
X-SENDER-IP: [85.230.173.76]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArpiAO9kE05V5q1MPGdsb2JhbABTiQqefQsBAQEBNzKIegLCdg6GKASXPIsy
X-IronPort-AV: E=Sophos;i="4.65,481,1304287200"; 
   d="scan'208";a="205695232"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 5 Jul 2011 21:27:59 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: dmitry.torokhov@gmail.com, chase.douglas@canonical.com,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 09/12] Input: synaptics - add image sensor support
Message-ID: <20110705192759.GA29549@polaris.bitmath.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-10-git-send-email-djkurtz@chromium.org>
 <20110704214220.GE23915@polaris.bitmath.org>
 <CAGS+omAzKe5frVYuV2MPXBTugKD1xNZCHsaz53H+tDO7EWw8xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGS+omAzKe5frVYuV2MPXBTugKD1xNZCHsaz53H+tDO7EWw8xQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I guess the real question here is: do the following patches really
> > help? Creating additional logic to band-aid yet another special case,
> > which still does not give full MT support, seems to create more
> > problems than it solves. If the code was needed to ensure proper five
> > finger support to userspace, then maybe one could live with
> > it. However, as it stands, keeping the semi-mt behavior also for the
> > slightly better devices may not be such a bad idea, after all.
> >
> > _Iff_ the whole series can be formulated as true protocol B support
> > (no special flags, please), and _iff_ it helps to use software finger
> > tracking for less than four fingers, then please do tell, and we can
> > add that part to the input core to simplify the synaptics
> > implementation a bit.
> 
> Image sensors and profile sensors behave differently.  However, even
> the image sensors do not allow true MT-B, since they only report 2
> fingers.  Hence, it makes sense to add a property to distinguish the 3
> cases.

The lifetime of such a solution should also be considered.

> This implementation addresses the following issues:
> 
>   (1) Improves handling of the 2-finger case.  Image sensors due allow
> true MT-B for two finger case.  This, for example, allows detecting
> whether the click in a click+drag is happening in bottom right or
> bottom left quadrant of the pad.

In principle, this could be done within the semi-mt realm by adding a
binary value to the protocol, distinguishing the diagonals of the
bounding box. It would be ugly too, but at least it would be
compatible with the current semi-mt effort in userspace.

>   (2) Helps improve handling of number-of-fingers transitions.  Most
> of the complexity of the synaptics driver comes with dealing with the
> complicated way that the protocol handles number-of-fingers
> transitions.  Just ignoring them with semi-mt could cause lots of
> jumpy behavior as the transitions are mapped to bounding boxes whose
> coordinates jump around.  Thus, this implementation tries to notify
> userspace of finger transition by 'rolling slots' when necessary.

If the kernel driver cannot create a smooth bounding box, which by all
means is simpler than providing proper finger tracking, then there is
no way this can be done in userspace either.

> What I mean is, if the driver deduces that a given slot may not
> contain the same finger as a previous report, it releases it (sets its
> tracking_id = -1), and reestablishes the slot with a new tracking_id
> when it is more confident that it is now tracking a new finger.

As a general question, one might ask oneself: If the new device
_really_ can track five fingers, then why does it not send enough
information to recover that information? A proper tracking id would
suffice.

>   (3) Properly decode the "AGM_CONTACT" packet type.  4- and 5- finger
> gestures may never be supported, however, I think it is still a good
> idea to detect and parse these packets properly in the kernel driver,
> and leave policy to userspace.  I'm open to alternative suggestions
> for ways to represent this to userspace.  The idea in this patch set
> is to reuse the MT-B plumbing as much as possible, but use the device
> property to mark the fact that the interpretation of the resulting
> slots is somewhat different.

If the data cannot be reliably utilized, I doubt anyone cares.  There
is a lot of hardware out there capable of tracking ten and more
fingers, without the agonizing pain.

> A bare minimum patchset might do:
>    (1) Do true MT-B for two fingers
>    (2) Improved number-of-finger tracking for just the 2-finger case.
> (Keep tracking finger 1 when finger 2 is removed, and vice versa)

In what way is this different from 1)?

>    (3) Properly parse, but don't use, AGM_CONTACT packets

I am tempted to write something about Schrödinger's cat here... ;-)

Thanks,
Henrik
