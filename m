Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2EWQ2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:28:39 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:3969 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab2EWQ2i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:28:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1337790513!5713963!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>, Dan Carpenter <dan.carpenter@oracle.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Wed, 23 May 2012 11:28:32 -0500
Subject: RE: [PATCH] staging: comedi: remove this_board macro in the s526
 driver
Thread-Topic: [PATCH] staging: comedi: remove this_board macro in the s526
 driver
Thread-Index: Ac04xPyn3QP8XWfKSMmnReOe+fv+aQAObjfQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698BAC8D8@AUSP01VMBX24.collaborationhost.net>
References: <201205221820.10770.hartleys@visionengravers.com>
 <20120523054849.GK4637@mwanda> <4FBCAB50.5000907@mev.co.uk>
In-Reply-To: <4FBCAB50.5000907@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2012 2:18 AM, Ian Abbott wrote:
> On 2012-05-23 06:48, Dan Carpenter wrote:
>> On Tue, May 22, 2012 at 06:20:10PM -0700, H Hartley Sweeten wrote:
>>> -/*
>>> - * Initialize dev->board_name.  Note that we can use the "thisboard"
>>> - * macro now, since we just initialized it in the last line.
>>> - */
>>> -	dev->board_ptr =&s526_boards[0];
>>
>> Was this intended?  Most of the boards have auto probing so the
>> ->board_ptr gets set automatically.  We already called
>> comedi_board() so I wonder if the autoprobed board is the same as
>> the&s526_boards[0];?  NULL pointer perhaps?  I don't know.
>
> If .num_names in struct comedi_driver is non-zero, the core comedi 
> module will set dev->board_ptr to something non-NULL and meaningful to 
> the driver before it calls the driver's ->attach() method.  (This is 
> done by the comedi_recognize() function.)  The driver can change 
> dev->board_ptr to something else if it wants.  In this case, 
> dev->board_ptr will already be set to &s526_boards[0] so there is no 
> point setting it again.

Ian,

Side-note on the boardinfo stuff.

I wonder if it makes sense to create a common boardinfo struct
and modify the comedi_driver struct a bit. Something like:

struct comedi_boardinfo {
	const char *name;
	unsigned short	vendor;
	unsigned short device;
	void *private;
};

struct comedi_driver {
	struct comedi_driver *next;

	const char *driver_name;
	struct module *module;
	int (*attach) (struct comedi_device *, struct comedi_devconfig *);
	void (*detach) (struct comedi_device *);
	int (*attach_pci) (struct comedi_device *, struct pci_dev *);
	int (*attach_usb) (struct comedi_device *, struct usb_interface *);

	u32 num_boards;
	struct comedi_boardinfo *board;
};

This would allow comedi_recognize() to walk the boardinfo
to find the match without all the ugly casts. It should also
allow creating a common comedi_find_pcidev() for all the
comedi pci drivers to use when probing for the board_ptr.

This would create a bit of churn but I think it would be a
lot cleaner in the end.

What do you think?

Regards,
Hartley


