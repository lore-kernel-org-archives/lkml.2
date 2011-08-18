Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab1HRH3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:29:13 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:24447 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1HRH3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:29:11 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 3/6] Input: elantech - packet checking for v2 hardware
In-Reply-To: <20110818063818.GC10093@core.coreip.homeip.net>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-4-git-send-email-jj_ding@emc.com.tw> <20110818063818.GC10093@core.coreip.homeip.net>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 18 Aug 2011 15:31:27 +0800
Message-ID: <87wreb2n1s.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Wed, 17 Aug 2011 23:38:18 -0700, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Thu, Aug 18, 2011 at 09:57:06AM +0800, JJ Ding wrote:
> > For v2 hardware, there is no real parity check, but we can still check
> > some constant bits for data integrity.
> > 
> > Signed-off-by: JJ Ding <jj_ding@emc.com.tw>
> > ---
> >  drivers/input/mouse/elantech.c |   26 +++++++++++++++++++++++---
> >  1 files changed, 23 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
> > index cf41f23..032181c 100644
> > --- a/drivers/input/mouse/elantech.c
> > +++ b/drivers/input/mouse/elantech.c
> > @@ -376,6 +376,25 @@ static int elantech_check_parity_v1(struct psmouse *psmouse)
> >  	       etd->parity[packet[3]] == p3;
> >  }
> >  
> > +static int packet_simple_check_v2(struct psmouse *psmouse)
> > +{
> > +	struct elantech_data *etd = psmouse->private;
> > +	unsigned char *packet = psmouse->packet;
> > +
> > +	if (etd->reports_pressure)
> > +		return (packet[0] & 0x0c) == 0x04 &&
> > +		       (packet[3] & 0x0f) == 0x02;
        this is for newer v2 hardware

> > +
> > +	if ((packet[0] & 0xc0) == 0x80)
> > +		return (packet[0] & 0x0c) == 0x0c &&
> > +		       (packet[3] & 0x0e) == 0x08;
        this is for older v2, two finger touch 

> > +
> > +	return (packet[0] & 0x3c) == 0x3c &&
> > +	       (packet[1] & 0xf0) == 0x00 &&
> > +	       (packet[3] & 0x3e) == 0x38 &&
> > +	       (packet[4] & 0xf0) == 0x00;
        this is for older v2, 1/3 finger touch
      
> 
> Can we please spell out the assumptions under which we decide that
> packet is invalid?
> 
> Thanks.
> 
> -- 
> Dmitry
V2 hardware has two flavors. Older ones that do not report pressure,
and newer ones that reports pressure and width.

With newer ones, all packets (1, 2, 3 finger touch) have the same
constant bits.

With older ones, 1/3 finger touch packets and 2 finger touch packets have
different constant bits.

With all three cases, if the constant bits are not exactly what I
expected, I consider them invalid.

Dmitry, how do you want me to improve this? not enough comments?

Thanks
jj
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
