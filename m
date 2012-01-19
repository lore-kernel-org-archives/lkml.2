Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab2ATAEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 19:04:09 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40325 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756115Ab2ATAED convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 19:04:03 -0500
MIME-Version: 1.0
In-Reply-To: <201201200046.59766.rjw@sisk.pl>
References: <1327001336-28703-1-git-send-email-sjg@chromium.org>
	<201201200046.59766.rjw@sisk.pl>
Date: Thu, 19 Jan 2012 15:57:10 -0800
X-Google-Sender-Auth: HKzyHOsg-HHAevd_eUSU528kyRQ
Message-ID: <CAPnjgZ1_6BM9Xrtn0S2Rp1_YsjcUYi3iyKpH62LyhkR_T63ojg@mail.gmail.com>
Subject: Re: [PATCH] serial: Fix wakeup init logic to speed up startup
From: Simon Glass <sjg@chromium.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Thu, Jan 19, 2012 at 3:46 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, January 19, 2012, Simon Glass wrote:
>> The synchronize_rcu() call resulting from making every serial driver
>> wake-up capable (commit b3b708fa) slows boot down on my Tegra2x system
>> (with CONFIG_PREEMPT disabled).
>>
>> But this is avoidable since it is the device_set_wakeup_enable() and then
>> subsequence disable which causes the delay. We might as well just make
>> the device wakeup capable but not actually enable it for wakeup until
>> needed.
>>
>> Effectively the current code does this:
>>
>>       device_set_wakeup_capable(dev, 1);
>>       device_set_wakeup_enable(dev, 1);
>>       device_set_wakeup_enable(dev, 0);
>>
>> We can just drop the last two lines.
>>
>> Before this change my boot log says:
>> [    0.227062] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
>> [    0.702928] serial8250.0: ttyS0 at MMIO 0x70006040 (irq = 69) is a Tegra
>>
>> after:
>> [    0.227264] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
>> [    0.227983] serial8250.0: ttyS0 at MMIO 0x70006040 (irq = 69) is a Tegra
>>
>> for saving of 450ms.
>>
>> Suggested-by: Rafael J. Wysocki <rjw@sisk.pl>
>> Signed-off-by: Simon Glass <sjg@chromium.org>
>
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
>
> Thanks!

Thanks for your help with this.

Regards,
Simon

>
>> ---
>>  drivers/tty/serial/serial_core.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
>> index c7bf31a..1305618 100644
>> --- a/drivers/tty/serial/serial_core.c
>> +++ b/drivers/tty/serial/serial_core.c
>> @@ -2348,11 +2348,11 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
>>        */
>>       tty_dev = tty_register_device(drv->tty_driver, uport->line, uport->dev);
>>       if (likely(!IS_ERR(tty_dev))) {
>> -             device_init_wakeup(tty_dev, 1);
>> -             device_set_wakeup_enable(tty_dev, 0);
>> -     } else
>> +             device_set_wakeup_capable(tty_dev, 1);
>> +     } else {
>>               printk(KERN_ERR "Cannot register tty device on line %d\n",
>>                      uport->line);
>> +     }
>>
>>       /*
>>        * Ensure UPF_DEAD is not set.
>>
>
