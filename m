Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab0F1F1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 01:27:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61754 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0F1F1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 01:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fr+ep/xi38vOFgAHDJsF8wfo/2E8sRJPT7L+oj5AtU48tO91C3OV90t9s9Az+9Vr9p
         7zAno7Hc+cl+2YgwxfbDmnNKAvXVznFU+0mLXV8jBjChOXlTbAvihdn1xHOoyti4/OpH
         L8DsfCP9SPhyITJPRwtHbmRm8EifqYnJfSbSs=
MIME-Version: 1.0
In-Reply-To: <20100628051606.GA16445@pengutronix.de>
References: <20100618073950.GA12822@pengutronix.de> <1277129511-2732-1-git-send-email-u.kleine-koenig@pengutronix.de> 
	<20100621213846.GB25511@kroah.com> <20100622052314.GA17128@pengutronix.de> 
	<AANLkTinMLrXyqKZ76AiWiw6N_glrWWrP-2_aUTzQm5Xr@mail.gmail.com> 
	<20100628051606.GA16445@pengutronix.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 28 Jun 2010 13:27:25 +0800
Message-ID: <AANLkTikw_wceFTLFKDF5DH9p5Or6r_8G0gVAI91sN2zK@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] Driver core: reduce duplicated code
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Greg KH <greg@kroah.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Dmitry Torokhov <dtor@mail.ru>,
       Anisse Astier <anisse@astier.eu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Magnus Damm <damm@opensource.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Paul Mundt <lethal@linux-sh.org>, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/28 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Hi Eric,
>
> On Mon, Jun 28, 2010 at 12:55:45PM +0800, Eric Miao wrote:
>> I suggest you to have a look into arch/arm/mach-mmp/devices.c and
>> arch/arm/mach-mmp/pxa{168,910}.c as well as
>> arch/arm/mach-mmp/include/mach/pxa{168,910}.h, maybe we can find
>> some common practice.
> I think I like this approach in general, I already thought about not
> passing all parameters as function/macro arguments, too.  But maybe this
> becomes too excessive for imx as I would need too many of these device
> desc for the different imx variants?!
>
> Anyhow a few things I thought when looking in the files you suggested:
>
>  - Why not use an array for all uart devdescs, maybe the code for
>   pxa168_add_uart could become a bit smaller then?:
>
>        extern struct pxa_device_desc pxa168_device_uart[2];
>        ...
>        static inline int pxa168_add_uart(int id)
>        {
>                struct pxa_device_desc *d = pxa168_device_uart + id;
>
>                if (id < 0 || id > 2)
>                        return -EINVAL;
>
>                return pxa_register_device(d, NULL, 0);
>        }
>
>   (Ditto for the other types obviously.)

That's a good suggestion, yet it came that way for two reasons:

1. the initial naming mess, uart0 was later renamed to uart1, e.g.
2. and the restrictions of PXA{168,910}_DEVICE() macros, these
   macros are handy to simplify the definition, but may require fancy
   tricks to make it support array

>
>  - shouldn't all these pxa_device_descs and pxa168_add_$device functions
>   be __initdata and __init?
>

pxa{168,910}_add_device() are actually 'static inline' so my assumption
is they will be inlined when referenced, otherwise won't occupy any code
space. The *_descs, however, they are __initdata if you look into the
definitions of PXA{168,910}_DEVICES

>  - pxa_register_device is better than my add_resndata function in (at
>   least) one aspect as it sets coherent_dma_mask, too.  This is
>   something I missed when trying to add mxc-mmc (IIRC) devices.
>
> Thanks
> Uwe
>
> --
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
