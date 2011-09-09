Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab1IIOhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:37:40 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:43632 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758646Ab1IIOhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:37:39 -0400
Message-ID: <4E6A25B1.8070400@free-electrons.com>
Date: Fri, 09 Sep 2011 16:41:53 +0200
From: David Wagner <david.wagner@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Arnd Bergmann <arnd@arndb.de>, linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCHv3] UBI: new module ubiblk: block layer on top of UBI
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>	 <1315280704.19067.14.camel@sauron> <1315282208.19067.24.camel@sauron>	 <201109081726.00769.arnd@arndb.de> <1315569206.7905.41.camel@sauron>
In-Reply-To: <1315569206.7905.41.camel@sauron>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2011 01:53 PM, Artem Bityutskiy wrote:
> On Thu, 2011-09-08 at 17:26 +0200, Arnd Bergmann wrote:
>> On Tuesday 06 September 2011, Artem Bityutskiy wrote:
>>> Not sure about the bus approach - David, could you take a look at it
>>> please? If we can handle errors there - then we could indeed re-use the
>>> UBI control device. We could even re-use the ioctl data structures for
>>> UBI volumes creation/removal - we have plenty of space there reserved
>>> for future extensions.
>>

@Arnd:
> * Use the existing UBI control device for the block devices as
>   well and just add two more ioctls to create the devices.
>   You can add a logical bus_type for this so that the ubi block
>   driver gets automatically loaded matched with the device when
>   one is created using the control device.

I certainly miss some background, I'm not sure I understand how this
works: bus_type seems suitable for pluggable devices that possess a
device ID which matches against a driver that will then get loaded.  But
ubiblk devices are created by ubiblk.
So, are you suggesting to move ubiblk_create() to UBI and add a
MODULE_ALIAS to ubiblk (actually, I don't know what it would contain) ?

(I just saw that you sent an email while I was writing this one ;
however, I still understand. I'll try and read how scsi does that).


@Artem:
> Sorry, I wonted to talk about situations when someone opens an ubiblk
> device while the underlying UBI volume is being removed, but then though
> this is trivial and forgot to erase the last sentence.

Ah, yes, I guess we need to hold a vol_lock in ubiblk_remove() ?


> Anyway, I suggest the following algorithm:
> 
> 1. Stick with the own cdev approach - the driver becomes very simple
>    in this case - we review it.

This is the way it's implemented in v4, right ?

BTW, those are the changes made so far since v4:
 * Add missing headers (they are included by other headers but it seems
   to be good practice not to rely on that).

 * Remove an macro rendered useless with the linked lists

 * correct some formatting in kerneldoc comments

 * introduce refcounting to avoid multiple opens or closing a UBI
   volume while still in use

 * make checkpatch happy about assignation inside a condition

 * use DEFINE_MUTEX for devlist_lock


	Best Regards,
	David

-- 
David Wagner, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
