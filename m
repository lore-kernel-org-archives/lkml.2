Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab2ISO3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:29:42 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60477 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2ISO3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:29:41 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.118.250]
In-Reply-To: <81C3A93C17462B4BBD7E272753C1057923BD6DED30@EXDCVYMBSTM005.EQ1STM.local>
References: <1347992952-4134-1-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=Wgbat_oMZdE4DQvfOOeQz78hRjWvRzem1a5OCZDV-h7KPnA@mail.gmail.com> <81C3A93C17462B4BBD7E272753C1057923BD6DED30@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 19 Sep 2012 17:29:19 +0300
Message-ID: <CAK=WgbYA4rGHt3YMf97aEom-u_jvT66iUggECo0UoUTfuN3Uyg@mail.gmail.com>
Subject: Re: [RFCv2] remoteproc: Add STE modem driver for remoteproc
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Wed, Sep 19, 2012 at 1:08 PM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
>> >  include/linux/modem_shm/ste_modem.h  |   71 ++++++
>>
>> Why did you decide to create a separate folder for this header ? if
>> it's STE specific, maybe use an 'ste' prefix for it too ?
>
> There has been some attempt to upstream a shm driver for another modem
> vendor as well, see https://lkml.org/lkml/2012/8/27/15.
>
> This driver used  .../driver/modem_shm, and
> .../include/linux/modem_shm/. I feel that this driver belongs in the same
> family. This other driver did not include any vendor prefix though.
>
> What about .../include/linux/modem_shm/ste/modem.h or maybe just
> .../include/linux/modem_shm/modem.h?

Do your driver and Arun's share any code ? More importantly - is there
any common functionality to consolidate ?

If it's just the name "modem_shm" that is common, I'm not sure there's
merit in having a common folder ?

But if you do, why not use ste_modem_shm ? It looks like Arun comes
from STE too :)

>> > +       /*
>> > +        * STE-modem requires the firmware to be located
>> > +        * at the start of the shared memory region. So we need to
>> > +        * reserve space for firmware at the start.
>> > +        * This cannot be done in the function sproc_load_segments because
>> > +        * then dma_alloc_coherent is already called by Core and the
>> > +        * start of the share memory area would already have been occupied.
>> > +        */
>> > +       if (!sproc->fw_addr) {
>> > +               sproc->fw_addr = dma_alloc_coherent(rproc->dev.parent, fw-
>> >size,
>>
>> This doesn't look good: this function should just find an offset
>> within the firmware and return it, and not do any memory allocations.
>>
>> I understand the reason why you do that, ...
>
> I am afraid I *must* put the TOC at the start of memory. There is no way
> around this.

Sure that's fine. Let's just do it the right way :)

> But I can pre-allocate space for firmware and just bail out if
> it is not enough room. This is a much simpler approach.
>
>> but I think we had a nice
>> generic solution which shouldn't be too hard to implement (i.e. let
>> remoteproc maintain dedicated, purpose-specific, memory pools).
>> Moreover, if we implement it into the core, others could use it too.
>> Any chance you can look into it ? Ludovic started spinning some code
>> internally but was probably sucked away for other tasks meanwhile.
>
> I propose we pre-allocate some memory for now

Care to elaborate what do you mean exactly ? or just send a patch :)

>> > +static int __init sproc_init(void)
>> > +{
>> > +       return platform_driver_register(&sproc_driver.drv);
>> > +}
>> > +module_init(sproc_init);
>> > +
>> > +static void __exit sproc_exit(void)
>> > +{
>> > +       platform_driver_unregister(&sproc_driver.drv);
>> > +}
>> > +module_exit(sproc_exit);
>>
>> Replace boilerplate code with module_platform_driver ?
>
> I tried, but the macros cannot handle the sproc_driver.drv as argument.

I see, but I wonder why did you have to create the ste_modem_driver
struct in the first place ? How does the modem code access
sproc_kick_callback ?

Can you instead just ditch ste_modem_driver and provide
sproc_kick_callback in kick_subscribe or something ?

I'm asking not because using module_platform_driver is so important,
but because this may suggest something more importantly may need to be
fixed here.

Thanks,
Ohad.
