Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1CaUyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 16:54:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59381 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1CaUyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 16:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=UFSPr0Pi6RtyAQcjzZGzzIhg3RnRO/zSlV+lmhvA8pMKRcE4JADX4XLpL4mDEOCC85
         BRORtF0bOQWyEwDjlTACRJW3yoWRH/sKkFv2wNY3oqGJt/3IARq0mpNqc0yKIFwpJgDq
         vG8pyBZ9CNJuIDOSr4Ahfkmqt4cSYg/SDMiMI=
Message-ID: <4D94E9E7.2050600@suse.cz>
Date: Thu, 31 Mar 2011 22:53:59 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jack Stone <jwjstone@fastmail.fm>, Mac <kmac@poczta.fm>,
        linux-kernel@vger.kernel.org, linux-ppp@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 'scheduling while atomic' during ppp connection on 2.6.37.1 and
 2.6.38
References: <fuopaigyaypsqveewtjx@pwmq>	<4D864A82.4090104@fastmail.fm>	<20110320215826.79cadfe2@lxorguk.ukuu.org.uk>	<4D87173D.50906@suse.cz> <20110321110214.5174f1b2@lxorguk.ukuu.org.uk>
In-Reply-To: <20110321110214.5174f1b2@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2011 12:02 PM, Alan Cox wrote:
>> Anyway is the test needed at all? I.e. could
>> tty->ops->write/chars_in_buffer/ntty_write_room be called with
>> port->port.count == 0 at all?
> 
> I'm not entirely sure what the Nozomi driver is trying to do. Generally
> any case a driver is looking at port->port.count it's a bug and should
> not matter with the tty krefs. However the chances are it should be
> testing *something* instead in this case.

Well, I looked into the history of the driver and into the driver
itself. What I've found out is:

* tty_sem is useless now. It was used to protect port->tty_open_count
which was later switched to port->port.count. The lock should have been
switched to port->lock at that time too.

* the port->port.count == 0 tests are an illusion of protection against
race with hup.

IOW both of them are crap nowadays. The former doesn't protect anything,
the latter is not protected by anything.

What is the proper way to avoid a race with HUP in tty->ops->write,
chars_in_buffer, ntty_write_room and possibly others?

I looked into the drivers, moxa tests tty->driver_data (why? [1]), mxser
does nothing as well as rocket and many others. What is the reference
driver I should look into?

[1] Perhaps leftover from when moxa_shutdown used to NULL it.

I don't see why the driver should care at all. It has a tty,
tty->driver_data and thus all the HW info. So it should ignore the race,
i.e. test nothing, right?

thanks,
-- 
js
suse labs
