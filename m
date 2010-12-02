Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab0LBAsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:48:16 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41109 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab0LBAsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:48:14 -0500
MIME-Version: 1.0
X-Originating-IP: [14.99.2.3]
In-Reply-To: <AANLkTiktDkjFH=aGbu3f+mkVUgmFDwB6xLW3e1VNXKtz@mail.gmail.com>
References: <1290763257-12382-1-git-send-email-pavan_savoy@ti.com>
	<20101130154654.GE5919@vigoh>
	<AANLkTiktDkjFH=aGbu3f+mkVUgmFDwB6xLW3e1VNXKtz@mail.gmail.com>
Date: Thu, 2 Dec 2010 06:18:12 +0530
Message-ID: <AANLkTi=YOQxr3mL_tgkXC1qM8rrH1bTAtRLVn5N-4U_c@mail.gmail.com>
Subject: Re: [PATCH v7] Bluetooth: btwilink driver
From: Pavan Savoy <pavan_savoy@sify.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gustavo,

On Tue, Nov 30, 2010 at 9:30 PM, Pavan Savoy <pavan_savoy@ti.com> wrote:
>>> Marcel, Gustavo,
>>> comments attended to from v5 and v6,

There was 1 solution which was proposed for this,
See in tty_receive/st_int_recv() - we pretty much want only the
packet_id, header length and
the offset of the payload in the header structure.
this is to pack together the data coming in single frame or sets of
multiple frames...

so if bt driver can do something like,
st_register(acl_proto) -> where ACL_PKT=0x2, acl_hdr.len and
acl_hdr.payload_offset is sent to ST
st_register(sco_proto) -> where SCO_PKT=0x3, sco_hdr.len and
sco_hdr.payload_offset is sent to ST
st_register(evt_proto) -> where EVT_PKT=0x2, sco_hdr.len and
evt_hdr.payload_offset is sent to ST

and all 3 map to same st_recv() functions from ST, then
the ST driver as you suggested can be generic enough not to include
any net/bluetooth/ stuff,
and also can be ignorant about any bluetooth, fm or gps stuff in general...

So please suggest if this seems a valid solution, we had previously
declined it because it made bt_driver
sort of register to ST 3 times instead of 1 time like now....

Thanks,
Pavan

>>> 1. Inside ti_st_open, I previously only checked for EINPROGRESS & EPERM,
>>> Now I handle for EINPROGRESS - which is not really an error and
>>> return during all other error cases.
>>>
>>> 2. _write is still a function pointer and not an exported function, I
>>> need to change the underlying driver's code for this.
>>> However, previous lkml comments on the underlying driver's code
>>> suggested it to be kept as a function pointer and not EXPORT.
>>> Gustavo, Marcel - Please comment on this.
>>> Is this absolutely required? If so why?
>>>
>>> 3. test_and_set_bit of HCI_RUNNING is done at beginning of
>>> ti_st_open, and did not see issues during firmware download.
>>> However ideally I would still like to set HCI_RUNNING once the firmware
>>> download is done, because I don't want to allow a _send_frame during
>>> firmware download - Marcel, Gustavo - Please comment.
>>>
>>> 4. test_and_clear of HCI_RUNNING now done @ beginning of close.
>>>
>>> 5. EAGAIN on failure of st_write is to suggest to try and write again.
>>> I have never this happen - However only if UART goes bad this case may
>>> occur.
>>>
>>> 6. ti_st_tx_complete is very similar to hci_ldisc's tx_complete - in
>>> fact the code is pretty much borrowed from there.
>>> Marcel, Gustavo - Please suggest where should it be done? If not here.
>>>
>>> 7. comments cleaned-up + hst memory leak fixed when hci_alloc_dev fails.
>>>
>>> 8. platform_driver registration inside module_init now is similar to
>>> other drivers.
>>>
>>> 9. Dan Carpenter's comments on leaking hst memory on failed
>>> hci_register_dev and empty space after quotes in debug statements
>>> fixed.
>>>
>>> Thanks for the comments...
>>> Sorry, for previously not being very clear on which comments were
>>> handled and which were not.
>>>
>>> -- patch description --
>>>
>>> This is the bluetooth protocol driver for the TI WiLink7 chipsets.
>>> Texas Instrument's WiLink chipsets combine wireless technologies
>>> like BT, FM, GPS and WLAN onto a single chip.
>>>
>>> This Bluetooth driver works on top of the TI_ST shared transport
>>> line discipline driver which also allows other drivers like
>>> FM V4L2 and GPS character driver to make use of the same UART interface.
>>>
>>> Kconfig and Makefile modifications to enable the Bluetooth
>>> driver for Texas Instrument's WiLink 7 chipset.
>>>
>>> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
>>> ---
>>>  drivers/bluetooth/Kconfig    |   10 ++
>>>  drivers/bluetooth/Makefile   |    1 +
>>>  drivers/bluetooth/btwilink.c |  363 ++++++++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 374 insertions(+), 0 deletions(-)
>>>  create mode 100644 drivers/bluetooth/btwilink.c
>>
>> So as part of reviewing this I took a look at your underlying driver and
>> I didn't like what I saw there, you are handling Bluetooth stuff inside
>> the core driver and that is just wrong. You have a Bluetooth driver here
>> then you have to leave the Bluetooth data handling to the Bluetooth
>> driver and do not do that in the core.
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
>
>> So I'm going to clear NACK this. Your TI ST driver architecture is
>> a mess, Ideally you should not have any #include <net/bluetoooth/...>
>> there. Implement a core driver that only gets the Shared Transport
>> data and pass it to the right driver without look into the data and
>> process it. Process the data is not the role of the core driver.
>
> So as I see it the tty_receive which translates to st_int_recv() in
> TI-ST is the area of concern for
> you ...
> So any suggestions as to how we can go about just abstracting the BT,
> FM and GPS data part to their individual drivers?
>
>> Please fix this and come back when you have a proper solution for your
>> driver.
>>
>> --
>> Gustavo F. Padovan
>> http://profusion.mobi
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
