Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab1CUJPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 05:15:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45654 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1CUJPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 05:15:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=T58IXNOBAImMPqHtOqh/Q7ij9g5JQ5RZtCa3a/YDjAp53AAyAXkEReY3emAZ1WaYPD
         b7iOeusClrwk2j0JmOjmOUH+GCC6/IYZiNZ3qV+KF7iPtblePhXmsORWg6wHTGIZa0cE
         tOXZoKCQ8Ac4Q4xvqYWjsyphSETzEFXm9FWto=
Message-ID: <4D87173D.50906@suse.cz>
Date: Mon, 21 Mar 2011 10:15:41 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jack Stone <jwjstone@fastmail.fm>, Mac <kmac@poczta.fm>,
        linux-kernel@vger.kernel.org, linux-ppp@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 'scheduling while atomic' during ppp connection on 2.6.37.1 and
 2.6.38
References: <fuopaigyaypsqveewtjx@pwmq>	<4D864A82.4090104@fastmail.fm> <20110320215826.79cadfe2@lxorguk.ukuu.org.uk>
In-Reply-To: <20110320215826.79cadfe2@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2011 10:58 PM, Alan Cox wrote:
>> +        spin_lock_irqsave(&dc->spin_mutex, flags);
>>           if (port->port.count)
>>               room = kfifo_avail(&port->fifo_ul);
>> -        mutex_unlock(&port->tty_sem);
>> +        spin_unlock_irqrestore(&dc->spin_mutex, flags);
> 
> dc->spin_mutex does not protect port->port.count.

Neither port->tty_sem did.

Anyway is the test needed at all? I.e. could
tty->ops->write/chars_in_buffer/ntty_write_room be called with
port->port.count == 0 at all?

And the lock should not as well be needed. Kfifo assures atomicity where
there is only one reader and one writer which should be the case here.
Unless tty->ops->write can be called in parallel. And it should not,
that's what's tty->atomic_write_lock for.

thanks,
-- 
js
suse labs
