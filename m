Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab1LLJFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:05:36 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:52252 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748Ab1LLJFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:05:32 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>
Date: Mon, 12 Dec 2011 10:05:07 +0100
Subject: RE: [PATCH 0/9] XSHM: Shared Memory Driver for ST-E Thor M7400 LTE
 modem
Thread-Topic: [PATCH 0/9] XSHM: Shared Memory Driver for ST-E Thor M7400 LTE
 modem
Thread-Index: Acy2gLu093ancBftR0qIZqj6+HNlRgCKmpcQ
Message-ID: <81C3A93C17462B4BBD7E272753C105791FB0D6BA63@EXDCVYMBSTM005.EQ1STM.local>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
 <201112071230.08019.arnd@arndb.de>
 <81C3A93C17462B4BBD7E272753C105791FB0D15949@EXDCVYMBSTM005.EQ1STM.local>
 <201112091442.04294.arnd@arndb.de>
In-Reply-To: <201112091442.04294.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBC95h3p017452

Hi Arnd,

>> However for the long term perspective: we expect this interface to evolve
>> for future products, so suggestions and input for improvements is welcome.
>> rpmsg or at least the use of virtio-ring combined with a true end-to-end
>> zero copy is something we definitely are interested to look into for the
>> future.
> 
> Is the rpmsg support something that can be done with the current low-level
> protocol? It would be really nice if you could at least share some code
> for the general infrastructure, even if both the underlying transport
> and the high-level protocols are different.

I have already been challenged in this area by Linux Walleij :-),
but I'm afraid I don't see how this could be done in a sensible way.

The modem doesn't understand the virtual-ring format, and implements
a different "protocol" - so the virtual-ring format cannot be used to
talk to the modem. And using virtqueue as a packet elevator between
Kernel internal modules doesn't seem like the right thing either.

If the virtqueue_ops structure hadn't been removed, we could have used
this as an abstraction. But this structure was killed off.

I might be missing something here, but currently I don't see how I 
could reuse any of the virtio architecture for the current implementation.
However it is definitely something we want to look into for the future. 

>> As mentioned above, the modem is in different run modes, stream device
>> is only used when modem runs in OS-less mode, during boot or crash-dump.
>> Except for boot and crash-dump the CAIF stack is used.
>> A similar approach is used for HSI, where we use a bare
>> HSI channel in OS-less mode, and CAIF over HSI otherwise.
> 
> My feeling is that a character device is not the ideal implementation here,
> but I'm not sure what is. One option I can see is to declare the stream
> interface part of the configuration logic and do everything through netlink,
> packetizing the stream data in netlink frames. Alternatively, a tty port
> device might be more appropriate than a plain chardev. Both of these
> are likely a bit slower than what you have today, but my impression is that
> performance is not the main design goal for the stream interface. If it is,
> the best option would probably be to allow user space to mmap the buffer and
> do the implementation in an application outside of the kernel.

The M7400 modem implements other physical interfaces such as HSI and USB. We
have a daemon in user space controlling the run modes and "life-cycle" of the
modem (boot, shutdown, upgrade, etc) and we are trying to keep the interface
to the different physical interfaces aligned. So for both HSI and USB we're
using a stream interface (tty or char device) for the flash-less boot protocol.
Due to this I'd prefer to stick to a plain char/tty interface and not use netlink
or mmap interfaces.

The overall modem boot time is certainly important. But I don't have performance
figures of how much of the overall boot time is used for transferring the flash-
less boot image in front of me. So it's hard to make a judgment of exactly how
performance critical this is. With the current implementation there is *one* copy
from user-space to the shared memory area so it should be reasonably efficient. 

Regards,
Sjur
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
