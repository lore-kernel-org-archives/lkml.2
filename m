Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2K2Vz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:55:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38048 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab2K2Vz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:55:57 -0500
Message-ID: <1354226152.12162.6.camel@fourier>
Subject: Re: [PATCH v2 2/3] input: Cypress PS/2 Trackpad psmouse driver
From: Kamal Mostafa <kamal@canonical.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Solda <dso@cypress.com>, Troy Abercrombia <ta@cypress.com>,
        Dudley Du <dudl@cypress.com>,
        Cypress Semiconductor Corporation <customercare@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Date: Thu, 29 Nov 2012 13:55:52 -0800
In-Reply-To: <20121121192012.GA1345@polaris.bitmath.org>
References: <1353447010-4852-1-git-send-email-kamal@canonical.com>
	 <1353447010-4852-3-git-send-email-kamal@canonical.com>
	 <20121121192012.GA1345@polaris.bitmath.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik-

Thanks very much for your detailed review...


On Wed, 2012-11-21 at 20:20 +0100, Henrik Rydberg wrote:
> Reading the patch, it looks very much like a typical semi-mt device to
> me. Any good reason not to handle it that way?

Well, the device does properly report contact-counts up to 5 fingers
(though only two actual contact positions).  If I understand SEMI_MT
correctly (and I might not) using it restricts us to reporting only up
to 2 fingers, which seems undesirable.

That said, my forthcoming PATCH v3 does implement the SEMI_MT /
2-contacts-only method as you requested (I think) -- and includes one
more proposed patch to re-enable >2 contacts.

PATCH v3 also implements the majority of your other suggestions,
including replacing all the custom slot tracking code with
input_mt_assign_slots.  Large swaths of code have been eliminated
(thanks!).

Below are notes regarding the few suggestions which I have not
addressed.

Thanks again for your help, and in advance for your review of PATCH v3.

 -Kamal


> > +static int cypress_read_vital_statistics(struct psmouse *psmouse)
> > +{
>> [...]
> > +
> > +	if (!cytp->tp_max_pressure ||
> > +	    (cytp->tp_max_pressure < cytp->tp_min_pressure) ||
> > +	    (!cytp->tp_width || !cytp->tp_high) ||
> > +	    (!cytp->tp_max_abs_x) ||
> > +	    (cytp->tp_max_abs_x < cytp->tp_width) ||
> > +	    (!cytp->tp_max_abs_y) ||
> > +	    (cytp->tp_max_abs_y < cytp->tp_high))
> > +		return -1;
> 
> Odd parenthesis. Can tp_min_pressure be zero? Don't we trust the
> values coming from the device?

I do not know, so I have left this as is.


> > +static psmouse_ret_t cypress_validate_byte(struct psmouse *psmouse)
> > +{
> > +	int contact_cnt;
> > +	int index = psmouse->pktcnt - 1;
> > +	unsigned char *packet = psmouse->packet;
> > +	struct cytp_data *cytp = psmouse->private;
> > +
> > +	if (index < 0 || index > cytp->pkt_size)
> > +		return PSMOUSE_BAD_DATA;
> > +
> > +	if ((index == 0) && ((packet[0] & 0xfc) == 0)) {
> > +		/* call packet process for reporting finger leave. */
> > +		cypress_process_packet(psmouse, 1);
> > +		return PSMOUSE_FULL_PACKET;
> > +	}
> 
> Odd placement given the function's name?

Do you mean the call to cypress_process_packet?  I agree that it is odd.
Left it as is.  :-)


> > diff --git a/drivers/input/mouse/cypress_ps2.h b/drivers/input/mouse/cypress_ps2.h
>> [...]
> > +
> > +/* bits of first byte response of E9h-Status Request command. */
> > +#define RESP_BTN_RIGHT_BIT  0x01
> > +#define RESP_BTN_MIDDLE_BIT 0x02
> > +#define RESP_BTN_LEFT_BIT   0x04
> > +#define RESP_SCALING_BIT    0x10
> > +#define RESP_ENABLE_BIT     0x20
> > +#define RESP_REMOTE_BIT     0x40
> > +#define RESP_SMBUS_BIT      0x80
> > +
> > +#define CYTP_MAX_CONTACTS 5
> > +#define CYTP_MAX_MT_SLOTS 16
> 
> Are all these values used?

Some of the #define's are not used, but I'm reluctant to remove them as
they might be useful for later versions of the driver.  I left them as
is, pending your advice.



