Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0IPUTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:19:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53921 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab0IPUTP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:19:15 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 17 Sep 2010 01:48:53 +0530
Subject: RE: [RFC 3/3] include:linux: make ti_wilink_st like the rest
Thread-Topic: [RFC 3/3] include:linux: make ti_wilink_st like the rest
Thread-Index: ActV2l5aptkbx8pFRjSKkbC1YjcHSwAAFvvQ
Message-ID: <19F8576C6E063C45BE387C64729E73940468914048@dbde02.ent.ti.com>
References: <1284148738-21643-1-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-2-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-3-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-4-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-5-git-send-email-pavan_savoy@ti.com>
 <20100916200058.GI10397@kroah.com>
In-Reply-To: <20100916200058.GI10397@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg,

 
> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, September 16, 2010 3:01 PM
> To: Savoy, Pavan
> Cc: gregkh@suse.de; alan@lxorguk.ukuu.org.uk; devel@driverdev.osuosl.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [RFC 3/3] include:linux: make ti_wilink_st like the rest
> 
> On Fri, Sep 10, 2010 at 03:58:58PM -0400, pavan_savoy@ti.com wrote:
> > From: Pavan Savoy <pavan_savoy@ti.com>
> >
> > ti_wilink_st.h now is similar to other headers in include/linux.
> > The st_ll dependency on ti_wilink_st is also fixed.
> >
> > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > ---
> >  drivers/staging/ti-st/st_ll.c |    2 +
> >  include/linux/ti_wilink_st.h  |   51 +++++++++++++++++++++++---------------
> --
> >  2 files changed, 31 insertions(+), 22 deletions(-)
> >
> > diff --git a/drivers/staging/ti-st/st_ll.c b/drivers/staging/ti-st/st_ll.c
> > index e899920..15e4028 100644
> > --- a/drivers/staging/ti-st/st_ll.c
> > +++ b/drivers/staging/ti-st/st_ll.c
> > @@ -19,6 +19,8 @@
> >   */
> >
> >  #define pr_fmt(fmt) "(stll) :" fmt
> > +#include <linux/module.h>
> > +#include <linux/skbuff.h>
> 
> Why is this needed?  Does it fix something that broke in patch 2/3?  If
> so, fix it in that patch please.

Hnm, I don't think they are needed. Must be a mistake will correct it.

> >  #include <linux/ti_wilink_st.h>
> >
> >  /**********************************************************************/
> > diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
> > index df8d2ee..a563e09 100644
> > --- a/include/linux/ti_wilink_st.h
> > +++ b/include/linux/ti_wilink_st.h
> > @@ -26,12 +26,18 @@
> >  #ifndef ST_H
> >  #define ST_H
> >
> > -#include <linux/skbuff.h>
> > +#ifdef __KERNEL__
> > +#include <linux/skbuff.h>	/* for sk_buff */
> > +#include <linux/rfkill.h>	/* for rfkill */
> > +#include <linux/tty.h>		/* for tty_struct */
> > +#include <linux/tty_ldisc.h>	/* for tty_ldisc_ops */
> 
> Are these really needed?  Can't you include them in the .c files that
> need to include this .h file instead?

Yes, that was the idea, but then just including these without including the headers here, we get tons of errors, although it shouldn't happen.
Had a look at other headers which sort of did something similar.

> > +
> > +#endif
> 
> I don't think you need this #ifdef, do you?  Are you really exporting
> this file to userspace for some reason?  If so, what reason?

For line discipline number only.
There will be a user-space daemon which when requested (via rfkill) opens the UART, sets the baud-rate to both local and chip side and installs the line discipline.

> >
> >  /* TODO:
> >   * Move the following to tty.h upon acceptance
> >   */
> > -#define N_TI_WL	20	/* Ldisc for TI's WL BT, FM, GPS combo chips */
> > +#define N_TI_WL	22	/* Ldisc for TI's WL BT, FM, GPS combo chips */
> 
> Why did this change?

Yes the number of line disciplines has grown since I last submitted a patch :)

> >
> >  /**
> >   * enum kim_gpio_state - Few protocols such as FM have ACTIVE LOW
> > @@ -292,10 +298,10 @@ void kim_st_list_protocols(struct st_data_s *, void
> *);
> >   *	relevant procedure to be called.
> >   */
> >  struct bts_header {
> > -	uint32_t magic;
> > -	uint32_t version;
> > -	uint8_t future[24];
> > -	uint8_t actions[0];
> > +	unsigned long magic;
> > +	unsigned long version;
> > +	unsigned char future[24];
> > +	unsigned char actions[0];
> 
> Why change these now?  That should happen some other place in the
> series, not here.  Especially as you don't mention anything like this in
> the changelog comment.
> 
> Also, why not just use 'u8' and friends instead?  That's the "proper"
> kernel types to be using, not the uint8_t mess that is not correct
> kernel types.

Yes a mistake here too.
This should have been in the patch where I plan to combine all the headers into 1 header and have it in include/linux/
[the headers like st_core.h, st_kim.h, st_ll.h, bt_drv.h and fm and GPs headers]

Yes, and the Bluetooth driver to go into drivers/Bluetooth/ and ST driver (st_core.c/st_kim.c and st_ll.c) to go into drivers/char/
And the upcoming FM V4L2 to go into the drivers/media/radio/

Does this sound fine?

> > @@ -386,6 +392,7 @@ void st_ll_wakeup(struct st_data_s *);
> >
> >  /**
> >   * structures and declarations used by the st_core for FM packets
> > + * and GPS packets
> >   */
> >  struct fm_event_hdr {
> >  	unsigned char plen;
> 
> Oh, is it?  That should go somewhere else.

Plan is to have just 1 large header to be included by all protocol drivers (BT, FM and GPS)...
Is it a bad idea?

> > @@ -397,8 +404,8 @@ struct fm_event_hdr {
> >
> >  /* gps stuff */
> >  struct gps_event_hdr {
> > -unsigned char opcode;
> > -unsigned short plen;
> > +	unsigned char opcode;
> > +	unsigned short plen;
> >  } __attribute__ ((packed));
> 
> This should be done somewhere else, it's a formatting patch.

Yes, I'll do it in another patch.

> >
> >  #endif /* ST_H */
> 
> I don't think this file is called "ST_H" here anymore.

Yes, need your input here. This file will be made use by the rest of the protocol drivers I plan to push patches for.
So does ti_wilink_st.h sound fine? And in include/linux? So that rest of the drivers can be in their individual directories.

Thanks,
Pavan

> thanks,
> 
> greg k-h
