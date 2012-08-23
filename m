Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab2HWQwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:52:33 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41725 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab2HWQw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:52:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120819205018.GA1031@lizard>
References: <1343583999-30231-1-git-send-email-develkernel412222@gmail.com>
	<1344573355.2441.0.camel@test-laptop>
	<20120819205018.GA1031@lizard>
Date: Thu, 23 Aug 2012 22:22:26 +0530
Message-ID: <CA+C2MxTwu74macE5+AH8ZOyPW+Ko-9PoUr7PiCoPNX=+=dBMFg@mail.gmail.com>
Subject: Re: [PATCH 1/2] lp8727_charger: free_irq when lp8727_register_psy fail
From: Devendra Naga <develkernel412222@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Milo.Kim@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Mon, Aug 20, 2012 at 2:20 AM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> On Fri, Aug 10, 2012 at 10:05:55AM +0530, Devendra wrote:
>> Sorry Guys on disturbing you,
>>
>> Will you guys please ACK, NACK or comment on this?
>
> Technically, it looks OK. But the irq registration logic is sill broken,
> and the hidden issue is much more serious.
>
> 1. lp8727_init_device() -> the function enables interrupts in hw;
> 2. lp8727_intr_config() -> the function requests interrupts, so CPU
>    is now able to process them;
> 3. lp8727_register_psy() -> the function allocates power supply
>    objects.
>
> Now, the problem will arise if interrupt comes between "2." and
> "3.", the interrupt service routine will cause NULL dereference.
>
> So, what you really want to fix the driver is to reorder "2." and "3.",
> and on error condition call lp8727_unregister_psy().
>
I think i need to learn more in order to touch this path. will give a try.

Thanks,
> Thanks,
>
>> On Sun, 2012-07-29 at 23:31 +0545, Devendra Naga wrote:
>> > actually the driver does a request_threaded_irq and after this it calls
>> > lp8727_register_psy, and if it fails it doesn't free the irqs that it
>> > registered to
>> >
>> > Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
>> > ---
>> >  drivers/power/lp8727_charger.c |    4 +++-
>> >  1 file changed, 3 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
>> > index d8b7578..699f0ef 100644
>> > --- a/drivers/power/lp8727_charger.c
>> > +++ b/drivers/power/lp8727_charger.c
>> > @@ -454,11 +454,13 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
>> >     ret = lp8727_register_psy(pchg);
>> >     if (ret) {
>> >             dev_err(pchg->dev, "power supplies register err: %d", ret);
>> > -           goto error;
>> > +           goto error_irq;
>> >     }
>> >
>> >     return 0;
>> >
>> > +error_irq:
>> > +   free_irq(pchg->client->irq, pchg);
>> >  error:
>> >     kfree(pchg);
>> >     return ret;
