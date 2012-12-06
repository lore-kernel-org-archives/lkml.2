Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2LFAPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 19:15:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35766 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2LFAPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:15:35 -0500
Message-ID: <1354752930.2795.37.camel@fourier>
Subject: Re: [PATCH v4 2/4] input: Cypress PS/2 Trackpad psmouse driver
From: Kamal Mostafa <kamal@canonical.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dudley Du <dudl@cypress.com>, David Solda <dso@cypress.com>,
        Troy Abercrombia <ta@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Date: Wed, 05 Dec 2012 16:15:30 -0800
In-Reply-To: <20121205200711.GA1025@polaris.bitmath.org>
References: <1354674245-25768-1-git-send-email-kamal@canonical.com>
	 <1354674245-25768-3-git-send-email-kamal@canonical.com>
	 <20121205200711.GA1025@polaris.bitmath.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik-

Thanks yet again, for your review.  I very much appreciate your time and
efforts to get the driver closer to acceptance.  Dmitry and Dudley, my
thanks to you as well.

Henrik, the forthcoming PATCH v5 includes all of your change requests
from this round.  See below for additional notes on those changes.


On Wed, 2012-12-05 at 21:07 +0100, Henrik Rydberg wrote:

> > +#undef CYTP_RELATIVE_SUPPORT  /* define to enable unused EV_REL code */
> 
> Code inside a local ifdef which is off by default is very rare in the
> kernel, and will likely bitrot. If you want to preserve the
> information, why not add it to the documentation, and remove the code
> here?

For PATCH v5, I have removed all that #ifdef'd relative-mode code.


> > +		/*
> > +		 * send extension command 0xE8 or 0xF3,
> > +		 * if send extension command failed,
> > +		 * try to send recovery command to make
> > +		 * trackpad device return to ready wait command state.
> > +		 * It alwasy success based on this recovery commands.
> > +		 */
> 
> This still reads the same, please change the wording of the last sentence.


The comment has been changed to:

                /*
                 * Send extension command byte (0xE8 or 0xF3).
                 * If sending the command fails, send recovery command
                 * to make the device return to the ready state.
                 */


> > +	if (cmd == CYTP_CMD_READ_VITAL_STATISTICS)
> > +		psmouse->pktsize = 8;
> 
> This still reads statistics, which is a misnomer.


All the "vital_stat{ist}ics" references have been changed to
"tp_metrics".


> > +		if (cytp->tp_res_x && cytp->tp_res_y) {
> > +			input_abs_set_res(input, ABS_X, cytp->tp_res_x);
> > +			input_abs_set_res(input, ABS_Y, cytp->tp_res_y);
> > +
> > +			input_abs_set_res(input, ABS_MT_POSITION_X,
> > +					  cytp->tp_res_x);
> > +			input_abs_set_res(input, ABS_MT_POSITION_Y,
> > +					  cytp->tp_res_y);
> > +
> > +		}
> 
> If the above block is not executed, the device will not function
> properly. Please return error or check preconditions again.


I have fixed this check (it now checks at the top of the routine, and
returns an error if x or y are insane).


> > +		/* Remove HSCROLL bit */
> > +		if (report_data->contact_cnt == 4)
> > +			header_byte &= ~(ABS_HSCROLL_BIT);
> 
> Why should this not be removed when contact_cnt is 5 ?


You're right: That bit should be removed if (contact_cnt & 0x4) ...

But you later pointed out that the vscroll/hscroll code isn't actually
used.  So having dropped that code, this clause can actually just be
dropped as well, which I've done.


> > +
> > +	if (report_data->contact_cnt <= 0)
> > +		return 0;
> 
> How can this happen?


It can be == 0 in the palm detection case (never <0).  I fixed and moved
that check up higher in the routine and commented it.


> > +#define CYTP_MAX_CONTACTS 2
> > +#define CYTP_MAX_MT_SLOTS 2
> 
> Code seems to depend on both being the same, please skip one.


CYTP_MAX_CONTACTS has been dropped.


> > +	signed char vscroll;
> > +	signed char hscroll;
> 
> The above two are only used for debug output.


They've been dropped.


 -Kamal


