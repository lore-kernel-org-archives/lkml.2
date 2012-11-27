Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab2K0Sdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:33:35 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:49288 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756568Ab2K0Sdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:33:32 -0500
Message-ID: <1354041196.3284.121.camel@thor>
Subject: Re: [PATCH v2 1/1] staging: fwserial: Add TTY-over-Firewire serial
 driver
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux1394-devel@lists.sourceforge.net,
        linux-serial@vger.kernel.org
Date: Tue, 27 Nov 2012 13:33:16 -0500
In-Reply-To: <20121114022522.633a44d4@stein>
References: <1350565015.23730.4.camel@thor>
	 <cover.1351817601.git.peter@hurleysoftware.com>
	 <55547e779e65e6865f18d537ef1a42191a4b7e46.1351817601.git.peter@hurleysoftware.com>
	 <20121113003338.6aafd7c8@stein> <1352834072.16401.100.camel@thor>
	 <20121114022522.633a44d4@stein>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 02:25 +0100, Stefan Richter wrote:
> On Nov 13 Peter Hurley wrote:
> > On Tue, 2012-11-13 at 00:33 +0100, Stefan Richter wrote:
> > > On Nov 02 Peter Hurley wrote:
> > > > +2. MAX_ASYNC_PAYLOAD needs to be publicly exposed by core/ohci
> > > > +   - otherwise how will this driver know the max size of address window to
> > > > +     open for one packet write?
> > > 
> > > Hmm, don't firewire-sbp2 and firewire-net deal with this very problem
> > > already on their own?  Firewire-sbp2 tells the target what maximum payload
> > > the local node is ready to accept, and firewire-net figures out whether it
> > > needs to fragment the datagrams in unicast TX depending on the remote
> > > node's capabilities.
> > 
> > I wasn't as clear as I should have been here. This is only about how big
> > to make the address handler window.
> 
> Isn't fw_card.max_receive what you were looking for?

Yes, you're right, this is what I should do.

> But since the
> current firewire-core API requires you to allocate one handler address and
> size for all cards --- even for cards which will be hot-added later while
> your driver is already running ---, you should surely just allocate
> 4096 bytes; see below.

This driver uses a 2-stage negotiation scheme.

A small address window is allocated for all cards in the unit address
space. This address window is known to all peers because it is
advertised in the unit device config rom for all cards. The associated
handler handles requests for attach/detach from peers.

Then, when a local node is probed, the larger status+fifo address
windows are allocated (one address window for each tty port). Thus each
attached peer will get a dedicated address window.

The peer learns which status+fifo window it has been assigned
(corresponding to a particular tty port) while negotiating the attach.

Currently, the larger windows are allocated before knowledge of which
peer (or indeed any peer) might attempt to attach.

I will need to delay this allocation until during the attach
negotiation.

But if it's ok with you, maybe I can put this off for right now and just
note it in the TODO?

> > Just like firewire-net, this driver
> > communicates with remotes at S100 speeds (and packet sizes) to
> > query the largest packet size that the remote supports.
> 
> (RFC 2734 additionally keeps things sane for itself by requiring all 2734
> compliant nodes to support at least max packet = 512 bytes.)
> 
> Could it be easier to take this information from fw_device.max_speed and
> the max_rec in fw_device.config_rom?  RFC 2734 was designed to work
> without a local node management layer which is capable to gather such
> information, but we have this information on Linux (at the time when
> core_device.c finished its node discovery).

I see your point and I hadn't considered that. That said, the
attach/detach negiotiation doesn't need optimizing, so I'm comfortable
leaving this as is.

> > Currently, firewire-net sets an arbitrary address handler length of
> > 4096. This works because the largest AR packet size the current
> > firewire-ohci driver handles is 4096 (value of MAX_ASYNC_PAYLOAD) +
> > header/trailer. Note that firewire-ohci does not limit card->max_receive
> > to this value.
> > 
> > So if the ohci driver changes to handle 8K+ AR packets and the hardware
> > supports it, these address handler windows will be too small.
> 
> While the IEEE 1394:2008 link layer specification (section 6) provides for
> asynchronous packet payloads of up to 16384 bytes (table 6-4), the IEEE
> 1394 beta mode port specification (section 13) only allows up to 4096
> bytes (table 16-18).  And alpha mode is of course limited to 2048 bytes.
> 
> So, asynchronous packet payloads greater than 4096 bytes are out of scope
> of the current revision of IEEE 1394.

You should look at this 1394ta.org video
http://www.youtube.com/watch?v=xVXNvXHNQTY of DAP Technologies S1600
OHCI controllers running S1600 cameras using beta cables. (I apologize
for the youtube link but that's where they hosted it :\)

> > > > +4. To avoid dropping rx data while still limiting the maximum buffering,
> > > > +     the size of the AR context must be known. How to expose this to drivers?
> > > 
> > > I don't see a requirement to know the local or remote node's size of AR
> > > DMA buffer.  Rather, keep the traffic throttled such that too frequent
> > > ack-busy are avoided.
> [...]
> > I do need to implement retries but that will be of limited benefit to
> > this particular problem.
> > 
> > Data is written from the remote as a posted write into the AR buffer.
> [...]
> 
> Oh, I forgot about posted writes.  However, you only lose data with posted
> writes if the OHCI somehow fails to access the host bus.  Merely getting
> to the end of the DMA program before all of the PCI posting FIFO could be
> emptied is not a reason to drop data.  See OHCI-1394 section 3.3 which
> speaks about the possibility to drop selfID/ IR/ AR-resp data if out of
> buffer, but not AR-req data.
> 
> Well, maybe there are bad OHCI implementations which drop posted AR-req
> data...?  I don't know.

When I refer to dropping rx data here, I mean this sequence for
receiving a posted write:

handle_ar_packet
  fw_core_handle_request
    handle_exclusive_region_request
      handler->address_callback() => fwtty_port_handler(WRITE_BLOCK_REQUEST)
        ** tty buffer space is full so can't copy the data out of AR buffer **

That data will be dropped and need to be retransmitted. But see below.

> firewire-net uses posted writes too.  But with IP-over-1394, delivery
> guarantee is handled further above if needed, not by the 1394
> encapsulation.  firewire-sbp2 also uses posted writes, in two ways:  With
> physical DMA to SCSI READ command data buffers, and for the SBP status
> FIFO.  But physical DMA does not have a backing DMA program, and data loss
> during a status FIFO write would likely be covered by a SCSI transaction
> retry.

see below.

> [...]
> > Besides the inefficiency of re-sending data that has already been
> > received, retrying may not be possible. Consider when a console driver
> > (work-in-progress) writes to the remote using the same interface. It
> > could be one of the last things the remote does. And the most crucial
> > information is that last write.
> 
> As mentioned, I have no idea how TTY works or is supposed to work.  But
> even if the sending application is allowed to quit before its last
> outbound datagram was delivered, fwserial could still be made to deliver
> this last datagram at its own pace, with as many software retries as
> prudent.

Among the many uses for fast tty is to receive the output from a remote
console driver (where printk's go). The last printk coming from the
remote will be the most important as it may contain a vital clue as to
why the remote host died. (Note: most console drivers will busy-wait the
current cpu until the transmission completes or it times out).

That's why I'd like to only be forced to software retry if absolutely
necessary. To my mind, software retrying is partly avoidable if the
receiver can ensure enough tty buffer space is available at any given
time. To provide this guarantee, this driver reserves a buffer as large
as the AR-req buffer (initially I had wanted to simply use a watermark
within the existing tty buffers but that idea was a non-starter). This
way the receiver can throttle the remote but still receive all the data
the remote may already have sent that is already in the AR-req buffer.

Does that make sense?

Regards,
Peter Hurley

