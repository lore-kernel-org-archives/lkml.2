Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200Ab2J2RHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:07:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61952 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760225Ab2J2RGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:06:39 -0400
Date: Mon, 29 Oct 2012 10:06:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, linux-input@vger.kernel.org,
        linux-omap@vger.kernel.org, b-cousson@ti.com, santosh.shilimkar@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5] Input: keypad: Add smsc ece1099 keypad driver
Message-ID: <20121029170633.GA11558@core.coreip.homeip.net>
References: <1351507129-10229-1-git-send-email-sourav.poddar@ti.com>
 <20121029162045.GK27566@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029162045.GK27566@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 06:20:45PM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Oct 29, 2012 at 04:08:49PM +0530, Sourav Poddar wrote:
> > +static int __devinit
> > +smsc_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct input_dev *input;
> > +	struct smsc_keypad *kp;
> > +	int ret = 0;
> > +	int i, max_keys, row_shift;
> > +	int irq;
> > +	int addr;
> > +
> > +	kp = devm_kzalloc(dev, sizeof(*kp), GFP_KERNEL);
> > +
> > +	input = devm_input_allocate_device(dev);
> > +	if (!kp || !input)
> > +		ret = -ENOMEM;
> > +
> > +	ret = smsc_keypad_parse_dt(dev, kp);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Get the debug Device */
> > +	kp->input = input;
> > +	kp->irq = platform_get_irq(pdev, 0);
> > +	kp->dev = dev;
> > +
> > +	/* setup input device */
> > +	 __set_bit(EV_KEY, input->evbit);
> > +
> > +	/* Enable auto repeat feature of Linux input subsystem */
> > +	if (!kp->no_autorepeat)
> > +		__set_bit(EV_REP, input->evbit);
> > +
> > +	input_set_capability(input, EV_MSC, MSC_SCAN);
> > +	input->name             = "SMSC Keypad";
> > +	input->phys             = "smsc_keypad/input0";
> > +	input->dev.parent       = &pdev->dev;
> > +	input->id.bustype       = BUS_HOST;
> > +	input->id.vendor        = 0x0001;
> > +	input->id.product       = 0x0001;
> > +	input->id.version       = 0x0003;
> > +
> > +	input->open = smsc_keypad_open;
> > +	input->close = smsc_keypad_close;
> > +	input_set_drvdata(input, kp);
> > +
> > +	/* Mask all GPIO interrupts (0x37-0x3B) */
> > +	for (addr = SMSC_GPIO_INT_MASK_START;
> > +			addr < SMSC_GPIO_INT_MASK_START + 4; addr++)
> > +		smsc_write(dev, addr, 0);
> > +
> > +	/* Set all outputs high (0x05-0x09) */
> > +	for (addr = SMSC_GPIO_DATA_OUT_START;
> > +			addr < SMSC_GPIO_DATA_OUT_START + 4; addr++)
> > +		smsc_write(dev, addr, 0xff);
> > +
> > +	/* Clear all GPIO interrupts (0x32-0x36) */
> > +	for (addr = SMSC_GPIO_INT_STAT_START;
> > +			addr < SMSC_GPIO_INT_STAT_START + 4; addr++)
> > +		smsc_write(dev, addr, 0xff);
> > +
> > +	/* Configure the smsc pins as Keyboard scan Input */
> > +	for (i = 0; i < kp->rows; i++) {
> > +		addr = 0x12 + i;
> > +		smsc_write(dev, addr, SMSC_KP_KSI);
> > +	}
> > +
> > +	/* Configure the smsc pins as Keyboard scan output */
> > +	for (i = 0; i < kp->cols; i++) {
> > +		addr = 0x1a + i;
> > +		smsc_write(dev, addr, SMSC_KP_KSO);
> > +	}
> > +
> > +	smsc_write(dev, SMSC_KP_INT_STAT, SMSC_KP_SET_HIGH);
> > +	smsc_write(dev, SMSC_WKUP_CTRL, SMSC_KP_SET_LOW_PWR);
> > +	smsc_write(dev, SMSC_KP_OUT, SMSC_KSO_ALL_LOW);
> > +
> > +	row_shift = get_count_order(kp->cols);
> > +	max_keys = kp->rows << row_shift;
> > +
> > +	kp->row_shift = row_shift;
> > +	kp->keymap = devm_kzalloc(dev, max_keys * sizeof(kp->keymap[0]),
> > +					GFP_KERNEL);
> > +	if (!kp->keymap) {
> > +		dev_err(dev, "Not enough memory for keymap\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	ret = matrix_keypad_build_keymap(NULL, NULL, kp->rows,
> > +			kp->cols, kp->keymap, input);
> > +	if (ret) {
> > +		dev_err(dev, "failed to build keymap\n");
> > +		return ret;
> > +	}
> > +
> > +	/*
> > +	* This ISR will always execute in kernel thread context because of
> > +	* the need to access the SMSC over the I2C bus.
> > +	*/
> > +	ret = devm_request_threaded_irq(dev, kp->irq, NULL, do_kp_irq,
> > +			IRQF_TRIGGER_FALLING | IRQF_ONESHOT, pdev->name, kp);
> > +	if (ret) {
> > +		dev_dbg(dev, "request_irq failed for irq no=%d\n",
> > +			irq);
> > +		return ret;
> > +	}
> > +
> > +	ret = input_register_device(input);
> > +	if (ret) {
> > +		dev_err(kp->dev,
> > +			"Unable to register twl4030 keypad device\n");
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int __devexit smsc_remove(struct platform_device *pdev)
> > +{
> 
> shouldn't you unregister the input device here ??

And that is why I do not like devm_* interface myself... But no, since
input device was allocated with devm_input_allocate_device() it does not
need to be explicitly freed or unregistered.

Thanks.

-- 
Dmitry
