Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab2LaVLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 16:11:39 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:51065 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab2LaVLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 16:11:37 -0500
Message-ID: <1356988294.15709.11.camel@gitbox>
Subject: Re: [PATCH v2] input: vt8500: Add power button keypad driver
From: Tony Prisk <linux@prisktech.co.nz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-input@vger.kernel.org
Date: Tue, 01 Jan 2013 10:11:34 +1300
In-Reply-To: <20121231203713.GC20317@core.coreip.homeip.net>
References: <1356919499-9654-1-git-send-email-linux@prisktech.co.nz>
	 <20121231203713.GC20317@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-31 at 12:37 -0800, Dmitry Torokhov wrote:
> Hi Tony,
> 
> On Mon, Dec 31, 2012 at 03:04:59PM +1300, Tony Prisk wrote:
> > This patch adds support for the Power Button keypad found on
> > Wondermedia netbooks/tablets.
> > 
> > Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> > ---
> > v2:
> > Remove devicetree binding for keycode
> > Add dependency on OF in Kconfig
> > Move static variables in a struct
> > Remove redundant inline modifier from kpad_power_timeout()
> > Remove unneccessary checks against power_button_pressed. Drop variable.
> > Cleanup the fail path code and add a .remove function.
> > Change the button behaviour so that a key-released event is only generated once
> > the key is released, not after timeout.
> > *Changes tested on WM8650 tablet.
> 
> 
> Thank you for making the requested changes, unfortunately there is some
> more...
It's never unfortunate to get it right :)
> 
> > 
> > +	status = readl(data->pmc_base + 0x14);
> > +	if (status & BIT(14)) {
> > +		/* Button isn't release so check again in 50ms */
> > +		mod_timer(&data->timer, jiffies + msecs_to_jiffies(50));
> 
> I do not think you need to do this: your ISR does "mod_timer" which
> means that the timer expiration gets extended every time there is
> interrupt, so as long as the button is pressed the timer will not run.
> So I'd just report the button as released here and be done with it.
Will fix.

> > +
> > +	np = of_find_compatible_node(NULL, NULL, "via,vt8500-pmc");
> > +	if (!np) {
> > +		dev_err(&pdev->dev, "pmc node not found\n");
> > +		return -EINVAL;
> > +	}
> 
> Hmm, why are we looking up another device? What is it is not there yet?
> Can we have all resources contained in this device DT description?

This driver uses registers in the power management controller. It didn't
seem right to declare the memory space for this device as well as the PM
controller, but I don't think there is any reason why it couldn't - just
seemed a bit backward to me.

> > +	data->pmc_base = of_iomap(np, 0);
> > +	if (!data->pmc_base) {
> > +		dev_err(&pdev->dev, "unable to map pmc memory\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	np = pdev->dev.of_node;
> > +	if (!np) {
> > +		dev_err(&pdev->dev, "devicenode not found\n");
> 
> Your error handling is still incomplete, you need to unmap the memory
> you just mapped above.
Will do.
> 
> I happened to peek at other vt8500 drivers and the lack of proper error
> handling and absence of remove() methods is a common theme among them.
Will put this on my list of things to look into. Thanks for pointing it
out.
> 
> > +
> > +	data->kpad_power->evbit[0] = BIT_MASK(EV_KEY);
> > +	set_bit(data->keycode, data->kpad_power->keybit);
> 
> Make it:
> 
> 	input_set_capability(data->kpad_power, EV_KEY, data->keycode);
OK.
> 
> > +
> > +	data->kpad_power->name = "wmt_power_keypad";
> > +	data->kpad_power->phys = "wmt_power_keypad";
> 
> You can have more "human" name in name field, you do not have to have
> underscores. Also if you want to use phys it is common to have it in
> form of "<parent device>/input0" so something like "vt8500-pmic/input0".
Thanks.
> 
> > +	data->kpad_power->keycode = &data->keycode;
> > +	data->kpad_power->keycodesize = sizeof(unsigned int);
> > +	data->kpad_power->keycodemax = 1;
> > +
> > +	err = input_register_device(data->kpad_power);
> > +	if (err < 0) {
> > +		dev_err(&pdev->dev, "failed to register input device\n");
> > +		goto cleanup_input;
> > +	}
> > +
> 
> I'd recommend registering input device after you request irq as it
> simplifies error path (it is OK for ISR to use allocated but not
> registered input device).
Sounds good.
> 
> > +
> > +static int vt8500_pwr_kpad_remove(struct platform_device *pdev)
> > +
> > +{
> > +	struct kpad_pwr_data *data = platform_get_drvdata(pdev);
> > +
> > +	free_irq(data->irq, data);
> > +	del_timer(&data->timer);
> 
> This should be del_timer_sync().
OK.
> 
> > +	input_unregister_device(data->kpad_power);
> > +	input_free_device(data->kpad_power);
> 
> input_free_device() after input_unregister_device() will result in
> double-free. The rule is use input_free_device() if device has not been
> registered, otherwise use input_unregister_device().
That seems a little unintuitive given the functions seemed to be paired.
Will fix. Thanks.
> 
> You also need to unmap the mapped region.
Will do.



Regards
Tony P

