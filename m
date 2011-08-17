Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab1HQQrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 12:47:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54305 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab1HQQrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 12:47:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=sueNncPTxlASXtUt64oXm4hzN5Kmy8xPG2sduo00/8pLJsjn+ZZldoATtEzp4hmrO
	jZ511qyp4umVzuuEi6DFg==
MIME-Version: 1.0
In-Reply-To: <20110817163226.GB4877@core.coreip.homeip.net>
References: <1313169407-4358-1-git-send-email-djkurtz@chromium.org>
 <1313169407-4358-5-git-send-email-djkurtz@chromium.org> <20110812210911.GA9124@polaris.bitmath.org>
 <CAGS+omAo1tPzBQ_s+vz-7_5SS6vWv4bdzD1JfqepUS7wYxK5sA@mail.gmail.com>
 <CAGS+omCeb6R_Y7Js+da=E+etNYXWu+DjT=Mio_DLSwQo97yNkg@mail.gmail.com> <20110817163226.GB4877@core.coreip.homeip.net>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 18 Aug 2011 00:47:12 +0800
X-Google-Sender-Auth: O13Q5sF76JtUM1AfOJxKwbfMWNQ
Message-ID: <CAGS+omDWRu6CVgHs1BQpOpWYwA6oECNmn=60hnCsWEaVVbAckA@mail.gmail.com>
Subject: Re: [PATCH 4/8 v3] Input: synaptics - add image sensor support
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, chase.douglas@canonical.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 12:32 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> On Wed, Aug 17, 2011 at 10:05:48PM +0800, Daniel Kurtz wrote:
> > On Mon, Aug 15, 2011 at 3:17 PM, Daniel Kurtz <djkurtz@chromium.org> wrote:
> > >
> > > Hi Henrik,
> > >
> > > Thanks for the great feedback.
> > >
> > > On Sat, Aug 13, 2011 at 5:09 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> > > > Hi Daniel,
> > > >
> > > > looks good, some details below.
> > > >
> > > > The ABS_MT_TOUCH_MAJOR is supposed to have zero intercept, to remain
> > > > compatible with user space handling of type A devices. Also, the scale
> > > > should match the screen/pad size, such that the actual size of the
> > > > touch area can be deduced. In addition, based on the current sensor
> > > > technologies, ABS_MT_PRESSURE and ABS_MT_TOUCH_MAJOR are normally
> > > > mutually exclusive.
> > > >
> > > > All in all, I would prefer to only report width via (the single-finger
> > > > axis) ABS_TOOL_WIDTH, and only for compatibility reasons.
> > > >
> > > > +
> > > > +static void synaptics_report_slot_agm(struct input_dev *dev, int slot,
> > > > +                                   const struct synaptics_hw_state *agm)
> > > > +{
> > > > +     input_mt_slot(dev, slot);
> > > > +     input_mt_report_slot_state(dev, MT_TOOL_FINGER, true);
> > > > +     input_report_abs(dev, ABS_MT_POSITION_X, agm->x);
> > > > +     input_report_abs(dev, ABS_MT_POSITION_Y, invert_y(agm->y));
> > > > +     input_report_abs(dev, ABS_MT_PRESSURE, agm->z);
> > > > +}
> > >
> > > With ABS_MT_TOUCH_MAJOR dropped, sgm and agm seems to coincide...
> > > ....
> > > >
> > > > Looks good otherwise.
> > > >
> > > > Thanks,
> > > > Henrik
> > > >
> > >
> > > Ahh....  ok, this makes sense.  I missed this detail previously.
> > > Basically:
> > >  * Only report synaptics "w" as ABS_TOOL_WIDTH (for backwards compatibility)
> > >  * Report synaptics "z" as ABS_MT_TOUCH_MAJOR (assuming it is really
> > > 'width of finger in surface units'), and ABS_PRESSURE (for backwards
> > > compatibility).
> > >  * Don't use ABS_MT_PRESSURE.
> > >  * This will simplify agm/sgm reporting by making them both reoprt
> > > the same axes.
> >
> > Hi Henrik,
> >
> > I think I was wrong in my previous comment.
> >
> > I agree we should drop reporting synaptics 'w' (4-15, arbitrary units)
> > in ABS_MT_TOUCH_MAJOR.
> > Instead, to support legacy, report 'w' in ABS_TOOL_WIDTH, and do not
> > report ABS_MT_TOUCH_MAJOR at all.
> >
> > However, I believe we should still report synaptics 'z' (0-255, in
> > arbitrary units) as ABS_MT_PRESSURE.
> > This will, in turn, be used by input_mt_report_pointer_emulation() to
> > determine the correct ABS_PRESSURE to report for legacy userspace
> > uses.
>
> Alternatively, you can use input_mt_set_value() to save Z value to be
> used by input_mt_report_pointer_emulation() later, but not report it as
> part of MT packet.
>
> --
> Dmitry

But I want userspace to get per-contact pressure, since it is used to
determine whether a given contact is a palm or finger, etc. The
trackpad does not report a useful per-contact "width" that can be used
to generate "TOUCH_MAJOR".
Does it therefore sound reasonable to report ABS_MT_PRESSURE?

-Dan
