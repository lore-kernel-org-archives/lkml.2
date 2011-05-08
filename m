Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1EHO77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 10:59:59 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48331 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1EHO74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 10:59:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sShx+FbTZJK41+ZX4IbX1sBGJmMWkpLY29BMaNnuNGtAyXJT2AgoNgCs2dnuVHAQPC
         hC2yaBSMomDsJiZjWGb1fX+SlnTdhUmGep3H24tH5ipBX4NDSgR0ifdqNsvPkOmhTlio
         kXol1kieV5a8piofb6W6drEhl5x2s8+6vPJeQ=
MIME-Version: 1.0
In-Reply-To: <201105081647.22091.arnd@arndb.de>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	<201105061605.31625.arnd@arndb.de>
	<BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
	<201105081647.22091.arnd@arndb.de>
Date: Sun, 8 May 2011 16:59:55 +0200
Message-ID: <BANLkTimhOCL7O1ERqUKkH_4sgq5xNYJZRg@mail.gmail.com>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/8 Arnd Bergmann <arnd@arndb.de>:
> On Friday 06 May 2011 16:50:30 Rafał Miłecki wrote:
>> 2011/5/6 Arnd Bergmann <arnd@arndb.de>:
>
>> > This really needs a changelog. You've probably written all of
>> > it before, just explain above the Cc what bcma is, where it's
>> > used, why you use a bus_type. This will be the place where
>> > people look when they want to find out what it is, so try
>> > to make a good description.
>>
>> What do you mean by changelog? Is README unsufficient? It contains
>> almost everything you mentioned...
>
> The changelog is the text at the start of the email, which is
> what 'git log' shows you after the patch gets applied.

By changelog I understood differences between V1, V2, ..., V6.
I read "above the Cc" as "to above Cc". I thought you want me to
explain ppl from Cc what BCMA is.


>> > This would be a good start for the changelog. You don't actually need the
>> > readme in the code directory, it's better to put the information somewhere
>> > in the Documentation/ directory.
>>
>> I guess Documentation/ can be a good idea, but I'd like to make it
>> later if nobody really minds. It's no fun to post more and more
>> versions of patches, just to update some single description.
>
> Having the text in Documentation/ is optional except for user
> interfaces, but generally considered a good idea. The changelog
> in the email text is not optional.
>
>> >> diff --git a/drivers/bcma/TODO b/drivers/bcma/TODO
>> >> new file mode 100644
>> >> index 0000000..45eadc9
>> >> --- /dev/null
>> >> +++ b/drivers/bcma/TODO
>> >> @@ -0,0 +1,3 @@
>> >> +- Interrupts
>> >> +- Defines for PCI core driver
>> >> +- Convert bcma_bus->cores into linked list
>> >
>> > The last item doesn't make sense to me. Since you are using the regular
>> > driver model, you can simply iterate over all child devices of any
>> > dev.
>>
>> It's about optimization. Right now bcma_bus->cores is static array, we
>> probably never will use all entries.
>
> Oh, I see. You should probably have neither of them. Instead allocate
> the devices dynamically as you find them and do a device_register,
> which will add the device into linked list.

As I said, and wrote: TODO.


>> > I don't know if we discussed this before. Normally, you should not need such
>> > udelay() calls, at least if you have the correct I/O barriers in place.
>>
>> I believe we didn't.
>>
>> We had to use such a delays in ssb to let devices react to the
>> changes. Did you maybe have a talk with hardware guys at Broadcom
>> about this? Are you sure this is not needed for BCMA?
>
> Normally what you should have is a register which you can poll
> to find out of the device is ready. In some cases the mmio read
> gets stalled until the hardware is done, in other cases, you have
> to do repeated reads until a register goes from 1 to 0 or the
> opposite. I would be surprised if BCMA didn't have this, but
> it's possible.
>
>> >> +#include "bcma_private.h"
>> >> +#include <linux/bcma/bcma.h>
>> >> +
>> >> +MODULE_DESCRIPTION("Broadcom's specific AMBA driver");
>> >> +MODULE_LICENSE("GPL");
>> >> +
>> >> +static int bcma_bus_match(struct device *dev, struct device_driver *drv);
>> >> +static int bcma_device_probe(struct device *dev);
>> >> +static int bcma_device_remove(struct device *dev);
>> >
>> > Try to reorder your functions so you don't need any forward declarations.
>>
>> That's needed because I put bus-closely-related stuff at the
>> beginning. I did this for readability, I don't think it really hurts
>> anyone or is against coding style or sth.
>
> When I'm reading a source file, I usually start at the end
> because that is where the important stuff gets registered to
> other subsystems. It's really confusing when one source file
> does it in a different order.
>
> Further, it's not obvious that the code is recursion free if
> you have forward declarations in the beginning.
>
>> >> +const char *bcma_device_name(u16 coreid)
>> >> +{
>> >> +     switch (coreid) {
>> >> +     case BCMA_CORE_OOB_ROUTER:
>> >> +             return "OOB Router";
>> >> +     case BCMA_CORE_INVALID:
>> >> +             return "Invalid";
>> >> +     case BCMA_CORE_CHIPCOMMON:
>> >> +             return "ChipCommon";
>> >> +     case BCMA_CORE_ILINE20:
>> >> +             return "ILine 20";
>> >
>> > It's better to make that a data structure than a switch() statement,
>> > both from readability and efficiency aspects.
>>
>> Well, maybe. We call it only once, at init time. In any case we're
>> still waiting for Broadcom to clarify which cores are really used for
>> BCMA.
>
> Readability is really what counts here. With efficiency, I mostly
> referred to code size, not execution time. As a general rule, use
> data structures instead of code where they are equivalent.
>
>> >> +/* 1) It is not allowed to put struct device statically in bcma_device
>> >> + * 2) We can not just use pointer to struct device because we use container_of
>> >> + * 3) We do not have pointer to struct bcma_device in struct device
>> >> + * Solution: use such a dummy wrapper
>> >> + */
>> >> +struct __bcma_dev_wrapper {
>> >> +     struct device dev;
>> >> +     struct bcma_device *core;
>> >> +};
>> >> +
>> >> +struct bcma_device {
>> >> +     struct bcma_bus *bus;
>> >> +     struct bcma_device_id id;
>> >> +
>> >> +     struct device *dev;
>> >> +
>> >> +     u8 core_index;
>> >> +
>> >> +     u32 addr;
>> >> +     u32 wrap;
>> >> +
>> >> +     void *drvdata;
>> >> +};
>> >
>> > Something went wrong here, maybe you misunderstood the API, or I
>> > misunderstood what you are trying to do. When you define your own bus
>> > type, the private device (struct bcma_device) should definitely contain
>> > a struct device as a member, and you allocate that structure dynamically
>> > when probing the bus. I don't see any reason for that wrapper.
>>
>> Having "stuct device" in my "struct bcma_device" let me walk from
>> bcma_device to device. Not the opposite. In case of:
>> manuf_show
>> id_show
>> rev_show
>> class_show
>> I've to go this opposite way. I've "stuct device" but I need to get
>> corresponding "struct bcma_device".
>
> Maybe you didn't understand what I said: This should be
>
> struct bcma_device {
>     struct bcma_bus *bus;
>     struct bcma_device_id id;
>     struct device dev;
>     u8 core_index;
>
>     u32 addr;
>     u32 wrap;
>
>     void *drvdata;
> };
>
> Here, bcma_device is the device, no need to follow pointers
> around. It's how all bus_types work, you should just do the same.

We can not use static "struct device", see Greg's comments in:
[RFC][PATCH V3] axi: add AXI bus driver
(not to mention we would have unused "struct device" in ChipCommon's
and PCI's "struct bcma_device").

-- 
Rafał
