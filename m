Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284Ab0LTWV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 17:21:29 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:32435 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933270Ab0LTWV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 17:21:27 -0500
Message-ID: <4D0FD747.9020700@bluewatersys.com>
Date: Tue, 21 Dec 2010 11:23:03 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Alexey Charkov <alchark@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v9] ARM: Add basic architecture support for VIA/WonderMedia
 85xx SoC's
References: <1289147348-31969-1-git-send-email-alchark@gmail.com>	<20101107165745.GB1759@n2100.arm.linux.org.uk>	<AANLkTimFJ=Brx4pDiUqZOKDfABaDg0s_yFC7EkZGi7D8@mail.gmail.com>	<20101107171726.GF1759@n2100.arm.linux.org.uk>	<20101108171930.GA1471@alchark-u3s.lan>	<20101111212322.GA15533@alchark-u3s.lan>	<20101111234957.GA28735@n2100.arm.linux.org.uk>	<20101219174017.GA31832@alchark-u3s>	<20101220191549.GH28157@n2100.arm.linux.org.uk>	<20101220195423.GA14509@alchark-u3s>	<4D0FC1AE.2050708@bluewatersys.com> <AANLkTin4XqbGwznp56Xjt_zest6rxNmir0QDJWTySY4+@mail.gmail.com>
In-Reply-To: <AANLkTin4XqbGwznp56Xjt_zest6rxNmir0QDJWTySY4+@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 10:48 AM, Alexey Charkov wrote:
> 2010/12/20 Ryan Mallon <ryan@bluewatersys.com>:
>> On 12/21/2010 08:54 AM, Alexey Charkov wrote:
>>> This adds support for the family of Systems-on-Chip produced initially
>>> by VIA and now its subsidiary WonderMedia that have recently become
>>> widespread in lower-end Chinese ARM-based tablets and netbooks.
>>>
>>> Support is included for both VT8500 and WM8505, selectable by a
>>> configuration switch at kernel build time.
>>>
>>> Included are basic machine initialization files, register and
>>> interrupt definitions, support for the on-chip interrupt controller,
>>> high-precision OS timer, GPIO lines, necessary macros for early debug,
>>> pulse-width-modulated outputs control, as well as platform device
>>> configurations for the specific drivers implemented elsewhere.
>>>
>>> Signed-off-by: Alexey Charkov <alchark@gmail.com>
>>
>> Hi Alexey,
>>
>> Quick review below.

> <snip>
>>> +void __init wmt_set_resources(void)
>>> +{
>>> +     resources_lcdc[0].start = wmt_current_regs->lcdc;
>>> +     resources_lcdc[0].end = wmt_current_regs->lcdc + SZ_1K - 1;
>>> +     resources_lcdc[1].start = wmt_current_irqs->lcdc;
>>> +     resources_lcdc[1].end = wmt_current_irqs->lcdc;
>>
>> Ah, this makes more sense. But why have all the indirection? The
>> wmt_regmaps table could just be replaced with #defines and then have
>> separate device files for the VT8500 and the WM8505. This would also
>> make clearer which variants have which peripherals.
>>
> 
> This was the way I implemented it originally. However, Arnd made quite
> a valid suggestion to allow runtime selection of the chip variant,
> thus registers and interrupts need to be held in an indexed data type
> instead of just compile-time macros. In addition, there is now some
> overall movement towards unification of binary kernel images for
> different ARM variants (as far as I can see), so this would be
> required in any case.
> 
> Furthermore, as with many unbranded Chinese products, it's somewhat
> difficult to reliably determine the exact chip version used in your
> netbook without disassembling it. Reading a hardware register for
> identification is easier :)

Okay, that makes sense. I still think there must be a better way than
having a massive indirect table with all the values. Why not detect the
variant in the core code and then have something like:

int init_devices(void)
{
	int board_type = detect_board_type();

	switch (board_type) {
	case BOARD_TYPE_VT8500:
		return vt8500_init_devices();

	case BOARD_TYPE_WM8505:
		return wm8500_init_devices();
	}

	pr_err("Unknown board type\n");
	BUG(); /* panic()? */
	while (1)
		;
}

Then you can have the peripheral setup for each of the variants in their
own files and use #defines. It may get tricky in a couple of places if
you need to be able to access some value directly which is different on
each of the variants, but that can be handled on a case by case basis.
The majority of the numbers will be passed into drivers via the resource
structs.

>>> +
>>> +void __init vt8500_map_io(void)
>>> +{
>>> +     wmt_current_regs = &wmt_regmaps[VT8500_INDEX];
>>> +     wmt_current_irqs = &wmt_irqs[VT8500_INDEX];
>>> +
>>> +     vt8500_io_desc[0].virtual = wmt_current_regs->mmio_regs_virt;
>>> +     vt8500_io_desc[0].pfn =
>>> +                     __phys_to_pfn(wmt_current_regs->mmio_regs_start);
>>> +     vt8500_io_desc[0].length = wmt_current_regs->mmio_regs_length;
>>> +
>>> +     iotable_init(vt8500_io_desc, ARRAY_SIZE(vt8500_io_desc));
>>> +}
>>> +
>>> +void __init wm8505_map_io(void)
>>> +{
>>> +     wmt_current_regs = &wmt_regmaps[WM8505_INDEX];
>>> +     wmt_current_irqs = &wmt_irqs[WM8505_INDEX];
>>> +
>>> +     vt8500_io_desc[0].virtual = wmt_current_regs->mmio_regs_virt;
>>> +     vt8500_io_desc[0].pfn =
>>> +                     __phys_to_pfn(wmt_current_regs->mmio_regs_start);
>>> +     vt8500_io_desc[0].length = wmt_current_regs->mmio_regs_length;
>>> +
>>> +     iotable_init(vt8500_io_desc, ARRAY_SIZE(vt8500_io_desc));
>>> +}
>>
>> Separate files. If more variants get added, this file will become
>> unwieldy very quickly.
>>
> 
> Is it really worthwhile to create separate files for single 12-line
> functions? After all, WonderMedia does not release new chips every now
> and then :)

I meant if you have the full peripheral initialisation for each variant
in its own file.

>>> +
>>> +void __init vt8500_reserve_mem(void)
>>> +{
>>> +#ifdef CONFIG_FB_VT8500
>>> +     panels[current_panel_idx].bpp = 16; /* Always use RGB565 */
>>> +     preallocate_fb(&panels[current_panel_idx], SZ_4M);
>>> +     vt8500_device_lcdc.dev.platform_data = &panels[current_panel_idx];
>>> +#endif
>>> +}
>>
>> Not sure if this should exist in the platform code or the framebuffer
>> driver. In the latter case it would automatically be CONFIG_FB_VT8500
>> and the platform_data can still be set in the platform code. Is there a
>> reason for this not to be in the framebuffer driver?
>>
> 
> I can't reserve memory via memblock from the driver, and usual runtime
> allocation functions can't handle it (need alignment to 4 megabytes in
> 8500, framebuffer sizes exceed 4 megabytes in 8505).

Can you use one of the initcalls from a driver to to the memblock
reserve? I don't know much about how memblock works. There are also the
various large page allocators in the works, but I don't think anything
has hit mainline yet.

>>> +#ifndef __ASM_ARCH_MEMORY_H
>>> +#define __ASM_ARCH_MEMORY_H
>>> +
>>> +/*
>>> + * Physical DRAM offset.
>>> + */
>>> +#define PHYS_OFFSET  UL(0x00000000)
>>
>> If you renamed this to PHYS_DRAM_OFFSET you wouldn't need the comment :-).
>>
> 
> I'm not the one who chooses :)

Oops, missed that :-).

>>> +void __init vt8500_init_irq(void)
>>> +{
>>> +     unsigned int i;
>>> +
>>> +     ic_regbase = ioremap(wmt_current_regs->ic0, SZ_64K);
>>> +
>>> +     if (ic_regbase) {
>>> +             /* Enable rotating priority for IRQ */
>>> +             writel((1 << 6), ic_regbase + 0x20);
>>> +             writel(0, ic_regbase + 0x24);
>>> +
>>> +             for (i = 0; i < wmt_current_irqs->nr_irqs; i++) {
>>> +                     /* Disable all interrupts and route them to IRQ */
>>> +                     writeb(0x00, ic_regbase + VT8500_IC_DCTR + i);
>>> +
>>> +                     set_irq_chip(i, &vt8500_irq_chip);
>>> +                     set_irq_handler(i, handle_level_irq);
>>> +                     set_irq_flags(i, IRQF_VALID);
>>> +             }
>>> +     } else {
>>> +             printk(KERN_ERR "Unable to remap the Interrupt Controller "
>>> +                             "registers, not enabling IRQs!\n");
>>
>> printk strings should be on a single line (can be > 80 columns) to make
>> grepping easier. You could also use the pr_ macros with pr_fmt set.
>>
> 
> Well, checkpatch.pl complained about that in the first place, so I
> split the line. Should I merge them back in all instances?

Yes. I think checkpatch has been changed to warn about spitting printk
strings across lines now.

> <snip>
> 
>>> diff --git a/arch/arm/mach-vt8500/pwm.c b/arch/arm/mach-vt8500/pwm.c
>>> new file mode 100644
>>> index 0000000..d1356a1
>>> --- /dev/null
>>> +++ b/arch/arm/mach-vt8500/pwm.c
>>
>> I'm not sure what the state of the various efforts to provide a common
>> pwm framework are, but you may want to check.
>>
> 
> I did before starting to write this code, found nothing.

Fair enough.

>>> +
>>> +static inline void pwm_busy_wait(void __iomem *reg, u8 bitmask)
>>> +{
>>> +     int loops = 1000;
>>> +     while ((readb(reg) & bitmask) && --loops)
>>> +             cpu_relax();
>>
>> Ugh. If you are going to busy wait, can't you delay for a known amount
>> of time? Even better, can this be replaced with wait_event or some
>> equivalent?
>>
> 
> The delay should be on the order of several bus cycles, where udelay
> actually busy-waits, too. wait_event would be longer than that to set
> up, and there is no associated interrupt.

I meant if the hardware has some specific maximum wait time then you
could just delay that long. If there is no interrupt then wait_event and
friends probably aren't going to work.

Maybe convert this to a timed loop (i.e. 1 second timeout) using
jiffies. That way you are never dependent on cpu speed. You should
probably also emit a warning if the timeout is reached and the device
still claims to be busy.

>>> +}
>>> +
>>> +int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
>>> +{
>>> +     unsigned long long c;
>>> +     unsigned long period_cycles, prescale, pv, dc;
>>> +
>>> +     if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
>>> +             return -EINVAL;
>>> +
>>> +     c = 25000000/2; /* wild guess --- need to implement clocks */
>>> +     c = c * period_ns;
>>> +     do_div(c, 1000000000);
>>> +     period_cycles = c;
>>
>> This looks like it could be reworked to remove the do_div call.
>>
> 
> I just followed PXA implementation in this regard. Are there any
> specific suggestions? Note that c should not be a complie-time
> constant eventually, as this is the guessed PWM base frequency (should
> be read from the hardware, but the code for clocks is not yet in).

I didn't have a particular solution in mind, but often by changing the
units used and rearranging the math a bit you can often avoid having to
do horrible multiplies and divides.

For now at least you could avoid the do_div by assigning period_cycles
directly.

>>> +struct pwm_device *pwm_request(int pwm_id, const char *label)
>>> +{
>>> +     struct pwm_device *pwm;
>>> +     int found = 0;
>>> +
>>> +     mutex_lock(&pwm_lock);
>>> +
>>> +     list_for_each_entry(pwm, &pwm_list, node) {
>>> +             if (pwm->pwm_id == pwm_id) {
>>> +                     found = 1;
>>> +                     break;
>>> +             }
>>> +     }
>>> +
>>> +     if (found) {
>>> +             if (pwm->use_count == 0) {
>>> +                     pwm->use_count++;
>>> +                     pwm->label = label;
>>> +             } else
>>> +                     pwm = ERR_PTR(-EBUSY);
>>> +     } else
>>> +             pwm = ERR_PTR(-ENOENT);
>>> +
>>> +     mutex_unlock(&pwm_lock);
>>> +     return pwm;
>>> +}
>>
>> Maybe a bit clearer and more concise like this? Also replaces -ENOENT
>> (No such file or directory) with -ENODEV (No such device):
>>
>>        pwm = ERR_PTR(-ENODEV);
>>        mutex_lock(&pwm_lock);
>>
>>        list_for_each_entry(pwm, &pwm_list, node) {
>>                if (pwm->pwm_id == pwm_id) {
>>                        if (pwm->use_count != 0) {
>>                                pwm = ERR_PTR(-EBUSY);
>>                                break;
>>                        }
>>
>>                        pwm->use_count++;
>>                        pwm->label = label;
>>                        break;
>>                }
>>        }
>>
>>        mutex_unlock(&pwm_lock);
>>        return pwm;
>>
> 
> Isn't pwm overwritten inside the loop? -ENODEV will then be lost with
> this layout.

Oops, yes. You would need a second temporary pwm for the list iterator.
It's not a big deal anyway, just though it could be made more concise by
having all the code inside the loop.

>>> +static int __devinit pwm_probe(struct platform_device *pdev)
>>> +{
>>> +     struct pwm_device *pwms;
>>> +     struct resource *r;
>>> +     int ret = 0;
>>> +     int i;
>>> +
>>> +     pwms = kzalloc(sizeof(struct pwm_device) * VT8500_NR_PWMS, GFP_KERNEL);
>>> +     if (pwms == NULL) {
>>> +             dev_err(&pdev->dev, "failed to allocate memory\n");
>>> +             return -ENOMEM;
>>> +     }
>>
>> Devices should ideally be a single entity, so one platform device per pwm.
>>
> 
> We have 4 pwm outputs that share status registers, so they are not
> really separable.

Okay.

<snip>

>>> +static void vt8500_power_off(void)
>>> +{
>>> +     local_irq_disable();
>>
>> Is this necessary?
>>
> 
> Vendor's code disables interrupts. I believe my device refused to
> actually switch off without this.

Okay, fair enough.

> Thanks for the comments, Ryan!

No problem.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
