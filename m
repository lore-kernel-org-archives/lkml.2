Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab2C1Jf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 05:35:58 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:48900 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786Ab2C1Jf4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 05:35:56 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>
Date: Wed, 28 Mar 2012 11:33:08 +0200
Subject: RE: Using remoteproc with ST-Ericsson modem.
Thread-Topic: Using remoteproc with ST-Ericsson modem.
Thread-Index: Ac0MIYjq0JMCsLEfRH+R0JKklhUcQAAGdj9Q
Message-ID: <81C3A93C17462B4BBD7E272753C105792060C09F1D@EXDCVYMBSTM005.EQ1STM.local>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
 <201112091442.04294.arnd@arndb.de>
 <81C3A93C17462B4BBD7E272753C105792060B42C9C@EXDCVYMBSTM005.EQ1STM.local>
 <201203221657.09820.arnd@arndb.de>
 <81C3A93C17462B4BBD7E272753C105792060C098E4@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbY+n_CESWCSiC5tAXTm+8CJVEd2TOa4H0-iVeeb1=3C9Q@mail.gmail.com>
In-Reply-To: <CAK=WgbY+n_CESWCSiC5tAXTm+8CJVEd2TOa4H0-iVeeb1=3C9Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> Can you please elaborate why would you want that ? Let's go
> requirement by requirement.

1) Resource descriptors and parameters such as size of vring,
size of the "carved-out" shared memory, as well as proprietary
(CAIF specific) parameters, should be supported. These parameters
must be available to the Virtio device-drivers (CAIF interface),
and to the modem. The resource/parameter configuration has to be
stored in shared memory before booting the modem.

2a) The resource descriptors and configuration parameters are pre-
formatted in the proprietary binary format. Remoteproc (or it's plugin)
must then be able to parse this proprietary format, extract
configuration parameters, and load the binary image into shared memory.
OR 
2b) Configuration parameters and firmware can be provided separately.
The remoteproc (or it's plugin) must be able to format the provided
configuration parameters in a proprietary format understood by the
modem boot-loader and store the firmware and configuration in
shared memory. A user-space API for configuration (e.g. netlink)
must be supported.
OR
2c) As in 2a, the image in proprietary format containing both firmware 
and parameters could be provided. In addition configuration parameters
could be provided to remoteproc separately. The binary-image and
configuration parameters will in this case hold identical configuration
information. A user-space API for configuration (e.g. netlink)
must be supported.

I had a quick look at the patch from Loic and Ludovic and they seem to
provide resource-table and firmware separately.

In my case, the best solution seems to be 2a). I.e to parse parameters
from the provided firmware, and avoid any extra configuration parameters
provided from user-space. It seems to me we could do this by adding a
callback function to remoteproc that parses the firmware and returns
a resource table.

>> I think we need to be able to launch other Virtio device types than
>> VIRTIO_ID_RPMSG as well.
> 
> Sure. Please note that we already support that today: a firmware can
> indicate any type of (and number of) virito devices it supports, and
> remoteproc will create those device as needed.

Excellent.

>> Most likely, I need to make a CAIF specific VIRTIO type
> 
> Have you considered making this an rpmsg driver ? it might make your
> implementation simpler.

Hm, there are some issue we need to handle in that case: last time I
looked rpmsg did blocking calls, but CAIF may be running in soft-irq context.
As mentioned before I need rpmsg to do "reversed/symmetric Vrings" for
the RX direction. I also need performance specific tweaks such as
disabling kicks and go into poll-mode at upon high load.

However there might be new requirements we have in common such as:
buffer pools with different fixed sized buffers, zero-copy handling of
SKBs (TX), and DMA for (RX). Even if I end up not using rpmsg we should
definitely look for opportunities for common code. I think we will be
trying to solve the same type of problems.

>> due to the fact that I need RX direction to be reversed
>> (modem must be able to post its payload buffer to Virtio ring).
> 
> It sounds like something that Loic and Ludovic (cc'ed) have been
> dealing with recently too. To solve it, they have created a symmetric
> variation of vrings - you might want to take a look at their
> implementation.

Thanks for info, I've already started talking to them :-)

>> We also define stream channels. As mentioned, I'm considering the possibility
>> of reusing Virtio console.
> 
> Sounds nice. We tried virtio console with a remote processor and it
> worked quite nicely.

OK, good to hear. I'll definitely look into this more closely.

Regards,
Sjur
