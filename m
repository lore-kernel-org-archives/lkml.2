Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab1CUBBQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 21:01:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33952 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1CUBBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 21:01:13 -0400
Date: Sun, 20 Mar 2011 18:01:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg KH <gregkh@suse.de>, Oliver Neukum <oneukum@suse.de>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: "usb_wwan: error case of resume" (16871dcac) is buggy
Message-Id: <20110320180106.a835ce67.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LNX.2.00.1103210140530.19969@pobox.suse.cz>
References: <alpine.LNX.2.00.1103210130260.19969@pobox.suse.cz>
	<alpine.LNX.2.00.1103210140530.19969@pobox.suse.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D86A355.0008,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Mar 2011 01:41:14 +0100 (CET) Jiri Kosina wrote:

> 
> [ fixing Oliver's address in CC ]
> 
> On Mon, 21 Mar 2011, Jiri Kosina wrote:
> 
> > Hi,
> > 
> > the commit in subject make the kernel with CONFIG_PM_RUNTIME unset fail 
> > during compilation, as struct dev_pm_info doesn't have whole bunch of 
> > members in such case.
> > 
> > The commit in question adds this code:
> > 
> > 	/* we have to throw away the rest */
> > 	do {
> > 		unbusy_queued_urb(urb, portdata);
> > 		//extremely dirty
> > 		atomic_dec(&port->serial->interface->dev.power.usage_count);
> > 	} while ((urb = usb_get_from_anchor(&portdata->delayed)));
> > 
> > The 'extermely dirty' comment makes me a bit nervous whether the patch 
> > below is correct or some more thinking would be necessary.
> > 
> > 
> > 
> > From: Jiri Kosina <jkosina@suse.cz>
> > Subject: [PATCH] USB: usb_wvan: fix compilation for !CONFIG_PM_RUNTIME case
> > 
> > With CONFIG_PM_RUNTIME unset, struct dev_pm_info doesn't have
> > usage count which is used only for run-time power management
> > purposes.
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > ---
> >  drivers/usb/serial/usb_wwan.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
> > index a65ddd5..8b456dc 100644
> > --- a/drivers/usb/serial/usb_wwan.c
> > +++ b/drivers/usb/serial/usb_wwan.c
> > @@ -698,8 +698,10 @@ static void play_delayed(struct usb_serial_port *port)
> >  			/* we have to throw away the rest */
> >  			do {
> >  				unbusy_queued_urb(urb, portdata);
> > -				//extremely dirty
> > +#ifdef CONFIG_PM_RUNTIME
> > +				/* extremely dirty */
> >  				atomic_dec(&port->serial->interface->dev.power.usage_count);
> > +#endif
> >  			} while ((urb = usb_get_from_anchor(&portdata->delayed)));
> >  			break;
> >  		}
> > -- 
> > 1.7.3.1
> > 
> > 

Please see Oliver's patch for this at
http://marc.info/?l=linux-usb&m=130044862323463&w=2

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
