Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab0JIJcI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 05:32:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62682 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab0JIJcG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 05:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mPakttSnBFIxpQ1iY6f6oBPysYfw/TnSFdrtQT/3XaSbYrUe2wO3qFiThzkpnTbXNT
         6V3ZyOGXDaHNlqvM+34HixTs9qBu6ygsIaPO4TGFctzIqu51BLHR3LXEcXKeHbFE6F+h
         DFrbULh2aQLiYpfycNelG9YFp3yv0hyaDNLTU=
MIME-Version: 1.0
In-Reply-To: <20101009030455.GB5913@kroah.com>
References: <20101007192245.GC26435@n2100.arm.linux.org.uk>
	<AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	<20101008175308.GA10975@n2100.arm.linux.org.uk>
	<AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com>
	<20101008230451.GB10975@n2100.arm.linux.org.uk>
	<20101008232539.GA28697@kroah.com>
	<20101008234448.GD10975@n2100.arm.linux.org.uk>
	<20101009000046.GA30616@kroah.com>
	<20101009002546.GB14675@n2100.arm.linux.org.uk>
	<alpine.LFD.2.00.1010082210150.3107@xanadu.home>
	<20101009030455.GB5913@kroah.com>
Date: Sat, 9 Oct 2010 12:32:05 +0300
Message-ID: <AANLkTimwNivgL1cxrQnmoOQj_FmSVznHMuFwHO365wRU@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        "Uwe Kleine-K?nig" <u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 9, 2010 at 6:04 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, Oct 08, 2010 at 10:41:42PM -0400, Nicolas Pitre wrote:
>> diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
>> index 99627d3..4f071e4 100644
>> --- a/arch/arm/mm/ioremap.c
>> +++ b/arch/arm/mm/ioremap.c
>> @@ -201,6 +201,15 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
>>       if (pfn >= 0x100000 && (__pfn_to_phys(pfn) & ~SUPERSECTION_MASK))
>>               return NULL;
>>
>> +     /*
>> +      * Warn if RAM is mapped to discourage this usage. Let's forbid it
>> +      * outright on ARMv6+ where this became architecturally undefined
>> +      * in theory and causes memory corruption in practice.
>> +      */
>> +     if (WARN_ON(pfn_valid(pfn)))
>> +             if (__LINUX_ARM_ARCH__ >= 6)
>> +                     return NULL;
>> +
>>       type = get_mem_type(mtype);
>>       if (!type)
>>               return NULL;
>>
>
> That looks good to me, anyone else object to this?

I object; this is still breaking drivers.

The decision was to don't allow ioremap() on RAM for all ARM, I agree
with that decision, there's no point in an API to works differently on
different ARM chips. Moreover, this would be more in line with x86's
ioremap().

All that is needed IMO is a grace period... Before this is activated
for real, the warning should happen on all drivers.

-- 
Felipe Contreras
