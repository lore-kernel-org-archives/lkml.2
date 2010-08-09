Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab0HIFmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 01:42:16 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53276 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab0HIFmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 01:42:15 -0400
MIME-Version: 1.0
In-Reply-To: <20100809013245.1cefb9bf@dev.queued.net>
References: <20100808231116.21c7d6f3@dev.queued.net> <AANLkTimG7u5eXWSn5VznKfuFcFD+evTzo1_QpAFmCdpL@mail.gmail.com> 
	<20100809013245.1cefb9bf@dev.queued.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 8 Aug 2010 23:41:54 -0600
X-Google-Sender-Auth: nkz0KEpcu0zsGvSxvbf0BZEz8a8
Message-ID: <AANLkTimDGP+2K7gswDsfUW0FjomfOBRfTKEqDV9-=zm6@mail.gmail.com>
Subject: Re: [PATCH 2/3] sparc: make driver/of/pdt no longer sparc-specific
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 8, 2010 at 11:32 PM, Andres Salomon <dilinger@queued.net> wrote:
> On Sun, 8 Aug 2010 23:12:21 -0600
> Grant Likely <grant.likely@secretlab.ca> wrote:
>
>> Hi Andres, thanks for the patch.  Comments below.
>>
>> g.
>>
>> On Sun, Aug 8, 2010 at 9:11 PM, Andres Salomon <dilinger@queued.net>
>> wrote:
> [...]
>> > +
>> >  unsigned int prom_early_allocated __initdata;
>> >
>> > -#include "../../../drivers/of/pdt.c"
>> > +static struct of_pdt_ops prom_sparc_ops __initdata = {
>> > +       .firstprop = prom_common_firstprop,
>> > +       .nextprop = prom_common_nextprop,
>> > +       .getproplen = (int (*)(phandle, const char
>> > *))prom_getproplen,
>> > +       .getproperty = (int (*)(phandle, const char *, char *,
>> > int))prom_getproperty,
>> > +       .getchild = (phandle (*)(phandle))prom_getchild,
>> > +       .getsibling = (phandle (*)(phandle))prom_getsibling,
>>
>> If you have to explicitly cast these function pointers, then you're
>> doing it wrong.  :-)  Listen to and fix the compiler complaint here.
>>
>
> Hm, can you please expand on that?  The reason it's necessary to cast is
> because sparc's prom_* functions are using ints instead of phandles.  I
> don't understand why casting is the wrong thing here.

because casting will mean the compiler can no longer catch errors when
someone accidentally assigns an incompatible function.

>> I can tell from the context here you're working from an older tree.
>> Please rebase onto Linus' current top-of-tree.  :-)  A bunch of OF
>> related patches have been merged for 2.6.36 that will conflict with
>> this patch.
>>
>
> Sorry, will do.  Was just looking for more feedback (while testing)
> before sending final versions of this stuff.

:-)

>>
>> > +
>> > +#if defined(CONFIG_SPARC)
>> > +static unsigned int prom_unique_id __initdata;
>> > +
>> > +#define inc_unique_id(p) do { \
>> > +       (p)->unique_id = prom_unique_id++; \
>> > +} while (0)
>>
>> Use a static inline.  C code is preferred over preprocessor code.
>> Also preserver the namespace and use the of_pdt_ prefix (that goes for
>> all the new functions here in this file).
>
> This is processing multiple types, that's the reason for the macro.
>
> 'p' can be either a property struct, or device_node struct.

Ah, right.  I missed that.  A little ugly.  Personally I'd rather be
explicit and have a separate static inline for each usage.

> [...]
>> > -       of_console_init();
>> > +void __init of_pdt_set_ops(struct of_pdt_ops *ops)
>> > +{
>> > +       BUG_ON(!ops);
>> >
>> > -       printk("PROM: Built device tree with %u bytes of memory.\n",
>> > -              prom_early_allocated);
>> > +       prom_ops = *ops;
>>
>> As mentioned above, why is the structure copied instead of just
>> storing the pointer.
>>
>
> Er, right, because originally the struct was handled differently.  No
> reason for it to be copied anymore.
>
> Thanks for the feedback!

np

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
