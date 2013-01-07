Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3AGLaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:30:15 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55623 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab3AGLaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:30:13 -0500
Message-ID: <50EAB1C1.9050808@imgtec.com>
Date: Mon, 7 Jan 2013 11:30:09 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 43/44] tty/metag_da: Add metag DA TTY driver
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com> <1354723742-6195-44-git-send-email-james.hogan@imgtec.com> <20121205172446.41aa464e@pyramind.ukuu.org.uk> <50E6E322.8070108@imgtec.com> <20130104170013.74b6dbe2@pyramind.ukuu.org.uk>
In-Reply-To: <20130104170013.74b6dbe2@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_07_11_30_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On 04/01/13 17:00, Alan Cox wrote:
>> Agreed and done. I didn't realise the TTY layer was so prone to
>> providing lots of itty bitty fragments (even with a single 4k write from
>> userland). The thing that really hurt was not the allocations but that
>> each one was written out to the DA separately each incurring it's own
>> large latency. Using a write buffer makes it a lot faster :)
> 
> Think about typing a command and the echo - you get a lot of very small
> writes !

Yes. The case I tried was a large write (strace cat /etc/somefile >
/dev/ttyDA2) and strace showed a single large write, but it got to the
driver in chunks of a dozen or so characters. Is that expected to happen?

>>>> +	channel_driver->init_termios = tty_std_termios;
>>>> +	channel_driver->init_termios.c_cflag =
>>>> +	    B38400 | CS8 | CREAD | HUPCL | CLOCAL;
>>>> +	channel_driver->flags = TTY_DRIVER_REAL_RAW;
>>>
>>> Need to set the speed flags
>>
>> Do you mean c_ispeed, and c_ospeed? These are set in tty_std_termios,
>> and they aren't meaningful in the context of this driver anyway, so are
>> they still necessary?
> 
> You update c_cflag to B38400 so you should set c_ispeed/c_ospeed
> accordingly. For a virtual interface it really only exists so that
> applications have an answer. You want a higher speed like 38400 so that
> apps don't try and do clever stuff for low speed links, that is all
> really.

Okay, assuming no objections I'll do the following to avoid specifying
an arbitrary speed in the first place (since tty_std_termios sets
c_cflag and c_{i,o}speed to 38400 anyway):

@@ -613,8 +613,7 @@ static int __init dashtty_init(void)
 	channel_driver->type = TTY_DRIVER_TYPE_SERIAL;
 	channel_driver->subtype = SERIAL_TYPE_NORMAL;
 	channel_driver->init_termios = tty_std_termios;
-	channel_driver->init_termios.c_cflag =
-	    B38400 | CS8 | CREAD | HUPCL | CLOCAL;
+	channel_driver->init_termios.c_cflag |= CLOCAL;
 	channel_driver->flags = TTY_DRIVER_REAL_RAW;

 	tty_set_operations(channel_driver, &dashtty_ops);

Thanks
James

