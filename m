Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab2KLXeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:34:09 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34674 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2KLXeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:34:04 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 13 Nov 2012 00:33:38 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux1394-devel@lists.sourceforge.net,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 1/1] staging: fwserial: Add TTY-over-Firewire serial
 driver
Message-ID: <20121113003338.6aafd7c8@stein>
In-Reply-To: <55547e779e65e6865f18d537ef1a42191a4b7e46.1351817601.git.peter@hurleysoftware.com>
References: <1350565015.23730.4.camel@thor>
	<cover.1351817601.git.peter@hurleysoftware.com>
	<55547e779e65e6865f18d537ef1a42191a4b7e46.1351817601.git.peter@hurleysoftware.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 02 Peter Hurley wrote:
> This patch provides the kernel driver for high-speed TTY
> communication over the IEEE 1394 bus.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

Hi Greg,

you asked for an Ack.  Here it is:  I am OK with this getting added to the
staging tree.

(Sorry for the delay, I was ill and at the same time buried in work at the
day job.)  Note, I only quickly scrolled through v1 and v2.  I will do an
actual review when somebody asks to move this from staging into a proper
mainline place.

Peter,
below are some high-level comments to your TODOs.

> ---
> v2
[...]
> ---
>  drivers/staging/Kconfig             |    2 +
>  drivers/staging/Makefile            |    1 +
>  drivers/staging/fwserial/Kconfig    |    9 +
>  drivers/staging/fwserial/Makefile   |    2 +
>  drivers/staging/fwserial/TODO       |   37 +
>  drivers/staging/fwserial/dma_fifo.c |  310 ++++
>  drivers/staging/fwserial/dma_fifo.h |  130 ++
>  drivers/staging/fwserial/fwserial.c | 2946 +++++++++++++++++++++++++++++++++++
>  drivers/staging/fwserial/fwserial.h |  387 +++++
>  9 files changed, 3824 insertions(+)
>  create mode 100644 drivers/staging/fwserial/Kconfig
>  create mode 100644 drivers/staging/fwserial/Makefile
>  create mode 100644 drivers/staging/fwserial/TODO
>  create mode 100644 drivers/staging/fwserial/dma_fifo.c
>  create mode 100644 drivers/staging/fwserial/dma_fifo.h
>  create mode 100644 drivers/staging/fwserial/fwserial.c
>  create mode 100644 drivers/staging/fwserial/fwserial.h
[...]
> --- /dev/null
> +++ b/drivers/staging/fwserial/Kconfig
> @@ -0,0 +1,9 @@
> +config FIREWIRE_SERIAL
> +       tristate "TTY over Firewire"
> +       depends on FIREWIRE
> +       help
> +          This enables TTY over IEEE 1394, providing high-speed serial
> +	  connectivity to cabled peers.
> +
> +	  To compile this driver as a module, say M here:  the module will
> +	  be called firewire-serial.

This should mention that this is a Linux-only affair at this time:  It uses
an ad-hoc defined protocol which no other platform is known to support for
the time being.

[...]
> --- /dev/null
> +++ b/drivers/staging/fwserial/TODO
> @@ -0,0 +1,37 @@
> +TODOs
> +-----
> +1. Implement retries for RCODE_BUSY, RCODE_NO_ACK and RCODE_SEND_ERROR
> +   - I/O is handled asynchronously which presents some issues when error
> +     conditions occur.
> +2. Implement _robust_ console on top of this. The existing prototype console
> +   driver is not ready for the big leagues yet.
> +3. Expose means of controlling attach/detach of peers via sysfs. Include
> +   GUID-to-port matching/whitelist/blacklist.
> +
> +-- Issues with firewire stack --
> +1. This driver uses the same unregistered vendor id that the firewire core does
> +     (0xd00d1e). Perhaps this could be exposed as a define in
> +     firewire-constants.h?

I guess there is no better OUI for this purpose.

The constant could be added to linux/firewire.h, but IMO rather not to
uapi/linux/firewire-constants.h.  We don't want this definition to leak
out to userland; userland can hardwire its own hacks itself. :-)

This trivial move to a header should be deferred until the driver moves
out of staging.

> +2. MAX_ASYNC_PAYLOAD needs to be publicly exposed by core/ohci
> +   - otherwise how will this driver know the max size of address window to
> +     open for one packet write?

Hmm, don't firewire-sbp2 and firewire-net deal with this very problem
already on their own?  Firewire-sbp2 tells the target what maximum payload
the local node is ready to accept, and firewire-net figures out whether it
needs to fragment the datagrams in unicast TX depending on the remote
node's capabilities.

> +3. Maybe device_max_receive() and link_speed_to_max_payload() should be
> +     taken up by the firewire core?

Sounds like an extension of item 2, and is easier resolved after the
driver moves out of staging.

> +4. To avoid dropping rx data while still limiting the maximum buffering,
> +     the size of the AR context must be known. How to expose this to drivers?

I don't see a requirement to know the local or remote node's size of AR
DMA buffer.  Rather, keep the traffic throttled such that too frequent
ack-busy are avoided.  As far as I have learned from firewire-net, just
limiting the number or in-flight transactions should work reasonably.  Of
course, hardware ack-busy retries which the OHCI performs on its own won't
be noticed by software but take away from overall bus bandwidth.  IOW the
optimum queue depth is by a certain margin less than the depth at which
software starts to see ack-busy transaction terminations.

Furthermore:  In order to avoid dropping data, you don't need to know the
buffer size at all.  You need to implement proper software retries.  I.e.
either those which you noted yourself at the top of this TODO file, or you
let the userland on top of the TTY handle it if this is possible.  (I
don't know how the TTY subsystem and TTY based applications work.)

> +5. Explore if bigger AR context will reduce RCODE_BUSY responses
> +   (or auto-grow to certain max size -- but this would require major surgery
> +    as the current AR is contiguously mapped)

For the particular application "firewire-net", the present AR-Req DMA
buffer size has apparently been determined as suitable.  Of course if you
find a different optimum, that could certainly be changed.

I haven't looked closely, but I suppose your bandwidth requirement
concerns AR-Request DMA, not so much AR-Response DMA, right?
-- 
Stefan Richter
-=====-===-- =-== -==--
http://arcgraph.de/sr/
