Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab0JMQRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 12:17:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38276 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab0JMQRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 12:17:30 -0400
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>
CC: Arnd Hannemann <arnd@arndnet.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Pedanekar, Hemant" <hemantp@ti.com>, Greg KH <greg@kroah.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Date: Wed, 13 Oct 2010 11:17:02 -0500
Subject: RE: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Thread-Topic: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Thread-Index: ActnmOoAbrWxw/lCQeeIa45LeEIwmwDU7wQw
Message-ID: <13B9B4C6EF24D648824FF11BE896716203D760F19C@dlee02.ent.ti.com>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101007192245.GC26435@n2100.arm.linux.org.uk>
	<AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	<20101008175308.GA10975@n2100.arm.linux.org.uk>
	<20101008231926.GA28235@kroah.com>
	<alpine.LFD.2.00.1010082242390.3107@xanadu.home>
 <AANLkTi=BvXROFEnzYykoUQNbU05Q=mWoV3t7qKDk7+vL@mail.gmail.com>
In-Reply-To: <AANLkTi=BvXROFEnzYykoUQNbU05Q=mWoV3t7qKDk7+vL@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9DGHg0l001640

> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-kernel-
> bounces@lists.infradead.org] On Behalf Of Felipe Contreras
> Sent: Saturday, October 09, 2010 5:01 AM

> That's not true, drivers on ARMv6 and above do work. I still wonder
> how exactly to trigger the issue, and how often does this happen,
> because I've never seen it.

On a Cortex-A8 if you enable auxcr.asa speculative accesses will be allowed to happen more broadly (cross outside of L2).  There are few failures which have been seen in testing which go away with its disable. Most Linux kernels have this feature off.  They still prefetch but with reduced scope.

On Cortex-A9 to get performance there are prefetches at both A9 level and PL310 (L2 controller) level. Enabling them for some things gives a very good boost. It will increase your chances of hitting issues as it activates D-Side prefetch along with increasing the amount I side prefetch.  An A9 doesn't have auxcr to limit its prefetch to L2 like A8.  If there is a MMU table with a valid TLB its free game to speculate against and bring data in (for non device memory maps).

I'm told A15 gets much more aggressive here. It has dedicated hardware resources (fill buffers ++) for speculation and not just competing against the current instruction stream for these resources.

Having incoherent views and/or copies of data is not what you want. SMP should amplify the badness by doubling speculation sources and adding extra l1 caches. Killing the alias from ioremap is a good thing and something people should want for production.

Regards,
Richard W.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
