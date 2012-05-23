Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562Ab2EWQst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:48:49 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:33245 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760536Ab2EWQsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:48:45 -0400
Message-ID: <4FBD14E5.2090806@mev.co.uk>
Date: Wed, 23 May 2012 17:48:37 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120516 Thunderbird/12.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: remove this_board macro in the s526
 driver
References: <201205221820.10770.hartleys@visionengravers.com> <20120523054849.GK4637@mwanda> <4FBCAB50.5000907@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F0020698BAC8D8@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698BAC8D8@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-23 17:28, H Hartley Sweeten wrote:
> On Wednesday, May 23, 2012 2:18 AM, Ian Abbott wrote:
>> On 2012-05-23 06:48, Dan Carpenter wrote:
>>> On Tue, May 22, 2012 at 06:20:10PM -0700, H Hartley Sweeten wrote:
>>>> -/*
>>>> - * Initialize dev->board_name.  Note that we can use the "thisboard"
>>>> - * macro now, since we just initialized it in the last line.
>>>> - */
>>>> -	dev->board_ptr =&s526_boards[0];
>>>
>>> Was this intended?  Most of the boards have auto probing so the
>>> ->board_ptr gets set automatically.  We already called
>>> comedi_board() so I wonder if the autoprobed board is the same as
>>> the&s526_boards[0];?  NULL pointer perhaps?  I don't know.
>>
>> If .num_names in struct comedi_driver is non-zero, the core comedi
>> module will set dev->board_ptr to something non-NULL and meaningful to
>> the driver before it calls the driver's ->attach() method.  (This is
>> done by the comedi_recognize() function.)  The driver can change
>> dev->board_ptr to something else if it wants.  In this case,
>> dev->board_ptr will already be set to&s526_boards[0] so there is no
>> point setting it again.
>
> Ian,
>
> Side-note on the boardinfo stuff.
>
> I wonder if it makes sense to create a common boardinfo struct
> and modify the comedi_driver struct a bit. Something like:
>
> struct comedi_boardinfo {
> 	const char *name;
> 	unsigned short	vendor;
> 	unsigned short device;
> 	void *private;
> };
>
> struct comedi_driver {
> 	struct comedi_driver *next;
>
> 	const char *driver_name;
> 	struct module *module;
> 	int (*attach) (struct comedi_device *, struct comedi_devconfig *);
> 	void (*detach) (struct comedi_device *);
> 	int (*attach_pci) (struct comedi_device *, struct pci_dev *);
> 	int (*attach_usb) (struct comedi_device *, struct usb_interface *);
>
> 	u32 num_boards;
> 	struct comedi_boardinfo *board;
> };
>
> This would allow comedi_recognize() to walk the boardinfo
> to find the match without all the ugly casts. It should also
> allow creating a common comedi_find_pcidev() for all the
> comedi pci drivers to use when probing for the board_ptr.
>
> This would create a bit of churn but I think it would be a
> lot cleaner in the end.
>
> What do you think?

Please don't do this yet.  We might want to implement auto configuration 
for device types that have no concept of vendor ID or product ID, such 
as PCMCIA, platform devices, SPI devices etc., either by adding extra 
attach_xxx hooks to struct comedi_driver for the more common bus types, 
or a more generic attach_generic hook for the less common bus types.

Also, it would waste space in the ISA-only drivers.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
