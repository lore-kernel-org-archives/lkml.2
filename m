Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab2EJQf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:35:59 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:52942 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758323Ab2EJQf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:35:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EADbtq09bdWOb/2dsb2JhbABDAYV2rhyBB4IVAQEEASMEES8SEAQHGgIVAQEPAgJXBhMIE4V3gXcJqEKTDYEviWODEAQBgXyBGASVfZBAgmqBXg
X-IronPort-AV: E=Sophos;i="4.75,565,1330902000"; 
   d="scan'208";a="906244522"
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 1/3] Staging: IndustryPack bus for the Linux Kernel
X-PHP-Originating-Script: 33:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 10 May 2012 17:34:54 +0100
From: =?UTF-8?Q?Samuel_Iglesias_Gons=C3=A1lvez?= <siglesias@igalia.com>
Cc: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Manohar Vanga <manohar.vanga@cern.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>
Organization: Igalia
In-Reply-To: <20120510153728.GA18574@kroah.com>
References: <1336570041-32724-1-git-send-email-siglesias@igalia.com>
 <20120509211338.GA23322@kroah.com>
 <1336659838.3458.24.camel@fourier.local.igalia.com>
 <20120510153728.GA18574@kroah.com>
Message-ID: <3c71a30f539ee297f781beede0a411f3@igalia.com>
User-Agent: Roundcube Webmail/0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-10 16:37, Greg Kroah-Hartman wrote:
(snip)
>
>> > > +static void ipack_device_release(struct device *dev)
>> > > +{
>> > > +}
>> >
>> > Weee.  As per the in-kernel documentation, I get to publically 
>> mock
>> you
>> > for doing something as foolish as thinking you are smarter than 
>> the
>> > kernel by just creating an empty function for the release 
>> callback.
>> >
>> > Did you think this really is the solution for when the kernel is
>> > complaining to you about the fact that you need a callback 
>> function
>> > here?  Surely I didn't just put that logic in the core for no good
>> > reason now, right?
>> >
>> > Please fix this up NOW.
>>
>> OK, I will fix it. However reading my code, I don't see the need to
>> kfree anything here, like in other drivers, for example.
>
> Then your code is designed wrong.  You must free the memory here.  
> The
> problem is that your "core" is not doing the allocation, but are 
> relying
> on the driver to do it instead.  Don't do that, the driver should not
> have to do any of this at all.  Look at other busses for examples.
>

OK.

>> Is it OK to have a pr_info notifying the release of the device or 
>> should
>> I think again about it?
>
> You should never have a pr_info() call anywhere, what would a user do
> with such a message?  That seems pretty pointless, right?
>
> Also, please always use dev_*() calls instead of pr_*() calls, as you
> should always have access to a struct device in your code.
>

OK

>> > > +++ b/drivers/staging/ipack/ipack.h
>> > > @@ -0,0 +1,183 @@
>> > > +/*
>> > > + * Industry-pack bus.
>> > > + *
>> > > + * (C) 2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
>> > > + * (C) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
>> Igalia
>> > > + *
>> > > + * This program is free software; you can redistribute it 
>> and/or
>> modify it
>> > > + * under the terms of the GNU General Public License as 
>> published
>> by the Free
>> > > + * Software Foundation; either version 2 of the License, or (at
>> your option)
>> > > + * any later version.
>> >
>> > Again, "any later version", are you sure?  Be very sure about this
>> > please.
>> >
>> > > +struct ipack_device {
>> > > +   char board_name[IPACK_BOARD_NAME_SIZE];
>> >
>> > Why not use dev->name?
>>
>> May I be wrong, do you refer rename it to "name"?
>
> rename what?  Why do you need a board name for a device?  Shouldn't 
> that
> just be the "name" for the device?  And as such, just use the field 
> you
> already have.
>

In struct device there is the field "init_name". There is a "name" 
field in the corresponding struct kobject inside of dev. This is the 
reason of my misunderstanding.

I will change it.

>> > > +   char bus_name[IPACK_BOARD_NAME_SIZE];
>
> And, why do you need a bus name?  Shouldn't that be implied based on
> what bus the device is attached to?
>

This is the name of the bus device. The problem here is that the 
ipoctal mezzanine needs to save the IRQ vector in his memory space in a 
different address depending of the carrier board it is plugged to.

It is described in IP-OCTAL's datasheet. So this bus_name variable 
gives the way to do it.

Best regards,

Sam
