Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1BXR2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:28:05 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46811 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1BXR2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:28:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ljnwfgos9s5o0a4QOEj597VOnA7OP7kS+U7u4pv6y88RAcSMTQO7B4j7XizrxkJcfA
         zbFyCt4FiB/X2npv4TfcSBQXnqGAGAG7FNVBbpp+6WpeVYk7swki3XvuJDj307yCT3XI
         VrBsopTGIFg/79AJci7FvPNpkC+siOGt5u8pY=
Date: Thu, 24 Feb 2011 18:26:52 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH V11 2/4] ptp: Added a clock that uses the eTSEC found
 on the MPC85xx.
Message-ID: <20110224172652.GC15234@riccoc20.at.omicron.at>
References: <cover.1298447722.git.richard.cochran@omicron.at>
 <be1f5e801e8cd0145dd23aadae7c2055bb3c1d47.1298447722.git.richard.cochran@omicron.at>
 <20110223165058.GE14597@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223165058.GE14597@angua.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 09:50:58AM -0700, Grant Likely wrote:
> On Wed, Feb 23, 2011 at 11:38:17AM +0100, Richard Cochran wrote:
> > +Clock Properties:
> > +
> > +  - tclk-period  Timer reference clock period in nanoseconds.
> > +  - tmr-prsc     Prescaler, divides the output clock.
> > +  - tmr-add      Frequency compensation value.
> > +  - cksel        0= external clock, 1= eTSEC system clock, 3= RTC clock input.
> > +                 Currently the driver only supports choice "1".
> 
> I'd be hesitant about defining something that isn't actually
> implemented yet.  You may find the binding to be insufficient at a
> later date.

Okay, I'll remove it.
We never got the external VCO working anyhow.

> > +  - tmr-fiper1   Fixed interval period pulse generator.
> > +  - tmr-fiper2   Fixed interval period pulse generator.
> > +  - max-adj      Maximum frequency adjustment in parts per billion.
> 
> These are all custom properties (not part of any shared binding) so
> they should probably be prefixed with 'fsl,'.

Okay, fine.

> > +  The calculation for tmr_fiper2 is the same as for tmr_fiper1. The
> > +  driver expects that tmr_fiper1 will be correctly set to produce a 1
> > +  Pulse Per Second (PPS) signal, since this will be offered to the PPS
> > +  subsystem to synchronize the Linux clock.
> 
> Good documentation, thanks.  Question though, how many of these values
> will the end user (or board builder) be likely to want to change.  It
> is risky encoding the calculation results into the device tree when
> they aren't the actually parameters that will be manipulated, or at
> least very user-unfriendly.

The whole thing is pretty opaque, and my explanation is (IMHO) way
better that Freescale's documentation of how the fipers work.

The board designer / system designer will want to set these carefully,
but never change them. Basically, for a given input clock, there is
only one optimal setting.

I think the device tree is the right place for that kind of setting.

The fiper1 signal should always be a 1 PPS.  We could make fiper2 run
time programmable via PHC ioctls, but I think this can wait.


> > +	etsects->irq = irq_of_parse_and_map(node, 0);
> 
> Use platform_get_irq().

Okay.

> > +	etsects->regs = of_iomap(node, 0);
> 
> Use platform_get_resource(), and don't forget to request the
> resources.

Okay, but didn't you tell me before to do this way?

   http://marc.info/?l=linux-netdev&m=127662247203659&w=4

> > +static struct of_platform_driver gianfar_ptp_driver = {
> 
> Use a platform_driver instead.  of_platform_driver is deprecated and
> being removed.

Ja, should have noticed that myself, sorry.

> > +++ b/drivers/net/gianfar_ptp_reg.h
> 
> This data is only used by gianfar_ptp.c, so there is no need for a
> separate include file.  Move the contents of gianfar_ptp_reg.h into
> gianfar_ptp.c

You are right, of course, since private #defines and declarations
should simply stay in their .c files. Some people think that all
#defines and declarations must go into a header file.

I am not one of those people, but in this case, I generated the file
from a little tool I wrote and so kept it separate.

Still, it is no trouble to combine the header into the driver .c file.

Thanks for your review,

Richard
