Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab0KJQkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:40:07 -0500
Received: from atlantis.8hz.com ([212.129.237.78]:50062 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756943Ab0KJQkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:40:06 -0500
Date: Wed, 10 Nov 2010 16:40:04 +0000
From: Sean Young <sean@mess.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        linux-kernel@vger.kernel.org, jesse.barnes@intel.com
Subject: Re: [PATCH] Fix Winbond CIR driver initialisation
Message-ID: <20101110164004.GA78127@atlantis.8hz.com>
References: <20101107131825.GA40383@atlantis.8hz.com> <20101107154648.4bcdfb9f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107154648.4bcdfb9f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 03:46:48PM +0000, Alan Cox wrote:
> > A workaround is to boot with argument 8250.nr_uarts=1. This is not really 
> > desirable, so this patch makes ttyS1 go away.
> 
> setserial can also be used for this surely ?
> 
> > +		dev_info(device, "Unregistering phony serial port ttyS1\n");
> > +		serial8250_unregister_port(1);
> > +		ok = request_region(data->sbase, SP_IOMEM_LEN, DRVNAME);
> 
> That's a hack that is only going to work on specific systems where it is
> mapped the way you expect and doing stuff behind the back of the serial
> driver.
> 
> I'm not averse to a better solution but it needs to be general and
> maintainable. Is there a way to identify the presence of the windbond CIR
> device as opposed to an 8250 ?

The past couple of days I've been trying to find a way of identifying the 
winbond cir device correctly in the 8250 driver by its registers, but so 
far I've had no luck. It is a device which can operate in CEIR, UART and 
one the irda modes, but all I can find for identifying what is physically
connected is querying the Super I/O model or the PNP identifier for CIR.

The Super I/O model might not be enough in cases where different things
can be connected to it physically.

The hardware can be flipped between various IR (SIR/CIR/etc) and normal
uart modes. We could have an new call which represents this a bit
more closely.

To ensure it is mapped as expected, the call should include the I/O 
port range and irq.

  bool serial8250_port_non_uart(int ioport, int ioportlen, int irq);

The 8250 serial driver would unregister the port which matches this, and
unregister the corresponding port, returning true if such a port can be
found.

This problem here is also one which is encountered by some of the irda 
drivers, so it would be nice to solve as well for those too.

Would that make more sense?

Regards,
Sean
