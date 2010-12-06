Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab0LFVXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 16:23:11 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:62602 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab0LFVXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 16:23:10 -0500
Date: Mon, 6 Dec 2010 19:23:26 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Pavan Savoy <pavan_savoy@ti.com>
Cc: marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] Bluetooth: btwilink driver
Message-ID: <20101206212326.GI883@vigoh>
References: <1290763257-12382-1-git-send-email-pavan_savoy@ti.com>
 <20101130154654.GE5919@vigoh>
 <AANLkTiktDkjFH=aGbu3f+mkVUgmFDwB6xLW3e1VNXKtz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTiktDkjFH=aGbu3f+mkVUgmFDwB6xLW3e1VNXKtz@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan,

* Pavan Savoy <pavan_savoy@ti.com> [2010-11-30 21:30:47 +0530]:

> Gustavo,
> 
> On Tue, Nov 30, 2010 at 9:16 PM, Gustavo F. Padovan
> <padovan@profusion.mobi> wrote:
> > Hi Pavan,
> >
> > * pavan_savoy@ti.com <pavan_savoy@ti.com> [2010-11-26 04:20:57 -0500]:
> >
> >> From: Pavan Savoy <pavan_savoy@ti.com>
> >>
> >> Marcel, Gustavo,
> >>
> >> comments attended to from v5 and v6,
> >>
> >> 1. Inside ti_st_open, I previously only checked for EINPROGRESS & EPERM,
> >> Now I handle for EINPROGRESS - which is not really an error and
> >> return during all other error cases.
> >>
> >> 2. _write is still a function pointer and not an exported function, I
> >> need to change the underlying driver's code for this.
> >> However, previous lkml comments on the underlying driver's code
> >> suggested it to be kept as a function pointer and not EXPORT.
> >> Gustavo, Marcel - Please comment on this.
> >> Is this absolutely required? If so why?
> >>
> >> 3. test_and_set_bit of HCI_RUNNING is done at beginning of
> >> ti_st_open, and did not see issues during firmware download.
> >> However ideally I would still like to set HCI_RUNNING once the firmware
> >> download is done, because I don't want to allow a _send_frame during
> >> firmware download - Marcel, Gustavo - Please comment.
> >>
> >> 4. test_and_clear of HCI_RUNNING now done @ beginning of close.
> >>
> >> 5. EAGAIN on failure of st_write is to suggest to try and write again.
> >> I have never this happen - However only if UART goes bad this case may
> >> occur.
> >>
> >> 6. ti_st_tx_complete is very similar to hci_ldisc's tx_complete - in
> >> fact the code is pretty much borrowed from there.
> >> Marcel, Gustavo - Please suggest where should it be done? If not here.
> >>
> >> 7. comments cleaned-up + hst memory leak fixed when hci_alloc_dev fails.
> >>
> >> 8. platform_driver registration inside module_init now is similar to
> >> other drivers.
> >>
> >> 9. Dan Carpenter's comments on leaking hst memory on failed
> >> hci_register_dev and empty space after quotes in debug statements
> >> fixed.
> >>
> >> Thanks for the comments...
> >> Sorry, for previously not being very clear on which comments were
> >> handled and which were not.
> >>
> >> -- patch description --
> >>
> >> This is the bluetooth protocol driver for the TI WiLink7 chipsets.
> >> Texas Instrument's WiLink chipsets combine wireless technologies
> >> like BT, FM, GPS and WLAN onto a single chip.
> >>
> >> This Bluetooth driver works on top of the TI_ST shared transport
> >> line discipline driver which also allows other drivers like
> >> FM V4L2 and GPS character driver to make use of the same UART interface.
> >>
> >> Kconfig and Makefile modifications to enable the Bluetooth
> >> driver for Texas Instrument's WiLink 7 chipset.
> >>
> >> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> >> ---
> >>  drivers/bluetooth/Kconfig    |   10 ++
> >>  drivers/bluetooth/Makefile   |    1 +
> >>  drivers/bluetooth/btwilink.c |  363 ++++++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 374 insertions(+), 0 deletions(-)
> >>  create mode 100644 drivers/bluetooth/btwilink.c
> >
> > So as part of reviewing this I took a look at your underlying driver and
> > I didn't like what I saw there, you are handling Bluetooth stuff inside
> > the core driver and that is just wrong. You have a Bluetooth driver here
> > then you have to leave the Bluetooth data handling to the Bluetooth
> > driver and do not do that in the core.
> 
> Thanks for reviewing this and the underlying driver.
> yes, we do have Bluetooth/FM/GPS handling inside the TI ST driver, on
> addition of further technologies
> we do plan to have them inside the ST driver too.
> 
> The understanding of BT or FM or GPS is required for the ST driver
> because, the data coming from the chip
> can either be of these technologies, further-more the data might not
> come in a set.
> As in, an a2dp/ftp ACL frame might come in 2 frames instead of 1, and
> in other cases,
> there might be a HCI-EVENT + FM CH8 data in a single frame received by the UART.

Can't you differentiate Bluetooth data in a generic way, withou looking if it
is ACL, SCO or HCI EVENT? That done, you can just accumulate in a buffer all
the Bluetooth data you received in that stream then send it to Bluetooth
driver after finish that stream processing.

-- 
Gustavo F. Padovan
http://profusion.mobi
