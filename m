Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589Ab2IFTlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:41:14 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54645 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab2IFTlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:41:11 -0400
MIME-Version: 1.0
In-Reply-To: <5048F161.3000805@suse.cz>
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com>
	<1346894238-12870-1-git-send-email-tmshlvck@gmail.com>
	<5048E35F.5020304@suse.cz>
	<CAEB7QLAWLuXFLWMYX70enP5X0z5EXTNo93hfOm7sH_kQteMAkA@mail.gmail.com>
	<5048F161.3000805@suse.cz>
Date: Thu, 6 Sep 2012 21:41:09 +0200
Message-ID: <CAEB7QLAk6pe9ih+P_621fZE3JpRcFpPA+Wzk57x3FmVaGmoOKg@mail.gmail.com>
Subject: Re: [PATCH v6] uartclk value from serial_core exposed to sysfs
From: Tomas Hlavacek <tmshlvck@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        marek.vasut@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Thu, Sep 6, 2012 at 8:54 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 09/06/2012 08:39 PM, Tomas Hlavacek wrote:
>> On Thu, Sep 6, 2012 at 7:54 PM, Jiri Slaby <jslaby@suse.cz> wrote:
>>> On 09/06/2012 03:17 AM, Tomas Hlavacek wrote:
>>>> @@ -2362,8 +2392,8 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
>>>>        * Register the port whether it's detected or not.  This allows
>>>>        * setserial to be used to alter this ports parameters.
>>>>        */
>>>> -     tty_dev = tty_port_register_device(port, drv->tty_driver, uport->line,
>>>> -                     uport->dev);
>>>> +     tty_dev = tty_register_device_attr(drv->tty_driver, uport->line,
>>>> +                     uport->dev, port, tty_dev_attr_groups);
>>>
>>> This makes me believe you have not tested the change at all?
>>
>> Thanks! I can't believe I missed that. (And I actually tested that,
>> but I have to admit that it was not enough apparently.)
>>
>> I will re-send the patch (after some additional testing and double-checking).
>
> Ok. A couple more questions...
>
> * why are you passing tty_port to the struct device's private data and
> not uart_port proper? Is this for some future use?

I actually used the uart_port structure in older RFC versions of the
patch. Alan Cox advised to use struct tty_port because of consistency.
More precisely he said (in an e-mail from Aug 12):

I'd rather however it pointed
to the tty_port that each tty device has (or very soon will be required
to have). You can still find the uart_foo structs from that but it means
we can do the dev_set_drvdata() in a consistent manner for all tty
devices in the kernel. That in turn means we can make some of the sysfs
valid the same way.

> * cannot be all those attribute structs const?

It seems that making

static const struct attribute *tty_dev_attrs[] = ...

produces warning:

drivers/tty/serial/serial_core.c:2334:2: warning: initialization from
incompatible pointer type [enabled by default]
drivers/tty/serial/serial_core.c:2334:2: warning: (near initialization
for ‘tty_dev_attr_group.attrs’) [enabled by default]

But others can. I am going to make them const in following patch.

> * kdoc for tty_register_device_attr says that when
> TTY_DRIVER_DYNAMIC_DEV is not set, tty_register_device_attr *should* not
> be called. But it must not be called, otherwise it will fail and emit a
> warning as a bonus, right?

Yes. In fact it does the same thing as tty_register_device() did
before itself. The _attr version is only slightly refactored and the
doc regarding the TTY_DRIVER_DYNAMIC_DEV test is the same as in old
non-_attr version.
I am not sure that I am the right person to change the doc because I
am not an author of this part of doc nor of the test in the function.

> * final remark. I would prefer declaration and code be delimited by a
> new line in uart_get_attr_uartclk:
> <===>
> +       int ret;
> +
> +       struct tty_port *port = dev_get_drvdata(dev);
> +       struct uart_state *state = container_of(port, struct uart_state,
> port);
> +       mutex_lock(&state->port.mutex);
> <===>
>
> Like:
> <===>
>   struct tty_port *port = ...;
>   struct uart_state *state = ...;
>   int ret;
>
>   mutex_lock(&state->port.mutex);
> <===>

Yes, it looks better. I am going to it accordingly.

Tomas
