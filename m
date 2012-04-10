Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab2DJKms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:42:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52159 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2DJKmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:42:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 6/6] tilegx network driver: initial support
Date: Tue, 10 Apr 2012 10:42:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com> <201204091349.54484.arnd@arndb.de> <4F835510.4060100@tilera.com>
In-Reply-To: <4F835510.4060100@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204101042.39877.arnd@arndb.de>
X-Provags-ID: V02:K0:3CtuZWywiQLM+v82g9HEdlQj7po9/OBI4/LEinR0qiK
 8HvG4NX07khW0zXrk9pCx84SSgCWNLSJrVz5Hbe6dsErdZvbkY
 CfwT2a2yzJaa6QiWpb3U9tiWbjZcjBzBzBvF1dr2na5y9Eyzh/
 3MwvYaPH3oEhVQH/usSXMPpURxznzNsSr7xvaNynQskwHH8TXK
 3W0wmgVd222msTrESrgZCbuDLgUUBiwGyOPazYWUgikVgy7W9P
 4HrvD13OFilMwaaq3VdyFiBI5gtoi44xEq8W4Sp8wr7p3ZWC2x
 8DYUQ4ovYZ37lOe7r1+DyrbvUUWJrkmS1hOe9iTl6QP2eU13U9
 I1hA+LIOtxui+Vh8jc8E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2012, Chris Metcalf wrote:
> On 4/9/2012 9:49 AM, Arnd Bergmann wrote:
> > On Friday 06 April 2012, Chris Metcalf wrote:
> >> This change adds support for the tilegx network driver based on the
> >> GXIO IORPC support in the tilegx software stack, using the on-chip
> >> mPIPE packet processing engine.
> >>
> >> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> >> ---
> >>  drivers/net/ethernet/tile/Kconfig  |    1 +
> >>  drivers/net/ethernet/tile/Makefile |    4 +-
> >>  drivers/net/ethernet/tile/tilegx.c | 2045 ++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 2048 insertions(+), 2 deletions(-)
> >>  create mode 100644 drivers/net/ethernet/tile/tilegx.c
> > I think the directory name should be the company, not the architecture here, so make
> > it drivers/net/ethernet/tilera/tilegx.c instead.
> 
> This path was picked back when Jeff Kirsher did the initial move into
> drivers/net/ethernet/ for the tilepro driver.  I don't have too strong an
> opinion on this; at this point I'm mostly just concerned that it seems like
> potentially not worth the churn to move the files for 3.2, then again for
> 3.5.  But if folks agree we should do it, it's fine with me.

Ah, I didn't realize that the directory already exists. It's probably better
not to move it then.

> The actual author would rather not publish his name (I just double-checked
> with him). 

Hmm, it doesn't look all that bad actually, the comments I had are just for
small details.

> >> +/* The actual devices. */
> >> +static struct net_device *tile_net_devs[TILE_NET_DEVS];
> >> +
> >> +/* The device for a given channel.  HACK: We use "32", not
> >> + * TILE_NET_CHANNELS, because it is fairly subtle that the 5 bit
> >> + * "idesc.channel" field never exceeds TILE_NET_CHANNELS.
> >> + */
> >> +static struct net_device *tile_net_devs_for_channel[32];
> > When you need to keep a list or array of device structures in a driver, you're
> > usually doing something very wrong. The convention is to just pass the pointer
> > around to where you need it.
> 
> We need "tile_net_devs_for_channel" because we share a single hardware
> queue for all devices, and each packet's metadata contains a "channel"
> value which indicates the device.
 
Ok, but please remove tile_net_devs then.

I think a better abstraction for tile_net_devs_for_channel would be
some interface that lets you add private data to a channel so when
you get data from a channel, you can extract that pointer from the driver
using the channel.

Don't you already have a per-channel data structure?

> 
> /*
>  * The on-chip I/O hardware on tilegx is configured with VA=PA for the
>  * kernel's PA range.  The low-level APIs and field names use "va" and
>  * "void *" nomenclature, to be consistent with the general notion
>  * that the addresses in question are virtualizable, but in the kernel
>  * context we are actually manipulating PA values.  To allow readers
>  * of the code to understand what's happening, we direct their
>  * attention to this comment by using the following two no-op functions.
>  */
> static inline unsigned long pa_to_tile_io_addr(phys_addr_t pa)
> {
>         BUILD_BUG_ON(sizeof(phys_addr_t) != sizeof(unsigned long));
>         return pa;
> }
> static inline phys_addr_t tile_io_addr_to_pa(unsigned long tile_io_addr)
> {
>         return tile_io_addr;
> }
> 
> Then the individual uses in the network driver are just things like
> "edesc_head.va = pa_to_tile_io_addr(__pa(va))" or "va =
> __va(tile_io_addr_to_pa((unsigned long)gxio_mpipe_idesc_get_va(idesc)))"
> which I think is a little clearer.

Yes, although I would probably add a typedef for tile_io_addr and pass
the virtual address in and out these helper functions.

For added clarity, you could make the interface look like dma_map_single(),
which requires adding an empty unmap() function as well -- that would
make it obvious where that data is actually used. Why do you require
the reverse map anyway? Normally you only need to pass a bus address to
the device but don't need to translate that back into a virtual address
because you already had that in the beginning.

> >> +/* Allocate and push a buffer. */
> >> +static bool tile_net_provide_buffer(bool small)
> >> +{
> >> [...]
> >> +
> >> +	/* Save a back-pointer to 'skb'. */
> >> +	*(struct sk_buff **)(skb->data - sizeof(struct sk_buff **)) = skb;
> > This looks very wrong: why would you put the pointer to the skb into the
> > skb itself?
> 
> Because we create skbuffs, and then feed the raw underlying buffer storage
> to our hardware, and later, we get back this raw pointer from hardware,
> from which we need to be able to extract the actual skbuff.

Hmm, this sounds very unusual, but I don't really have a better suggestion
here.

> >> +		/* Compute the "ip checksum". */
> >> +		jsum = isum_hack + htons(s_len - eh_len) + htons(id);
> >> +		jsum = __insn_v2sadu(jsum, 0);
> >> +		jsum = __insn_v2sadu(jsum, 0);
> >> +		jsum = (0xFFFF ^ jsum);
> >> +		jh->check = jsum;
> >> +
> >> +		/* Update the tcp "seq". */
> >> +		uh->seq = htonl(seq);
> >> +
> >> +		/* Update some flags. */
> >> +		if (!final)
> >> +			uh->fin = uh->psh = 0;
> >> +
> >> +		/* Compute the tcp pseudo-header checksum. */
> >> +		usum = tsum_hack + htons(s_len);
> >> +		usum = __insn_v2sadu(usum, 0);
> >> +		usum = __insn_v2sadu(usum, 0);
> >> +		uh->check = usum;
> > Why to you open-code the ip checksum functions here? Normally the stack takes
> > care of this by calling the functions you already provide in
> > arch/tile/lib/checksum.c
> 
> If there is a way to do TSO without this, we'd be happy to hear it, but
> it's not clear how it would be possible.  We are only computing a PARTIAL
> checksum here, and letting the hardware compute the "full" checksum.

Sounds like you're looking for csum_partial() ;-)

	Arnd
