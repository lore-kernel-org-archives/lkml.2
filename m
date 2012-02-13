Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab2BMJP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:15:58 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51732 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab2BMJP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:15:56 -0500
Message-ID: <4F38D4C5.9080907@suse.cz>
Date: Mon, 13 Feb 2012 10:15:49 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120129 Thunderbird/10.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org
Subject: Re: your mail
References: <1329006070-4275-1-git-send-email-richard@nod.at> <20120212191134.GQ23916@ZenIV.linux.org.uk>
In-Reply-To: <20120212191134.GQ23916@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2012 08:11 PM, Al Viro wrote:
> On Sun, Feb 12, 2012 at 01:21:10AM +0100, Richard Weinberger wrote:
> 
>> @@ -343,7 +267,7 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
>>  {
>>  	struct chan *chan = data;
>>  	struct line *line = chan->line;
>> -	struct tty_struct *tty = line->tty;
>> +	struct tty_struct *tty = tty_port_tty_get(&line->port);
>>  	int err;
>>  
>>  	/*
>> @@ -354,6 +278,9 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
>>  	spin_lock(&line->lock);
>>  	err = flush_buffer(line);
>>  	if (err == 0) {
>> +		tty_kref_put(tty);
>> +
>> +		spin_unlock(&line->lock);
>>  		return IRQ_NONE;
>>  	} else if (err < 0) {
>>  		line->head = line->buffer;
>> @@ -365,9 +292,12 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
>>  		return IRQ_NONE;
>>  
>>  	tty_wakeup(tty);
>> +	tty_kref_put(tty);
>>  	return IRQ_HANDLED;
>>  }
> 
> That, BTW, smells ugly.  Note that return before the last one has no
> tty_kref_put() for a very good reason - it's under if (!tty).  And
> just as line->tty, port->tty can become NULL, so tty_port_tty_get()
> can, indeed, return NULL here.  Which makes the first tty_kref_put()
> oopsable...

Nope, it is allowed to call tty_kref_put(NULL).

regards,
-- 
js
suse labs
