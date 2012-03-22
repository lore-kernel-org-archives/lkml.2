Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab2CVOdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:33:14 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:37660 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753264Ab2CVOdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:33:09 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>
Date: Thu, 22 Mar 2012 15:31:39 +0100
Subject: RE: [PATCH 0/9] XSHM: Shared Memory Driver for ST-E Thor M7400 LTE
 modem
Thread-Topic: [PATCH 0/9] XSHM: Shared Memory Driver for ST-E Thor M7400 LTE
 modem
Thread-Index: Acy2gLu093ancBftR0qIZqj6+HNlRhRsUXfQ
Message-ID: <81C3A93C17462B4BBD7E272753C105792060B42C9C@EXDCVYMBSTM005.EQ1STM.local>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2MEXicd021754

Hi Arnd,

I've got some updates since my last reply from December...

[Arnd]
>>> Also, to what degree is the protocol design flexible? Is the modem
>>> side fixed, so you have to live with any shortcomings of the interface,
>>> or are you at this point able to improve both sides when something
>>> is found to be lacking?

I have started working on the next generation shared memory interface for
ST-Ericsson modems. So the interface design is now flexible! This means that
I can be open to input and new ideas, at least for the next month or two.
I'm hoping (if time allows) to prototype and post some patches while working
on the specification.

The primary goal for the new interface design, besides getting it accepted
in the mainline kernel, is to implement zero-copy for IP traffic on the modem
side. Zero-copy on host side would be the next step.

[Sjur]
>> However for the long term perspective: we expect this interface to evolve
>> for future products, so suggestions and input for improvements is welcome.
>> rpmsg or at least the use of virtio-ring combined with a true end-to-end
>> zero copy is something we definitely are interested to look into for the
>> future.

My current idea for the new interface design is to use Virtio channels for
transporting CAIF frames. The CAIF interface could be implemented as a
virtio-driver using separate RX and TX rings.

For uplink traffic (TX) we could (initially) copy SKB into a buffer located in
the shared-memory area, and add the buffer to the Virtio-ring. We will need
to manage a fixed size buffer pool of uplink data buffers. (I don't think we
will be able to access the kernel memory from the modem, so I cannot put SKB
content directly on the virtio-ring as virtio-net does)

For Downlink payload (RX) I'm planning on using a reversed virtio-ring.
The modem has its own sophisticated memory allocator for payload and
implements mechanisms for efficient buffer handling inside the modem.
The modem could add the payload buffer on the virtual-ring without
copying and kick the host.

[Sjur:]
>>>> The driver for the stream channel is implemented as a character device
...
[Arnd:]
> My feeling is that a character device is not the ideal implementation here,
> but I'm not sure what is. One option I can see is to declare the stream
> interface part of the configuration logic and do everything through netlink,
> packetizing the stream data in netlink frames. Alternatively, a tty port
> device might be more appropriate than a plain chardev. Both of these
> are likely a bit slower than what you have today, but my impression is that
> performance is not the main design goal for the stream interface. If it is,
> the best option would probably be to allow user space to mmap the buffer and
> do the implementation in an application outside of the kernel.

For the stream interface it's tempting to reuse the ring buffer interface
to the modem from last time. But perhaps the Virtio-console could be as the
user-space interface, with a slim virtual device underneath feeding data
from the ring-buffer into a virtual-ring...?

Regards,
Sjur
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
