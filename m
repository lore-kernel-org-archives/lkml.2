Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab2IFSyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:54:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51153 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab2IFSya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:54:30 -0400
Message-ID: <5048F161.3000805@suse.cz>
Date: Thu, 06 Sep 2012 20:54:25 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Tomas Hlavacek <tmshlvck@gmail.com>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        marek.vasut@gmail.com
Subject: Re: [PATCH v6] uartclk value from serial_core exposed to sysfs
References: <1344929718-22736-1-git-send-email-tmshlvck@gmail.com> <1346894238-12870-1-git-send-email-tmshlvck@gmail.com> <5048E35F.5020304@suse.cz> <CAEB7QLAWLuXFLWMYX70enP5X0z5EXTNo93hfOm7sH_kQteMAkA@mail.gmail.com>
In-Reply-To: <CAEB7QLAWLuXFLWMYX70enP5X0z5EXTNo93hfOm7sH_kQteMAkA@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 08:39 PM, Tomas Hlavacek wrote:
> On Thu, Sep 6, 2012 at 7:54 PM, Jiri Slaby <jslaby@suse.cz> wrote:
>> On 09/06/2012 03:17 AM, Tomas Hlavacek wrote:
>>> @@ -2362,8 +2392,8 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
>>>        * Register the port whether it's detected or not.  This allows
>>>        * setserial to be used to alter this ports parameters.
>>>        */
>>> -     tty_dev = tty_port_register_device(port, drv->tty_driver, uport->line,
>>> -                     uport->dev);
>>> +     tty_dev = tty_register_device_attr(drv->tty_driver, uport->line,
>>> +                     uport->dev, port, tty_dev_attr_groups);
>>
>> This makes me believe you have not tested the change at all?
> 
> Thanks! I can't believe I missed that. (And I actually tested that,
> but I have to admit that it was not enough apparently.)
> 
> I will re-send the patch (after some additional testing and double-checking).

Ok. A couple more questions...

* why are you passing tty_port to the struct device's private data and
not uart_port proper? Is this for some future use?
* cannot be all those attribute structs const?
* kdoc for tty_register_device_attr says that when
TTY_DRIVER_DYNAMIC_DEV is not set, tty_register_device_attr *should* not
be called. But it must not be called, otherwise it will fail and emit a
warning as a bonus, right?
* final remark. I would prefer declaration and code be delimited by a
new line in uart_get_attr_uartclk:
<===>
+       int ret;
+
+       struct tty_port *port = dev_get_drvdata(dev);
+       struct uart_state *state = container_of(port, struct uart_state,
port);
+       mutex_lock(&state->port.mutex);
<===>

Like:
<===>
  struct tty_port *port = ...;
  struct uart_state *state = ...;
  int ret;

  mutex_lock(&state->port.mutex);
<===>

regards,
-- 
js
suse labs
