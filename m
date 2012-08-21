Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2HULav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:30:51 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:48124 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919Ab2HULaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:30:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120821104549.GT10347@arwen.pp.htv.fi>
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
	<1345545940-2232-3-git-send-email-sourav.poddar@ti.com>
	<20120821104549.GT10347@arwen.pp.htv.fi>
Date: Tue, 21 Aug 2012 17:00:44 +0530
Message-ID: <CAKdam57c=yc2AtG8R_ioMcxQhNj39i+f4PDuJM5wruWOSn5FYw@mail.gmail.com>
Subject: Re: [PATCH 2/4] Input: keypad: Add smsc ece1099 keypad driver
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: balbi@ti.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 21, 2012 at 4:15 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Aug 21, 2012 at 04:15:38PM +0530, Sourav Poddar wrote:
>> From: G, Manjunath Kondaiah <manjugk@ti.com>
>>
>> SMSC ECE1099 is a keyboard scan or GPIO expansion device.The device
>> supports a keypad scan matrix of 23*8.This driver uses this
>> device as a keypad driver.
>>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> Cc: Benoit Cousson <b-cousson@ti.com>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Signed-off-by: G, Manjunath Kondaiah <manjugk@ti.com>
>> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
>
> looks good. If you just fix my comment on free_irq() below, you can add:
>
> Acked-by: Felipe Balbi <balbi@ti.com>
>
>> +static int __devinit
>> +smsc_probe(struct platform_device *pdev)
>> +{
>> +     struct device *dev = &pdev->dev;
>> +     struct smsc *smsc = dev_get_drvdata(pdev->dev.parent);
>> +     struct input_dev *input;
>> +     struct smsc_keypad *kp;
>> +     int ret = 0, error;
>> +     int col, i, max_keys, row_shift;
>> +     int irq;
>> +     int addr_start, addr;
>> +
>> +     kp = devm_kzalloc(dev, sizeof(*kp), GFP_KERNEL);
>> +
>> +     input = input_allocate_device();
>> +     if (!kp || !input) {
>> +             error = -ENOMEM;
>> +             goto err1;
>> +     }
>> +
>> +     error = smsc_keypad_parse_dt(&pdev->dev, kp);
>> +     if (error)
>> +             return error;
>> +
>> +     /* Get the debug Device */
>> +     kp->input = input;
>> +     kp->smsc = smsc;
>> +     kp->irq = platform_get_irq(pdev, 0);
>> +     kp->dev = dev;
>> +
>> +     for (col = 0; col < 16; col++) {
>> +             kp->last_key_state[col] = 0;
>> +             kp->last_key_ms[col] = 0;
>> +     }
>> +
>> +     /* setup input device */
>> +      __set_bit(EV_KEY, input->evbit);
>> +
>> +     /* Enable auto repeat feature of Linux input subsystem */
>> +     if (!(kp->no_autorepeat))
>> +             __set_bit(EV_REP, input->evbit);
>> +
>> +     input_set_capability(input, EV_MSC, MSC_SCAN);
>> +     input->name             = "SMSC Keypad";
>> +     input->phys             = "smsc_keypad/input0";
>> +     input->dev.parent       = &pdev->dev;
>> +     input->id.bustype       = BUS_HOST;
>> +     input->id.vendor        = 0x0001;
>> +     input->id.product       = 0x0001;
>> +     input->id.version       = 0x0003;
>> +
>> +     error = input_register_device(input);
>> +     if (error) {
>> +             dev_err(kp->dev,
>> +                     "Unable to register twl4030 keypad device\n");
>> +             goto err1;
>> +     }
>> +
>> +     /* Mask all GPIO interrupts (0x37-0x3B) */
>> +     for (addr = 0x37; addr < 0x3B; addr++)
>> +             smsc_write(dev, addr, 0);
>> +
>> +     /* Set all outputs high (0x05-0x09) */
>> +     for (addr = 0x05; addr < 0x09; addr++)
>> +             smsc_write(dev, addr, 0xff);
>> +
>> +     /* Clear all GPIO interrupts (0x32-0x36) */
>> +     for (addr = 0x32; addr < 0x36; addr++)
>> +             smsc_write(dev, addr, 0xff);
>> +
>> +     addr_start = 0x12;
>> +     for (i = 0; i <= kp->rows; i++) {
>> +             addr = 0x12 + i;
>> +             smsc_write(dev, addr, SMSC_KP_KSI);
>> +     }
>> +
>> +     addr_start =  0x1A;
>> +     for (i = 0; i <= kp->cols; i++) {
>> +             addr = 0x1A + i;
>> +             smsc_write(dev, addr, SMSC_KP_KSO);
>> +     }
>> +
>> +     addr = SMSC_KP_INT_STAT;
>> +     smsc_write(dev, addr, SMSC_KP_SET_HIGH);
>> +
>> +     addr = SMSC_WKUP_CTRL;
>> +     smsc_write(dev, addr, SMSC_KP_SET_LOW_PWR);
>> +
>> +     addr = SMSC_KP_OUT;
>> +     smsc_write(dev, addr, SMSC_KSO_ALL_LOW);
>> +
>> +     row_shift = get_count_order(kp->cols);
>> +     max_keys = kp->rows << row_shift;
>> +
>> +     kp->row_shift = row_shift;
>> +     kp->keymap = kzalloc(max_keys * sizeof(kp->keymap[0]),
>> +                                     GFP_KERNEL);
>> +     if (!kp->keymap) {
>> +             dev_err(&pdev->dev, "Not enough memory for keymap\n");
>> +             error = -ENOMEM;
>> +     }
>> +
>> +     matrix_keypad_build_keymap(NULL, NULL, kp->rows,
>> +                     kp->cols, kp->keymap, input);
>> +
>> +     /*
>> +     * This ISR will always execute in kernel thread context because of
>> +     * the need to access the SMSC over the I2C bus.
>> +     */
>> +     ret = devm_request_threaded_irq(dev, kp->irq, NULL, do_kp_irq,
>> +                     IRQF_TRIGGER_FALLING | IRQF_ONESHOT, pdev->name, kp);
>> +     if (ret) {
>> +             dev_dbg(&pdev->dev, "request_irq failed for irq no=%d\n",
>> +                     irq);
>> +             goto err2;
>> +     }
>> +
>> +     /* Enable smsc keypad interrupts */
>> +     ret = smsc_write(dev, SMSC_KP_INT_MASK, 0xff);
>> +     if (ret < 0)
>> +             goto err2;
>> +
>> +     return 0;
>> +
>> +err2:
>> +     input_unregister_device(input);
>> +     free_irq(kp->irq, NULL);
>
> you're using devm_request_threaded_irq, this is unnecessary
>
True. Will remove "free_irq"  from the code.
>> +err1:
>> +     input_free_device(input);
>> +     return ret;
>> +}
>> +
>> +static int smsc_remove(struct platform_device *pdev)
>> +{
>> +     struct smsc_keypad *kp = platform_get_drvdata(pdev);
>> +     free_irq(kp->irq, kp);
>
> ditto.
>
>
> --
> balbi
