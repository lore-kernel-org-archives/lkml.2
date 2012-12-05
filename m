Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2LEGY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 01:24:26 -0500
Received: from relay.ihostexchange.net ([66.46.182.58]:53842 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2LEGYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 01:24:23 -0500
From: Dudley Du <dudl@cypress.com>
To: Kamal Mostafa <kamal@canonical.com>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Solda <dso@cypress.com>, Troy Abercrombia <ta@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        Dudley Du <dudl@cypress.com>
Date: Wed, 5 Dec 2012 01:24:14 -0500
Subject: RE: [PATCH v3 2/4] input: Cypress PS/2 Trackpad psmouse driver
Thread-Topic: [PATCH v3 2/4] input: Cypress PS/2 Trackpad psmouse driver
Thread-Index: Ac3Sj2xpNFQB9OymQvWRLVI3pzo4sgAAZgQA
Message-ID: <B27AC323FA92C946BA36D2913DDC8E370234D9A16FD4@VMBX126.ihostexchange.net>
References: <1354226281-3476-1-git-send-email-kamal@canonical.com>
	 <1354226281-3476-3-git-send-email-kamal@canonical.com>
	 <20121203074520.GA2687@polaris.bitmath.org>
 <1354674169.11174.87.camel@fourier>
In-Reply-To: <1354674169.11174.87.camel@fourier>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB56OWKP012812

Hi Henrik, Kamal,

Thanks for your review.
And I add some comments in below.

Thanks.
Dudley Du
dudl@cypress.com

> Hi Henrik-
>
> Thanks again for your review.  The forthcoming PATCH v4 includes the majority of your change requests, except where noted below (and considering my email "Subject: SEMI_MT vs. simulated mt")...
>
>
> On Mon, 2012-12-03 at 08:45 +0100, Henrik Rydberg wrote:
>
> > > +         /*
> > > +          * send extension command 0xE8 or 0xF3,
> > > +          * if send extension command failed,
> > > +          * try to send recovery command to make
> > > +          * trackpad device return to ready wait command state.
> > > +          * It alwasy success based on this recovery commands.
> >
> > -EPARSE
>
> I don't understand the meaning of that comment either.  Perhaps the original author Dudley Du can explain it.

Since all trackpad specific commands are sent as extension command,
the format of extension command series is "0xE8 dd 0xE8 cc 0xE8 bb 0xE8".
And as we know, it may fail when sending the extension command series,
So this comment just want to indicates that if some unknown error occurred when sending the extension command,
this code will send recovery command to make trackpad firmware go back to ready state,
so same command can be tried to be re-sent.
Sorry for the bad comments causing confusion.

> > > +static int cypress_read_vital_statistics(struct psmouse *psmouse)
> >
> > Why do you call this statistics?
>
> Perhaps "cypress_read_tp_metrics" would be a better name.  Any thoughts on this, Dudley?
>
>
> > > +/*
> > > + * reset trackpad device to standard relative mode.
> > > + * This is also the defalut mode when trackpad powered on.
> > > + */
> > > +static void cypress_reset(struct psmouse *psmouse) {
> > > + struct cytp_data *cytp = psmouse->private;
> > > +
> > > + psmouse_reset(psmouse);
> > > +
> > > + CYTP_SET_MODE_BIT(CYTP_BIT_STANDARD_REL);
> > > + CYTP_SET_PACKET_SIZE(3);
> > > +
> > > + cytp->prev_contact_cnt = 0;
> > > +}
> >
> > I suppose it is, but is it necessary to reset to default mode?
>
> I left this unchanged, as I think you and Dmitry agreed.
>
>
> > > +
> > > +static int cypress_set_input_params(struct input_dev *input,
> > > +                             struct cytp_data *cytp)
> > > +{
> > > + int ret;
> > > +
> > > + if (cytp->mode & CYTP_BIT_ABS_MASK) {
> >
> > It seems the device will always operate in this mode, so please simplify.
>
> I #ifdef'd out the unused relative-mode code, as opposed to deleting it.
> Will that be acceptable?

I think relative-mode code should be reserved,
since for some unknown reason, trackpad may failed in absolution mode,
and in order to make trackpad device kept on usable,
we may set it to relative-mode,
so in this situation, the relative-mode code should be exist.


> > > +         /* Remove HSCROLL bit */
> > > +         if (report_data->contact_cnt == 4)
> > > +                 header_byte &= ~(ABS_HSCROLL_BIT);
> >
> > Why conditionally?
>
> Dudley, can you answer this?  I left this (and all the scroll code) unchanged.

Yes, this condition should be reserved.
Because ABS_HSCROLL_BIT is will reused to indicate finger numbers when finger number is bigger than 3.
And when the contact_cnt is 4, the ABS_HSCROLL_BIT is set to indicate 4 fingers touched, not HSCROLL BIT set.
But it will be confused with the flag of HSCROLL bit with one finger touched.
So we must clear this bit when contact_cnt is 4.


> > > +#if 0
> > > + /* FIXME: cypress_reconnect() never works...
> > > +  * just let psmouse re-init() us for now.
> > > +  */
> > > + psmouse->reconnect = cypress_reconnect; #endif
> >
> > This needs to be removed or fixed, of course.
>
> Per Dudley, this does work in his disconnect/reconnect scenario, so I re-enabled it.  We will continue to investigate why it fails
> (harmlessly) in my suspend/resume scenario.


> > > + int tp_max_abs_x;  /* Max X absolution units can be reported. */
> > > + int tp_max_abs_y;  /* Max Y absolution units can be reported. */
> >
> > I do not think we are seeking absolution here. :-)
>
> Ha!  Speak for yourself, Henrik!  ;-)  I'm starting to feel like maybe I should be seeking absolution here!
>
>
>  -Kamal

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
