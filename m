Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab1CXLqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:46:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab1CXLqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:46:17 -0400
Date: Thu, 24 Mar 2011 12:46:14 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] hid-multitouch: migrate 3M PCT touch screens to
 hid-multitouch
In-Reply-To: <20110322165815.GA6706@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1103241244500.19969@pobox.suse.cz>
References: <AANLkTimFF3pgMMgOcEhYnRm5adgsCL5S6Hjkz+GFcpCT@mail.gmail.com> <1300811641-3327-1-git-send-email-benjamin.tissoires@enac.fr> <20110322165815.GA6706@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Henrik Rydberg wrote:

> On Tue, Mar 22, 2011 at 05:34:01PM +0100, Benjamin Tissoires wrote:
> > This patch merges the hid-3m-pct driver into hid-multitouch.
> > To keep devices working the same way they used to with hid-3m-pct,
> > we need to add two signal/noise ratios for width and height.
> > We also need to work on width/height to send proper
> > ABS_MT_ORIENTATION flag.
> > 
> > Importing 3M into hid-multitouch also solved the bug in which
> > devices handling width and height in their report descriptors
> > did not show ABS_MT_TOUCH_MAJOR and ABS_MT_TOUCH_MINOR.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> > Reviewed-by: Stéphane Chatty <chatty@enac.fr>
> > ---
> [...]
> > Henrik, do I still have your Reviewed-and-tested-by ?
> 
> Yep, looks good. One more thing, though:
> 
> > @@ -332,11 +351,18 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
> >  		input_mt_report_slot_state(input, MT_TOOL_FINGER,
> >  			s->touch_state);
> >  		if (s->touch_state) {
> > +			/* this finger is on the screen */
> > +			int wide = (s->w > s->h);
> > +			/* divided by two to match visual scale of touch */
> > +			int major = max(s->w, s->h) >> 1;
> > +			int minor = min(s->w, s->h) >> 1;
> 
> This scaling is most likely not correct for all devices. I went
> through a set of devices some time ago, running mtview on all of them,
> visually inspecting the touch size. Some were low by a factor of two,
> some were high by a factor of two. A confirmation that the other
> devices supported by this driver seem right would be good. If not, a
> quirk should probably be added here.

Okay, thanks a lot for the review. This can be handled later during 
-rc phase if needed. So please proceed with confirming with the existing 
devices, and meanwhile I have applied the patch.

> > +
> >  			input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
> >  			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
> > +			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
> >  			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
> > -			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, s->w);
> > -			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, s->h);
> > +			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
> > +			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
> >  		}
> >  		s->seen_in_this_frame = false;

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
