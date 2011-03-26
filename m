Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506Ab1CZALu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:11:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52059 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933308Ab1CZALs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:11:48 -0400
Date: Sat, 26 Mar 2011 00:11:43 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [RFC PATCHv3 3/4] drivers/otp: convert bfin otp to generic OTP
Message-ID: <20110326001143.GX3130@pulham.picochip.com>
References: <1301073283-30821-1-git-send-email-jamie@jamieiles.com>
 <1301073283-30821-4-git-send-email-jamie@jamieiles.com>
 <AANLkTin+Uvw8=CN+2oawAUHGot8gdM5u98S4zC8QoB=u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin+Uvw8=CN+2oawAUHGot8gdM5u98S4zC8QoB=u@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 06:56:03PM -0400, Mike Frysinger wrote:
> On Fri, Mar 25, 2011 at 13:14, Jamie Iles wrote:
> > +       /*
> > +        * Skip the control pages then if we would run into the ECC area skip
> > +        * past to the next data region.
> > +        */
> > +       raw_addr = region_addr + control_words;
> > +       if (raw_addr > 0x80 * BFIN_OTP_WORDS_PER_PAGE)
> > +               raw_addr += 0x20 * BFIN_OTP_WORDS_PER_PAGE;
> 
> mmm, no, we dont want to do that.  the Blackfin documentation is very
> exact when it maps out pages, and we want the driver to match the
> documentation.
> 
> but i guess in the other discussion we had, this would be removed anyways.

OK, so in that case could we initially have:

	- region for control bits
	- region for the first data bits
	- region for the ecc for the first data
	- region for the second data bits
	- region for the ecc for the second data

or shall I just leave it as one big region for now?

> 
> > +static int bfin_region_write_word(struct otp_region *region, unsigned long addr,
> > +                                 u64 content)
> > +{
> > +       return -EACCES;
> > +}
> 
> i think we'd just stub this out as NULL and let the common layer take
> care of rejecting it ?

Yes, that's probably best.  At least we're always building the whole 
driver then.

> 
> > +static const struct otp_device_ops bfin_otp_ops = {
> > +       .name           = "BFIN",
> 
> guess this should be "bfin-otp"

Good spot.

> 
> > +static const struct otp_region_ops bfin_region_ops = {
> > +       .read_word      = bfin_region_read_word,
> > +       .write_word     = bfin_region_write_word,
> > +       .get_size       = bfin_region_get_size,
> > +       .get_fmt        = bfin_region_get_fmt,
> > +       .ioctl          = bfin_region_ioctl,
> > +};
> 
> hmm, i just realized this stuff is per-region.  wouldnt the
> read/write/ioctl make more sense as per-device ?

No, I don't think so.  The file_operations are all based on the regions 
rather than the device so I think it makes sense to have these as region 
based operations.  We could make them per device and pass the region as 
a parameter but I'm not sure that it gains us anything.

Jamie
