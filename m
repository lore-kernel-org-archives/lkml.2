Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab2KNBZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:25:50 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50498 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab2KNBZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:25:46 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 14 Nov 2012 02:25:22 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux1394-devel@lists.sourceforge.net,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 1/1] staging: fwserial: Add TTY-over-Firewire serial
 driver
Message-ID: <20121114022522.633a44d4@stein>
In-Reply-To: <1352834072.16401.100.camel@thor>
References: <1350565015.23730.4.camel@thor>
	<cover.1351817601.git.peter@hurleysoftware.com>
	<55547e779e65e6865f18d537ef1a42191a4b7e46.1351817601.git.peter@hurleysoftware.com>
	<20121113003338.6aafd7c8@stein>
	<1352834072.16401.100.camel@thor>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 13 Peter Hurley wrote:
> On Tue, 2012-11-13 at 00:33 +0100, Stefan Richter wrote:
> > On Nov 02 Peter Hurley wrote:
> > > +2. MAX_ASYNC_PAYLOAD needs to be publicly exposed by core/ohci
> > > +   - otherwise how will this driver know the max size of address window to
> > > +     open for one packet write?
> > 
> > Hmm, don't firewire-sbp2 and firewire-net deal with this very problem
> > already on their own?  Firewire-sbp2 tells the target what maximum payload
> > the local node is ready to accept, and firewire-net figures out whether it
> > needs to fragment the datagrams in unicast TX depending on the remote
> > node's capabilities.
> 
> I wasn't as clear as I should have been here. This is only about how big
> to make the address handler window.

Isn't fw_card.max_receive what you were looking for?  But since the
current firewire-core API requires you to allocate one handler address and
size for all cards --- even for cards which will be hot-added later while
your driver is already running ---, you should surely just allocate
4096 bytes; see below.

> Just like firewire-net, this driver
> communicates with remotes at S100 speeds (and packet sizes) to
> query the largest packet size that the remote supports.

(RFC 2734 additionally keeps things sane for itself by requiring all 2734
compliant nodes to support at least max packet = 512 bytes.)

Could it be easier to take this information from fw_device.max_speed and
the max_rec in fw_device.config_rom?  RFC 2734 was designed to work
without a local node management layer which is capable to gather such
information, but we have this information on Linux (at the time when
core_device.c finished its node discovery).

> Currently, firewire-net sets an arbitrary address handler length of
> 4096. This works because the largest AR packet size the current
> firewire-ohci driver handles is 4096 (value of MAX_ASYNC_PAYLOAD) +
> header/trailer. Note that firewire-ohci does not limit card->max_receive
> to this value.
> 
> So if the ohci driver changes to handle 8K+ AR packets and the hardware
> supports it, these address handler windows will be too small.

While the IEEE 1394:2008 link layer specification (section 6) provides for
asynchronous packet payloads of up to 16384 bytes (table 6-4), the IEEE
1394 beta mode port specification (section 13) only allows up to 4096
bytes (table 16-18).  And alpha mode is of course limited to 2048 bytes.

So, asynchronous packet payloads greater than 4096 bytes are out of scope
of the current revision of IEEE 1394.

> > > +3. Maybe device_max_receive() and link_speed_to_max_payload() should be
> > > +     taken up by the firewire core?
> > 
> > Sounds like an extension of item 2, and is easier resolved after the
> > driver moves out of staging.
> 
> Ok.
> 
> > > +4. To avoid dropping rx data while still limiting the maximum buffering,
> > > +     the size of the AR context must be known. How to expose this to drivers?
> > 
> > I don't see a requirement to know the local or remote node's size of AR
> > DMA buffer.  Rather, keep the traffic throttled such that too frequent
> > ack-busy are avoided.
[...]
> I do need to implement retries but that will be of limited benefit to
> this particular problem.
> 
> Data is written from the remote as a posted write into the AR buffer.
[...]

Oh, I forgot about posted writes.  However, you only lose data with posted
writes if the OHCI somehow fails to access the host bus.  Merely getting
to the end of the DMA program before all of the PCI posting FIFO could be
emptied is not a reason to drop data.  See OHCI-1394 section 3.3 which
speaks about the possibility to drop selfID/ IR/ AR-resp data if out of
buffer, but not AR-req data.

Well, maybe there are bad OHCI implementations which drop posted AR-req
data...?  I don't know.

firewire-net uses posted writes too.  But with IP-over-1394, delivery
guarantee is handled further above if needed, not by the 1394
encapsulation.  firewire-sbp2 also uses posted writes, in two ways:  With
physical DMA to SCSI READ command data buffers, and for the SBP status
FIFO.  But physical DMA does not have a backing DMA program, and data loss
during a status FIFO write would likely be covered by a SCSI transaction
retry.

[...]
> Besides the inefficiency of re-sending data that has already been
> received, retrying may not be possible. Consider when a console driver
> (work-in-progress) writes to the remote using the same interface. It
> could be one of the last things the remote does. And the most crucial
> information is that last write.

As mentioned, I have no idea how TTY works or is supposed to work.  But
even if the sending application is allowed to quit before its last
outbound datagram was delivered, fwserial could still be made to deliver
this last datagram at its own pace, with as many software retries as
prudent.
-- 
Stefan Richter
-=====-===-- =-== -===-
http://arcgraph.de/sr/
