Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965721Ab2EOQOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:14:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44323 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965660Ab2EOQOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:14:33 -0400
MIME-Version: 1.0
In-Reply-To: <201205121318.54115.arnd@arndb.de>
References: <20120511094103.16423.51840.sendpatchset@w520>
	<CACRpkdaVsBswz8uO_nTjbfbzt+T+YcxunpvoDvOn4+=DTwjG3A@mail.gmail.com>
	<CANqRtoRx0VDmrPz=foD03z+ZYdb605Km8SEDKQQwCzbrZ54m3Q@mail.gmail.com>
	<201205121318.54115.arnd@arndb.de>
Date: Wed, 16 May 2012 01:14:32 +0900
Message-ID: <CANqRtoQa8Ewd74d+t0iXPXkmUDan6OjcD5VPwCFpQKcg8KvXbg@mail.gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, linus.walleij@stericsson.com, linux-sh@vger.kernel.org,
        horms@verge.net.au, grant.likely@secretlab.ca, lethal@linux-sh.org,
        olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 10:18 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 11 May 2012, Magnus Damm wrote:
>> On Fri, May 11, 2012 at 10:10 PM, Linus Walleij
>> <linus.walleij@linaro.org> wrote:
>> > On Fri, May 11, 2012 at 11:41 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>> >
>> >> +config GPIO_EM
>> >> +       tristate "Emma Mobile GPIO"
>> >> +       depends on ARM
>> >
>> > ARM really? Why should all ARM systems have the option of configuring in an Emma
>> > controller?
>>
>> Well, first of all, the Emma Mobile line of SoCs are ARM based. You
>> may think of MIPS based Emma devices. I don' t know so much about
>> them, but if you happen to know where I can find docs then I'd be very
>> interested in looking at them to see if I can share any of my recently
>> developed drivers.
>>
>> Not sure if your point is that this has nothing to do with the CPU
>> core itself - at least I usually prefer to omit CPU dependencies for
>> I/O devices and have as few dependencies as possible to get as much as
>> compile time testing done. In this particular case I've added ARM as
>> dependency because I was asked so for the UART driver 8250_em. Either
>> way is fine with me, so it's up to you GPIO maintainers to decide what
>> you want. As long as I can enable it on the ARM based SoC family I'm
>> happy. =)
>
> My preference is generally to define the dependencies rather broadly
> so you can build each driver on as many platforms as possible, and
> just leave them out of defconfig. This seems to be the common way to
> do things. Limiting by architecture makes some sense if you don't
> want to expose the driver to all architectures that might not be
> able to build it (e.g. s390 would not be able to build this one).

I believe that is rather close to what i prefer too. I kept the ARM dependency.

>> >> +static inline unsigned long em_gio_read(struct em_gio_priv *p, int offs)
>> >> +{
>> >> +       if (offs < GIO_IDT0)
>> >> +               return ioread32(p->base0 + offs);
>> >> +       else
>> >> +               return ioread32(p->base1 + (offs - GIO_IDT0));
>> >> +}
>> >> +
>> >> +static inline void em_gio_write(struct em_gio_priv *p, int offs,
>> >> +                               unsigned long value)
>> >> +{
>> >> +       if (offs < GIO_IDT0)
>> >> +               iowrite32(value, p->base0 + offs);
>> >> +       else
>> >> +               iowrite32(value, p->base1 + (offs - GIO_IDT0));
>> >> +}
>> >
>> > Isn't ioread()/iowrite() some ISA I/O-space operations? What's wrong with
>> > readl_[relaxed] and writel_[relaxed]()?
>>
>> Nothing wrong with readl/writel, I've just have a habit of using the
>> ioread/iowrite ones. I find the code that allows platforms to select
>> PORT or IOMEM in lib/iomap.c rather neat.
>
> For reference: The ioread family is defined to be a superset of the
> readl family and the inl family and to be compatible with the calling
> convention of readl, so it's correct to use it here, but it may be
> slower on architectures that require the lib/iomap.c wrappers. ARM
> does not use those wrappers on modern systems because the PIO space
> is memory mapped.
>
> For performance sensitive drivers that do not use DMA, it makes
> sense to use the readl_relaxed() family instead, because those
> omit the expensive barriers that protect us from overlapping with
> DMA.
>
> The main advantage of using readl/writel is that it's more common
> on ARM so reviewers don't have to wonder why this driver does things
> differently. Any driver shared with powerpc, mips or sh would likely
> use a different style. E.g. on powerpc, using readl/writel is considered
> wrong because it's only well-defined for PCI there.

Thanks for zooming out a bit and sharing your knowledge. As you know,
the code is not shared with any other architecture at this point, but
I decided to keep on using ioread/iowrite in V2 after all. I may
optimize the GPIO bits later if I need to hook up some big banging SPI
or I2C, but for now I think this is fine.

>> >> +static struct em_gio_priv *irq_to_priv(unsigned int irq)
>> >> +{
>> >> +       struct irq_chip *chip = irq_get_chip(irq);
>> >> +       return container_of(chip, struct em_gio_priv, irq_chip);
>> >> +}
>> >
>> > Should this be inline maybe?
>>
>> I have not checked if they actually turn out inline with my ARM
>> compiler, but gcc for SH was always rather good at deciding when to
>> inline by itself. Its a bit like likely()/unlikely() in my mind, it
>> may be good to give hints for the compiler but in the majority of the
>> cases the compiler will be fine by itself. I guess this particular
>> function may end up as just a few instructions.
>
> Right.
>
>> >> +static irqreturn_t em_gio_irq_handler(int irq, void *dev_id)
>> >> +{
>> >> +       struct em_gio_priv *p = dev_id;
>> >> +       unsigned long tmp, status;
>> >> +       unsigned int offset;
>> >> +
>> >> +       status = tmp = em_gio_read(p, GIO_MST);
>> >> +       if (!status)
>> >> +               return IRQ_NONE;
>> >> +
>> >> +       while (status) {
>> >> +               offset = __ffs(status);
>> >> +               generic_handle_irq(p->irq_base + offset);
>> >
>> > Pleas use irqdomain to translate the IRQ numbers.
>>
>> Is this mandatory for regular platform devices not using DT?
>>
>> I don't object to your idea, but I was planning on adding that in my
>> DT feature patch.
>
> There is little value in delaying this if you already know how
> to do it. irq domains are useful for other reasons as well, e.g.
> for allowing to build with sparse IRQ, which is needed when we get
> to multiplatform kernels.

Hm, I thought I had sparse irq enabled already even though I'm not
using irq domains. I suppose the static range used with the legacy irq
domain is somewhat limited compared to the linear one if it gets
allocated dynamically, so I agree that static ranges (with or without
irq domains) certainly limit the usefulness of spare irqs.

I agree that there is little value delaying it, so i cooked up some
basic legacy irq domain support in V2.

>> >> +static struct em_gio_priv *gpio_to_priv(struct gpio_chip *chip)
>> >> +{
>> >> +       return container_of(chip, struct em_gio_priv, gpio_chip);
>> >> +}
>> >
>> > inline?
>>
>> Sure, if you think that is absolutely necessary. May I ask, is it
>> important for you, or is it ok if I skip and keep this driver in line
>> with my other ones? =)
>
> I don't think it makes any difference in practice, other for people
> reading the code. Adding the 'inline' tells the reader that this is
> meant to be a trivial function that doesn't add much object code,
> and that the author was aware of that. I don't think it matters much
> either way.

I agree. In V2 for readability I decided to add inline to the
functions getting private data using container_of().

>> > Isn't there a new nice inline that will both request and
>> > remap a piece of memory?
>>
>> If so then that would be excellent. Especially together with
>> ioread/iowrite so the code can work both for IOMEM and PORT
>> transparently.
>
> We have a bunch of helpers, but I think none that does
> everything yet. io_iomap() locates and remaps the resource.
> devm_request_and_ioremap() does the request and the map, but
> doesn't pull it out of the device.

Let me know if you see any reason for not doing that. I'd be happy to
try to cook something up and convert my drivers one by one.

Thank you!

/ magnus
