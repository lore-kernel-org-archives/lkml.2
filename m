Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab2HNRG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 13:06:58 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:38493 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594Ab2HNRG4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 13:06:56 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Date: Tue, 14 Aug 2012 19:06:51 +0200
Subject: RE: [RFC 4/4] remoteproc: Add driver for STE Modem
Thread-Topic: [RFC 4/4] remoteproc: Add driver for STE Modem
Thread-Index: Ac1ap6tN5oXVNupeRxWWaMy5FJggwgfUyTZw
Message-ID: <81C3A93C17462B4BBD7E272753C1057923B924C92E@EXDCVYMBSTM005.EQ1STM.local>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com>
 <1340375470-13097-5-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbbG2nHH7+rm6CoR=VhiXVQT3-2VqJYLswmg9EshWu_=EA@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C10579232F86BE52@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=Wgbb_pAx9Kfwbh23k=62vQUx5vnVpwe3q50BY=KwAkLC=ng@mail.gmail.com>
In-Reply-To: <CAK=Wgbb_pAx9Kfwbh23k=62vQUx5vnVpwe3q50BY=KwAkLC=ng@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

>>> It seems to me that a char device will solve these issues: we can use
>>> ioctl to control the power, if the user crashes we'll know about it
>>> via the release handler, and if the remote processor crashes we can
>>> let the user know by sending it a notification for it to read via the fd.

How about skipping definition of ioctls and simply call rproc_boot() upon
open and rproc_shutdown() upon close, this is perhaps quirky, but simpler.
I'd also like to use a char-misc device, then we get the device 
node with proper name automatically from existing udev rules.

>> In this case we need a way to make the virtio-drivers release the
>> virtio-queues in order to decrement the refcount, right?
...
>> So it seems that we need to force an unregistration of the virtio devices,
>> in order to make it release its queues.
...
> Yeah, no code is needed; something like this should do the trick:
> 
> root@omap4430-panda:/sys/bus/virtio/drivers/virtio_console# echo
> virtio1 > unbind

Looking on this once more after vacation I prefer if the ste-rproc driver
could enforce shutdown if we use the char-device.
In our case user-space will detect modem crashes and power off
the device. So if user-space uses char-device to request power off,
it feels like kernel space should do everything possible to really
trigger the shutdown, including unbinding the virtio devices.
Depending on additional "echo .../virtio > unbind" seems like an
unnecessary extra dependency. 


Alternatively, we could let user-space handle the power switch
for the modem directly. Remoteproc could simply notify user-space
(e.g. using gen-netlink) when rproc usage count has dropped to zero.
And this could trigger power-down. This would be more aligned with
our existing solution for power control.

Regards,
Sjur
