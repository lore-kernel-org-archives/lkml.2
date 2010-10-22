Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab0JVOyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:54:47 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51376 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab0JVOyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M+psjPz5DOZ7+BA7VwQleG0VRvcWhlNXd6jWVIs/Ql7GpQHHSMOR6jQoeEWaeyaMHx
         qwcKWiFEJU97Xx+P21Cs9PNI68Xqg4LaVSnt71vWSOUiiolV8/s1N42V2upeqGogf+99
         xF1cBfT7NGwoNdLc5rcbImExUCeT+5mJBHNOg=
MIME-Version: 1.0
In-Reply-To: <20101022135130.617f0ce8@lxorguk.ukuu.org.uk>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<20101022135130.617f0ce8@lxorguk.ukuu.org.uk>
Date: Fri, 22 Oct 2010 16:54:44 +0200
Message-ID: <AANLkTik-S50ZX6mFG+vWhBv0x_WmipP=t+4VqmAgssRC@mail.gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linus.walleij@stericsson.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lukasz.Rymanowski@tieto.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi and thanks for your comments Alan.
See below for answers.

/P-G

2010/10/22 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>
>> + * is_chip_flow_off() - Check if chip has set flow off.
>> + * @tty:     Pointer to tty.
>> + *
>> + * Returns:
>> + *   true - chip flows off.
>> + *   false - chip flows on.
>> + */
>> +static bool is_chip_flow_off(struct tty_struct *tty)
>> +{
>> +     int lines;
>> +
>> +     lines = tty->ops->tiocmget(tty, uart_info->fd);
>> +
>> +     if (lines & TIOCM_CTS)
>> +             return false;
>> +     else
>> +             return true;
>> +}
>
> What if the device doesn't have a tiocmget ? You must check this. If you
> want to call into the ttys own tiocmget froma sleeping context fine, but
> see tty_tiocmget and you'll notice you need to check the op is non NULL
> somewhere. You could do this when the ldisc is opened and refuse to open
> - some ldiscs do that
>

The existence of the callback is checked in the function
uart_tty_open. If either break_ctl or tiocmget is NULL we do not allow
sleep and this code will never run.

>
>> +
>> +/**
>> + * create_work_item() - Create work item and add it to the work queue.
>> + * @wq:              work queue struct where the work will be added.
>> + * @work_func:       Work function.
>> + * @data:    Private data for the work.
>> + *
>> + * Returns:
>> + *   0 if there is no error.
>> + *   -EBUSY if not possible to queue work.
>> + *   -ENOMEM if allocation fails.
>> + */
>> +static int create_work_item(struct workqueue_struct *wq, work_func_t work_func,
>> +                         void *data)
>> +{
>> +     struct uart_work_struct *new_work;
>> +     int err;
>> +
>> +     new_work = kmalloc(sizeof(*new_work), GFP_ATOMIC);
>
> So instead of a tiny object embedded in your device you've got a whole
> error path to worry about, a printk disguised in a macro and a text
> string longer than the struct size ? Surely this should be part of the
> device
>

OK. We can embed the work struct in the device structure.

>> +     if (!new_work) {
>> +             CG2900_ERR("Failed to alloc memory for uart_work_struct!");
>
> Please use the standard dev_dbg etc functionality - or pr_err etc when
> you have no device pointer. The newest kernel tty object has a device
> pointer added so you could use that.
>

OK. I like the debug system we have now (using module parameter to set
debug level in runtime), but I've received comments regarding this
before so I assume we will have to switch to standard printouts.
Is it OK to use defines or inline functions to add "CG2900" before and
'\n' after (as BT_INFO in include/net/bluetooth/bluetooth.h)?
>
>> + * set_tty_baud() - Called to set specific baud in TTY.
>> + * @tty:     Tty device.
>> + * @baud:    Baud to set.
>> + *
>> + * Returns:
>> + *   true - baudrate set with success.
>> + *   false - baundrate set failure.
>> + */
>> +static bool set_tty_baud(struct tty_struct *tty, int baud)
>> +{
>> +     struct ktermios *old_termios;
>> +     bool retval = true;
>> +
>> +     old_termios = kmalloc(sizeof(*old_termios), GFP_ATOMIC);
>
> termios struct is easily small enough to be fine on the stack
>

OK.

>> +     /* Let's mark that CG2900 driver uses c_ispeed and c_ospeed fields. */
>> +     tty->termios->c_cflag |= BOTHER;
>
> This shouldn't be needed - the tty_encode_baud_rate logic works out of
> BOTHER must be set
>

I will have to check with the guy who wrote this code. I think he put
it there for a reason.

>> +     tty->termios->c_cflag &= ~BOTHER;
>
> And your termios is now potentially invalid
>

As above, I will check.

>
>> +     /* Set IRQ on CTS. */
>> +     err = request_irq(pf_data->uart.cts_irq,
>> +                       cts_interrupt,
>> +                       IRQF_TRIGGER_FALLING,
>> +                       UART_NAME,
>> +                       NULL);
>
> So we now ave terminal tty/ldisc confusion
>

The guy responsible for this is thinking through a new design, where
we can move the hardware specific handling to another place.

>> +     if (err) {
>> +             CG2900_ERR("Could not request CTS IRQ (%d)", err);
>> +             goto error;
>> +     }
>> +
>> +#ifdef CONFIG_PM
>> +     enable_irq_wake(pf_data->uart.cts_irq);
>> +#endif
>> +     return 0;
>> +
>> +error:
>> +     if (pf_data->uart.enable_uart)
>> +             (void)pf_data->uart.enable_uart();
>> +     return err;
>
>> +}
>> +
>> +/**
>> + * unset_cts_irq() - Disable interrupt on CTS.
>> + */
>> +static void unset_cts_irq(void)
>
> And no ability to support multiple devices
>

OK. We will try to fix this.

>> +     CG2900_DBG("Clear break");
>> +     tty->ops->break_ctl(tty, TTY_BREAK_OFF);
>
> What if the tty doesn't have one ?
>

See answer above. It is checked in another place.

>
>> +     if (CHIP_AWAKE == uart_info->sleep_state) {
>> +             uart_info->tty->ops->break_ctl(uart_info->tty, TTY_BREAK_ON);
>
> Ditto
>

And ditto as well :-)

>
>> +             set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
>> +             len = tty->ops->write(tty, skb->data, skb->len);
>
> A tty isn't required to have a write function

I don't quite understand your comment here. This particular code is
inspired of the Bluetooth ldisc code and there it is used like. It
seems to work fine so we do it the same way.
How would you prefer it to be?

>
>> +             if ((BAUD_START == uart_info->baud_rate_state) &&
>> +                 (is_set_baud_rate_cmd(skb->data))) {
>> +                     CG2900_INFO("UART set baud rate cmd found.");
>> +                     SET_BAUD_STATE(BAUD_SENDING);
>
> Do we really need this all in capitals ?
>

We use a define to get a debug printout when setting state, but I
understand it's not so popular so I guess we will have to skip it.
I guess it won't help if we would use an inline function instead of a
define (which would mean we could skip the capitals)?

>
>
>> + * uart_tty_open() - Called when UART line discipline changed to N_HCI.
>> + * @tty:     Pointer to associated TTY instance data.
>> + *
>> + * Returns:
>> + *   0 if there is no error.
>> + *   Errors from cg2900_register_trans_driver.
>> + */
>> +static int uart_tty_open(struct tty_struct *tty)
>> +{
>> +     int err;
>> +
>> +     CG2900_INFO("uart_tty_open");
>> +
>> +     /* Set the structure pointers and set the UART receive room */
>> +     uart_info->tty = tty;
>
> You must respect the kref handling in the kernel tty code. Take
> references by all means but do it properly.
>

OK. We will add tty_kref_get/put handling.

>
>> +static void uart_tty_wakeup(struct tty_struct *tty)
>> +{
>> +     int err;
>> +
>> +     CG2900_INFO("uart_tty_wakeup");
>> +
>> +     /*
>> +      * Clear the TTY_DO_WRITE_WAKEUP bit that is set in
>> +      * work_do_transmit().
>> +      */
>> +     clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
>> +
>> +     if (tty != uart_info->tty)
>> +             return;
>
> How can this occur - and why check it after you've changed tty->flags ???
>

OK. Will be removed.

>
>> +/**
>> + * uart_tty_receive() - Called by TTY low level driver when receive
>> data is available.
>> + * @tty:     Pointer to TTY instance data
>> + * @data:    Pointer to received data
>> + * @flags:   Pointer to flags for data
>> + * @count:   Count of received data in bytes
>> + */
>> +static void uart_tty_receive(struct tty_struct *tty, const u8 *data,
>> +                          char *flags, int count)
>> +{
>> +     CG2900_INFO("uart_tty_receive");
>> +
>> +     if (tty != uart_info->tty)
>> +             return;
>
> Again this is nonsense
>

OK.Will be removed.

>
>> +/*
>> + * We don't provide read/write/poll interface for user space.
>> + */
>> +static ssize_t uart_tty_read(struct tty_struct *tty, struct file *file,
>> +                          unsigned char __user *buf, size_t nr)
>> +{
>> +     CG2900_INFO("uart_tty_read");
>> +     return 0;
>> +}
>
> -EINVAL then
>

OK. We can probably skip registering the callback function completely otherwise.

>> +
>> +static ssize_t uart_tty_write(struct tty_struct *tty, struct file *file,
>> +                           const unsigned char *data, size_t count)
>> +{
>> +     CG2900_INFO("uart_tty_write");
>> +     return count;
>
> This is wrong - you can't jusr vanish the data

OK. To be changed.

>> +}
>
>
>
> This needs some restructuring I think
>
> A line discipline should contain no hardware awareness, that goes in the
> actual uart hardware driver. So we shouldn't have magic irq code in this
> part of things.
>
> You also need to sort out the tty kref handling in open/close and the
> fact you've got magic hardcoded single instance stuff buried i nit.
>
> Finally tty ldiscs don't go buried in the mfd directory, or they'll get
> missed during chanegs/updates. The ldisc probably belongs in bluetooth a
> and the hardware support in the mfd directory.
>
>
> So - NAK this for the moment, it needs to be split cleanly into ldisc
> (thing which speaks the protocol and eg sees "speed change required" and
> acts on it) and device (thing which knows about the hardware).
>
>

OK. We will try to figure out a new design.
I'm not too happy about putting the ldisc part in Bluetooth though
since it is only partly Bluetooth, it is also GPS and FM. Better could
maybe be under char/?
