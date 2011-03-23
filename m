Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab1CWPRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:17:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45506 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932996Ab1CWPRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:17:33 -0400
Date: Wed, 23 Mar 2011 11:17:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <roger.quadros@nokia.com>,
        Michal Nazarewicz <mina86@mina86.com>
cc: gregkh@suse.de, <sshtylyov@mvista.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] usb: gadget: file_storage: Make CD-ROM emulation
 work with Mac OS-X
In-Reply-To: <4D89AD56.1080602@nokia.com>
Message-ID: <Pine.LNX.4.44L0.1103231110400.2211-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011, Roger Quadros wrote:

> > On the other hand, I don't think any implementations would get upset if
> > we simply ended the transfer with a short packet instead of adhering
> > strictly to the spec.
> >
> > The patch below should do what you want.  I haven't tested it.
> 
> I tried your patch with the CD-ROM implementation and it works perfectly. I do 
> not see the unnecessary zero padded transfers any more.
> 
> Do you think we should have this patch in? with the risk of not strictly 
> adhering to spec for cases where controller cannot stall?

There already is another place where not stalling forces the driver to 
violate the spec.  I don't think this makes things much worse... but it 
is a significant change in behavior.

This affects Michal's driver too; we should ask his opinion.  Michal, 
in case you didn't see it, the proposed patch is here:

	http://marc.info/?l=linux-usb&m=130080683528607&w=2

> Maybe the term "controller cannot stall" itself does not adhere to bulk-only 
> transport spec :).

True enough.  However I believe USB flash drives behave this way: They 
don't stall and they don't pad their data.

> > @@ -1710,24 +1683,19 @@ static int finish_reply(struct fsg_commo
> >   			common->next_buffhd_to_fill = bh->next;
> >
> >   		/*
> > -		 * For Bulk-only, if we're allowed to stall then send the
> > -		 * short packet and halt the bulk-in endpoint.  If we can't
> > -		 * stall, pad out the remaining data with 0's.
> > +		 * For Bulk-only, mark the end of the data with a short
> > +		 * packet.  If we are allowed to stall, halt the bulk-in
> > +		 * endpoint.  (Note: This violates the Bulk-Only Transport
> > +		 * specification, which requires us to pad the data if we
> 
> violates the spec only if we are not allowed to stall (i.e. stall=n) right?

Right.

> > +		 * don't halt the endpoint.  Presumably nobody will mind.)
> >   		 */

Alan Stern

