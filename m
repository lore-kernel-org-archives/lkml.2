Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab1GDQfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:35:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab1GDQff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:35:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 7/7] serial/8250: make PIO support optional
Date: Mon, 4 Jul 2011 18:35:22 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <1309211120-2803-1-git-send-email-arnd@arndb.de> <201106281352.01459.arnd@arndb.de> <20110628132255.71dcb72a@lxorguk.ukuu.org.uk>
In-Reply-To: <20110628132255.71dcb72a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107041835.22660.arnd@arndb.de>
X-Provags-ID: V02:K0:lnwPHD0342JZbMKou/Q24dWxplxUgTWU/xLs/YdBhBQ
 4crNEw0Vbn8zm3wy+I6DpYdC0SEIVgWszpPy7PdvihwJHGvll9
 +A4WjrxueolP6TI+Fd5GGMnG1SnaVVdYu1VhXlk5KvJfmYBre3
 41gsRGdC1mU5zWgd0p2Fx+nsrQvTGJRGrKxQ4KRzRIYtR6IPNY
 fNVyV5OXAHbNFV6A59Jxw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011, Alan Cox wrote:
> Agreed but that can be done by io_serial_in/io_serial_out out of the
> 8250.c file. Really we need p->ops or a function in another file which
> provides the ioport 8250 interface and then all you'd have in the core
> code would be
> 
>         uart8250_set_ioport_ops(p);
> 
> which would live in 8250_ioport.c or be a "return -EINVAL' for anything
> else. 
> 
> That leaves request/release_std resources depending how such platforms
> handle request_region attempts, and the other fourport bits which want
> pushing into the 8250f_fourport driver perhaps as extra p-> ops.
> 
>         if (p->startup)
>                 p->startup(p);
> 
> etc
> 
> (Or indeed probably a p->ops-> for the lot is even saner)
> 
> Thoughts ?

I've tried a few of variations of that now, and I felt that I'm
getting drawn into some of the darkest corners of Linux driver
history ;-)

I first started out by separating the classing ISA device probing
and the platform driver into separate files. I think these
are useful to split out, because e.g. the PCI driver has no
dependency on either. Having the option to build without the
ISA stuff simplifies a lot of things.

I also made a patch for the mn10300 use of SERIAL_PORT_DFNS,
which is the only architecture that defines non-ISA ports
that way.

Where I failed so far is the dynamic configuration of ports using
setserial. This intentionally allows changing the io_type setting
as well as the actual resources (ioport, mapbase, irq, ...).
Changing the io_type is not supported by /bin/setserial, but
other tools might be doing it.
My question is whether we should still care about those. If
we can remove the reconfiguration of existing ports or move
it to one of the more obscure parts of the driver, it's possible
to confine the dependencies on the ioport_ops to the front-end
drivers, while the core 8250 library driver would not need it
any more.

Today, most ports don't set the UPF_FIXED flag, even though
the ports definitely have fixed resources, e.g. all of the
8250-platform drivers in arch/ or the 8250_pnp and 8250_cs
front-ends. Do you think it would be reasonable to mark all
8250 ports except the ISA ones as UPF_FIXED, and move the
reconfiguration logic into the 8250_isa driver along with
old_serial_port, serial8250_isa_devs,  and
serial8250_isa_init_ports?

	Arnd
