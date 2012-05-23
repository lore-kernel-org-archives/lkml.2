Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704Ab2EWQGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:06:54 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:55307 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab2EWQGv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:06:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1337789179!6365429!59
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Wed, 23 May 2012 11:06:39 -0500
Subject: RE: [PATCH] staging: comedi: remove this_board macro in the s526
 driver
Thread-Topic: [PATCH] staging: comedi: remove this_board macro in the s526
 driver
Thread-Index: Ac04pzaFK6HL5PusQg20Fzl2KYDjKgAVeKdg
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698BAC8A9@AUSP01VMBX24.collaborationhost.net>
References: <201205221820.10770.hartleys@visionengravers.com>
 <20120523054849.GK4637@mwanda>
In-Reply-To: <20120523054849.GK4637@mwanda>
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

On Tuesday, May 22, 2012 10:49 PM, Dan Carpenter wrote:
> On Tue, May 22, 2012 at 06:20:10PM -0700, H Hartley Sweeten wrote:
>> The 'thisboard' macro depends on having a local variable with
>> a magic name. The CodingStyle document suggests not doing this
>> to avoid confusion. Remove the macro and use the comedi_board()
>> inline helper to get the dev->board_ptr information.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: Mori Hess <fmhess@users.sourceforge.net>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> 
>> ---
>> @@ -769,13 +765,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>>  	}
>>  	***/
>>  
>> -/*
>> - * Initialize dev->board_name.  Note that we can use the "thisboard"
>> - * macro now, since we just initialized it in the last line.
>> - */
>> -	dev->board_ptr = &s526_boards[0];
>
> Was this intended?  Most of the boards have auto probing so the
> ->board_ptr gets set automatically.  We already called
> comedi_board() so I wonder if the autoprobed board is the same as
> the &s526_boards[0];?  NULL pointer perhaps?  I don't know.

Yes, removing the line was intended. Sorry I didn't mention it in the
commit message.

The dev->board_ptr will already be set by comedi_device_attach()
before the drivers attach() method is called.

I think the author of this driver misunderstood the skel driver and
thought this was needed in order to simulate a "probe". See this
comment in the skel.c driver:

/*
 * If you can probe the device to determine what device in a series
 * it is, this is the place to do it.  Otherwise, dev->board_ptr
 * should already be initialized.
 */
	/* dev->board_ptr = skel_probe(dev, it); */

The only comedi drivers that modify the dev->board_ptr are the
PCI ones. Hopefully I can figure out a way to clean them up...
The comedi_board() inline does not change the dev->board_ptr,
it's simply a helper to fetch it from the comedi_device.

Regards,
Hartley
