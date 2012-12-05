Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab2LECWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 21:22:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58882 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2LECWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 21:22:50 -0500
Message-ID: <1354674169.11174.87.camel@fourier>
Subject: Re: [PATCH v3 2/4] input: Cypress PS/2 Trackpad psmouse driver
From: Kamal Mostafa <kamal@canonical.com>
To: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dudley Du <dudl@cypress.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Solda <dso@cypress.com>, Troy Abercrombia <ta@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Date: Tue, 04 Dec 2012 18:22:49 -0800
In-Reply-To: <20121203074520.GA2687@polaris.bitmath.org>
References: <1354226281-3476-1-git-send-email-kamal@canonical.com>
	 <1354226281-3476-3-git-send-email-kamal@canonical.com>
	 <20121203074520.GA2687@polaris.bitmath.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik-

Thanks again for your review.  The forthcoming PATCH v4 includes the
majority of your change requests, except where noted below (and
considering my email "Subject: SEMI_MT vs. simulated mt")...


On Mon, 2012-12-03 at 08:45 +0100, Henrik Rydberg wrote:

> > +		/*
> > +		 * send extension command 0xE8 or 0xF3,
> > +		 * if send extension command failed,
> > +		 * try to send recovery command to make
> > +		 * trackpad device return to ready wait command state.
> > +		 * It alwasy success based on this recovery commands.
> 
> -EPARSE

I don't understand the meaning of that comment either.  Perhaps the
original author Dudley Du can explain it.


> > +static int cypress_read_vital_statistics(struct psmouse *psmouse)
> 
> Why do you call this statistics?

Perhaps "cypress_read_tp_metrics" would be a better name.  Any thoughts
on this, Dudley?


> > +/*
> > + * reset trackpad device to standard relative mode.
> > + * This is also the defalut mode when trackpad powered on.
> > + */
> > +static void cypress_reset(struct psmouse *psmouse)
> > +{
> > +	struct cytp_data *cytp = psmouse->private;
> > +
> > +	psmouse_reset(psmouse);
> > +
> > +	CYTP_SET_MODE_BIT(CYTP_BIT_STANDARD_REL);
> > +	CYTP_SET_PACKET_SIZE(3);
> > +
> > +	cytp->prev_contact_cnt = 0;
> > +}
> 
> I suppose it is, but is it necessary to reset to default mode?

I left this unchanged, as I think you and Dmitry agreed.


> > +
> > +static int cypress_set_input_params(struct input_dev *input,
> > +				    struct cytp_data *cytp)
> > +{
> > +	int ret;
> > +
> > +	if (cytp->mode & CYTP_BIT_ABS_MASK) {
> 
> It seems the device will always operate in this mode, so please simplify.

I #ifdef'd out the unused relative-mode code, as opposed to deleting it.
Will that be acceptable?


> > +		/* Remove HSCROLL bit */
> > +		if (report_data->contact_cnt == 4)
> > +			header_byte &= ~(ABS_HSCROLL_BIT);
> 
> Why conditionally?

Dudley, can you answer this?  I left this (and all the scroll code)
unchanged.


> > +#if 0
> > +	/* FIXME: cypress_reconnect() never works...
> > +	 * just let psmouse re-init() us for now.
> > +	 */
> > +	psmouse->reconnect = cypress_reconnect;
> > +#endif
> 
> This needs to be removed or fixed, of course.

Per Dudley, this does work in his disconnect/reconnect scenario, so I
re-enabled it.  We will continue to investigate why it fails
(harmlessly) in my suspend/resume scenario.


> > +	int tp_max_abs_x;  /* Max X absolution units can be reported. */
> > +	int tp_max_abs_y;  /* Max Y absolution units can be reported. */
> 
> I do not think we are seeking absolution here. :-)

Ha!  Speak for yourself, Henrik!  ;-)  I'm starting to feel like maybe I
should be seeking absolution here!


 -Kamal


