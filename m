Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2K0X7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:59:17 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45831 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2K0X7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:59:14 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 28 Nov 2012 00:58:46 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux1394-devel@lists.sourceforge.net,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 1/1] staging: fwserial: Add TTY-over-Firewire serial
 driver
Message-ID: <20121128005846.0f1d4d5e@stein>
In-Reply-To: <1354041196.3284.121.camel@thor>
References: <1350565015.23730.4.camel@thor>
	<cover.1351817601.git.peter@hurleysoftware.com>
	<55547e779e65e6865f18d537ef1a42191a4b7e46.1351817601.git.peter@hurleysoftware.com>
	<20121113003338.6aafd7c8@stein>
	<1352834072.16401.100.camel@thor>
	<20121114022522.633a44d4@stein>
	<1354041196.3284.121.camel@thor>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 27 Peter Hurley wrote:
> > > Currently, firewire-net sets an arbitrary address handler length of
> > > 4096. This works because the largest AR packet size the current
> > > firewire-ohci driver handles is 4096 (value of MAX_ASYNC_PAYLOAD) +
> > > header/trailer. Note that firewire-ohci does not limit card->max_receive
> > > to this value.
> > > 
> > > So if the ohci driver changes to handle 8K+ AR packets and the hardware
> > > supports it, these address handler windows will be too small.  
> > 
> > While the IEEE 1394:2008 link layer specification (section 6) provides for
> > asynchronous packet payloads of up to 16384 bytes (table 6-4), the IEEE
> > 1394 beta mode port specification (section 13) only allows up to 4096
> > bytes (table 16-18).  And alpha mode is of course limited to 2048 bytes.
> > 
> > So, asynchronous packet payloads greater than 4096 bytes are out of scope
> > of the current revision of IEEE 1394.  
> 
> You should look at this 1394ta.org video
> http://www.youtube.com/watch?v=xVXNvXHNQTY of DAP Technologies S1600
> OHCI controllers running S1600 cameras using beta cables.

I don't know the details of their implementation, but I suppose they conform
with the 1394 beta mode port specification.  Which in turn means that their
S1600 solution (and by extrapolation, their S3200 prototypes) comply with a
maximum asynchronous packet payload of 4096 bytes.  Citing IEEE 1394-2008:

>>>
	Table 16-18———Maximum payload size for Beta data packets
 Data rate | Maximum asynchronous payload size | Maximum isochronous payload
           |              (bytes)              |           (bytes)
 ----------+-----------------------------------+----------------------------
    S100   |                 512               |             1024
    S200   |                1024               |             2048
    S400   |                2048               |             4096
    S800   |                4096               |             8192
    S1600  |                4096               |            16384
    S3200  |                4096               |            32768
<<<

(Alpha mode payload limits are the same as the S100...S400 subset of beta mode.
In IEEE 1394b-2002, the table number is 16-3.)

You can of course define registers (or better termed: buffers) which are larger
than what can be atomically read or written, or atomically compared-swapped;
IOW which are larger than what can be accessed in a single transaction, if such
registers or buffers are useful.  But if you particularly need a register which
is just large enough to accommodate the largest possible inbound block write
transaction which complies with IEEE 1394, and you don't know the peer's
capability and the speeds of all intermediary cable hops, then
fw_card.max_receive is the number that you need.  Or you ignore the cards actual
capability and just allocate 4096 bytes.

OHCIs that you can buy offer fw_card.max_receive of 1024, or 2048, or 4096 bytes.
1024 bytes is the limit of many but not all 1394a S400 CardBus cards.

[Issues of transaction retries and possible loss at session termination to be
left to another reply at another time.]
-- 
Stefan Richter
-=====-===-- =-== ==-==
http://arcgraph.de/sr/
