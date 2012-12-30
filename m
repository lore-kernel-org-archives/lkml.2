Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2L3Xo1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 18:44:27 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:49885 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab2L3XoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 18:44:25 -0500
Message-ID: <1356911071.26227.10.camel@gitbox>
Subject: Re: [PATCH] input: vt8500: Add power button keypad driver
From: Tony Prisk <linux@prisktech.co.nz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-input@vger.kernel.org
Date: Mon, 31 Dec 2012 12:44:31 +1300
In-Reply-To: <20121230232527.GA13899@core.coreip.homeip.net>
References: <1356904862-16417-1-git-send-email-linux@prisktech.co.nz>
	 <20121230232527.GA13899@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +Example:
> > +	powerkey: pwrkey@0 {
> > +		compatible = "wm,power-keypad";
> > +		interrupts = <22>;
> > +		keymap = <116>; /* KEY_POWER */
> 
> Do we really need this in DT? I'd say just having it manageable from
> userspace is enough.

Just seemed easier this way. Will be changed.

> > +config KEYBOARD_WMT_POWER_KEYPAD
> > +	tristate "Wondermedia Power keypad support"
> > +	depends on ARCH_VT8500
> 
> I'd feel safer if we added "depends on OF" as well.
ARCH_VT8500 always selects USE_OF, but I can add it as well if you think
its necessary.

> > +
> > +static void __iomem *pmc_base;
> > +static struct input_dev *kpad_power;
> > +static spinlock_t kpad_power_lock;
> > +static int power_button_pressed;
> > +static struct timer_list kpad_power_timer;
> > +static unsigned int kpad_power_code;
> 
> Maybe wrap it in a structure?
Will do.

> 
> > +
> > +static inline void kpad_power_timeout(unsigned long fcontext)
> 
> Why inline? It can't be inlined anyway since its address is used.
> 
Umm, no idea why this is inline. Will remove.

> > +{
> > +	u32 status;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&kpad_power_lock, flags);
> > +
> > +	status = readl(pmc_base + 0x14);
> > +
> > +	if (power_button_pressed) {
> 
> This check is useless, you won't ever get here if button hasn't been
> pressed.
> 
Hmm, correct. Will fix.

> > +	status = readl(pmc_base + 0x14);
> > +	udelay(100);
> > +	writel(status, pmc_base + 0x14);
> > +
> > +	if (status & BIT(14)) {
> > +		if (!power_button_pressed) {
> 
> No need to do this check.
> 
The hardware generates multiple interrupts when the button is held.
Without the !power_button_pressed, it will generate multiple pressed
events without releases, because the timer doesn't get to finish.

The interrupt is non-maskable.


> > +static int vt8500_pwr_kpad_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *np;
> > +	u32 status;
> > +	int err;
> > +	int irq;
> > +
> > +	np = of_find_compatible_node(NULL, NULL, "via,vt8500-pmc");
> > +	if (!np) {
> > +		dev_err(&pdev->dev, "pmc node not found\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	pmc_base = of_iomap(np, 0);
> > +	if (!pmc_base) {
> > +		dev_err(&pdev->dev, "unable to map pmc memory\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	np = pdev->dev.of_node;
> > +	if (!np) {
> > +		dev_err(&pdev->dev, "devicenode not found\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	err = of_property_read_u32(np, "keymap", &kpad_power_code);
> > +	if (err) {
> > +		dev_warn(&pdev->dev, "defaulting to KEY_POWER\n");
> > +		kpad_power_code = KEY_POWER;
> > +	}
> > +
> > +	/* set power button to soft-power */
> > +	status = readl(pmc_base + 0x54);
> > +	writel(status | 1, pmc_base + 0x54);
> > +
> > +	/* clear any pending interrupts */
> > +	status = readl(pmc_base + 0x14);
> > +	writel(status, pmc_base + 0x14);
> > +
> > +	kpad_power = input_allocate_device();
> > +	if (!kpad_power) {
> > +		dev_err(&pdev->dev, "failed to allocate input device\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	spin_lock_init(&kpad_power_lock);
> > +	setup_timer(&kpad_power_timer, kpad_power_timeout,
> > +				       (unsigned long)kpad_power);
> > +
> > +	irq = irq_of_parse_and_map(np, 0);
> > +	err = request_irq(irq, &kpad_power_isr, 0, "pwrbtn", NULL);
> > +	if (err < 0) {
> > +		dev_err(&pdev->dev, "failed to request irq\n");
> > +		return err;
> > +	}
> > +
> > +	kpad_power->evbit[0] = BIT_MASK(EV_KEY);
> > +	set_bit(kpad_power_code, kpad_power->keybit);
> > +
> > +	kpad_power->name = "wmt_power_keypad";
> > +	kpad_power->phys = "wmt_power_keypad";
> > +	kpad_power->keycode = &kpad_power_code;
> > +	kpad_power->keycodesize = sizeof(unsigned int);
> > +	kpad_power->keycodemax = 1;
> > +
> > +	err = input_register_device(kpad_power);
> > +	if (err < 0) {
> > +		dev_err(&pdev->dev, "failed to register input device\n");
> 
> You either need to use managed resources or clean up after yourself;
> leaking memory and other resources is not nice. Given that you are using
> timer, which needs to be canceled, and I am not sure if your device
> allows enabling/disabling generating interrupts while keeping the
> interrupt handler registered, manual cleanup looks like the only option
> for you.
> 
> BTW, where is your remove() method?
Eeek. Too much turkey :) I will tidy this up and resubmit.

Thanks for the quick review.

Regards
Tony P

