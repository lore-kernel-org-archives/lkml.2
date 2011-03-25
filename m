Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070Ab1CYKId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:08:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49569 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab1CYKIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:08:31 -0400
Date: Fri, 25 Mar 2011 10:08:22 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Message-ID: <20110325100822.GP3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <1300980071-24645-2-git-send-email-jamie@jamieiles.com>
 <AANLkTinJH46U=ueUPs2bnuTp16Vtn_ViwDCrhsAGPQvM@mail.gmail.com>
 <20110324203523.GJ3130@pulham.picochip.com>
 <AANLkTi=pKfKeoQxB3Xb-kasfrs_aa2rqHyF9N0wR6H3z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=pKfKeoQxB3Xb-kasfrs_aa2rqHyF9N0wR6H3z@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 05:33:25PM -0400, Mike Frysinger wrote:
> On Thu, Mar 24, 2011 at 16:35, Jamie Iles wrote:
> > On Thu, Mar 24, 2011 at 02:32:41PM -0400, Mike Frysinger wrote:
> >> On Thu, Mar 24, 2011 at 11:21, Jamie Iles wrote:
> >> > +Description:
> >> > +                The redundancy format of the region. Valid values are:
> >> > +                       - single-ended (1 bit of storage per data bit).
> >> > +                       - redundant (2 bits of storage, wire-OR'd per data
> >> > +                         bit).
> >> > +                       - differential (2 bits of storage, differential
> >> > +                         voltage per data bit).
> >> > +                       - differential-redundant (4 bits of storage, combining
> >> > +                         redundant and differential).
> >> > +               It is possible to increase redundancy of a region but care
> >> > +               will be needed if there is data already in the region.
> >>
> >> where does ECC fit in ?  the Blackfin OTP is structured:
> >>   - first 4 pages are write control bitfields for all other pages (so
> >> blowing bit 5 of page 0 prevents further writing to page 5)
> >>   - each 0x100 page region has 0x20 pages dedicated to ECC for the
> >> other 0x80 pages ... this provides 1 bit error correction and 2 bits
> >> of error detection (anymore and you're screwed!)
> >
> > How does the ECC correction work for bfin at the moment?  Does the user
> > specify it manually when writing then check it themselves when reading
> > back or does the hardware handle that?
> 
> it is taken care of by the layers below the Linux driver.  when we say
> "read a half page", the 64bits are returned via pointer args, and the
> function return value will tell us if the contents read are valid (ECC
> passed), corrected (1 bit error), or there was a read error (too may
> bit errors to recover).
> 
> > The way I was thinking that this sort of thing could be handled would be
> > for the ECC to be transparent to the user.  Perhaps for bfin the OTP
> > could be registered as 4 regions, otpa1-otpa4 which default to
> > "single-ended".  Writing "ecc" as the format would generate the ecc and
> > program it for that region then check the ECC when reading back.
> 
> reads and writes atm always have ECC enabled, and the driver restricts
> writes to the full half page (64bits).  if you wanted to be crafty,
> you could blow individual bits in a single half page over multiple
> writes before writing out the final ECC, but that isnt supported, and
> no one has complained.

The current version I have will do read-modify-write if the file offset 
isn't OTP word aligned so it sounds like I need to add a flag that says 
only do full word writes.

I guess in this framework we could make the OTP look like a single 
region of the 0x80 data pages concatenated or provide separate regions 
for each group of 0x80 pages but the control and ECC pages aren't 
directly accessible by the user.

The other question that brings up is whether any compatibility with the 
old driver is required.

Jamie
