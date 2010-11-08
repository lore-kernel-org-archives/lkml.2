Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0KHM4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 07:56:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56458 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0KHM4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 07:56:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fE8vKjFJKBmUmf32gKUm3TNfdphUUGfiEfe1goYrpbdMmCmmXGBmUmnS0WoRkOK/PF
         bKZuIKv++b+D0CPE34VjC9u/qyGo93MANBVwJP26bDxdcokag8DmYEvkCbHMm3GC4xp/
         dThiZWB6OsJMRQ8a4UHGcdglAHDmuu2R68OJE=
MIME-Version: 1.0
In-Reply-To: <20101108041721.GA11605@linux-sh.org>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>
	<1289147348-31969-6-git-send-email-alchark@gmail.com>
	<20101108041721.GA11605@linux-sh.org>
Date: Mon, 8 Nov 2010 12:56:42 +0000
Message-ID: <AANLkTimkrK9T7G3=K_Ob1SuK64DrGJD3WNoangPp_ryW@mail.gmail.com>
Subject: Re: [PATCH 6/6 v2] ARM: Add support for the display controllers in
 VT8500 and WM8505
From: Alexey Charkov <alchark@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/8 Paul Mundt <lethal@linux-sh.org>:
> On Sun, Nov 07, 2010 at 07:28:57PM +0300, Alexey Charkov wrote:
>> +static int __devinit vt8500lcd_probe(struct platform_device *pdev)
>> +{
>
> ...
>
>> +     addr = fbi;
>> +     addr = addr + sizeof(struct vt8500lcd_info);
>> +     fbi->fb.pseudo_palette  = addr;
>> +
> ...
>
>> +     fbi->palette_size       = PAGE_ALIGN(512);
>> +     fbi->palette_cpu        = dma_alloc_coherent(&pdev->dev,
>> +                                                  fbi->palette_size,
>> +                                                  &fbi->palette_phys,
>> +                                                  GFP_KERNEL);
>> +     if (fbi->fb.pseudo_palette == NULL) {
>> +             dev_err(&pdev->dev, "Failed to allocate palette buffer\n");
>> +             ret = -ENOMEM;
>> +             goto failed_free_io;
>> +     }
>> +
> This looks like a bogus test, you've already allocated enough space for
> the pseudo_palette and will have bailed out on the kmalloc() failing well
> before this. You also don't have any error handling for fbi->palette_cpu,
> which is presumably what you intended to do here.
>

True, this has to be corrected (old copy-paste error left unnoticed
somehow). It's also deallocated wrongly in the error path, which I
have just noticed.

>> +static int __devexit vt8500lcd_remove(struct platform_device *pdev)
>> +{
>> +     struct vt8500lcd_info *fbi = platform_get_drvdata(pdev);
>> +     struct resource *res;
>> +     int irq;
>> +
>> +     if (!fbi)
>> +             return 0;
>> +
>> +     unregister_framebuffer(&fbi->fb);
>> +
>> +     writel(0, fbi->regbase);
>> +
>> +     if (fbi->fb.cmap.len)
>> +             fb_dealloc_cmap(&fbi->fb.cmap);
>> +
>> +     irq = platform_get_irq(pdev, 0);
>> +     free_irq(irq, fbi);
>> +
>> +     iounmap(fbi->regbase);
>> +
>
> You're also missing a dma_free_coherent() here.
>

True, will be fixed.

>> +static int __devinit wm8505fb_probe(struct platform_device *pdev)
>> +{
>> +     fbi->fb.screen_base     = pdata->video_mem_virt;
>> +     fbi->fb.screen_size     = pdata->video_mem_len;
>> +
> ...
>
>> +failed_free_mem:
>> +     free_pages_exact(fbi->fb.screen_base, fbi->fb.screen_size);
>
> ...
>
> What in the name of all that is holy are you doing here? If you need to
> have your platform deal with virtual address allocation and freeing then
> you should pass in callbacks for that and hide the instrumentation
> details there. Presently this is tying you down to an alloc_pages_exact()
> interface buried in the board setup, which isn't going to mesh well with
> other platforms that may wish to go about this an alternate way (like
> memblock reservations).
>

Actually, this is a leftover from a previous implementation with
alloc_pages_exact(), which could not work for larger screen sizes (due
to the framebuffer growing over 4MB). Now memory is reserved via
memblock, so this should have probably been just dropped.

>> diff --git a/drivers/video/wmt_ge_rops.c b/drivers/video/wmt_ge_rops.c
>> new file mode 100644
>> index 0000000..c71f97e
>> --- /dev/null
>> +++ b/drivers/video/wmt_ge_rops.c
>> +void __iomem *regbase;
>> +
> Uhm, no. If this is only used in this driver then just make it static.
> Given that you are using the driver model here though and could
> theoretically support multiple rop engines, you're much better off making
> this private data and burying it under the appropriate per-device data
> structures.
>

Is that platform_{set,get}_drvdata() what you are talking about? Using
multiple engines seems extremely unlikely, though :)

>> +int wmt_ge_sync(struct fb_info *p)
>> +{
>> +     while (readl(regbase + GE_STATUS_OFF) & 4)
>> +             /* busy wait */;
>> +
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL(wmt_ge_sync);
>> +
> While I admire your optimism in your hardware, experience suggests you
> really want a timeout here. You may also wish to insert a cpu_relax()
> here.
>

I wonder if this callback is allowed to sleep? In principle, the
hardware seems to support interrupt generation on operation
completion, so maybe wait_event_interruptible_timeout() could be used
here to remove the busy wait altogether?

Thank you for the comments, Paul!

Best regards,
Alexey
