Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab1HYODL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:03:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52672 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750867Ab1HYODJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:03:09 -0400
Date: Thu, 25 Aug 2011 15:01:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dudley Du <dudl@cypress.com>
Cc: "rubini@ipvvis.unipv.it" <rubini@cvml.unipv.it>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] input:cyapa: Add new I2C-based input touchpad driver
 for Cypress I2C touchpad devices
Message-ID: <20110825150146.2e876af8@lxorguk.ukuu.org.uk>
In-Reply-To: <B27AC323FA92C946BA36D2913DDC8E370226D9457E7B@VMBX126.ihostexchange.net>
References: <B27AC323FA92C946BA36D2913DDC8E370226D9457E6B@VMBX126.ihostexchange.net>
	<B27AC323FA92C946BA36D2913DDC8E370226D9457E7B@VMBX126.ihostexchange.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 +/*
> + * Status of the cyapa device detection worker.
> + * The worker is started at driver initialization and
> + * resume from system sleep.
> + */
> +enum cyapa_detect_status {
> +       CYAPA_DETECT_DONE_SUCCESS,
> +       CYAPA_DETECT_DONE_FAILED,
> +};

So a bool is_detected would be much more obvious


> +struct cyapa_reg_data_gen3 {
> +       /*
> +        * bit 0 - 1: device status
> +        * bit 3 - 2: power mode
> +        * bit 6 - 4: reserved
> +        * bit 7: interrupt valid bit
> +        */
> +       u8 device_status;
> +       /*
> +        * bit 7 - 4: number of fingers currently touching pad
> +        * bit 3: valid data check bit
> +        * bit 2: middle mechanism button state if exists
> +        * bit 1: right mechanism button state if exists
> +        * bit 0: left mechanism button state if exists
> +        */
> +       u8 finger_btn;
> +       struct cyapa_touch_gen3 touches[CYAPA_MAX_TOUCHES];
> +};

If this is a hardware format you might want to check how different
platforms and compiler settings lay it out - eg if they'll put two bytes
of padding between finger_btn and the struct.

> +
> +union cyapa_reg_data {
> +       struct cyapa_reg_data_gen3 gen3_data;
> +};

A union of one struct.. wants cleaning up ....

> +/* The main device structure */
> +struct cyapa_i2c {
> +       /* synchronize i2c bus operations. */
> +       struct semaphore reg_io_sem;

Use mutexes unless you need to the counting behaviour, otherwise it
messes up real time Linux handling


> +
> +/*
> + * When requested IRQ number is not available, the trackpad driver
> + * falls back to using polling mode.
> + * In this case, do not actually enable/disable irq.
> + */
> +static void cyapa_enable_irq(struct cyapa_i2c *touch)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&touch->miscdev_spinlock, flags);
> +       if (!touch->polling_mode_enabled &&
> +               touch->bl_irq_enable &&
> +               !touch->irq_enabled) {
> +               touch->irq_enabled = true;
> +               enable_irq(touch->irq);
> +       }
> +       spin_unlock_irqrestore(&touch->miscdev_spinlock, flags);
> +}

For plling mode the kernel supports a polled input device type which will
do most of your polling work for you

> +
> +static void cyapa_disable_irq(struct cyapa_i2c *touch)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&touch->miscdev_spinlock, flags);
> +       if (!touch->polling_mode_enabled &&
> +               touch->bl_irq_enable &&
> +               touch->irq_enabled) {
> +               touch->irq_enabled = false;
> +               disable_irq(touch->irq);
> +       }
> +       spin_unlock_irqrestore(&touch->miscdev_spinlock, flags);

This doesn't do what you think. disable_irq does not guarantee that the
IRQ is not executing on another CPU core. disable_irq_sync does but then
you will deadlock.

> +}
> +
> +static int cyapa_acquire_i2c_bus(struct cyapa_i2c *touch)
> +{
> +       cyapa_disable_irq(touch);
> +       if (down_interruptible(&touch->reg_io_sem)) {
> +               cyapa_enable_irq(touch);
> +               return -ERESTARTSYS;
> +       }
> +
> +       return 0;

This may be running in many contexts in the workqueue so how does
allowing ^C and other signal handling make sense - especially when you
then don't seem to handle signal triggered returns ?

> +       if (ret != length)
> +               pr_warning("warning I2C block read bytes" \
> +                       "[%d] not equal to requested bytes [%d].\n",
> +                       ret, length);

Prefer dev_warn and friends then the user can relate a message to a
device more easily.

> + * In trackpad device, the memory block allocated for I2C register map
> + * is 256 bytes, so the max write block for I2C bus is 256 bytes.

Which is too big to throw on the stack. But you don't need the buffer
anyway. If you required the caller to leave the firsg byte blank you'd
save a large copy and could just fill that one byte in then send.


> +               ret = cyapa_i2c_reg_read_block(touch, 0, BL_HEAD_BYTES, status);
> +               if ((ret != BL_HEAD_BYTES) && (tries > 0)) {

And here you don't deal with the signal case you've made yourself need to
handle by using down_interruptible

> +static void cyapa_update_firmware_dispatch(struct cyapa_i2c *touch)
> +{
> +       /* do something here to update trackpad firmware. */
> +}

???

> +static void cyapa_get_reg_offset(struct cyapa_i2c *touch)
> +{
> +       touch->data_base_offset = GEN3_REG_OFFSET_DATA_BASE;
> +       touch->control_base_offset = GEN3_REG_OFFSET_CONTROL_BASE;
> +       touch->command_base_offset = GEN3_REG_OFFSET_COMMAND_BASE;
> +       touch->query_base_offset = GEN3_REG_OFFSET_QUERY_BASE;
> +}

These seem to be constant so why all the offset variables, and why pick
such incredibly long names to type ?


> +static irqreturn_t cyapa_i2c_irq(int irq, void *dev_id)
> +{
> +       struct cyapa_i2c *touch = dev_id;
> +
> +       cyapa_i2c_reschedule_work(touch, 0);
> +
> +       return IRQ_HANDLED;
> +}

Take a look at request_threaded_irq() I think that will solve a lot of
your problems and mess around this, along with the polled input device
for the non IRQ case
+
> +static int cyapa_i2c_open(struct input_dev *input)
> +{
> +       struct cyapa_i2c *touch = input_get_drvdata(input);
> +       int ret;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&touch->lock, flags);
> +       if (touch->open_count == 0) {
> +               ret = cyapa_i2c_reset_config(touch);
> +               if (ret < 0) {
> +                       pr_err("reset i2c trackpad error code, %d.\n", ret);
> +                       return ret;
> +               }
> +       }
> +       spin_unlock_irqrestore(&touch->lock, flags);
> +
> +       spin_lock_irqsave(&touch->lock, flags);
> +       touch->open_count++;
> +       spin_unlock_irqrestore(&touch->lock, flags);

You've dropped the lock and taken it and dropped it again in sequential
lines. That's nonsensical and also means you've added a race !


> +static void cyapa_i2c_close(struct input_dev *input)
> +{
> +       unsigned long flags;
> +       struct cyapa_i2c *touch = input_get_drvdata(input);
> +
> +       spin_lock_irqsave(&touch->lock, flags);
> +
> +       if (touch->open_count == 0) {

Wouldn't this be an error ?


> +       ret = request_irq(touch->irq,
> +                       cyapa_i2c_irq,
> +                       IRQF_TRIGGER_FALLING,
> +                       CYAPA_I2C_NAME,
> +                       touch);

This IRQ can happen from the moment it is registered which means it can
occur before the variables you set up further down...

> +       if (ret) {
> +               pr_warning("IRQ request failed: %d, "
> +                       "falling back to polling mode.\n", ret);
> +
> +               spin_lock_irqsave(&touch->miscdev_spinlock, flags);
> +               touch->polling_mode_enabled = true;
> +               touch->bl_irq_enable = false;
> +               touch->irq_enabled = false;
> +               spin_unlock_irqrestore(&touch->miscdev_spinlock, flags);
> +       } else {
> +               spin_lock_irqsave(&touch->miscdev_spinlock, flags);
> +               touch->polling_mode_enabled = false;
> +               touch->bl_irq_enable = false;
> +               touch->irq_enabled = true;
> +               enable_irq_wake(touch->irq);
> +               spin_unlock_irqrestore(&touch->miscdev_spinlock, flags);
> +       }
> +
> +       /* create an input_dev instance for trackpad device. */
> +       ret = cyapa_create_input_dev(touch);
> +       if (ret) {
> +               free_irq(touch->irq, touch);

But what if it was polling ?


In general I think

- use the threaded_irq interfaces for your IRQ paths (if you look at the
  current kernel you'll see a lot of drivers do this)
- use the polled input device interface for the no IRQ case, so it does
  all the polling work for you
- tidy up the locking (and the fact you've got locking in there is a lot
  better than many first submissions we see)

I would think about how the various states and handlers work. Right now
the code is quite convoluted, and maybe a state machine of some kind would
clean it up ?

