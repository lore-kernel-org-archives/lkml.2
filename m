Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab2BLMky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 07:40:54 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60208 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2BLMkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 07:40:53 -0500
Message-ID: <4F37B34F.1040307@suse.cz>
Date: Sun, 12 Feb 2012 13:40:47 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120129 Thunderbird/10.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: your mail
References: <1329006070-4275-1-git-send-email-richard@nod.at> <20120212010211.GN23916@ZenIV.linux.org.uk>
In-Reply-To: <20120212010211.GN23916@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2012 02:02 AM, Al Viro wrote:
> On Sun, Feb 12, 2012 at 01:21:10AM +0100, Richard Weinberger wrote:
>> +++ b/arch/um/drivers/line.c
>> @@ -19,19 +19,29 @@ static irqreturn_t line_interrupt(int irq, void *data)
>>  {
>>  	struct chan *chan = data;
>>  	struct line *line = chan->line;
>> +	struct tty_struct *tty;
>> +
>> +	if (line) {
>> +		tty = tty_port_tty_get(&line->port);
>> +		chan_interrupt(&line->chan_list, &line->task, tty, irq);
>> +		tty_kref_put(tty);
>> +	}
>>  
>> -	if (line)
>> -		chan_interrupt(&line->chan_list, &line->task, line->tty, irq);
>>  	return IRQ_HANDLED;
>>  }
> 
> Is tty_kref_put() safe in interrupt?  Here it seems to be OK, but in other
> callers...  More or less at random: drivers/tty/serial/lantiq.c has it
> called from lqasc_rx_int().  It seems to be possible to have it end up
> calling ->ops->shutdown() and in this case that'd be lqasc_shutdown().
> Which does a bunch of free_irq(), including the ->rx_irq, i.e. the one
> we have it called from.  Alan?

I'm not Alan, but will reply anyway. Yes, it is safe (unless the driver
does something tricky). In the driver you mention, this is uart_ops,
called from tty_port_operations' ->shutdown. And that's a different from
tty_operations' ->shutdown.

Yes, there are:
* tty->ops
* tty_port->ops
* uart_port->ops

uart_port->ops->shutdown is supposed to tear down interrupts like in
lantiq.c. It is called from tty_port->ops->shutdown. And that one is
allowed to be called only from user context (tty->ops->close and
tty->ops->hangup).

thanks,
-- 
js
suse labs
