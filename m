Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1F0WRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:17:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42969 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab1F0WPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:15:47 -0400
Date: Mon, 27 Jun 2011 23:15:41 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 4/7] serial/8250: move DWAP support to arch/mips
Message-ID: <20110627221541.GA5370@gallagher>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
 <1309211120-2803-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309211120-2803-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, Jun 27, 2011 at 11:45:17PM +0200, Arnd Bergmann wrote:
> Only one board uses the UPIO_DWAP iotype, and nothing uses
> the UPIO_DWAP32 iotype. It seems much cleaner to handle the
> DWAP quirk as a new port type, and move the serial_out
> accessor into the platform code. If more platforms start
> using the DWAP port, that function can be moved into a
> common location.

I posted a series[1] a couple of weeks back that does this for 
DWAPB/DWAPB32 in a slightly different way which also removes the extra 
interrupt handling into the platform code.

Incidentally, I've been trying to mainline a platform (picoxcell) that 
has a DWAPB (with 32-bit access requirement) but struggled to get 
feedback on the SoC port but hope to resubmit as a device tree based 
platform.

1. http://marc.info/?l=linux-serial&m=130821602729595&w=2

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Jamie Iles <jamie@jamieiles.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: linux-serial@vger.kernel.org
> ---
>  arch/mips/pmc-sierra/msp71xx/msp_serial.c |   32 ++++++++++-
>  drivers/tty/serial/8250.c                 |   87 +++--------------------------
>  drivers/tty/serial/8250_hub6.c            |   17 ++++++

Should the hub6 stuff be in this patch?

>  drivers/tty/serial/serial_core.c          |    4 -
>  include/linux/serial_core.h               |    5 +-
>  5 files changed, 57 insertions(+), 88 deletions(-)
> 
> diff --git a/arch/mips/pmc-sierra/msp71xx/msp_serial.c b/arch/mips/pmc-sierra/msp71xx/msp_serial.c
> index f726162..6c9f1d3 100644
> --- a/arch/mips/pmc-sierra/msp71xx/msp_serial.c
> +++ b/arch/mips/pmc-sierra/msp71xx/msp_serial.c
> @@ -38,6 +38,33 @@
>  #include <msp_int.h>
>  #include <msp_regs.h>
>  
> +/* Save the LCR value so it can be re-written when a Busy Detect IRQ occurs. */
> +static inline void dwapb_save_out_value(struct uart_port *p, int offset,
> +					int value)
> +{
> +	struct uart_8250_port *up =
> +		container_of(p, struct uart_8250_port, port);

I couldn't see that struct uart_8250_port is moved out of 8250.c, so I'm 
not sure that this would work in here?

Jamie
